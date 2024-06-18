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
	

CREATE OR REPLACE PROCEDURE division_operarios_departamento(ndept IN departamento.nombre%TYPE) AS $$
	DECLARE
		num_operarios numeric(4);
		nivel_dept numeric(1);
		grupos_operarios numeric(4);
		op_por_grupo numeric(4);
		op_restantes numeric(4);

	BEGIN
		SELECT d.nivel INTO nivel_dept FROM departamento d WHERE UPPER(d.nombre) = UPPER(ndept);

		IF nivel_dept <> 4 OR nivel_dept is null THEN
				raise exception 'Error: El departamento solicitado no contiene operarios generales';
		END IF;

		SELECT COUNT(e.trabaja) INTO num_operarios
		FROM departamento d, empleado e 
		WHERE d.uid_departamento = e.trabaja
		AND UPPER(d.nombre) = UPPER(ndept);

		grupos_operarios := floor((num_operarios / 10) + 1);
		op_por_grupo := floor(num_operarios / grupos_operarios);
		op_restantes:= num_operarios % grupos_operarios;

		CASE
			WHEN op_restantes = 0 THEN
					raise notice 'Para el departamento de % se sugiere una división de: % grupos de % empleados, cada grupo con un operario como Supervisor',
												ndept, grupos_operarios, op_por_grupo;
			WHEN op_restantes <= op_por_grupo THEN
					raise notice 'Para el departamento de % se sugiere una división de % grupos: % grupos de % empleados, y % grupos de % empleados, cada grupo con un operario como Supervisor',
												ndept, grupos_operarios, grupos_operarios-op_restantes, op_por_grupo, op_restantes, op_por_grupo+1;
			ELSE
					raise notice 'Para el departamento de % se sugiere una división de % grupos: % grupos de 9 empleados, y % grupos de 10 empleados, cada grupo con un operario como Supervisor',
												ndept, grupos_operarios, grupos_operarios-op_restantes, grupos_operarios-(grupos_operarios-op_restantes);
		END CASE;
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

CREATE OR REPLACE FUNCTION contar_inasistencias(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(4) AS $$
  DECLARE
    mes_fin date;
    n_inasistencias numeric(4);

  BEGIN
      mes_fin := mes_inicio + interval '1 month' - interval '1 day';
      SELECT COUNT(d.num_exp) INTO n_inasistencias FROM det_exp d WHERE d.num_exp = v_id_empleado AND fecha BETWEEN mes_inicio AND mes_fin;
      RETURN n_inasistencias;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION porcentaje_inasistencia_empleado(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(5,2) AS $$
  DECLARE
    dias_laborales numeric(2);
    inasistencias numeric(2);
    porcentaje_inac numeric(5,2);
    v_cargo varchar(2);
    v_departamento numeric(2);
  BEGIN
      

   		SELECT e.cargo, e.trabaja FROM EMPLEADO e WHERE e.num_expediente = v_id_empleado INTO v_cargo, v_departamento;

      dias_laborales := obtener_dias_laborales(v_cargo, v_departamento); 

      inasistencias := contar_inasistencias(v_id_empleado,mes_inicio);

      porcentaje_inac := 100-(inasistencias/dias_laborales) * 100;

      RETURN porcentaje_inac;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION porcentaje_ina_supervisor(v_id_supervisor IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(5,2) AS $$
  DECLARE
    porcentaje_inac numeric(5,2);
  BEGIN

      SELECT AVG(porcentaje_inasistencia_empleado(e.num_expediente, mes_inicio)) INTO porcentaje_inac
      FROM empleado e
      WHERE e.supervisor = v_id_supervisor;

      RETURN porcentaje_inac;
      --RETURN CONCAT('%', to_char(porcentaje_inac,'990'));
  END;
$$ LANGUAGE plpgsql;
--Hasta aquí es el número 6


--NUMERO 7 FUNCIONES PARA MOSTRAR DATOS AL USUARIO

CREATE OR REPLACE FUNCTION mostrar_empleados_departamento(nom_dept IN departamento.nombre%TYPE) RETURNS
		TABLE (	id_departamento numeric(2)
						, nombre_departamento text 
						, numero_expediente_empleado numeric(4)
						, nombre_completo_empleado text
						, cargo text
		      )
AS $$
  BEGIN
		RETURN QUERY SELECT
                d.uid_departamento,
								UPPER(d.nombre) nombre_departamento,
								e.num_expediente,
								CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre_empleado,
								CASE
									WHEN e.cargo = 'se' THEN 'Secretaria'
									WHEN e.cargo = 'ge'	THEN 'Gerente'
									WHEN e.cargo = 'me' THEN 'Mecánico'
									WHEN e.cargo = 'in'	THEN 'Inspector'
									WHEN e.cargo = 'el' THEN 'Electricista'
									WHEN e.cargo = 'og'	THEN 'Operario General'
								END cargo
							FROM empleado e, departamento d
							WHERE  d.uid_departamento = e.trabaja
							AND	 UPPER(d.nombre) = UPPER(nom_dept);
	END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION mostrar_supervisores_departamento(nom_dept IN departamento.nombre%TYPE) RETURNS
		TABLE (	id_departamento numeric(2)
						, nombre_departamento text 
						, numero_expediente_empleado numeric(4)
						, nombre_completo_supervisor text
		      )
AS $$
  DECLARE
    nivel numeric(1);
  BEGIN
    SELECT d.nivel INTO nivel FROM departamento d WHERE UPPER(d.nombre) = UPPER(nom_dept);

    IF nivel <> 4 THEN
      raise exception 'Error: El departameno Solicitado no es un departamento que contenga Supervisores';
      RETURN QUERY SELECT;
    END IF;

    IF nivel is null THEN
      raise exception 'Error: El departameno Solicitado no existe';
      RETURN QUERY SELECT;
    END IF;

		RETURN QUERY SELECT
                d.uid_departamento,
								UPPER(d.nombre),
								e.num_expediente,
								CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))
							FROM empleado e, departamento d
							WHERE  d.uid_departamento = e.trabaja
              AND  (d.nivel = 4 AND e.supervisor is NULL AND e.cargo = 'og')
							AND	 UPPER(d.nombre) = UPPER(nom_dept);
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mostrar_supervisados_supervisor(v_uid_supervisor IN empleado.num_expediente%TYPE) RETURNS
		TABLE (	id_departamento numeric(2)
						, nombre_departamento text 
						, numero_expediente_empleado numeric(4)
						, nombre_completo_empleado text
            , nombre_completo_supervisor text
		      )
AS $$
  DECLARE
    esSupervisor numeric(1);
    cargo varchar(2);
    supervisor numeric(4);
    nombreSupervisor text;
  BEGIN
      --Se verifica que el empleado sea un supervisor
      SELECT e.cargo, e.supervisor, CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))
      INTO cargo, supervisor, nombreSupervisor FROM empleado e WHERE e.num_expediente = v_uid_supervisor;

      IF (cargo <> 'og') OR (supervisor IS NOT NULL) THEN
        raise exception 'Error: El empleado solicitado no es supervisor';
        RETURN QUERY SELECT;
      END IF;

    	SELECT COUNT(e.num_expediente) INTO esSupervisor
			FROM empleado e, empleado s
			WHERE s.num_expediente = e.supervisor
			AND e.supervisor = v_uid_supervisor;

      IF esSupervisor = 0 THEN
        raise exception 'Error: El empleado solicitado no es supervisor';
        RETURN QUERY SELECT;
      END IF;

      RETURN QUERY SELECT
                  d.uid_departamento,
                  UPPER(d.nombre),
                  e.num_expediente,
                  CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')),
                  nombreSupervisor
                FROM empleado e, departamento d
                WHERE  d.uid_departamento = e.trabaja
                AND  e.supervisor = v_uid_supervisor;
	END;
