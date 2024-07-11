-- REPORTE HORARIO MENSUAL DE HORNEROS

SELECT e.num_expediente, 
              CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre,
              to_char(h.mesano, 'TMMONTH "DE" YYYY') as fecha_turno,
              e.num_cedula,
              h.turno,  
		CASE WHEN h.turno = 1 THEN '7:00 am a 3:00 pm'
			 WHEN h.turno = 2 THEN '3:00 pm a 11:00 pm'
			 WHEN h.turno = 3 THEN '11:00 pm a 7:00 am'
		END AS horario
FROM empleado e, hist_turno h
WHERE h.num_expediente = e.num_expediente AND  h.mesano = date_trunc('month',to_date(CONCAT( $P{Año},'-',$P{Numero_mes} ,'-','01'),'YYYY MM DD')::timestamp) 
ORDER BY h.turno;



--REPORTE MINUTA SEMANAL 
--Reporte Principal
SELECT e.num_expediente,
	e.num_cedula,
		CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre,
		to_char(i.fecha_hora, 'TMDAY DD "DE" TMMONTH "DE" YYYY') fecha_hora,
	  CASE 
	    WHEN i.num_expediente IS NULL THEN 'ASISTENTES'
	    ELSE 'INASISTENTES'
	  END AS asistencia,
   e.supervisor
FROM inasistencia i
RIGHT OUTER JOIN empleado e 
ON  i.num_expediente = e.num_expediente AND i.num_expediente_supervisor = e.supervisor AND i.fecha_hora =  $P{fecha de la reunion} 
WHERE e.supervisor = $P{Id Supervisor} 
ORDER BY asistencia ASC;

--Subreporte 1
  SELECT e.resumen
  FROM reunion e
  WHERE e.num_expediente =  $P{Id Supervisor}
  AND e.fecha_hora =  $P{fecha de la reunion}

--Subreporte 2
  SELECT e.num_expediente,
      e.primer_nombre ||' '|| e.primer_apellido ||' '|| COALESCE(e.segundo_nombre,'') ||' '|| COALESCE(e.segundo_apellido,'') as nombre,
      e.num_cedula,
      upper(d.nombre) ndepart,
      cargo
  FROM departamento d, empleado e
  WHERE d.uid_departamento =(SELECT DISTINCT id_departamento FROM mostrar_supervisores_departamento( $P{nombre departamento} ))
  AND d.nivel = 4 
  AND e.cargo = 'og' 
  AND e.supervisor is NULL
  AND e.num_expediente =  $P{Id Supervisor}


--REPORTE ASISTENCIAS POR DEPARTAMENTO Y SUPERVISOR
  SELECT e.num_expediente,
        upper(CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))) as nombre,
        upper(d.nombre) ndepart,
        e.num_cedula,
        e.cargo,
        e.supervisor,
        upper(CONCAT(s.primer_nombre, ' ', COALESCE(s.segundo_nombre, ''), ' ', s.primer_apellido, ' ', COALESCE(s.segundo_apellido, ''))) as nombre_supervisor,
        s.num_cedula,
        contar_inasistencias(e.num_expediente,to_date(CONCAT(to_char($P{Año},'9999'),'-',to_char( $P{Numero_mes}  ,'9999'),'-','01'),'YYYY MM DD')) inasistencias,
        porcentaje_inasistencia_empleado(e.num_expediente, to_date(CONCAT(to_char($P{Año},'9999'),'-',to_char( $P{Numero_mes}  ,'9999'),'-','01'),'YYYY MM DD')) pinac
    FROM departamento d, empleado s, empleado e
    WHERE s.num_expediente = e.supervisor
    AND d.uid_departamento = s.trabaja
    AND d.uid_departamento = e.trabaja
    AND e.supervisor =  $P{id supervisor} 
    AND s.num_expediente =  $P{id supervisor}



