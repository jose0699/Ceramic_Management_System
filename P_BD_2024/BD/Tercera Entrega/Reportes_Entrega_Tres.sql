/*Reportes*/

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









