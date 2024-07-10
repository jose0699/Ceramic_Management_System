---------------------------------------------------------------------------------------------------------
--											ALTER TABLE  											   --
---------------------------------------------------------------------------------------------------------

BEGIN; ALTER TABLE PEDIDO DROP  CONSTRAINT check_estado_pedido; COMMIT;
BEGIN; ALTER TABLE PEDIDO ADD CONSTRAINT check_estado_pedido CHECK (estado in ('A', 'C', 'E', 'P')); COMMIT;

BEGIN; ALTER TABLE FACTURA ADD CONSTRAINT unique_pedido UNIQUE (uid_pedido); COMMIT;

---------------------------------------------------------------------------------------------------------
--							          FUNCIONES Y PROCEDIMIENTOS									   --
---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE ACTUALIZAR_COLA_PEDIDO(emision DATE, cliente numeric(3)) AS $$
	DECLARE
		new_fecha date;
		CONFLICTO numeric(1);
		cliente_conflicto numeric(3);
	BEGIN
		--Se agrega un dia a la fecha del pedido
		new_fecha := emision+INTERVAL '1 DAY';

		--Se crea Tabla CLIENTE_CONTRATO.
		CREATE TEMPORARY TABLE CLIENTE_CONTRATO ( pk_cliente numeric(3));

		--Se inserta todos los clientes con contrato en la tabla CLIENTE_CONTRATO
		INSERT INTO CLIENTE_CONTRATO (pk_cliente) SELECT con.uid_cliente FROM CONTRATO con WHERE con.fecha_hora_fin IS NULL;

		--Se crea la tabla CLIENTE_MODIFICAR
		CREATE TEMPORARY TABLE CLIENTE_MODIFICAR (pk_cliente numeric(3), pk_pedido NUMERIC(6), old_entrega DATE, estado varchar(1));

		-- Se interta todos los clientes que tenga un pedido con la fecha.
		INSERT INTO CLIENTE_MODIFICAR (pk_cliente, pk_pedido, old_entrega, estado) SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega, po.estado FROM PEDIDO po 
		WHERE po.estado IN ('E', 'A') AND po.fecha_entrega >= emision ORDER BY po.fecha_entrega ASC;
		CONFLICTO:= 1;

		WHILE CONFLICTO > 0 LOOP
			--Se revisa si en la fecha genera un conflicto
			IF 0 = (SELECT COUNT(*) FROM CLIENTE_MODIFICAR cm WHERE  cm.old_entrega = new_fecha) THEN 
				--Sin conflictos de fechas y actualiza el pedido.
				UPDATE PEDIDO SET fecha_entrega = new_fecha  WHERE uid_cliente = cliente AND fecha_entrega = emision;
				CONFLICTO:= 0;
				
			ELSE 
				--Se revisa si la fecha genera un conflicto con un cliente con contrato
				IF 1 = (SELECT COUNT(*) FROM CLIENTE_CONTRATO cc INNER JOIN 
							CLIENTE_MODIFICAR clmo ON cc.pk_cliente = clmo.pk_cliente
						WHERE clmo.old_entrega = new_fecha)
				THEN
					--Se agrega un dia a la fecha del pedido
					new_fecha := new_fecha + INTERVAL '1 DAY';
				ELSE
					IF 0 < (SELECT COUNT(*) FROM CLIENTE_MODIFICAR climod WHERE climod.old_entrega = new_fecha AND climod.estado = 'A')
					THEN 
						--Se agrega un dia a la fecha del pedido
						new_fecha := new_fecha + INTERVAL '1 DAY';	
					ELSE
						--Se busca el pk del cliente (cliente_conflicto)
						SELECT climodi.pk_cliente into cliente_conflicto FROM CLIENTE_MODIFICAR climodi WHERE climodi.old_entrega = new_fecha;

						--Se elimina tablas para limpiar memoria
						DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
						DROP TABLE IF EXISTS CLIENTE_CONTRATO;

						CALL ACTUALIZAR_COLA_PEDIDO(new_fecha ,cliente_conflicto);

						--Se actualiza la fecha del pedido
						UPDATE PEDIDO SET fecha_entrega = new_fecha  WHERE uid_cliente = cliente AND fecha_entrega = emision;
						CONFLICTO:= 0;
					END IF;
				END IF;
			END IF;
			--Se elimina tablas para limpiar memoria
			DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
			DROP TABLE IF EXISTS CLIENTE_CONTRATO;
		END LOOP;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------
