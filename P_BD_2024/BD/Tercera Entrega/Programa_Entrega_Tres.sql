CREATE OR REPLACE PROCEDURE INSERTAR_PEDIDO(cliente numeric(6), tipo varchar(1)) AS $$
BEGIN
	IF tipo IN ('F', 'I') THEN
		INSERT INTO PEIDO VALUES (cliente, nextval('pedido_uid_seq'), current_date, null, (SELECT * FROM ASIGNAR_FECHA_ENTREGA), 'E', tipo);
	END IF;
END;
$$ LANGUAGE plpgsql;


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


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
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
	IF (SELECT pedi.tipo_pedido FROM PEDIDO pedi WHERE pedi.uid_pedido = pedido) = 'E' THEN
		--Se busca la cantidad de detalle existente del pedido.
		select count(*) into num_detalle FROM detalle_pedido_pieza dpp WHERE dpp.uid_pedido = pedido; 

		--Incrementa el número del detalle.
		num_detalle := num_detalle + 1;

		--Se busca la pk del cliente y el tipo de pedido (F o I).
		SELECT p.uid_cliente, p.tipo_pedido, p.estado INTO cliente, tipo, estado_pedido FROM PEDIDO p WHERE p.uid_pedido = pedido;

		--Si el estado = Emitido, puede insertar
		IF estado_pedido = 'E' THEN
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
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
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

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
BEGIN;	insert into factura values( 1,1,nextval('factura_uid_seq') ,'2024-01-18 10:50:00' , 943.5 );	COMMIT;--1


CREATE OR REPLACE FUNCTION MODIFICAR_PEDIDO() RETURNS TRIGGER AS $$
DECLARE
BEGIN
	IF new.estado = 'A' THEN 
		INSERT INTO factura values(old.uid_cliente, old.uid_pedido, nextval('factura_uid_seq'), current_date, );
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER PEDIDO_ACEPTADO BEFIRE INSERT OR BEFORE UPDATE ON PEDIDO FOR EACH ROW EXECUTE FUNCTION MODIFICAR_PEDIDO();


---------------------------------------------------------------------------------------------------------
																					--CIERRE Y APERTURA DE CONTRATOS--
---------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE CERRAR_CONTRATO(id_cliente IN cliente.uid_cliente%TYPE) AS $$ 
	BEGIN
		UPDATE CONTRATO SET fecha_hora_fin = NOW() WHERE uid_cliente = id_cliente AND fecha_hora_fin IS NULL;

		RAISE NOTICE 'Contrato cerrado exitosamente para el cliente solicitado';
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE ABRIR_CONTRATO(id_cliente IN cliente.uid_cliente%TYPE, descuento IN contrato.porcentaje_descuento%TYPE) AS $$
		BEGIN
			INSERT INTO CONTRATO (uid_cliente, num_contrato, porcentaje_descuento, fecha_hora_emision,fecha_hora_fin)
						 VALUES(id_cliente, nextval('contrato_uid_seq'), descuento, NOW(), NULL);

			RAISE NOTICE 'Contrato abierto exitosamente para el cliente solicitado';
		END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION VALIDAR_CIERRE_CONTRATO() RETURNS TRIGGER AS $$
		BEGIN
			IF new.fecha_hora_fin < old.fecha_hora_emision + interval '1 year' THEN
				RAISE EXCEPTION 'Error: El contrato ha estado en vigencia por menos de un año, debe esperar como mínimo un año después de la emisión del mismo para poder cancelarlo';
			END IF; 
			
			RETURN NEW;

		END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE TRIGGER VALIDEZ_FECHA_CIERRE_CONTRATO BEFORE UPDATE OF fecha_hora_fin ON CONTRATO FOR EACH ROW EXECUTE FUNCTION VALIDAR_CIERRE_CONTRATO();
CREATE OR REPLACE TRIGGER VALIDEZ_FECHA_APERTURA_CONTRATO BEFORE INSERT ON CONTRATO FOR EACH ROW EXECUTE FUNCTION VALIDAR_APERTURA_CONTRATO();

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
call ASIGNAR_FECHA_ENTREGA(1);
SELECT * FROM PEDIDO pe WHERE pe.fecha_emision = emision;
select * from pedido ORDER BY FECHA_EMISION;
select * from contrato

select * from ASIGNAR_FECHA_ENTREGA('2024-03-16',4)

CREATE OR REPLACE PROCEDURE ACTUALIZAR_COLA_PEDIDO(emision DATE, cliente numeric(3)) AS $$
DECLARE
	new_fecha date;
	CONFLICTO numeric(1);
	cliente_conflicto numeric(3);
