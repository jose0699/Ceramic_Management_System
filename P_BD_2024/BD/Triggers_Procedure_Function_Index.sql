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
		IF (EXTRACT(DAY FROM NOW() - NEW.fecha_nacimiento) / 365) <= 35 THEN
			RAISE EXCEPTION 'Error: Para ocupar el cargo de "Gerencia" debe ser mayor de 35 años.';
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
			( tipo_departamento = 'SE') AND (nombre_departamento = 'Control de Calidad') AND (NEW.cargo = 'in') OR
			((tipo_departamento = 'DE' OR tipo_departamento = 'AL') AND (NEW.cargo = 'og')) THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Cargo no compatible con el Departamento.';
	END;
	$$ LANGUAGE plpgsql;	

	--Numero 3
	/*CREATE OR REPLACE FUNCTION SUPERVISOR_EMPLEADO () RETURNS TRIGGERS AS $$ 
	DECLARE
		supervisor numeric(4);
		cargo_jefe varchar(2);
	BEGIN
		SELECT e.supervisor, e.cargo FROM EMPLEADO e where e.num_expediente = NEW.supervisor INTO supervisor, cargo_jefe;
		
		IF () OR ((expediente = NEW.trabaja) AND (cargo_jefe = 'og'))   THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: supervisor no pertenece al mismo departamento.';
	END;
	$$ LANGUAGE plpgsql;*/
		
	--RESUMEN_REUNION
	--Numero 5
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
	
--------------------------------------------------------------------------------------------------------
--                                           Trigger                                                  --
--------------------------------------------------------------------------------------------------------

--Proceso Venta

	--EMPLEADO
	CREATE OR REPLACE TRIGGER GERENTE_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION GERENCIA_EMPLEADO();
	CREATE OR REPLACE TRIGGER DEPARTAMENTO_CARGO_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION DEPARTAMENTO_EMPLEADO(); 
	
	--RESUMEN_REUNION
	CREATE OR REPLACE TRIGGER REUNION_SUPERVISOR BEFORE INSERT OR UPDATE ON RESUMEN_REUNION FOR EACH ROW EXECUTE FUNCTION REUNION_SUPERVISOR();
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