BEGIN;
	CREATE OR REPLACE FUNCTION CONFLICTO_FECHA (emision DATE, cliente numeric(3)) RETURNS DATE AS $$
	DECLARE
		existe numeric(1);
		cliente_conflicto numeric(3);
		aux numeric(1);
		aux2 numeric(1);
		aux3 numeric(1);
		aux4 varchar(1);
	BEGIN
		--Se crea Tabla CLIENTE_CONTRATO.
		CREATE TEMPORARY TABLE CLIENTE_CONTRATO ( pk_cliente numeric(3));

		--Se inserta todos los clientes con contrato en la tabla CLIENTE_CONTRATO
		INSERT INTO CLIENTE_CONTRATO (pk_cliente) SELECT con.uid_cliente FROM CONTRATO con WHERE con.fecha_hora_fin IS NULL;

		--Se crea la tabla CLIENTE_MODIFICAR
		CREATE TEMPORARY TABLE CLIENTE_MODIFICAR (pk_cliente numeric(3), pk_pedido NUMERIC(6), old_entrega DATE, estado varchar(1));

		-- Se interta todos los clientes que tenga un pedido con la fecha.
		INSERT INTO CLIENTE_MODIFICAR (pk_cliente, pk_pedido, old_entrega, estado) SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega, po.estado FROM PEDIDO po 
		WHERE po.estado IN ('E', 'A') AND po.fecha_entrega >= emision ORDER BY po.fecha_entrega ASC ;

		--Consulta si el cliente tiene contrato activo.
		SELECT COUNT(*) into aux FROM CLIENTE_CONTRATO co WHERE co.pk_cliente = cliente;	
		existe := 1;

		IF aux = 0 THEN
			--Ciclo para verificar si hay conclito de fecha, simplemente el cliente no tiene contrato entonces se  
			--le añade un día hasta encontrar una fecha sin conclicto.
			WHILE existe = 1 LOOP
				emision := emision + Interval '1 DAY';
				SELECT COUNT(*) into existe FROM CLIENTE_MODIFICAR cm WHERE cm.old_entrega = emision;
			END LOOP;
		
			--Se elimina tablas para limpiar memoria
			DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
			DROP TABLE IF EXISTS CLIENTE_CONTRATO;

			--Retorna la fecha sin conflicto.
			RETURN emision;
		ELSE 
			--Esta parte esta crudo
			WHILE existe = 1 LOOP
				--Verifica existencia de conflicto entre fecha
				SELECT COUNT(*) into aux2 FROM CLIENTE_MODIFICAR cmo WHERE cmo.old_entrega = emision;
				IF aux2 = 1 THEN
					--Verifica si la fecha que genera el conclicto sea dos clientes con contrato y dos pedidos emitidos
					SELECT COUNT(*) INTO aux3 FROM CLIENTE_CONTRATO clco
						INNER JOIN CLIENTE_MODIFICAR clmo ON clco.pk_cliente = clmo.pk_cliente
					WHERE clmo.old_entrega = emision AND clmo.estado = 'E';

					--Si aux3 = 0 entonces el conclicto lo genera dos cliente con contratos
					IF aux3 = 0 THEN
						--Se busca el pk del cliente que genera el conflicto
						SELECT  climodif.pk_cliente INTO cliente_conflicto  FROM CLIENTE_MODIFICAR climodif WHERE climodif.old_entrega = emision;

						--Se elimina tablas para limpiar memoria
						DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
						DROP TABLE IF EXISTS CLIENTE_CONTRATO;

						--Se actualiza la cola de pedido
						CALL ACTUALIZAR_COLA_PEDIDO(emision,cliente_conflicto);

						RETURN emision;		
					END IF;
					--Se añade un dia a la fecha de entrega
					emision := emision + Interval '1 DAY';
				ELSE 
					--Se elimina tablas para limpiar memoria
					DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
					DROP TABLE IF EXISTS CLIENTE_CONTRATO;

					RETURN emision;
				END IF;
			END LOOP;

			--Se elimina tablas para limpiar memoria
			DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
			DROP TABLE IF EXISTS CLIENTE_CONTRATO;
			
			RETURN emision;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION ASIGNAR_FECHA_ENTREGA(emision DATE, cliente numeric(3), id_pedido numeric(6)) RETURNS DATE AS $$
	DECLARE
		aux numeric(1);
	BEGIN
		--Posible fecha de entrega
		emision := emision + interval '2 months';

		--Se busca si existe alguien con la misma fecha, si no hay nadie es la fecha de entrega sino, se buscara posibles fecha de entrega.
		SELECT COUNT(*) INTO aux FROM PEDIDO pe WHERE pe.fecha_entrega = emision AND pe.estado IN ('E', 'A');

		IF aux = 0 THEN
			RAISE NOTICE 'Pedido #% emitido con fecha de entrega para: %', id_pedido, emision;
			RETURN emision;
		ELSE
			SELECT * INTO emision FROM CONFLICTO_FECHA(emision, cliente);
			RAISE NOTICE 'Pedido #% emitido con fecha de entrega para: %', id_pedido, emision;
			RETURN emision;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION CALCULAR_MONTO_FACTURA(id_pedido IN pedido.uid_pedido%TYPE) RETURNS numeric(8,2) AS $$
		DECLARE
			monto_sin_descuento numeric (8,2);
			tipo_p varchar(1);
			Descuento numeric (8,2);
			monto_IVA numeric(8,2);
		BEGIN
			--Descuento ofrecido
			SELECT COALESCE (c.porcentaje_descuento, 0), p.tipo_pedido INTO Descuento, tipo_p
			FROM CLIENTE cl
				LEFT JOIN CONTRATO c ON cl.uid_cliente = c.uid_cliente 
				INNER JOIN PEDIDO p ON cl.uid_cliente = p.uid_cliente 
			WHERE p.uid_pedido = id_pedido AND c.fecha_hora_fin IS NULL;

			--Monto sin el descuento
			SELECT  COALESCE(SUM(dt.cantidad * COALESCE(fh.precio,pi.precio)), 0) + 
											COALESCE((SELECT COALESCE(SUM(d.cantidad * (COALESCE(fam.precio,pz.precio) * dv.cantidad)) * 0.85, 0) 
																		FROM pedido p 
																		INNER JOIN DETALLE_PEDIDO_PIEZA d ON p.uid_pedido = d.uid_pedido
																		INNER JOIN DETALLE_PIEZA_VAJILLA dv ON d.uid_juego = dv.uid_juego
																		INNER JOIN PIEZA pz ON pz.uid_pieza = dv.uid_pieza
																		LEFT JOIN familiar_historico_precio fam ON pz.uid_pieza = fam.uid_pieza
																	WHERE p.uid_pedido = id_pedido AND 
																			d.uid_juego IS NOT NULL AND 
																			fam.fecha_fin IS NULL), 0) INTO  monto_sin_descuento		
				FROM PEDIDO pe 
				INNER JOIN DETALLE_PEDIDO_PIEZA dt ON pe.uid_pedido = dt.uid_pedido
				INNER JOIN PIEZA pi ON pi.uid_pieza = dt.uid_pieza
				LEFT JOIN familiar_historico_precio fh ON pi.uid_pieza = fh.uid_pieza
			WHERE pe.uid_pedido = id_pedido  AND 	
					dt.uid_juego IS NULL AND 
					fh.fecha_fin IS NULL;	

			IF tipo_p = 'F' THEN
				monto_IVA := monto_sin_descuento*0.16;
			ELSE 
				monto_IVA := 0;
			END IF;

			IF Descuento <> 0 THEN
				RETURN ((monto_sin_descuento * (1 -(Descuento/100)))+monto_IVA):: Numeric(8,2);
			ELSE 
				RETURN ((monto_sin_descuento)+monto_IVA)::Numeric(8,2);
			END IF;
		END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------
--												PEDIDO                                                 --
---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE INSERTAR_PEDIDO(cliente numeric(6), tipo varchar(1), entrega date) AS $$
	BEGIN
		IF tipo IN ('F', 'I') THEN
			INSERT INTO PEDIDO VALUES (cliente, nextval('pedido_uid_seq'), current_date, null, entrega, 'P', tipo);
			RAISE NOTICE 'Pedido ingresado exitosamente para el cliente #%, ESTADO: En Proceso, Numero del pedido: #%', cliente, currval('pedido_uid_seq');
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;


BEGIN;
	CREATE OR REPLACE PROCEDURE EMITIR_PEDIDO(cliente numeric(6) ,id_pedido numeric(6)) AS $$
	BEGIN
		UPDATE PEDIDO SET estado = 'E', fecha_entrega = (SELECT * FROM ASIGNAR_FECHA_ENTREGA(current_date, cliente, id_pedido)) WHERE uid_pedido = id_pedido;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;


