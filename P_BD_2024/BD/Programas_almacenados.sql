/*
Este archivo tiene la función de contener toda la información relacionada con las funciones, procedimientos, del sistema.
	El orden a seguir es:
		1-Procedure
		2-Function
*/

--------------------------------------------------------------------------------------------------------
--                                           Procedure                                                --
--------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE rotacion_turnos_horneros() AS $$
  DECLARE
      h record;
  BEGIN
      FOR h IN SELECT num_expediente, mes_inicioano, turno   
                  FROM hist_turno 
                  WHERE mes_inicioano = date_trunc('month', now()) - interval '1 month'
      LOOP
        INSERT INTO hist_turno values (h.num_expediente, h.mes_inicioano + interval '1 month', CASE
				                                                    WHEN h.turno = 1 THEN 2
				                                                    WHEN h.turno = 2 THEN 3
				                                                    WHEN h.turno = 3 THEN 1
				                                                 END);
      END LOOP;
  END;

$$ LANGUAGE plpgsql;
	
	

--------------------------------------------------------------------------------------------------------
--                                            Function                                                --
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calcular_precio_vajilla(v_id_vaj IN detalle_pieza_vajilla.uid_juego%TYPE, v_id_col IN detalle_pieza_vajilla.uid_coleccion%TYPE,
                                                    finc date, ffin date) 
RETURNS numeric(8,2) AS $$
  DECLARE
      v record;
      linea varchar(10);
      precio_vaj numeric(8,2);
  BEGIN
      precio_vaj := 0;
      SELECT c.linea INTO linea FROM coleccion c WHERE c.uid_coleccion = v_id_col;

      IF linea = 'I' THEN
          FOR v IN SELECT d.cantidad,
                          p.precio
                          FROM detalle_pieza_vajilla d, pieza p 
                          WHERE d.uid_pieza = p.uid_pieza  
                          AND d.uid_juego = v_id_vaj
                          AND d.uid_coleccion = v_id_col
          LOOP
              precio_vaj := precio_vaj + (v.precio*v.cantidad);
          END LOOP;

      ELSE linea = 'F' THEN;
          FOR v IN SELECT d.cantidad,
                          f.precio
                        FROM detalle_pieza_vajilla d, familiar_historico_precio f, pieza p 
                        WHERE d.uid_pieza = p.uid_pieza  
                        AND f.uid_pieza = p.uid_pieza
                        AND (f.fecha_inicio BETWEEN finc AND ffin)
                        AND d.uid_juego = v_id_vaj
                        AND d.uid_coleccion = v_id_col
          LOOP
              precio_vaj := precio_vaj + (v.precio*v.cantidad);
          END LOOP;

      END IF;
      
      RETURN precio_vaj - (precio_vaj * 0.15);

  END;

$$ LANGUAGE plpgsql;





