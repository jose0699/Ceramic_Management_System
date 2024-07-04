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

--VIEJA VERSION DE PEDIR DATOS BÁSICOS FACTURA

CREATE OR REPLACE FUNCTION DATOS_BASICO_FACTURA (num_factura numeric(6))
	RETURNS TABLE (
		uid_pedido numeric(6),
		numero_factura numeric(6),
		fecha_emision text,
		nombre_cliente  varchar(50),
		telefono_cliente varchar(15),
		email_cliente varchar(256),
		tipo_pedido varchar(1),
		pais_cliente varchar(40),
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
		 INNER JOIN CONTRATO c ON cl.uid_cliente = c.uid_cliente 
 		 INNER JOIN PEDIDO p ON cl.uid_cliente = p.uid_cliente 
		 INNER JOIN FACTURA fac ON fac.uid_pedido = p.uid_pedido
	WHERE fac.numero_factura = num_factura AND c.fecha_hora_fin IS NULL;
	
	--Monto sin el descuento
	SELECT  COALESCE(SUM(dt.cantidad * fh.precio), 0) + 
									 COALESCE((SELECT COALESCE(SUM(d.cantidad * (fam.precio * dv.cantidad)) * 0.85, 0) 
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
		INNER JOIN familiar_historico_precio fh ON pi.uid_pieza = fh.uid_pieza
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
			 fact.numero_factura,
		   to_char(fact.fecha_emision, 'DD-TMMON-YYYY'),
		   c.nombre,
		   c.telefono,
		   c.email,
			 p.tipo_pedido,
			 pa.nombre  AS nombre_pais,
		   monto_sin_descuento,
		   Descuento,
			 --LEER: mira este nuevo valor lo agregué porque en la factura necesito el monto del descuento como tal, si quieres cambia el lugar en donde se hace el calculo, pero de ser posible deja el Alias como monto_descontado
			 round(monto_sin_descuento*(Descuento/100), 2)::Numeric(8,2) AS monto_descontado,
		   monto
	FROM CLIENTE c
		INNER JOIN PEDIDO p ON c.uid_cliente = p.uid_cliente
		INNER JOIN PAIS pa ON pa.uid_pais = c.uid_pais
		INNER JOIN FACTURA fact ON fact.uid_pedido = p.uid_pedido
	WHERE fact.numero_factura = num_factura; 
END;
$$ LANGUAGE plpgsql;


--CONSULTAS SUBREPORTE DE FACTURA PARA LISTADO DEL DETALLE -ya no se usa
--Subreporte Piezas de la factura
	SELECT 
		d.uid_detalle, 	
		p.uid_pieza, 
		CASE 
		 WHEN position(' ' in c.nombre) != 0 THEN CONCAT(substring(c.nombre,1,1),'. ',substring(c.nombre,strpos(c.nombre, ' ')))
		 ELSE c.nombre
		END nombre_col,
		m.molde, 
		d.cantidad,
		p.precio AS p_inst,
		f.precio AS p_fami,
		CASE
		  WHEN p.precio IS NOT NULL THEN round(p.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)
		  WHEN f.precio IS NOT NULL THEN round(f.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)
		END descuento,
		CASE
		  WHEN p.precio IS NOT NULL THEN (d.cantidad*p.precio)-(d.cantidad*round(p.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		  WHEN f.precio IS NOT NULL THEN (d.cantidad*f.precio)-(d.cantidad*round(f.precio * (COALESCE(con.porcentaje_descuento,0)/100),2))
		END total
	FROM detalle_pedido_pieza d
		JOIN pedido x ON x.uid_pedido = d.uid_pedido
		LEFT JOIN contrato con ON con.uid_cliente = x.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN pieza p ON p.uid_pieza = d.uid_pieza
		LEFT JOIN familiar_historico_precio f ON p.uid_pieza = f.uid_pieza AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,x.fecha_entrega)
		JOIN nombres_moldes m ON m.uid_molde = p.uid_molde
		JOIN coleccion c ON c.uid_coleccion = p.uid_coleccion
	WHERE d.uid_pedido in (SELECT fr.uid_pedido FROM FACTURA fr WHERE fr.numero_factura = $P{id_factura})ORDER BY uid_detalle DESC;

--Subreporte Vajillas de la factura
WITH precios_vaj AS(
	SELECT DISTINCT
	v.uid_juego, 
	round(calcular_precio_vajilla(v.uid_juego, x.uid_coleccion, p.fecha_entrega),2) AS precio
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN detalle_pieza_vajilla x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE d.uid_pedido in (SELECT fr.uid_pedido FROM FACTURA fr WHERE fr.numero_factura = $P{id_factura})
)


SELECT DISTINCT
		d.uid_detalle, 
		v.uid_juego, 
		CASE
		  WHEN c.linea = 'F' THEN 0
		  WHEN c.linea = 'I' THEN 1
		END linea,
		CASE 
		 WHEN position(' ' in c.nombre) != 0 THEN CONCAT(substring(c.nombre,1,1),'. ',substring(c.nombre,strpos(c.nombre, ' ')))
		 ELSE c.nombre
		END nombre_col, 
		v.nombre AS nombre_vaj, 
		d.cantidad, 
		prv.precio AS precio,
		round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2) descuento,
		d.cantidad*round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2) descuento_total,
		(d.cantidad*prv.precio)-(d.cantidad*round(prv.precio * (COALESCE(con.porcentaje_descuento,0)/100),2)) total
	FROM detalle_pedido_pieza d
		JOIN pedido p ON p.uid_pedido = d.uid_pedido
		LEFT JOIN contrato con ON con.uid_cliente = p.uid_cliente AND con.fecha_hora_fin IS NULL
		JOIN vajilla v ON v.uid_juego = d.uid_juego
		JOIN precios_vaj prv ON prv.uid_juego = v.uid_juego 
		JOIN detalle_pieza_vajilla x ON v.uid_juego = x.uid_juego
		JOIN coleccion c ON c.uid_coleccion = x.uid_coleccion
	WHERE d.uid_pedido in (SELECT fr.uid_pedido FROM FACTURA fr WHERE fr.numero_factura = $P{id_factura}) ORDER BY uid_detalle DESC;