---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE INSERTAR_DETALLE_PEDIDO(
		pedido numeric(6), 
		producto numeric(3), 
		cantidad numeric(3), 
		tipo_pedido numeric(1)) 
	AS $$
	DECLARE
		num_detalle numeric(3);
		cliente numeric(3);
		coleccion numeric(3);
		estado_pedido varchar(1);
		tipo varchar(1);
		tipo_producto varchar(1);
	BEGIN
		--Se busca la cantidad de detalle existente del pedido.
		select count(*) into num_detalle FROM detalle_pedido_pieza dpp WHERE dpp.uid_pedido = pedido; 

		--Incrementa el número del detalle.
		num_detalle := num_detalle + 1;

		--Se busca la pk del cliente y el tipo de pedido (F o I).
		SELECT p.uid_cliente, p.tipo_pedido, p.estado INTO cliente, tipo, estado_pedido FROM PEDIDO p WHERE p.uid_pedido = pedido;


		--Si tipo = 1 entonces estamos manejando una Vajilla.
		IF tipo_pedido = 1 THEN
			--Se busca la linea de la vajilla.
			SELECT co.linea into tipo_producto FROM COLECCION co
				INNER JOIN DETALLE_PIEZA_VAJILLA dpv ON co.uid_coleccion = dpv.uid_coleccion 
			WHERE uid_juego = producto Limit 1;

			--Se verifica si coincide con la linea del pedido
			IF tipo = tipo_producto THEN
				insert into DETALLE_PEDIDO_PIEZA values( cliente, pedido, num_detalle, cantidad , producto);
			ELSE
				RAISE EXCEPTION 'Error: Productos distintos';
			END IF;
		END IF;

		--Si tipo = 2 entonces estamos manejando una Pieza
		IF tipo_pedido = 2 THEN
			--Se busca la pk y linea de la coleccion de la pieza
			SELECT pi.uid_coleccion, col.linea  into coleccion, tipo_producto FROM PIEZA pi
				INNER JOIN COLECCION col ON col.uid_coleccion = pi.uid_coleccion
			WHERE pi.uid_pieza = producto;

			--Se verifica si coincide con la linea del pedido
			IF tipo = tipo_producto THEN
				insert into DETALLE_PEDIDO_PIEZA values( cliente, pedido, num_detalle, cantidad, null, coleccion, producto);
			ELSE
				RAISE EXCEPTION 'Error: Productos distintos';
			END IF;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION CONTAR_PEDIDO(pedido numeric(6)) RETURNS numeric(6) AS $$
	DECLARE 
		pieza numeric(6);
		vajilla numeric(6);
	BEGIN
		SELECT COALESCE(SUM(cantidad), 0) INTO pieza FROM DETALLE_PEDIDO_PIEZA dpp 	WHERE dpp.uid_pedido = pedido AND dpp.uid_juego IS NULL;

		SELECT COALESCE(SUM(dp.cantidad * COALESCE(dpv.cantidad, 0)), 0) INTO vajilla FROM DETALLE_PIEZA_VAJILLA dpv
			INNER JOIN DETALLE_PEDIDO_PIEZA dp ON dpv.uid_juego = dp.uid_juego
		WHERE dp.uid_pedido = pedido AND dp.uid_juego IS NOT NULL;

		RETURN (pieza + vajilla);
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------
--												FACTURA												   --
---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE GENERAR_FACTURA(pedido numeric(6)) AS $$
	BEGIN
		IF 15 <= (SELECT * FROM CONTAR_PEDIDO(pedido)) THEN
			INSERT INTO factura values((SELECT p.uid_cliente FROM PEDIDO p WHERE p.uid_pedido = pedido), pedido, nextval('factura_uid_seq'), 
									   current_date,( SELECT * FROM CALCULAR_MONTO_FACTURA(pedido)));
			UPDATE PEDIDO SET estado = 'A' WHERE uid_pedido = pedido;
		ELSE
			RAISE EXCEPTION 'Error: Cantidad de piezas insuficientes.';
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
---------------------------------------------------------------------------------------------------------
--													CONTRATOS										   --
---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE CERRAR_CONTRATO(id_cliente IN cliente.uid_cliente%TYPE) AS $$ 
		BEGIN
			UPDATE CONTRATO SET fecha_hora_fin = NOW() WHERE uid_cliente = id_cliente AND fecha_hora_fin IS NULL;

			RAISE NOTICE 'Contrato cerrado exitosamente para el cliente solicitado';
		END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE PROCEDURE ABRIR_CONTRATO(id_cliente IN cliente.uid_cliente%TYPE, descuento IN contrato.porcentaje_descuento%TYPE) AS $$
			BEGIN
				INSERT INTO CONTRATO (uid_cliente, num_contrato, porcentaje_descuento, fecha_hora_emision,fecha_hora_fin)
							 VALUES(id_cliente, nextval('contrato_uid_seq'), descuento, NOW(), NULL);

				RAISE NOTICE 'Contrato abierto exitosamente para el cliente solicitado';
			END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION VALIDAR_CIERRE_CONTRATO() RETURNS TRIGGER AS $$
			BEGIN
				IF new.fecha_hora_fin < old.fecha_hora_emision + interval '1 year' THEN
					RAISE EXCEPTION 'Error: El contrato ha estado en vigencia por menos de un año, debe esperar como mínimo un año después de la emisión del mismo para poder cancelarlo';
				END IF; 

				RETURN NEW;

			END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION VALIDAR_APERTURA_CONTRATO() RETURNS TRIGGER AS $$
			DECLARE
				id_cliente numeric(3);
				existe numeric(2);
			BEGIN
				id_cliente := new.uid_cliente;


				SELECT COUNT(*) INTO existe FROM CONTRATO c WHERE c.uid_cliente = id_cliente AND fecha_hora_fin IS NULL; 

				IF existe <> 0 THEN

					RAISE EXCEPTION 'Error: El cliente que solicita el contrato ya tiene un contrato activo en estos momentos.';

				ELSE 

					IF new.fecha_hora_fin IS NOT NULL THEN
						RAISE EXCEPTION 'Error: Al abrir un contrato, este no puede tener una fecha de finalización asignada';
					END IF;

				END IF; 

				RETURN NEW;

			END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------

BEGIN; CREATE OR REPLACE TRIGGER VALIDEZ_FECHA_CIERRE_CONTRATO BEFORE UPDATE OF fecha_hora_fin ON CONTRATO FOR EACH ROW EXECUTE FUNCTION VALIDAR_CIERRE_CONTRATO(); COMMIT;
BEGIN; CREATE OR REPLACE TRIGGER VALIDEZ_FECHA_APERTURA_CONTRATO BEFORE INSERT ON CONTRATO FOR EACH ROW EXECUTE FUNCTION VALIDAR_APERTURA_CONTRATO(); COMMIT;

---------------------------------------------------------------------------------------------------------
	
BEGIN;
	CREATE OR REPLACE FUNCTION MOSTRAR_COLA_PEDIDOS(mes numeric(2), ano numeric(4)) RETURNS
			TABLE (	  
				id_pedido numeric(3) 
				, nombre_cliente varchar(50) 
				, pais_del_cliente varchar(40)
				, tipo_pedido text 
				, fecha_entrega date)
	AS $$
	DECLARE 
		fecha_inicio date;
		fecha_fin date;
	BEGIN
		fecha_inicio := to_date(CONCAT(to_char(ano,'9999'),' ',to_char(mes,'99'),' ', '01'),'YYYY MM DD');
		fecha_fin := fecha_inicio + INTERVAL '1 month' - INTERVAL '1 day';

		RETURN QUERY SELECT 
									p.uid_pedido,
									c.nombre,
									pa.nombre,
									CASE
										WHEN p.tipo_pedido = 'F' THEN 'FAMILIAR'
										WHEN p.tipo_pedido = 'I' THEN 'INSTITUCIONAL'
									END AS tipo_pedido,
									p.fecha_entrega
								FROM PEDIDO p
								JOIN CLIENTE c ON c.uid_cliente = p.uid_cliente
								JOIN PAIS pa ON pa.uid_pais = c.uid_pais
								WHERE (p.fecha_entrega BETWEEN fecha_inicio AND fecha_fin) AND p.estado = 'E'
								ORDER BY 5;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;			