--NUMERO 6
CREATE OR REPLACE FUNCTION obtener_dias_no_laborales() RETURNS numeric(2) AS $$
  DECLARE
    dias_no_laborales numeric(2);
    dias_feriados numeric(1);
  BEGIN
      -- Esta SELECT genera una serie con la cual se obtienen los dias del mes_inicio y se le extraen a através del campo DOW(days of weekend)
      -- los domingos, que son días que la fábrica no está operativa
      SELECT count(*) INTO dias_no_laborales
      FROM generate_series(date_trunc('month', now()), 
                date_trunc('month', now()) + '1 month'::interval - '1 day'::interval,
                          '1 day'::interval) dias_laborales(d)
      WHERE extract(DOW FROM dias_laborales.d) IN (0);

      -- Se verifica en caso de ser un mes con feriado
      SELECT CASE 
        WHEN to_char(current_date,'MM') = '12' THEN 3
        WHEN to_char(current_date, 'MM') = '01' THEN 1
        WHEN to_char(current_date, 'MM') = '05' THEN 1
        ELSE 0
      END INTO dias_feriados;

      dias_no_laborales := dias_no_laborales + dias_feriados;

      RETURN dias_no_laborales;
  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_dias_laborales(v_cargo varchar(2), v_departamento numeric(2)) RETURNS numeric(2) AS $$
  DECLARE
    dias_laborales numeric;
  BEGIN
    SELECT date_part('days', 
            date_trunc('month', now()) 
            + '1 month'::interval
            - '1 day'::interval
        )::numeric INTO dias_laborales;


      IF(v_cargo = 'og' AND v_departamento = 15) THEN
          RETURN dias_laborales;
      END IF; 

      dias_laborales := dias_laborales - obtener_dias_no_laborales();

    RETURN dias_laborales;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION porcentaje_inasistencia_empleado(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(5,2) AS $$
  DECLARE
    dias_laborales numeric(2);
    inasistencias numeric(2);
    porcentaje_inac numeric(5,2);
    --mes_inicio date;
    mes_fin date;
    v_cargo varchar(2);
    v_departamento numeric(2);
  BEGIN
      --mes_inicio := date_trunc('month', now());
      mes_fin := mes_inicio + interval '1 month' - interval '1 day';

   		SELECT e.cargo, e.trabaja FROM EMPLEADO e WHERE e.num_expediente = v_id_empleado INTO v_cargo, v_departamento;

      dias_laborales := obtener_dias_laborales(v_cargo, v_departamento);  
      --raise notice 'dl: %', dias_laborales;
      SELECT COUNT(d.num_exp) INTO inasistencias FROM det_exp d WHERE d.num_exp = v_id_empleado AND fecha BETWEEN mes_inicio AND mes_fin;
      --raise notice 'inac: %', inasistencias;
      porcentaje_inac := 100-(inasistencias/dias_laborales) * 100;
      --raise notice 'Value: %', porcentaje_inac;
      RETURN porcentaje_inac;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION porcentaje_ina_supervisor(v_id_supervisor IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS varchar(4) AS $$
  DECLARE
    porcentaje_inac numeric(5,2);
  BEGIN

      SELECT AVG(porcentaje_inasistencia_empleado(e.num_expediente, mes_inicio)) INTO porcentaje_inac
      FROM empleado e
      WHERE e.supervisor = v_id_supervisor;

      RETURN CONCAT('%', to_char(porcentaje_inac,'990'));
  END;
$$ LANGUAGE plpgsql;
--Hasta aquí es el número 6







--------------------------------------------------------------------------------------------------------
--   Funciones y Procedimientos Menores       (Apoyo a inserciones, obtener tablas según parametros) --
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION edad (fec_nac date) RETURNS integer AS $$
	BEGIN
		RETURN (round(((current_date- fec_nac)/365),0));
	END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insertar_vajilla(nombre varchar(60), capacidad numeric(1), descripcion varchar(256)) returns numeric(3) AS $$ 
BEGIN
	INSERT INTO vajilla values(nextval ('vajilla_uid_seq'),nombre, capacidad, descripcion);
	return lastval();
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_pieza(coleccion numeric(2), descripcion varchar(256), precio numeric(8,2), uid_molde numeric(2)) AS $$
	DECLARE
		linea_coleccion varchar(1);
		new_uid_pieza numeric(3);
	BEGIN
		SELECT  c.linea INTO linea_coleccion FROM coleccion c WHERE c.uid_coleccion = coleccion;
		
		IF linea_coleccion = 'F' THEN 
			INSERT INTO pieza VALUES (coleccion,nextval ('pieza_uid_seq'),descripcion,precio,uid_molde);
			new_uid_pieza := lastval();
			
			INSERT INTO familiar_historico_precio values(coleccion, new_uid_pieza ,CURRENT_DATE , precio, NULL);
		ELSE
			INSERT INTO pieza VALUES (coleccion,nextval ('pieza_uid_seq'),descripcion,precio,uid_molde);		
		END IF;
	END;
$$ LANGUAGE plpgsql;	


CREATE OR REPLACE FUNCTION datos_piezas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE, finc date, ffin date) RETURNS 
  TABLE 
               (uid_pieza  numeric(3)   
               , coleccion varchar(40)
               , molde text
               , precio numeric(8,2)
               , forma text
               , linea text
               , categoria text
               , descripcion varchar(256))
AS $$
  DECLARE
    linea varchar(10);
  BEGIN
        SELECT	c.linea INTO linea
        FROM coleccion c
        WHERE c.uid_coleccion = v_id_coleccion;


    		IF linea = 'F' THEN

          RETURN QUERY
            SELECT p.uid_pieza, 
                c.nombre coleccion, 
                m.molde, 
                f.precio,
                CASE WHEN mo.forma = 'ova' THEN 'Ovalada'
                  WHEN mo.forma = 'rec' THEN 'Rectangular'
                  WHEN mo.forma = 'cua' THEN 'Cuadrada'
                  WHEN mo.forma = 'red' THEN 'Redonda'
                  ELSE null
                END forma,
                CASE
                  WHEN c.linea = 'F' THEN 'Familiar'
                  WHEN c.linea = 'I' THEN 'Institucional'
                END linea,
                
                CASE
                  WHEN c.categoria = 'cou' THEN 'Country'
                  WHEN c.categoria = 'cla' THEN 'Clásica'
                  WHEN c.categoria = 'mod' THEN 'Moderna'
                END categoria,
                p.descripcion
            FROM coleccion c, molde mo, nombres_moldes m, familiar_historico_precio f, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND mo.uid_molde = p.uid_molde
            AND c.uid_coleccion = f.uid_coleccion AND f.uid_pieza = p.uid_pieza
            AND (f.fecha_inicio BETWEEN finc AND ffin)
            AND c.uid_coleccion = v_id_coleccion
            ORDER BY c.uid_coleccion, p.uid_pieza ASC;
            
        ELSE

          RETURN QUERY
            SELECT p.uid_pieza, 
                c.nombre coleccion, 
                m.molde, 
                p.precio,
                CASE WHEN mo.forma = 'ova' THEN 'Ovalada'
                  WHEN mo.forma = 'rec' THEN 'Rectangular'
                  WHEN mo.forma = 'cua' THEN 'Cuadrada'
                  WHEN mo.forma = 'red' THEN 'Redonda'
                  ELSE null
                END forma,
                CASE
                  WHEN c.linea = 'F' THEN 'Familiar'
                  WHEN c.linea = 'I' THEN 'Institucional'
                END linea,
                
                CASE
                  WHEN c.categoria = 'cou' THEN 'Country'
                  WHEN c.categoria = 'cla' THEN 'Clásica'
                  WHEN c.categoria = 'mod' THEN 'Moderna'
                END categoria,
                p.descripcion
            FROM coleccion c, molde mo, nombres_moldes m, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND mo.uid_molde = p.uid_molde
            AND c.uid_coleccion = v_id_coleccion
            ORDER BY c.uid_coleccion, p.uid_pieza ASC;
        END IF;
  END;
$$ LANGUAGE plpgsql
/*
CREATE OR REPLACE FUNCTION datos_ficha_pieza(v_uid_pieza IN pieza.uid_pieza%TYPE, v_uid_coleccion, finc date, ffin date) RETURNS 
  TABLE 
               (uid_pieza  numeric(3)   
               , nombre varchar(40)
               , molde text
               , forma text
               , precio numeric(8,2))
AS $$
  DECLARE
    linea varchar(10);
  BEGIN
        SELECT	c.linea INTO linea
        FROM coleccion c
        WHERE c.uid_coleccion = v_id_coleccion;


    		IF linea = 'F' THEN

          RETURN QUERY
               SELECT  p.uid_pieza,	
                c.nombre,
                m.molde,
                  CASE WHEN mo.forma = 'ova' THEN ' ovalado'
                  WHEN mo.forma = 'rec' THEN ' rectangular'
                  WHEN mo.forma = 'cua' THEN ' cuadrado'
                  WHEN mo.forma = 'red' THEN ' redondo'
                  ELSE ''
                END forma,
                f.precio
                FROM coleccion c, nombres_moldes m, molde mo, familiar_historico_precio f, pieza p
                WHERE c.uid_coleccion = p.uid_coleccion
                AND m.uid_molde = p.uid_molde
                AND mo.uid_molde = p.uid_molde
                AND c.uid_coleccion = f.uid_coleccion AND f.uid_pieza = p.uid_pieza
                AND (f.fecha_inicio BETWEEN finc AND ffin) 
                AND p.uid_pieza = v_uid_pieza
                AND c.uid_coleccion = v_id_coleccion;
            
        ELSE

          RETURN QUERY
            SELECT p.uid_pieza, 
                c.nombre coleccion, 
                m.molde, 
                p.precio,
                  CASE WHEN mo.forma = 'ova' THEN ' ovalado'
                  WHEN mo.forma = 'rec' THEN ' rectangular'
                  WHEN mo.forma = 'cua' THEN ' cuadrado'
                  WHEN mo.forma = 'red' THEN ' redondo'
                  ELSE ''
                END forma
            FROM coleccion c, nombres_moldes m, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND p.uid_pieza = v_uid_pieza
            AND c.uid_coleccion = v_id_coleccion
            ORDER BY c.uid_coleccion, p.uid_pieza ASC;

        END IF;
  END;
$$ LANGUAGE plpgsql
*/
