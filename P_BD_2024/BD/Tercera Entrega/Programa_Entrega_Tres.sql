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

CREATE OR REPLACE FUNCTION CONFLICTO_FECHA (emision DATE) RETURNS DATE AS $$
DECLARE
	aux numeric(1);
BEGIN
	--Tabla de todos los contratos activos
		CREATE TEMPORARY TABLE CLIENTE_CONTRATO ( pk_cliente numeric(3), pk_contrato numeric(5));
		INSERT INTO CLIENTE_CONTRATO (pk_cliente, pk_contrato)
			SELECT con.uid_cliente, con.num_contrato FROM CONTRATO con WHERE con.fecha_hora_fin IS NULL;
			
	--Tabla de todos los pedidos en estado emitido
		CREATE TEMPORARY TABLE CLIENTE_MODIFICAR (pk_cliente numeric(3), pk_pedido NUMERIC(6), old_entrega DATE);
		INSERT INTO CLIENTE_MODIFICAR (pk_pedido, old_entrega) 
			SELECT po.uid_cliente, po.uid_pedido, po.fecha_entrega FROM PEDIDO po		
			WHERE po.estado = 'E' AND po.fecha_entrega >= emision;
		
	--Se busca si el cliente tiene un contrato en la emision
		SELECT COUNT(*) INTO aux FROM CLIENTE_CONTRATO cc 
		WHERE cc.pk_cliente IN (SELECT cm.pk_cliente FROM CLIENTE_MODIFICAR cm WHERE cm.old_entrega = emision)
			
	IF aux = 0 THEN
		SELECT clmo.old_entrega INTO emision FROM CLIENTE_MODIFICAR clmo ORDER BY clmo.old_entrega ASC LIMIT 1;
		emision := emision + Interval '1 DAY';		
	ELSE 
		SELECT mo.old_entrega FROM CLIENTE_MODIFICAR mo 
		WHERE mo.pk_cliente NOT IN (SELECT co.uid_cliente FROM CLIENTE_CONTRATO co) ORDER BY old_entrega DESC limit 1;
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ASIGNAR_FECHA_ENTREGA(emision DATE) RETURNS DATE AS $$
DECLARE
	estados varchar(1);
	aux numeric(1);
BEGIN
	--Se busca la fecha de emision del pedido emitido.
		SELECT p.fecha_emision INTO emision, p.estado into estados FROM pedido p WHERE p.uid_pedido = pedido;
		
	--Posible fecha de entrega
		emision := emision + interval '2 months';
					
	--Se busca si existe alguien con la misma fecha, si no hay nadie es la fecha de entrego sino, se buscara posibles fecha de entrega.
		SELECT COUNT(*) INTO aux FROM PEDIDO pe WHERE pe.fecha_entrega = emision AND pe.estado = 'E';
	
	IF aux = 0 THEN
			RAISE NOTICE 'La posible fecha de entrega es: %', emision;	
	ELSE
		IF estados = 'C' THEN
			RETURN emision;
			RAISE NOTICE 'La posible fecha de entrega 1 es: %', emision;	
		ELSE 
			emision:= CONFLICTO_FECHA(emision);
			RAISE NOTICE 'La posible fecha de entrega 2 es: %', emision;	
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;

					