---------------------------------------------------------------------------------------------------------
--					 				Funciones Reportes                                                 --
---------------------------------------------------------------------------------------------------------

BEGIN;
	CREATE OR REPLACE FUNCTION DATOS_BASICO_PEDIDO (num_pedido numeric(6))
		RETURNS TABLE (
			uid_pedido numeric(6),
			fecha_emision text,
			fecha_entrega text,
			fecha_entrega_deseada text,
			nombre_pais varchar(40),
			nombre_cliente  varchar(50),
			telefono_cliente varchar(15),
			email_cliente varchar(256),
			estado_pedido Text,
			tipo_pedido Text
		)
	AS $$
	BEGIN
		RETURN QUERY
		SELECT 
				 p.uid_pedido,
				 to_char(p.fecha_emision, 'DD "de" TMMonth "de" YYYY'),
			   to_char(p.fecha_entrega,'DD "de" TMMonth "de" YYYY'),
			   to_char(p.fecha_entrega_deseada, 'DD "de" TMMonth "de" YYYY'),
			   pa.nombre,
			   c.nombre,
			   c.telefono,
			   c.email,
			   CASE
				   WHEN p.estado = 'A' THEN 'Aprobado'
				   WHEN p.estado = 'C' THEN 'Cancelado'
				   WHEN p.estado = 'E' THEN 'Emitido'
			   END AS estado,
			   CASE
				   WHEN p.tipo_pedido = 'F' THEN 'Familiar'
				   WHEN p.tipo_pedido = 'I' THEN 'Institucional'
			   END AS pedido
		FROM CLIENTE c
			INNER JOIN PAIS pa ON pa.uid_pais = c.uid_pais
			INNER JOIN PEDIDO p ON c.uid_cliente = p.uid_cliente
		WHERE p.uid_pedido = num_pedido; 
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION DATOS_BASICO_FACTURA (num_factura IN FACTURA.numero_factura%TYPE)
		RETURNS TABLE (
			uid_pedido numeric(6),
			fecha_emision text,
			nombre_cliente  varchar(50),
			tipo_pedido varchar(1),
			monto_sin_descuento numeric (8,2),
			Descuento numeric (8,2),
			monto_descontado numeric (8,2),
			monto_total numeric(8,2)

		)
	AS $$
	DECLARE
		monto_sin_descuento numeric (8,2);
		Descuento numeric (8,2);
		monto numeric(8,2);
	BEGIN
		--Descuento ofrecido
		SELECT COALESCE (c.porcentaje_descuento, 0) INTO Descuento
		FROM CLIENTE cl
			 LEFT JOIN CONTRATO c ON cl.uid_cliente = c.uid_cliente 
			 INNER JOIN PEDIDO p ON cl.uid_cliente = p.uid_cliente 
			 INNER JOIN FACTURA fac ON fac.uid_pedido = p.uid_pedido
		WHERE fac.numero_factura = num_factura AND c.fecha_hora_fin IS NULL;

		--Monto sin el descuento
		SELECT  COALESCE(SUM(dt.cantidad * COALESCE(fh.precio,pi.precio)), 0) + 
										 COALESCE((SELECT COALESCE(SUM(d.cantidad * (COALESCE(fam.precio,pz.precio) * dv.cantidad)) * 0.85, 0) 
																FROM FACTURA f
																	INNER JOIN pedido p ON f.uid_pedido = p.uid_pedido
																	INNER JOIN DETALLE_PEDIDO_PIEZA d ON p.uid_pedido = d.uid_pedido
																	INNER JOIN DETALLE_PIEZA_VAJILLA dv ON d.uid_juego = dv.uid_juego
																	INNER JOIN PIEZA pz ON pz.uid_pieza = dv.uid_pieza
																	LEFT JOIN familiar_historico_precio fam ON pz.uid_pieza = fam.uid_pieza
																WHERE f.numero_factura = num_factura AND 
																		d.uid_juego IS NOT NULL AND 
																		fam.fecha_fin IS NULL), 0) INTO  monto_sin_descuento		
		FROM FACTURA fa
			INNER JOIN PEDIDO pe ON fa.uid_pedido = pe.uid_pedido
			INNER JOIN DETALLE_PEDIDO_PIEZA dt ON pe.uid_pedido = dt.uid_pedido
			INNER JOIN PIEZA pi ON pi.uid_pieza = dt.uid_pieza
			LEFT JOIN familiar_historico_precio fh ON pi.uid_pieza = fh.uid_pieza
		WHERE fa.numero_factura = num_factura  AND 	
			  dt.uid_juego IS NULL AND 
			  fh.fecha_fin IS NULL;	

		IF Descuento <> 0 THEN
			monto := (monto_sin_descuento * (1 -(Descuento/100))):: Numeric(8,2);
		ELSE 
			monto := (monto_sin_descuento)::Numeric(8,2);
		END IF;

		RETURN QUERY
		SELECT 
			   p.uid_pedido,
			   to_char(fact.fecha_emision, 'DD-TMMON-YYYY'),
			   c.nombre,
				 p.tipo_pedido,
			   monto_sin_descuento,
			   Descuento,
				 round(monto_sin_descuento*(Descuento/100), 2)::Numeric(8,2) AS monto_descontado,
			   monto
		FROM CLIENTE c
			INNER JOIN PEDIDO p ON c.uid_cliente = p.uid_cliente
			INNER JOIN FACTURA fact ON fact.uid_pedido = p.uid_pedido
		WHERE fact.numero_factura = num_factura; 
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

---------------------------------------------------------------------------------------------------------
/*                                        SEGURIDAD                                                    */
---------------------------------------------------------------------------------------------------------
--								       CREACION ROLES   											   --
---------------------------------------------------------------------------------------------------------
/*
	Se han definido los siguientes roles, basados en las funciones y responsabilidades descritas en el enunciado del proyecto:

	El proyecto contempla la creación de los siguientes roles:

	--Cliente
	--Empleado
	--Operario
	--Hornero
	--Supervisor
	--Gerente
	--Gerente planta
	--Secretaria
*/

	BEGIN; CREATE ROLE CLIENTE LOGIN; COMMIT;
	
	BEGIN; CREATE ROLE EMPLEADO LOGIN; COMMIT;
	BEGIN; CREATE ROLE OPERARIO LOGIN; COMMIT;
	BEGIN; CREATE ROLE HORNERO LOGIN; COMMIT;
	BEGIN; CREATE ROLE SUPERVISOR LOGIN; COMMIT;

	BEGIN; CREATE ROLE GERENTE LOGIN; COMMIT;
	BEGIN; CREATE ROLE GERENTE_PLANTA LOGIN; COMMIT;
	BEGIN; CREATE ROLE SECRETARIA LOGIN; COMMIT;

---------------------------------------------------------------------------------------------------------
--								      OTORGAR HERENCIA   											   --
---------------------------------------------------------------------------------------------------------
/*
	Según la información proporcionada, el proyecto contempla una estructura de herencia de privilegios 
	entre los diferentes roles:
	
	--Empleado
		Operario
		Gerente

	--Operario
		Hornero
		Supervisor

	--Gerente
		Secretaria
		Gerente de Planta
		Gerente Técnico (no es un rol)
		Gerente General (no es un rol)
		
	En esta estructura jerárquica, los privilegios y permisos se heredan desde los roles más generales hacia 
	los más específicos.	
*/
	BEGIN; ALTER ROLE EMPLEADO INHERIT; COMMIT;
	BEGIN; ALTER ROLE OPERARIO INHERIT; COMMIT;
	BEGIN; ALTER ROLE GERENTE INHERIT; COMMIT;

