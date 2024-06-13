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

	