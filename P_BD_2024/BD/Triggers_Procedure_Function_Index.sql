/*
Este archivo tiene la función de contener toda la información relacionada con las funciones, procedimientos, 
triggers e índices del sistema.
	El orden a seguir es:
		1-Procedure
		2-Function
		3-Trigger
		4-Index
*/

--------------------------------------------------------------------------------------------------------
--                                           Function                                                --
--------------------------------------------------------------------------------------------------------

--Proceso Venta
	--EMPLEADO
	--Numero 1
	CREATE OR REPLACE FUNCTION GERENCIA_EMPLEADO() RETURNS TRIGGER AS $$ BEGIN
		IF (NEW.cargo = 'ge') AND (new.titulo = 'ba') THEN
			RAISE EXCEPTION 'Error: Para ocupar el cargo de "Gerencia" debe tener la mención de Ingenieros Químicos, Mecánicos, de Producción, Industriales o Geólogos.';
		END IF;

		-- Obtener la fecha actual
		

		-- Calcular la diferencia en años
		IF (NEW.cargo = 'ge') AND (EXTRACT(DAY FROM NOW() - NEW.fecha_nacimiento) / 365) <= 35 THEN
			RAISE EXCEPTION 'Error: Para ocupar el cargo de "Gerencia" debe ser mayor o igual de 35 años.';
		END IF;

		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Numero 2
	CREATE OR REPLACE FUNCTION DEPARTAMENTO_EMPLEADO() RETURNS TRIGGER AS $$ 
	DECLARE 
		tipo_departamento varchar(2);
		nombre_departamento varchar(45);
	BEGIN
		SELECT d.tipo, d.nombre FROM DEPARTAMENTO d WHERE d.uid_departamento = NEW.trabaja INTO tipo_departamento, nombre_departamento;
		
		IF	(( tipo_departamento = 'GE') AND (NEW.cargo = 'ge') OR ((nombre_departamento = 'Secretaria') AND (NEW.cargo = 'se'))) OR 
			(( tipo_departamento = 'SE') AND (nombre_departamento = 'Mantenimiento') AND ((NEW.cargo = 'me') or (NEW.cargo = 'el'))) OR
			(( tipo_departamento = 'SE') AND (nombre_departamento = 'Control de Calidad') AND (NEW.cargo = 'in')) OR
			((tipo_departamento = 'DE' OR tipo_departamento = 'AL') AND (NEW.cargo = 'og')) THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Cargo no compatible con el Departamento.';
	END;
	$$ LANGUAGE plpgsql;	

	--Numero 3
	CREATE OR REPLACE FUNCTION SUPERVISOR_DEPARTAMENTO() RETURNS TRIGGER AS $$ 
	DECLARE
		supervisor numeric(4);
	BEGIN
		IF (NEW.cargo <> 'og') OR (new.cargo = 'og') AND (NEW.supervisor IS NULL) THEN 
			RETURN NEW;
		END IF;
		
		SELECT count(*) INTO supervisor FROM empleado e WHERE num_expediente = NEW.supervisor AND e.trabaja = NEW.trabaja;
		IF supervisor > 0 THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El supervisor y el Operario General, pertenecen a distintos departamentos.';		
	END;
	$$ LANGUAGE plpgsql;
	
	--Numero 4
	CREATE OR REPLACE FUNCTION NO_SUPERVISION() RETURNS TRIGGER AS $$ 
	Declare 
		cant_supervisados numeric (2);
	BEGIN
		IF (new.cargo <> 'og' and new.supervisor is null) THEN
			RETURN NEW;
		END IF;
		
		SELECT COUNT(*) INTO cant_supervisados FROM empleado e WHERE e.supervisor = NEW.supervisor AND e.supervisor is null; 
		IF ((new.cargo = 'og') AND ((cant_supervisados >= 0))) THEN
			RETURN NEW;		
		END IF;		 
		RAISE EXCEPTION 'Error: El empleado no puede tener supervisor.';
	END;
	$$ LANGUAGE plpgsql;
	
	
	--RESUMEN_REUNION
	--Numero 6
	CREATE OR REPLACE FUNCTION REUNION_SUPERVISOR() RETURNS TRIGGER AS $$ 
	DECLARE
		supervisor numeric(4);
		cargo_actual varchar(2);
	BEGIN
		SELECT e.supervisor, e.cargo FROM EMPLEADO e WHERE e.num_expediente = NEW.num_expediente INTO supervisor, cargo_actual;
		
		IF (supervisor IS NULL) AND (cargo_actual = 'og') THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El empleado no es un supervisor.';
	END;
	$$ LANGUAGE plpgsql;
	
	--INASISTENCIA 
	--Numero 7
	CREATE OR REPLACE FUNCTION SUPERVISION_CONGRUENTE() RETURNS TRIGGER AS $$
	DECLARE
		cantidad numeric(1);
	BEGIN
		SELECT count(*) INTO cantidad FROM empleado e WHERE e.num_expediente = NEW.num_expediente AND e.supervisor = NEW.num_expediente_supervisor;
		
		IF cantidad = 0 THEN 
			RAISE EXCEPTION 'Error: El empleado no está bajo la supervisión de este supervisor.';
		END IF;
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	/*
		Cuando se registre un id_empleado en la tabla, debe crearse un registro de inasistencia en la tabla de det_expediente.
	*/
	--Numero 8
	CREATE OR REPLACE FUNCTION INASISTENCIA_REGISTRADA() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO det_exp VALUES (NEW.num_expediente, nextval('det_exp_uid_seq'), NEW.fecha_hora, 'in', NULL, NULL, NULL, 'Falto a la ruenión semanal.');
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	--DET_EXP
	--Numero 9
	CREATE OR REPLACE FUNCTION DET_EXP_CAMPOS() RETURNS  TRIGGER AS $$
	DECLARE
	BEGIN
		IF  ((NEW.motivo = 'in' OR NEW.motivo = 'am') AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'bm' OR NEW.motivo = 'ba') AND (NEW.monto_bono IS NOT NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'lt') AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NOT NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'he')  AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NOT NULL)) OR THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Está ingresando información en un campo que no corresponde al motivo..';
	END;
	$$ LANGUAGE plpgsql;
	
		--Numero 11
	CREATE OR REPLACE FUNCTION LH_TARDE_EXTRA() RETURNS TRIGGER AS $$
		DECLARE
		existe numeric(1);
		BEGIN
		--Revisa si es diferente a los campos a revisar
		IF (NEW.motivo <> 'lt') OR (NEW.motivo <> 'he') THEN
			RETURN NEW; 
		END IF;

		--Se realiza la consulta;
		Select COUNT(*) INTO existe FROM departamento d, empleado e WHERE d.uid_departamento = e.trabaja and  d.nombre = 'Hornos'  
		and e.num_expediente = NEW.num_expediente;
		
		IF (existe = 1) AND (NEW.motivo = 'lt') OR (NEW.motivo = 'he')THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Motivo invalida, porque el empleado no es un Hornero.';
		END;
	$$ LANGUAGE plpgsql;
	
	--HIST_TURNO
	--Numero 12
	CREATE OR REPLACE FUNCTION HORNERO_CARGO() RETURNS TRIGGER AS $$
	DECLARE
		existe numeric(1);
	BEGIN
		Select COUNT(*) INTO existe FROM departamento d, empleado e WHERE d.uid_departamento = e.trabaja and  d.nombre = 'Hornos'  
		and e.num_expediente = NEW.num_expediente;
		IF existe = 1 THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El empleado no es un Hornero.';
	END;
	$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------