---------------------------------------------------------------------------------------------------------
--								       CREACION USUARIOS   											   --
---------------------------------------------------------------------------------------------------------
/*
	Los siguientes usuarios han sido creados siguiendo las inserciones ya existentes en la base de datos 
	correspondientes a los de Empleados y Clientes.
*/
	BEGIN; CREATE USER María_González WITH PASSWORD '21474659'; COMMIT;   
	BEGIN; CREATE USER Ana_Romero_Tules WITH PASSWORD '18934567'; COMMIT;
	BEGIN; CREATE USER Daniel_Guerrero  WITH PASSWORD '20876543'; COMMIT;

	BEGIN; CREATE USER Carlos_Torres WITH PASSWORD '27748963'; COMMIT;
	BEGIN; CREATE USER Luis_Blanco WITH PASSWORD '27474666';COMMIT;
	BEGIN; CREATE USER Carolina_Sánchez WITH PASSWORD '27474665'; COMMIT;
	BEGIN; CREATE USER María_González_López WITH PASSWORD '27474667'; COMMIT;
	BEGIN; CREATE USER Luis_Blanco_Fernández WITH PASSWORD '27441986'; COMMIT;
	BEGIN; CREATE USER Carlos_Blanco WITH PASSWORD '27365666';COMMIT;
	BEGIN; CREATE USER María_González_Suarez WITH PASSWORD '27364666'; COMMIT;
	BEGIN; CREATE USER Yuritza_Castillo WITH PASSWORD '27363666'; COMMIT;
	BEGIN; CREATE USER Luis_Blanco_Gutierrez WITH PASSWORD  '27362666'; COMMIT;

	BEGIN; CREATE USER Marcello_Servitad WITH PASSWORD '25474658'; COMMIT;
	BEGIN; CREATE USER Valentina_Harrison WITH PASSWORD '24485673'; COMMIT;
	BEGIN; CREATE USER Alejandro_Guzmán WITH PASSWORD '26321549' ; COMMIT;
	BEGIN; CREATE USER Sandra_Mendoza WITH PASSWORD '24210987' ; COMMIT;

	BEGIN; CREATE USER Ana_Romero_Flores WITH PASSWORD '27403661' ; COMMIT;
	BEGIN; CREATE USER Pedro_González WITH PASSWORD '23254321' ; COMMIT;

	BEGIN; CREATE USER Ana_Romero WITH PASSWORD '24360661'; COMMIT;
	BEGIN; CREATE USER Luis_Muñoz WITH PASSWORD '25147362'; COMMIT;

	BEGIN; CREATE USER Ana_Romero_Turmero WITH PASSWORD '27474661'; COMMIT;
	BEGIN; CREATE USER Carlos_Blanco_Montoya WITH PASSWORD '23372615' ; COMMIT;

	BEGIN; CREATE USER Ana_Romero_Texan WITH PASSWORD '28568661' ; COMMIT; 
	BEGIN; CREATE USER María_Gómez WITH PASSWORD '28261548'; COMMIT;

	BEGIN; CREATE USER Pedro_López WITH PASSWORD '28474660'  ; COMMIT;
	BEGIN; CREATE USER Gabriela_Martínez WITH PASSWORD '28251432'; COMMIT;
	BEGIN; CREATE USER Luis_Ramírez WITH PASSWORD '22548736' ; COMMIT;
	BEGIN; CREATE USER Andrea_Guerrero WITH PASSWORD '24721369' ; COMMIT;
	BEGIN; CREATE USER Carlos_Suárez WITH PASSWORD '23832147'; COMMIT;
	BEGIN; CREATE USER Isabel_Muñoz WITH PASSWORD '24943258' ; COMMIT; 
	BEGIN; CREATE USER Daniel_Romero WITH PASSWORD '24054369'; COMMIT;
	BEGIN; CREATE USER Jennifer_Gómez WITH PASSWORD '24165470'; COMMIT;
	BEGIN; CREATE USER José_López WITH PASSWORD '24276581'; COMMIT;
	BEGIN; CREATE USER María_Ramírez WITH PASSWORD '24387692' ; COMMIT;

	BEGIN; CREATE USER Paco_Gutierrez WITH PASSWORD '24474670' ; COMMIT;
	BEGIN; CREATE USER Ana_Suárez WITH PASSWORD '24509815' ; COMMIT;
	BEGIN; CREATE USER Juan_Muñoz WITH PASSWORD '27474663' ; COMMIT;
	BEGIN; CREATE USER Gabriela_Pérez WITH PASSWORD '26362516' ; COMMIT;

	BEGIN; CREATE USER Luis_Gómez WITH PASSWORD  '27273645' ; COMMIT;
	BEGIN; CREATE USER Andrea_Blanco WITH PASSWORD '24184756'; COMMIT;
	
	--CLIENTE
	BEGIN; CREATE USER Casa_Pakea WITH PASSWORD 'cliente1'; COMMIT;
	BEGIN; CREATE USER El_Leñador WITH PASSWORD 'cliente2'; COMMIT;
	BEGIN; CREATE USER Posada_Margot WITH PASSWORD 'cliente3'; COMMIT;
	BEGIN; CREATE USER Holiday_Inn_Hotel_Suites WITH PASSWORD 'cliente4'; COMMIT;
	BEGIN; CREATE USER Hard_Rock_Cafe_NY WITH PASSWORD 'cliente5'; COMMIT;
	BEGIN; CREATE USER Pearl_Urban_Lounge_Santo_Domingo WITH PASSWORD 'cliente6'; COMMIT;
	BEGIN; CREATE USER Cayo_Levantado_Resort WITH PASSWORD 'cliente7'; COMMIT;
	BEGIN; CREATE USER Maxima_Marea WITH PASSWORD 'cliente8'; COMMIT;
	BEGIN; CREATE USER La_Santa_Guadalupe_Medellin WITH PASSWORD 'cliente9'; COMMIT;
	BEGIN; CREATE USER Dona_Firmina WITH PASSWORD 'cliente10'; COMMIT;
	BEGIN; CREATE USER Vista_Cafe WITH PASSWORD 'cliente11'; COMMIT;
	BEGIN; CREATE USER Oporto_Cafe WITH PASSWORD 'cliente12'; COMMIT;
	BEGIN; CREATE USER Zanzibar WITH PASSWORD 'cliente13'; COMMIT;
	
