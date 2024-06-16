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
--                                           Function                                                --
--------------------------------------------------------------------------------------------------------

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

CREATE OR REPLACE FUNCTION porcentaje_inasistencia_empleado(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS varchar(4) AS $$
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
      RETURN CONCAT('%', to_char(porcentaje_inac,'990'));
  END;
$$ LANGUAGE plpgsql;
--Hasta aquí es el número 6







--------------------------------------------------------------------------------------------------------
--                           Funciones y Procedimientos Menores                                       --
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION edad (fec_nac date) RETURNS integer AS $$
	BEGIN
		RETURN (round(((current_date- fec_nac)/365),0));
	END; $$ LANGUAGE plpgsql;
