/*Reportes*/

--Pedido Completo
CREATE OR REPLACE FUNCTION DATOS_BASICO_PEDIDO (num_pedido numeric(6))
	RETURNS TABLE (
		uid_pedido numeric(6),
		fecha_emision date,
		fecha_entrega date,
		fecha_entrega_deseada date,
		nombre_pais varchar(40),
		nombre_cliente  varchar(50),
		telefono_cliente varchar(15),
		email_cliente varchar(256),
		estado_pedido Text,
		tipo_pedido Text,
		monto_total numeric(8,2)
	)
AS $$
DECLARE
    monto_total numeric(8,2);
BEGIN
    SELECT CALCULAR_MONTO_FACTURA(num_pedido) INTO monto_total;
	RETURN QUERY
	SELECT 
			 p.uid_pedido,
			 p.fecha_emision,
		   p.fecha_entrega,
		   p.fecha_entrega_deseada,
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
			   WHEN p.tipo_pedido = 'I' THEN 'Internacional'
		   END AS pedido,
		   monto_total
	FROM CLIENTE c
		INNER JOIN PAIS pa ON pa.uid_pais = c.uid_pais
		INNER JOIN PEDIDO p ON c.uid_cliente = p.uid_cliente
	WHERE p.uid_pedido = num_pedido; 
END;
$$ LANGUAGE plpgsql;


--Factura completa 


--Informe mensual de Venta
SELECT * FROM FACTURA

CALL INFORME_MENSUAL_VENTA('2024-03-10');
select * from cliente c, pais p where p.uid_pais = c.uid_pais and uid_cliente = 9

select * from factura  f 
where f.fecha_emision = '2024-09-10'

SELECT * /*COALESCE ((SUM(dp.cantidad * pi.precio)), 0)*/ FROM factura f
		INNER JOIN PEDIDO p ON f.uid_pedido = p.uid_pedido
        INNER JOIN DETALLE_PEDIDO_PIEZA dp ON p.uid_pedido = dp.uid_pedido
        INNER JOIN PIEZA pi ON pi.uid_pieza = dp.uid_pieza
WHERE EXTRACT(MONTH FROM f.fecha_emision) = EXTRACT(MONTH FROM DATE '2024-09-10');


	SELECT COALESCE(dp.cantidad * (dv.cantidad * pi.precio) * 0.85, 0) 
    FROM FACTURA f
    	INNER JOIN PEDIDO p ON f.uid_pedido = p.uid_pedido
        INNER JOIN DETALLE_PEDIDO_PIEZA dp ON p.uid_pedido = dp.uid_pedido
        INNER JOIN PIEZA pi ON pi.uid_pieza = dp.uid_pieza
        INNER JOIN DETALLE_PIEZA_VAJILLA dv ON dv.uid_pieza = pi.uid_pieza
    WHERE EXTRACT(MONTH FROM f.fecha_emision) = EXTRACT(MONTH FROM DATE '2024-09-10');

select * from pieza p , coleccion c where c.uid_coleccion = p.uid_coleccion AND uid_pieza = 9

select * from pedido where uid_pedido = 8
select * from DETALLE_PEDIDO_PIEZA where uid_pedido = 8


CREATE OR REPLACE PROCEDURE INFORME_MENSUAL_VENTA(periodo DATE) AS $$ 
DECLARE
    GANANCIA_INTERNACIONAL_PIEZA numeric(20,2);
	GANANCIA_INTERNACIONAL_VAJILLA numeric(20,2);
    GANANCIA_FAMILIAR numeric(20,2);
BEGIN
	SELECT COALESCE(dp.cantidad * (dv.cantidad * pi.precio) * 0.85, 0) INTO GANANCIA_INTERNACIONAL_VAJILLA
    FROM FACTURA f
    	INNER JOIN PEDIDO p ON f.uid_pedido = p.uid_pedido
        INNER JOIN DETALLE_PEDIDO_PIEZA dp ON p.uid_pedido = dp.uid_pedido
        INNER JOIN PIEZA pi ON pi.uid_pieza = dp.uid_pieza
        INNER JOIN DETALLE_PIEZA_VAJILLA dv ON dv.uid_pieza = pi.uid_pieza
    WHERE EXTRACT(MONTH FROM f.fecha_emision) = EXTRACT(MONTH FROM periodo) AND 
    	  EXTRACT(YEAR FROM f.fecha_emision) = EXTRACT(YEAR FROM periodo) AND
          dp.uid_juego IS NOT NULL AND dp.uid_pieza IS NULL;

    SELECT COALESCE ((SUM(dp.cantidad * pi.precio)), 0)  INTO GANANCIA_INTERNACIONAL_PIEZA
    FROM FACTURA f
    	INNER JOIN PEDIDO p ON f.uid_pedido = p.uid_pedido
        INNER JOIN DETALLE_PEDIDO_PIEZA dp ON p.uid_pedido = dp.uid_pedido
        INNER JOIN PIEZA pi ON pi.uid_pieza = dp.uid_pieza
    WHERE EXTRACT(MONTH FROM f.fecha_emision) = EXTRACT(MONTH FROM periodo) AND 
    	  EXTRACT(YEAR FROM f.fecha_emision) = EXTRACT(YEAR FROM periodo) AND
          dp.uid_juego IS NULL AND dp.uid_pieza IS NOT NULL;

	RAISE NOTICE 'Ganancia Internacional: %', 
    (COALESCE(GANANCIA_INTERNACIONAL_VAJILLA + GANANCIA_INTERNACIONAL_PIEZA, 0))::DECIMAL(20,2);
END;
$$ LANGUAGE plpgsql;