---------------------------------------------------------------------------------------------------------
--								     OTORGAR ROLES USUARIOS  										   --
---------------------------------------------------------------------------------------------------------
/*
	Se asignan a los siguientes usuarios los roles ya existente siguiendo la infomracion proporcionada por 
	las inserciones  en la base de datos, correspondientes a los roles de Cliente, Empleadom, Operario,
	Hornero, Supervisor, Gerente, Gerente planta y Secretaria.
*/
	BEGIN; GRANT GERENTE TO María_González; COMMIT;  
	BEGIN; GRANT GERENTE_PLANTA TO Ana_Romero_Tules; COMMIT; 
	BEGIN; GRANT GERENTE TO Daniel_Guerrero; COMMIT; 

	BEGIN; GRANT SUPERVISOR TO Carlos_Torres; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Luis_Blanco; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Carolina_Sánchez; COMMIT;
	BEGIN; GRANT SUPERVISOR TO María_González_López; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Luis_Blanco_Fernández; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Carlos_Blanco;COMMIT; 
	BEGIN; GRANT SUPERVISOR TO  María_González_Suarez; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Yuritza_Castillo; COMMIT; 
	BEGIN; GRANT SUPERVISOR TO Luis_Blanco_Gutierrez; COMMIT;

	BEGIN; GRANT SECRETARIA TO Marcello_Servitad; COMMIT;
	BEGIN; GRANT SECRETARIA TO Valentina_Harrison; COMMIT;
	BEGIN; GRANT SECRETARIA TO Alejandro_Guzmán; COMMIT;
	BEGIN; GRANT SECRETARIA TO Sandra_Mendoza; COMMIT;

	BEGIN; GRANT EMPLEADO TO Ana_Romero_Flores; COMMIT;
	BEGIN; GRANT EMPLEADO TO Pedro_González; COMMIT;

	BEGIN; GRANT EMPLEADO TO Ana_Romero; COMMIT; 
	BEGIN; GRANT EMPLEADO TO Luis_Muñoz; COMMIT;

	BEGIN; GRANT OPERARIO TO Ana_Romero_Turmero; COMMIT; 
	BEGIN; GRANT OPERARIO TO Carlos_Blanco_Montoya; COMMIT;

	BEGIN; GRANT OPERARIO TO Ana_Romero_Texan; COMMIT; 
	BEGIN; GRANT OPERARIO TO María_Gómez; COMMIT;

	BEGIN; GRANT OPERARIO TO Pedro_López; COMMIT;
	BEGIN; GRANT OPERARIO TO Gabriela_Martínez; COMMIT;
	BEGIN; GRANT OPERARIO TO Luis_Ramírez; COMMIT;
	BEGIN; GRANT OPERARIO TO Andrea_Guerrero; COMMIT;
	BEGIN; GRANT OPERARIO TO Carlos_Suárez; COMMIT;
	BEGIN; GRANT OPERARIO TO Isabel_Muñoz; COMMIT; 
	BEGIN; GRANT OPERARIO TO Daniel_Romero; COMMIT;
	BEGIN; GRANT OPERARIO TO Jennifer_Gómez; COMMIT;
	BEGIN; GRANT OPERARIO TO José_López; COMMIT;
	BEGIN; GRANT OPERARIO TO María_Ramírez; COMMIT;

	BEGIN; GRANT HORNERO TO Paco_Gutierrez; COMMIT;
	BEGIN; GRANT HORNERO TO Ana_Suárez; COMMIT;
	BEGIN; GRANT HORNERO TO Juan_Muñoz; COMMIT;
	BEGIN; GRANT HORNERO TO Gabriela_Pérez; COMMIT;

	BEGIN; GRANT OPERARIO TO Luis_Gómez; COMMIT;
	BEGIN; GRANT OPERARIO TO Andrea_Blanco; COMMIT;
	
	--CLIENTE
	BEGIN; GRANT CLIENTE TO Casa_Pakea; COMMIT;
	BEGIN; GRANT CLIENTE TO El_Leñador; COMMIT;
	BEGIN; GRANT CLIENTE TO Posada_Margot; COMMIT;
	BEGIN; GRANT CLIENTE TO Holiday_Inn_Hotel_Suites; COMMIT;
	BEGIN; GRANT CLIENTE TO Hard_Rock_Cafe_NY; COMMIT;
	BEGIN; GRANT CLIENTE TO Pearl_Urban_Lounge_Santo_Domingo; COMMIT;
	BEGIN; GRANT CLIENTE TO Cayo_Levantado_Resort; COMMIT;
	BEGIN; GRANT CLIENTE TO Maxima_Marea; COMMIT;
	BEGIN; GRANT CLIENTE TO La_Santa_Guadalupe_Medellin; COMMIT;
	BEGIN; GRANT CLIENTE TO Dona_Firmina; COMMIT;
	BEGIN; GRANT CLIENTE TO Vista_Cafe; COMMIT;
	BEGIN; GRANT CLIENTE TO Oporto_Cafe; COMMIT;
	BEGIN; GRANT CLIENTE TO Zanzibar; COMMIT;
	
---------------------------------------------------------------------------------------------------------
--								       PRIVILEGIOS ROLES   											   --
---------------------------------------------------------------------------------------------------------
--                                     ROLES CON HERENCIA                                              --
---------------------------------------------------------------------------------------------------------
/*
	Privilegios del rol EMPLEADO:
	Todos los empleados tienen el privilegio de visualizar la información de su propio expediente. Por lo 
	tanto, los usuarios con el rol de Empleado deben tener permisos de SELECT sobre todas las tablas 
	correspondientes a la información básica del Empleado.
*/
--EMPLEADO
	BEGIN; GRANT SELECT ON DEPARTAMENTO TO EMPLEADO; COMMIT;
	BEGIN; GRANT SELECT ON DET_EXP TO EMPLEADO; COMMIT; 
	BEGIN; GRANT SELECT ON ESTADO_SALUD TO EMPLEADO; COMMIT; 
	BEGIN; GRANT SELECT ON EMPLEADO TO EMPLEADO; COMMIT;
	BEGIN; GRANT SELECT ON E_E TO EMPLEADO; COMMIT; 
	
	BEGIN; GRANT EMPLEADO TO OPERARIO, GERENTE; COMMIT;

/*
	Privilegios del rol OPERARIO:
	Los Operarios Generales tienen el privilegio de consultar información sobre las reuniones a las que han 
	asistido. Por lo tanto, los usuarios con el rol de Operario General deben tener permisos de SELECT en las 
	siguientes tablas:

		--Tabla de REUNION
		--Tabla de INASISTENCIA
*/
--OPERARIO
	BEGIN; GRANT SELECT ON INASISTENCIA TO OPERARIO; COMMIT;
	BEGIN; GRANT SELECT ON REUNION TO OPERARIO; COMMIT; 
	
	BEGIN; GRANT OPERARIO TO HORNERO, SUPERVISOR; COMMIT;