--REPORTE DETALLE EXPEDIENTE

  SELECT 
    upper(CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')))as nombre,
    upper(CONCAT(e.primer_nombre, ' ', e.primer_apellido)) as nom,
    e.num_expediente,
    e.num_cedula,
    to_char(e.fecha_nacimiento,'DD-TMMM-YYYY') fecha_nacimiento,
    e.tipo_sangre,
    e.genero,
    e.calle_avenida,
    CASE
      WHEN e.titulo = 'ba' THEN 'Bachiller'
      WHEN e.titulo = 'qui' THEN 'Ingeniero Químico'
      WHEN e.titulo = 'mec' THEN 'Ingeniero Mecánico'
      WHEN e.titulo = 'pro' THEN 'Ingeniero de Producción'
      WHEN e.titulo = 'ind' THEN 'Ingeniero Industrial'
      WHEN e.titulo = 'geo' THEN 'Geólogo'
    END titulo,

  --SubReporte 1
    SELECT s.nombre,
      CASE 
        WHEN s.tipo = 'A' THEN 'ALERGIAS'
        WHEN s.tipo = 'P' THEN 'PARTICULARES'
      END tipo,
      e.descripcion descripcion_salud_emp
    FROM ESTADO_SALUD s, E_E e 
    WHERE s.uid_salud = e.uid_salud AND e.num_exp = $P{id Empleado} 
    ORDER BY s.tipo ASC;

  --SubReporte 2
  WITH esSupervisor AS(
	     SELECT CASE 
	  			  WHEN COUNT(e.num_expediente) > 0 THEN 'Sí'
	  		 	  ELSE 'No'
	  		 END 
	  FROM empleado e, empleado s
	  WHERE s.num_expediente = e.supervisor
	  AND e.supervisor = $P{id Empleado}
  )

	SELECT 
			d.nombre nombre_dep,
			to_char(e.sueldo,'L99999990.00') sueldo,
			CASE
				WHEN e.cargo = 'se' THEN 'Secretaria'
				WHEN e.cargo = 'ge'	THEN 'Gerente'
				WHEN e.cargo = 'me' THEN 'Mecánico'
				WHEN e.cargo = 'in'	THEN 'Inspector'
				WHEN e.cargo = 'el' THEN 'Electricista'
				WHEN e.cargo = 'og'	THEN 'Operario General'
			END cargo,
			esSupervisor.case esSuper
	FROM departamento d, empleado e, esSupervisor
	WHERE d.uid_departamento = e.trabaja 
	AND e.num_expediente = $P{id Empleado} ;


  --SubReporte 3
  SELECT
			d.num_exp,
			d.uid,
			to_char(d.fecha,'DD-TMMM-YYYY') fecha,
			CASE
				WHEN d.motivo = 'in' THEN 'INASISTENCIAS'
				WHEN d.motivo = 'bm' OR d.motivo = 'ba' THEN 'BONOS'
				WHEN d.motivo = 'am' THEN 'AMONESTACIONES'
				WHEN d.motivo = 'lt' THEN 'LLEGADAS TARDE'
				WHEN d.motivo = 'he' THEN 'HORAS EXTRA'
			END motivo,
			
			to_char(d.monto_bono,'L99999990.00') monto_bono,
		
			CASE 
				WHEN d.retraso is not null THEN CONCAT(to_char(d.retraso,'9'),' minutos')
				ELSE null
			END retraso,
			
			CASE
				WHEN d.total_hora_extra is not null THEN CONCAT(to_char(d.total_hora_extra,'9'),' horas')
				ELSE null
			END total_hora_extra,
			
			COALESCE(d.descripcion, 'No se adjuntó descripción') descripcion
	FROM det_exp d, empleado e
	WHERE d.num_exp = e.num_expediente
	AND e.num_expediente = $P{id Empleado}
	AND d.fecha BETWEEN  $P{fecha inicial} AND $P{fecha final} 
	ORDER BY motivo DESC,d.uid DESC,fecha ASC;


--REPORTE CATÁLOGO

SELECT 
	c.nombre coleccion,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea,
	
	CASE
        WHEN c.categoria = 'cou' THEN 'Country'
        WHEN c.categoria = 'cla' THEN 'Clásica'
         WHEN c.categoria = 'mod' THEN 'Moderna'
     END categoria
     
FROM coleccion c
WHERE c.uid_coleccion =  $P{id coleccion}

--Subreporte 1
SELECT * FROM datos_piezas_coleccion($P{id coleccion}, $P{fecha_precios});


--Subreporte 2
SELECT DISTINCT
	v.uid_juego,
	v.nombre,
	calcular_precio_vajilla(v.uid_juego, d.uid_coleccion, $P{fecha_precios}) precio,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea
FROM coleccion c, vajilla v, detalle_pieza_vajilla d 
WHERE v.uid_juego = d.uid_juego
AND c.uid_coleccion = d.uid_coleccion
AND d.uid_coleccion = $P{id coleccion}


--REPORTE FICHAS PIEZA Y VAJILLA

--Pieza
SELECT * FROM datos_pieza( $P{id de la Pieza} ,$P{id coleccion}, $P{fecha_precio} );


--Vajilla

WITH precios_vaj AS (
	SELECT DISTINCT
	c.nombre,
	v.uid_juego,
	calcular_precio_vajilla(v.uid_juego, d.uid_coleccion,  $P{fecha_precio}  ) precio,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea
	FROM coleccion c, vajilla v, detalle_pieza_vajilla d 
	WHERE v.uid_juego = d.uid_juego
	AND v.uid_juego = $P{id vajilla} 
	AND c.uid_coleccion = d.uid_coleccion
	AND d.uid_coleccion = $P{id coleccion} 
)

SELECT 
	v.uid_juego,
	x.nombre coleccion,
	v.nombre vajilla,
	m.molde,
	v.capacidad,
	p.uid_pieza,
	d.cantidad,
	x.precio,
	v.descripcion,
	x.linea
FROM vajilla v, detalle_pieza_vajilla d, nombres_moldes m, precios_vaj x, pieza p
WHERE v.uid_juego = d.uid_juego
AND v.uid_juego = $P{id vajilla} 
AND v.uid_juego =  x.uid_juego
AND d.uid_pieza = p.uid_pieza
AND m.uid_molde = p.uid_molde
AND d.uid_coleccion = $P{id coleccion} 
