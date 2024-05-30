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

	--DETALLE_PEDIDO_PIEZA
	CREATE FUNCTION FUN_ARCO_DETALLE() RETURNS TRIGGER AS $$ BEGIN
		IF (NEW.uid_juego IS NOT NULL) AND (NEW.uid_pieza IS NOT NULL) AND (NEW.uid_coleccion IS NOT NULL)
			THEN RAISE EXCEPTION 'Error: Solo se admite un producto por detalle.';
		END IF;
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION FUN_UN_DETALLE() RETURNs TRIGGER AS $$ BEGIN
		IF (NEW.uid_juego IS NULL) AND (NEW.uid_pieza IS NULL) AND (NEW.uid_coleccion IS NULL)
			THEN RAISE EXCEPTION 'Error: El detalle debe estar asociado aun producto.';
		END IF;
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------
--                                           Trigger                                                  --
--------------------------------------------------------------------------------------------------------

--Proceso Venta
	--DETALLE_PEDIDO_PIEZA
	CREATE OR REPLACE TRIGGER ARCO_DETALLE BEFORE INSERT OR UPDATE ON DETALLE_PEDIDO_PIEZA FOR EACH ROW EXECUTE FUNCTION FUN_ARCO_DETALLE();
	CREATE OR REPLACE TRIGGER UN_DETALLE BEFORE INSERT OR UPDATE ON DETALLE_PEDIDO_PIEZA FOR EACH ROW EXECUTE FUNCTION FUN_UN_DETALLE();
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