--                                           Trigger                                                  --
--------------------------------------------------------------------------------------------------------

--Proceso Venta

	--EMPLEADO
	CREATE OR REPLACE TRIGGER GERENTE_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION GERENCIA_EMPLEADO(); --1
	CREATE OR REPLACE TRIGGER DEPARTAMENTO_CARGO_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION DEPARTAMENTO_EMPLEADO(); --2 
	CREATE OR REPLACE TRIGGER SUPERVISOR_DEPARTAMENTO_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION SUPERVISOR_DEPARTAMENTO(); --3
	CREATE OR REPLACE TRIGGER NO_SUPERVISION_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION NO_SUPERVISION(); --4	
	
	--RESUMEN_REUNION
	CREATE OR REPLACE TRIGGER REUNION_SUPERVISOR BEFORE INSERT OR UPDATE ON REUNION FOR EACH ROW EXECUTE FUNCTION REUNION_SUPERVISOR(); --6
	
	--INASISTENCIA 
	CREATE OR REPLACE TRIGGER SUPERVISION_CONGRUENTE_INASISTENCIA BEFORE INSERT OR UPDATE ON REUNION FOR EACH ROW EXECUTE FUNCTION REUNION_SUPERVISOR(); --7
	CREATE OR REPLACE TRIGGER inasistencia_registrada AFTER INSERT ON inasistencia FOR EACH ROW EXECUTE FUNCTION INASISTENCIA_REGISTRADA();--8
	--DET_EXP
	CREATE OR REPLACE TRIGGER CAMPO_DET_EXP BEFORE INSERT ON DET_EXP FOR EACH ROW EXECUTE FUNCTION DET_EXP_CAMPOS(); --9
	CREATE OR REPLACE TRIGGER  LLEGADA_TARDE_HORAS_EXTRAS_DET_EXP BEFORE INSERT ON DET_EXP FOR EACH ROW EXECUTE FUNCTION LH_TARDE_EXTRA(); --11

	--HIST_TURNO
	CREATE OR REPLACE TRIGGER HORNERO_CARGO_HIST_TURNO BEFORE INSERT ON HIST_TURNO FOR EACH ROW EXECUTE FUNCTION HORNERO_CARGO(); --12

