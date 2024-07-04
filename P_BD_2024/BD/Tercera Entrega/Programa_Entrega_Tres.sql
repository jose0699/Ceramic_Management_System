CREATE OR REPLACE INSERTAR_PEDIDO() AS $$
DECLARE
	
BEGIN

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
	tipo varchar(1);
	tipo_producto varchar(1);
BEGIN
	--Se busca la cantidad de detalle existente del pedido.
		select count(*) into num_detalle FROM detalle_pedido_pieza dpp WHERE dpp.uid_pedido = pedido; 
	
	--Incrementa el número del detalle.
		num_detalle := num_detalle + 1;
		
	--Se busca la pk del cliente y el tipo de pedido (F o I).
		SELECT p.uid_cliente, p.tipo_pedido INTO cliente, tipo FROM PEDIDO p WHERE p.uid_pedido = pedido;
	
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
		raise notice 'paso';
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
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION MODIFICAR_PEDIDO() RETURNS TRIGGER AS $$
DECLARE
BEGIN
	IF new.estado = 'A' THEN 
			
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER PEDIDO_ACEPTADO BEFIRE INSERT OR BEFORE UPDATE ON PEDIDO FOR EACH ROW EXECUTE FUNCTION MODIFICAR_PEDIDO();


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CANCELAR_CONTRATO(cliente numeric(3)) AS $$ BEGIN
	UPDATE CONTRATO SET fecha_hora_fin = NOW() WHERE uid_cliente = cliente AND fecha_hora_fin is null;
END;
$$ LANGUAGE plpgsql;


SELECT CAST((
	SELECT (COALESCE(SUM(dt.cantidad * fh.precio), 0) +
		   COALESCE(
					   (SELECT COALESCE(SUM(d.cantidad * (f.precio * dv.cantidad)) * 0.85, 0)
						FROM pedido p
							INNER JOIN DETALLE_PEDIDO_PIEZA d ON p.uid_pedido = d.uid_pedido
							INNER JOIN DETALLE_PIEZA_VAJILLA dv ON d.uid_juego = dv.uid_juego
							INNER JOIN PIEZA pz ON pz.uid_pieza = dv.uid_pieza
							INNER JOIN familiar_historico_precio f ON pz.uid_pieza = f.uid_pieza
						WHERE p.uid_pedido = 1 AND d.uid_juego IS NOT NULL AND f.fecha_fin IS NULL) , 0) *
			COALESCE ((SELECT COALESCE ( 1 - (c.porcentaje_descuento / 100 ) ,1) FROM PEDIDO ped 
						INNER JOIN CLIENTE cl ON cl.uid_cliente = ped.uid_cliente 
						INNER JOIN CONTRATO c ON cl.uid_cliente = c.uid_cliente 
					  WHERE ped.uid_pedido = 1 AND c.fecha_hora_fin IS NULL) , 1)) AS Total
	FROM PEDIDO pe
		INNER JOIN DETALLE_PEDIDO_PIEZA dt ON pe.uid_pedido = dt.uid_pedido
		INNER JOIN PIEZA pi ON pi.uid_pieza = dt.uid_pieza
		INNER JOIN familiar_historico_precio fh ON pi.uid_pieza = fh.uid_pieza
	WHERE pe.uid_pedido = 1 AND dt.uid_juego IS NULL AND fh.fecha_fin IS NULL) 
AS DECIMAL(8,2));

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
call ASIGNAR_FECHA_ENTREGA(1);
SELECT * FROM PEDIDO pe WHERE pe.fecha_emision = emision;
select * from pedido ORDER BY FECHA_EMISION;
select * from contrato

select * from ASIGNAR_FECHA_ENTREGA('2024-03-16',4)

CREATE OR REPLACE FUNCTION CONFLICTO_FECHA (emision DATE, cliente numeric(3)) RETURNS DATE AS $$
DECLARE
	aux numeric(1);
	existe numeric(1);
	aux2 numeric(1);
	aux3 numeric(1);
	aux4 varchar(1);
BEGIN
	--Se crea Tabla CLIENTE_CONTRATO.
	CREATE TEMPORARY TABLE CLIENTE_CONTRATO ( pk_cliente numeric(3), pk_contrato numeric(5));
	
	--Se inserta todos los clientes con contrato en la tabla CLIENTE_CONTRATO
	INSERT INTO CLIENTE_CONTRATO (pk_cliente, pk_contrato) SELECT con.uid_cliente, con.num_contrato FROM CONTRATO con WHERE con.fecha_hora_fin IS NULL;
			
	--Se crea la tabla CLIENTE_MODIFICAR
	CREATE TEMPORARY TABLE CLIENTE_MODIFICAR (pk_cliente numeric(3), pk_pedido NUMERIC(6), old_entrega DATE, estado varchar(1));
	
	-- Se interta todos los clientes que tenga un pedido con la fecha.
	INSERT INTO CLIENTE_MODIFICAR (pk_cliente, pk_pedido, old_entrega, estado) SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega_deseada, po.estado FROM PEDIDO po WHERE po.estado IN ('E', 'A') AND po.fecha_entrega_deseada >= emision ORDER BY po.fecha_entrega_deseada ASC ;
	
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
	ELSE
	SELECT * INTO emision FROM CONFLICTO_FECHA(emision, cliente);
		RAISE NOTICE 'La posible fecha de entrega 2 es: %', emision;	
	END IF;
END;
$$ LANGUAGE plpgsql;

					