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
      FOR h IN SELECT num_expediente, mesano, turno   
                  FROM hist_turno 
                  WHERE mesano = date_trunc('month', now()) - interval '1 month'
      LOOP
        INSERT INTO hist_turno values (h.num_expediente, h.mesano + interval '1 month', CASE
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
/*
CREATE OR REPLACE FUNCTION porcentaje_inasistencia() AS $$
DECLARE 

BEGIN

END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION porcentaje_inasistencia_reunion(fecha DATE, nombre varchar(61))
RETURNS NUMERIC AS $$
DECLARE
  expediente NUMERIC(4);
  inasistencia NUMERIC(4);
  total_clases NUMERIC(4);
  porcentaje NUMERIC(5,2);
BEGIN
  -- Obtener el número de expediente del supervisor
  SELECT e.num_expediente
  INTO expediente
  FROM empleado e
  WHERE trabaja = $1
    AND e.primer_nombre || ' ' || e.primer_apellido = nombre;

  -- Obtener la cantidad de inasistencias del supervisor
  SELECT COUNT(*)
  INTO inasistencia
  FROM inasistencia i
  WHERE i.num_expediente_supervisor = expediente
    AND i.fecha_hora BETWEEN $1 AND $1 + INTERVAL '1 month';

  -- Obtener el total de clases del supervisor
  SELECT COUNT(*) * 4
  INTO total_clases
  FROM empleado emp
  WHERE emp.supervisor = expediente OR  emp.num_expediente = expediente;

  -- Calcular el porcentaje de inasistencia
  porcentaje := (inasistencia * 100.0) / total_clases;

  RETURN porcentaje;
END;
$$ LANGUAGE plpgsql;
*/



--------------------------------------------------------------------------------------------------------
--                           Funciones y Procedimientos Menores                                       --
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION edad (fec_nac date) RETURNS date AS $$
	BEGIN
		RETURN (round(((current_date- fec_nac)/365),0));
	END; $$ LANGUAGE plpgsql;