BEGIN
	new_fecha := emision;
	
	--Se crea Tabla CLIENTE_CONTRATO.
	CREATE TEMPORARY TABLE CLIENTE_CONTRATO ( pk_cliente numeric(3));
	
	--Se inserta todos los clientes con contrato en la tabla CLIENTE_CONTRATO
	INSERT INTO CLIENTE_CONTRATO (pk_cliente) SELECT con.uid_cliente FROM CONTRATO con WHERE con.fecha_hora_fin IS NULL;
			
	--Se crea la tabla CLIENTE_MODIFICAR
	CREATE TEMPORARY TABLE CLIENTE_MODIFICAR (pk_cliente numeric(3), pk_pedido NUMERIC(6), old_entrega DATE, estado varchar(1));
	
	-- Se interta todos los clientes que tenga un pedido con la fecha.
	INSERT INTO CLIENTE_MODIFICAR (pk_cliente, pk_pedido, old_entrega, estado) SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega_deseada, po.estado FROM PEDIDO po WHERE po.estado IN ('E', 'A') AND po.fecha_entrega_deseada >= emision ORDER BY po.fecha_entrega_deseada ASC;
	CONFLICTO:= 1;
	
	WHILE CONFLICTO > 0 LOOP
		--Se revisa si en la fecha genera un conflicto
		IF 0 = (SELECT COUNT(*) FROM CLIENTE_MODIFICAR cm WHERE  cm.fecha_entrega_deseada = new_fecha) THEN 
			--Sin conflictos de fechas y actualiza el pedido.
			UPDATE PEDIDO SET fecha_entrega_deseada = new_fecha  WHERE uid_cliente = cliente AND fecha_entrega_deseada = emision;
			CONFLICTO:= 0;
		ELSE 
			--Se revisa si la fecha genera un conflicto con un cliente con contrato
			IF 1 = (SELECT COUNT(*) FROM CLIENTE_CONTRATO cc INNER JOIN 
						CLIENTE_MODIFICAR clmo ON cc.pk_cliente = clmo.pk_cliente
					WHERE clmo.fecha_entrega_deseada = new_fecha)
			THEN
				--Se agrega un dia a la fecha del pedido
				new_fecha := new_fecha + INTERVAL '1 DAY';
			ELSE
				IF 0 < (SELECT COUNT(*) FROM CLIENTE_MODIFICAR climod WHERE climod.Fecha_entrega_deseada = new_fecha AND climod.estado = 'A')
				THEN 
					--Se agrega un dia a la fecha del pedido
					new_fecha := new_fecha + INTERVAL '1 DAY';	
				ELSE
					--Se busca el pk del cliente (cliente_conflicto)
					SELECT climodi.pk_cliente into cliente_conflicto FROM CLIENTE_MODIFICAR climodi WHERE climodi.Fecha_entrega_deseada = new_fecha;
					
					--Se agrega un dia a la fecha del pedido
					new_fecha := new_fecha + INTERVAL '1 DAY';
					
					--Se elimina tablas para limpiar memoria
					DROP TABLE IF EXISTS CLIENTE_MODIFICAR;
					DROP TABLE IF EXISTS CLIENTE_CONTRATO;
					
					CALL ACTUALIZAR_COLA_PEDIDO(new_fecha ,cliente_conflicto);
					
					--Se actualiza la fecha del pedido
					UPDATE PEDIDO SET fecha_entrega_deseada = new_fecha  WHERE uid_cliente = cliente AND fecha_entrega_deseada = emision;
					CONFLICTO:= 0;
				END IF;
			END IF;
		END IF;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

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
	INSERT INTO CLIENTE_MODIFICAR (pk_cliente, pk_pedido, old_entrega, estado) SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega_deseada, po.estado FROM PEDIDO po WHERE po.estado IN ('E', 'A') AND po.fecha_entrega_deseada >= emision ORDER BY po.fecha_entrega_deseada ASC ;
	
	--Consulta si el cliente tiene contrato activo.
	SELECT COUNT(*) into aux FROM CLIENTE_CONTRATO co WHERE co.pk_cliente = cliente AND co.fecha_hora_fin IS NULL;	

	SELECT COUNT(*) into aux FROM CLIENTE_CONTRATO co WHERE co.pk_cliente = cliente AND co.fecha_hora_fin is null;	
	existe := 1;
	
	IF aux = 0 THEN
		--Ciclo para verificar si hay conclito de fecha, simplemente el cliente no tiene contrato entonces se  
		--le añade un día hasta encontrar una fecha sin conclicto.
		WHILE existe = 1 LOOP
			emision := emision + Interval '1 DAY';
			SELECT COUNT(*) into existe FROM CLIENTE_MODIFICAR cm WHERE cm.old_entrega = emision;
		END LOOP;
	
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
				RETURN emision;
			END IF;
		END LOOP;
		RETURN emision;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ASIGNAR_FECHA_ENTREGA(emision DATE, cliente numeric(3)) RETURNS DATE AS $$
DECLARE
	aux numeric(1);
BEGIN
	--Posible fecha de entrega
	emision := emision + interval '2 months';

	--Se busca si existe alguien con la misma fecha, si no hay nadie es la fecha de entrego sino, se buscara posibles fecha de entrega.
	SELECT COUNT(*) INTO aux FROM PEDIDO pe WHERE pe.fecha_entrega_deseada = emision AND pe.estado IN ('E', 'A');
	
	IF aux = 0 THEN
		RAISE NOTICE 'La posible fecha de entrega es: %', emision;
		RETURN emision;
	ELSE
		SELECT * INTO emision FROM CONFLICTO_FECHA(emision, cliente);
		RAISE NOTICE 'La posible fecha de entrega 2 es: %', emision;
		RETURN emision;
	END IF;
END;
$$ LANGUAGE plpgsql;

					