/*
	Privilegios del rol GERENTE:
	
	Los Gerentes de la empresa comparten ciertos privilegios de consulta comunes, los cuales incluyen:

		--Consultar los expedientes de los empleados que se encuentran por debajo de su nivel jerárquico.
		--Consultar el catálogo de productos y servicios de la empresa.
		--Consultar los pedidos realizados por los clientes.
	
	Esto significa que los usuarios con el rol de Gerente deben tener permisos de SELECT en las siguientes 
	tablas:

		--DETALLE_PIEZA_VAJILLA
		--FAMILIAR_HISTORICO_PRECIO
		--PIEZA
		--VAJILLA
		--COLECCION
		--MOLDE
		--CLIENTE
		--PEDIDO
		--FACTURA
		--CONTRADO
		--DETALLE_PEDIDO_PIEZA
*/
--GERENTE
	BEGIN; GRANT SELECT ON DETALLE_PIEZA_VAJILLA TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON FAMILIAR_HISTORICO_PRECIO TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON PIEZA TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON VAJILLA TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON COLECCION TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON MOLDE TO GERENTE; COMMIT;
	
	BEGIN; GRANT SELECT ON CLIENTE TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON PEDIDO TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON FACTURA TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON CONTRADO TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON DETALLE_PEDIDO_PIEZA TO GERENTE; COMMIT;

	BEGIN; GRANT SELECT ON PAIS TO GERENTE; COMMIT;
	BEGIN; GRANT SELECT ON NOMBRES_MOLDES TO GERENTE; COMMIT;

	BEGIN; GRANT GERENTE TO SECRETARIA, GERENTE_PLANTA; COMMIT;
	
---------------------------------------------------------------------------------------------------------
--                                     ROLES SIN HERENCIA                                              --

/*
	Privilegios del rol CLIENTE:
	
*/
--CLIENTE
	BEGIN; GRANT INSERT, SELECT ON PEDIDO TO CLIENTE; COMMIT;
	BEGIN; GRANT INSERT, SELECT ON DETALLE_PEDIDO_PIEZA TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON CLIENTE TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON FACTURA TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON CONTRATO TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON DETALLE_PIEZA_VAJILLA TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON FAMILIAR_HISTORICO_PRECIO TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON PIEZA TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON VAJILLA TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON COLECCION TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON MOLDE TO CLIENTE; COMMIT;
	BEGIN; GRANT SELECT ON NOMBRES_MOLDES TO CLIENTE; COMMIT;
	
--HORNERO
	BEGIN; GRANT SELECT ON HIST_TURNO TO HORNERO; COMMIT;
	
--SUPERVISOR
	BEGIN; GRANT INSERT ON REUNION TO SUPERVISOR; COMMIT;
	BEGIN; GRANT INSERT ON INASISTENCIA TO SUPERVISOR; COMMIT;
	BEGIN; GRANT INSERT, SELECT ON DET_EXP TO SUPERVISOR; COMMIT;

--SECRETARIA
	BEGIN; GRANT INSERT, UPDATE(FECHA_HORA_FIN) ON CONTRATO TO SECRETARIA; COMMIT;
	BEGIN; GRANT INSERT, UPDATE(FECHA_ENTREGA, ESTADO) ON PEDIDO TO SECRETARIA; COMMIT;
	BEGIN; GRANT INSERT ON DETALLE_PEDIDO_PIEZA TO SECRETARIA; COMMIT;
	BEGIN; GRANT INSERT ON FACTURA TO SECRETARIA; COMMIT;
	BEGIN; GRANT INSERT ON CLIENTE TO SECRETARIA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE cliente_uid_seq TO SECRETARIA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE pedido_uid_seq TO SECRETARIA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE contrato_uid_seq TO SECRETARIA; COMMIT;
	
--GERENTE_PLANTA
	BEGIN; GRANT INSERT ON PIEZA TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT ON VAJILLA TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT ON DETALLE_PIEZA_VAJILLA TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT ON COLECCION TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT ON FACTURA TO GERENTE_PLANTA; COMMIT;

	BEGIN; GRANT INSERT, UPDATE(FECHA_HORA_FIN) ON CONTRATO TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT, UPDATE(FECHA_FIN), SELECT ON FAMILIAR_HISTORICO_PRECIO TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT, UPDATE(FECHA_ENTREGA, ESTADO) ON PEDIDO TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT INSERT ON DETALLE_PEDIDO_PIEZA TO GERENTE_PLANTA; COMMIT;

	BEGIN; GRANT SELECT, USAGE ON SEQUENCE pieza_uid_seq TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE coleccion_uid_seq TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE vajilla_uid_seq TO GERENTE_PLANTA; COMMIT;

	BEGIN; GRANT SELECT, USAGE ON SEQUENCE factura_uid_seq TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE pedido_uid_seq TO GERENTE_PLANTA; COMMIT;
	BEGIN; GRANT SELECT, USAGE ON SEQUENCE contrato_uid_seq TO GERENTE_PLANTA; COMMIT;
	
--TECNICO
	BEGIN; GRANT SELECT ON REUNION TO Daniel_Guerrero; COMMIT;
	BEGIN; GRANT SELECT ON INASISTENCIA TO Daniel_Guerrero; COMMIT;
	BEGIN; GRANT INSERT, SELECT ON HIST_TURNO TO Daniel_Guerrero; COMMIT;
	BEGIN; GRANT INSERT ON DET_EXP TO Daniel_Guerrero; COMMIT;