$$ LANGUAGE plpgsql;


---mostrar CATÁLOGO

CREATE OR REPLACE FUNCTION mostrar_colecciones(tipo_linea varchar(20)) RETURNS
		TABLE (	id_coleccion numeric(2)
						, nombre_coleccion varchar(40) 
						, categoria text
		      )
AS $$
  BEGIN
      tipo_linea := UPPER(substring(tipo_linea FROM 1 FOR 1));

      RETURN QUERY SELECT
                    c.uid_coleccion,
                    c.nombre,
                    CASE
                      WHEN c.categoria = 'cou' THEN 'Country'
                      WHEN c.categoria = 'cla' THEN 'Clásica'
                      WHEN c.categoria = 'mod' THEN 'Moderna'
                    END
                FROM coleccion c
                WHERE  c.linea = tipo_linea;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_piezas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE) RETURNS
		TABLE (	  nombre_coleccion varchar(40) 
            , uid_pieza  numeric(3) 
            , molde text
		      )
AS $$
  BEGIN
    RETURN QUERY SELECT c.nombre coleccion,
                        p.uid_pieza, 
                        m.molde
            FROM coleccion c, nombres_moldes m, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND c.uid_coleccion = v_id_coleccion;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mostrar_vajillas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE) RETURNS
		TABLE (	  nombre_coleccion varchar(40) 
            , uid_pieza  numeric(3) 
            , nombre_vajilla varchar(60)
		      )
AS $$
  BEGIN
    RETURN QUERY SELECT DISTINCT c.nombre,
                        v.uid_juego, 
                        v.nombre
            FROM coleccion c, detalle_pieza_vajilla d, vajilla v
            WHERE c.uid_coleccion = d.uid_coleccion
            AND v.uid_juego = d.uid_juego
            AND c.uid_coleccion = v_id_coleccion;
  END;
$$ LANGUAGE plpgsql;

--HASTA AQUÍ EL NÚMERO 6



--------------------------------------------------------------------------------------------------------
--   Funciones y Procedimientos Menores       (Apoyo a inserciones, obtener tablas según parametros) --
--------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION obtener_fecha_historico(v_id_pieza IN pieza.uid_pieza%TYPE,ffinc date) RETURNS date AS $$
	DECLARE
		fecha_hist date;
		v_fecha timestamp;
	BEGIN
			v_fecha:=ffinc::timestamp;
		  SELECT MAX(f.fecha_inicio)::date 
			INTO fecha_hist 
			FROM familiar_historico_precio f 
			WHERE f.uid_pieza = v_id_pieza
			AND f.fecha_inicio<=v_fecha;
			
			RETURN fecha_hist;
	END;
$$ LANGUAGE plpgsql;

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
$$ LANGUAGE plpgsql;

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
