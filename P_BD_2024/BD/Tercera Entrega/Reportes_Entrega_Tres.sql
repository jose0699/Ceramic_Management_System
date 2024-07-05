/*Reportes*/

--------------------------------------------------------------------------------------------------------------------
-----                                             Pedido completo                                           --------
--------------------------------------------------------------------------------------------------------------------


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
	SELECT  COALESCE(SUM(COALESCE(dt.cantidad,pi.precio) * fh.precio), 0) + 
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
			 --LEER: mira este nuevo valor lo agregué porque en la factura necesito el monto del descuento como tal, si quieres cambia el lugar en donde se hace el calculo, pero de ser posible deja el Alias como monto_descontado
			 round(monto_sin_descuento*(Descuento/100), 2)::Numeric(8,2) AS monto_descontado,
		   monto
	FROM CLIENTE c
		INNER JOIN PEDIDO p ON c.uid_cliente = p.uid_cliente
		INNER JOIN FACTURA fact ON fact.uid_pedido = p.uid_pedido
	WHERE fact.numero_factura = num_factura; 
END;
$$ LANGUAGE plpgsql;

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




----------------------------------------------------------------------------------------------------------------------
--NOTAS: De aquí no usé nada Mil perdones
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