/*
--------------------------------------------------------------------------------------------------------------------
-----                                                 Reportes                                              --------
--------------------------------------------------------------------------------------------------------------------
-----                                             Pedido completo                                           --------
--------------------------------------------------------------------------------------------------------------------

SELECT * FROM datos_basico_pedido($P{id_Pedido});


--Subreporte Piezas del pedido
	SELECT d.uid_detalle, p.uid_pieza, c.nombre AS nombre_col, m.molde, d.cantidad,	p.precio AS p_inst, f.precio AS p_fami,
				CASE
						WHEN p.precio IS NOT NULL THEN (d.cantidad*p.precio)
						WHEN f.precio IS NOT NULL THEN (d.cantidad*f.precio)
				END total
	FROM detalle_pedido_pieza d
		JOIN pedido x ON x.uid_pedido = d.uid_pedido
		JOIN pieza p ON p.uid_pieza = d.uid_pieza
		LEFT JOIN familiar_historico_precio f ON p.uid_pieza = f.uid_pieza AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,x.fecha_entrega)
		JOIN nombres_moldes m ON m.uid_molde = p.uid_molde
		JOIN coleccion c ON c.uid_coleccion = p.uid_coleccion
	WHERE d.uid_pedido = $P{id_Pedido} ORDER BY uid_detalle DESC;
	
--Subreporte Vajillas del pedido
	SELECT DISTINCT d.uid_detalle, v.uid_juego,	c.nombre AS nombre_col,	v.nombre AS nombre_vaj,	d.cantidad,	calcular_precio_vajilla(v.uid_juego, x.uid_coleccion, p.fecha_entrega) precio,
									CASE
										WHEN c.linea = 'F' THEN 1
										WHEN c.linea = 'I' THEN 0
									END linea
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN detalle_pieza_vajilla x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE d.uid_pedido = $P{id_Pedido} 	ORDER BY uid_detalle DESC;

--------------------------------------------------------------------------------------------------------------------
-----                                                Factura completa                                       --------
--------------------------------------------------------------------------------------------------------------------

--Consulta del reporte de Factura
WITH x AS(
	SELECT f.numero_factura FROM factura f, pedido p 
	WHERE p.uid_pedido = f.uid_pedido
	AND f.uid_pedido = $P{id_Pedido} 
)

SELECT * FROM x, datos_basico_factura(x.numero_factura)

--------------------------------------------------------------------------------------------------------------------
-----                                    Informe mensual de Venta                                           --------
--------------------------------------------------------------------------------------------------------------------

--REPORTE VENTAS POR LÍNEA Y COLECCIÓN
WITH ventas_vaj AS(

	 WITH precios_vaj AS(
		SELECT DISTINCT
		v.uid_juego, 
		round(calcular_precio_vajilla(v.uid_juego, x.uid_coleccion, p.fecha_entrega),2) AS precio
		FROM detalle_pedido_pieza d
			JOIN pedido p ON p.uid_pedido = d.uid_pedido
			JOIN vajilla v ON v.uid_juego = d.uid_juego
			JOIN detalle_pieza_vajilla x ON v.uid_juego = x.uid_juego
			JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
		WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea = upper(substring($P{Linea},1,1)))
	 )
	
	SELECT 
		c.uid_coleccion,
		SUM((d.cantidad*prv.precio)-(d.cantidad*round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))) total_vajs
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido AND ((p.fecha_entrega 
															BETWEEN to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes} ,'9999'),' ','01'),'YYYY MM DD') 
															AND to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes}  ,'9999'),' ','01'),'YYYY MM DD')+interval'1 month'-interval'1 day') 
															AND p.estado = 'A')
		LEFT JOIN contrato con ON con.uid_cliente = p.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN precios_vaj prv ON prv.uid_juego = v.uid_juego 
		JOIN (SELECT DISTINCT uid_juego, uid_coleccion FROM detalle_pieza_vajilla ORDER BY uid_juego, uid_coleccion ASC) AS x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea = upper(substring($P{Linea},1,1))) 
	GROUP BY c.uid_coleccion
	ORDER BY c.uid_coleccion ASC
	
)

	SELECT 
		c.linea,

		CASE
	      WHEN c.categoria = 'cou' THEN 'Country'
	      WHEN c.categoria = 'cla' THEN 'Clásica'
	      WHEN c.categoria = 'mod' THEN 'Moderna'
	    END categoria,
	
		c.nombre AS nombre_col, 
		
		SUM(CASE
		  WHEN p.precio IS NOT NULL THEN (d.cantidad*p.precio)-(d.cantidad*round(p.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		  WHEN f.precio IS NOT NULL THEN (d.cantidad*f.precio)-(d.cantidad*round(f.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		END) total_piezas,

		COALESCE(v.total_vajs,0) AS total_vajs
		
	FROM detalle_pedido_pieza d
		JOIN pedido x ON x.uid_pedido = d.uid_pedido AND ((x.fecha_entrega 
															BETWEEN to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes} ,'9999'),' ','01'),'YYYY MM DD') 
															AND to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes}  ,'9999'),' ','01'),'YYYY MM DD')+interval'1 month'-interval'1 day') 
															AND x.estado = 'A')
		LEFT JOIN contrato con ON con.uid_cliente = x.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN pieza p ON p.uid_pieza = d.uid_pieza
		LEFT JOIN familiar_historico_precio f ON p.uid_pieza = f.uid_pieza AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,x.fecha_entrega)
		JOIN coleccion c ON c.uid_coleccion = p.uid_coleccion
		LEFT JOIN ventas_vaj v ON v.uid_coleccion = p.uid_coleccion
	WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea = upper(substring($P{Linea},1,1)) )
	GROUP BY c.uid_coleccion,c.nombre, categoria,v.total_vajs
	ORDER BY 1 ASC, 2 ASC;






--Subreporte ventas de PIEZAS por linea y coleccion
	SELECT 
		p.uid_pieza, 
		CASE
      WHEN c.categoria = 'cou' THEN 'Country'
      WHEN c.categoria = 'cla' THEN 'Clásica'
      WHEN c.categoria = 'mod' THEN 'Moderna'
    END categoria,
		c.nombre AS nombre_col, 
		m.molde, 
		SUM(d.cantidad) cantidad,
		p.precio AS p_inst,
		f.precio AS p_fami,
		SUM(CASE
		  WHEN p.precio IS NOT NULL THEN round(p.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)
		  WHEN f.precio IS NOT NULL THEN round(f.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)
		END) descuento,
		SUM(CASE
		  WHEN p.precio IS NOT NULL THEN (d.cantidad*p.precio)-(d.cantidad*round(p.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		  WHEN f.precio IS NOT NULL THEN (d.cantidad*f.precio)-(d.cantidad*round(f.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		END) total
	FROM detalle_pedido_pieza d
		JOIN pedido x ON x.uid_pedido = d.uid_pedido AND ((x.fecha_entrega 
																												BETWEEN to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes} ,'9999'),' ','01'),'YYYY MM DD') 
																												AND to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes}  ,'9999'),' ','01'),'YYYY MM DD')+interval'1 month'-interval'1 day') 
																												AND x.estado = 'A')
		LEFT JOIN contrato con ON con.uid_cliente = x.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN pieza p ON p.uid_pieza = d.uid_pieza
		LEFT JOIN familiar_historico_precio f ON p.uid_pieza = f.uid_pieza AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,x.fecha_entrega)
		JOIN nombres_moldes m ON m.uid_molde = p.uid_molde
		JOIN coleccion c ON c.uid_coleccion = p.uid_coleccion
	WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea = upper(substring($P{Linea},1,1)) )
	GROUP BY p.uid_pieza, categoria, nombre_col, m.molde, p_inst, p_fami
	ORDER BY nombre_col ASC;


--Subreporte ventas de VAJILLAS por linea y coleccion

WITH precios_vaj AS(
	SELECT DISTINCT
	v.uid_juego, 
	round(calcular_precio_vajilla(v.uid_juego, x.uid_coleccion, p.fecha_entrega),2) AS precio
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN detalle_pieza_vajilla x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea =  upper(substring($P{Linea},1,1))
)



SELECT 
		v.uid_juego,
	    CASE
	      WHEN c.categoria = 'cou' THEN 'Country'
	      WHEN c.categoria = 'cla' THEN 'Clásica'
	      WHEN c.categoria = 'mod' THEN 'Moderna'
	    END categoria,
	    c.nombre nombre_col, 
		v.nombre AS nombre_vaj, 
		SUM(d.cantidad) cantidad, 
		prv.precio AS precio,
		SUM(round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)) descuento,
		SUM((d.cantidad*prv.precio)-(d.cantidad*round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))) total
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido AND ((p.fecha_entrega 
																												BETWEEN to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes} ,'9999'),' ','01'),'YYYY MM DD') 
																												AND to_date(CONCAT(to_char($P{Año},'9999'),' ',to_char( $P{Numero_mes}  ,'9999'),' ','01'),'YYYY MM DD')+interval'1 month'-interval'1 day') 
																												AND p.estado = 'A')
		LEFT JOIN contrato con ON con.uid_cliente = p.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN precios_vaj prv ON prv.uid_juego = v.uid_juego 
		JOIN (SELECT DISTINCT uid_juego, uid_coleccion FROM detalle_pieza_vajilla ORDER BY uid_juego, uid_coleccion ASC) AS x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE c.uid_coleccion in (SELECT uid_coleccion FROM coleccion col WHERE col.linea = upper(substring($P{Linea},1,1))) 
	GROUP BY v.uid_juego, categoria, nombre_col, nombre_vaj, precio
	ORDER BY nombre_col ASC;
*/