--------------------------------------------------------------------------------------------------------
--                                           INDEX                                                    --
--------------------------------------------------------------------------------------------------------
--Proceso Catalogo
	CREATE INDEX PIE_MOLDE ON PIEZA(uid_molde);

--Proceso Empleado
	CREATE INDEX EMP_SUPERVISOR ON EMPLEADO (supervisor);
	CREATE INDEX EMP_DEP ON EMPLEADO(trabaja);
	CREATE INDEX DEP_PADRE ON DEPARTAMENTO(uid_dep_padre);

--Proceso Venta
	CREATE INDEX CLI_PAIS ON CLIENTE(uid_pais);
	CREATE INDEX FAC_PEDIDO ON FACTURA (uid_cliente);
	CREATE INDEX DET_PED_PIE_JUEGO ON DETALLE_PEDIDO_PIEZA(uid_juego);
	CREATE INDEX DET_PED_PIE_PIEZA ON DETALLE_PEDIDO_PIEZA(uid_pieza, uid_coleccion);

--------------------------------------------------------------------------------------------------------
--                                           VIEW                                                     --
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW nombres_moldes AS

	SELECT m.uid_molde, 
		CASE WHEN m.tipo = 'JA' THEN 'Jarra'
			WHEN m.tipo = 'TT' THEN 'Tetera'
			WHEN m.tipo = 'LE' THEN 'Lechera'
			WHEN m.tipo = 'AZ' THEN 'Azucarero'
			WHEN m.tipo = 'CA' THEN 'Cazuela'
			WHEN m.tipo = 'BD' THEN 'Bandeja'
			WHEN m.tipo = 'PL' THEN 'Plato'
			WHEN m.tipo = 'TA' THEN 'Taza'
			WHEN m.tipo = 'EN' THEN 'Ensaladera'
		END 

		||''||

		CASE WHEN m.tipo_plato = 'HO' THEN ' Hondo'
			WHEN m.tipo_plato = 'LL' THEN ' llano'
			WHEN m.tipo_plato = 'TT' THEN ' taza té'
			WHEN m.tipo_plato = 'TC' THEN ' taza café'
			WHEN m.tipo_plato = 'TM' THEN ' taza moka'
			WHEN m.tipo_plato = 'PO' THEN ' postre'
			WHEN m.tipo_plato = 'PR' THEN ' presentación'
			WHEN m.tipo_plato = 'PA' THEN ' pasta'
			ELSE ''
		END

		||''||

		CASE WHEN m.tipo_taza = 'CS' THEN ' café sin plato'
			WHEN m.tipo_taza = 'CC' THEN ' café con plato'
			WHEN m.tipo_taza = 'TS' THEN ' té sin plato'
			WHEN m.tipo_taza = 'TC' THEN ' té con plato'
			WHEN m.tipo_taza = 'MS' THEN ' moka sin plato'
			WHEN m.tipo_taza = 'MC' THEN ' moka sin plato'
			ELSE ''
		END

		||''||

		CASE WHEN m.forma = 'ova' THEN ' ovalado'
			 WHEN m.forma = 'rec' THEN ' rectangular'
			 WHEN m.forma = 'cua' THEN ' cuadrado'
			 WHEN m.forma = 'red' THEN ' redondo'
			 ELSE ''
		END

		||' '|| m.tamaño
		||''|| COALESCE(to_char(m.volumen,'9.9') || 'lts','')
		||''|| COALESCE(to_char(m.cant_persona,'9') || 'pers','')

		AS molde
	FROM molde m;  

