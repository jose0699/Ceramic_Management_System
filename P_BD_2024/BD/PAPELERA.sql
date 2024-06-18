	--Numero 10Nota: Convertir a programa almacenado)
	CREATE OR REPLACE FUNCTION DET_INASISTENCIA_AMONESTACION() RETURNS TRIGGER AS $$
		DECLARE
		  num_inasistencias numeric(1);
		BEGIN
		  -- Contar el número de inasistencias del empleado en el último mes
		  SELECT COUNT(*) INTO num_inasistencias
		  FROM DET_EXP
		  WHERE num_exp= NEW.num_expediente
			AND fecha BETWEEN NEW.fecha - INTERVAL '3 month' AND NEW.fecha;

		  -- Si es la tercera inasistencia en el último mes, generar la amonestación
		  IF num_inasistencias = 3 THEN
			INSERT INTO DET_EXP VALUES
			(NEW.num_expediente,  nextval('det_exp_uid_seq'), CURRENT_DATE, 'am', null, null, null, 'Amonestación por 3 inasistencias en el último mes');
		  END IF;

		  RETURN NEW;
		END;
	$$ LANGUAGE plpgsql;
	CREATE OR REPLACE TRIGGER INASISTENCIA_AMONESTACION_DET_EXP AFTER INSERT ON DET_EXP FOR EACH ROW EXECUTE FUNCTION DET_INASISTENCIA_AMONESTACION(); --9

	--Numero 5
	CREATE OR REPLACE FUNCTION MAX_SUPERVISION() RETURNS TRIGGER AS $$ 
	Declare 
		cant_supervisados numeric (2);
	BEGIN
		SELECT COUNT(*) INTO cant_supervisados FROM empleado e WHERE e.supervisor = NEW.supervisor; 
		IF cant_supervisados > 10 THEN
			RAISE EXCEPTION 'Error: El supervisor alcanzo la cantidad maxima de empleado supervisados.';			
		END IF;	
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	CREATE OR REPLACE TRIGGER MAX_SUPERVISION_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION MAX_SUPERVISION(); --5


	CREATE OR REPLACE FUNCTION edad (fec_nac date) RETURNS integer AS $$
	BEGIN
		RETURN (round(((current_date- fec_nac)/365),0));
	END; $$ LANGUAGE plpgsql;

/* PROTOTIPO CALCULO INASISTENCIAS BY JOSÉ
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