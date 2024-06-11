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
