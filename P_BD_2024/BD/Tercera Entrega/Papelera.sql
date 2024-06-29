CREATE OR REPLACE FUNCTION CALCULAR_MONTO_FACTURA (pedido numeric(6)) RETURNS numeric(8,2) AS $$
DECLARE	
	GUARDAR numeric(8,2);
BEGIN
	SELECT CAST((
		SELECT (COALESCE(SUM(dt.cantidad * fh.precio), 0) +
			   COALESCE(
						   (SELECT COALESCE(SUM(d.cantidad * (f.precio * dv.cantidad)) * 0.85, 0) into guardar
							FROM pedido p
								INNER JOIN DETALLE_PEDIDO_PIEZA d ON p.uid_pedido = d.uid_pedido
								INNER JOIN DETALLE_PIEZA_VAJILLA dv ON d.uid_juego = dv.uid_juego
								INNER JOIN PIEZA pz ON pz.uid_pieza = dv.uid_pieza
								INNER JOIN familiar_historico_precio f ON pz.uid_pieza = f.uid_pieza
							WHERE p.uid_pedido = pedido AND d.uid_juego IS NOT NULL AND f.fecha_fin IS NULL) 
						, 0) *
				COALESCE ((SELECT COALESCE ( 1 - (c.porcentaje_descuento / 100 ) ,1) FROM PEDIDO ped 
							INNER JOIN CLIENTE cl ON cl.uid_cliente = ped.uid_cliente 
							INNER JOIN CONTRATO c ON cl.uid_cliente = c.uid_cliente 
						  WHERE ped.uid_pedido = pedido AND c.fecha_hora_fin IS NULL)
						 , 1)) AS Total
		FROM PEDIDO pe
			INNER JOIN DETALLE_PEDIDO_PIEZA dt ON pe.uid_pedido = dt.uid_pedido
			INNER JOIN PIEZA pi ON pi.uid_pieza = dt.uid_pieza
			INNER JOIN familiar_historico_precio fh ON pi.uid_pieza = fh.uid_pieza
		WHERE pe.uid_pedido = pedido AND dt.uid_juego IS NULL AND fh.fecha_fin IS NULL) 		
	AS DECIMAL(8,2));
	raise notice '%', guardar;
	RETURN GUARDAR;
END;
$$ LANGUAGE plpgsql;