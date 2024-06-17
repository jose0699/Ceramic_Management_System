const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'P_BD_2024',
    password: '17101717',
    port: 5432,
});

const COLECCION = (req, res, datos) => {
  const consulta = 'SELECT c.uid_coleccion, c.nombre FROM coleccion c;';
  pool.query(consulta, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const LINEA_COLECCION = (req, res, datos) => {
  const { coleccion} = datos;
  const consulta = ` SELECT c.linea FROM coleccion c WHERE c.uid_coleccion = $1;`;
  const valores = [coleccion];
  pool.query(consulta, valores, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
      res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const PIEZA_X_COLECCION_FAMILIAR = (req, res, datos) => {
  const { coleccion} = datos;
  const consulta = ` 
				SELECT p.uid_pieza AS id, 
		  CASE 
        WHEN m.tipo = 'JA' THEN 'Jarra'
			  WHEN m.tipo = 'TT' THEN 'Tetera'
			  WHEN m.tipo = 'LE' THEN 'Lechera'
			  WHEN m.tipo = 'AZ' THEN 'Azucarero'
			  WHEN m.tipo = 'CA' THEN 'Cazuela'
			  WHEN m.tipo = 'BD' THEN 'Bandeja'
			  WHEN m.tipo = 'PL' THEN 'Plato'
			  WHEN m.tipo = 'TA' THEN 'Taza'
			  WHEN m.tipo = 'EN' THEN 'Ensaladera'
		  END 

		  ||''||

		  CASE WHEN m.tipo_plato = 'HO' THEN ' Hondo'
			  WHEN m.tipo_plato = 'LL' THEN ' llano'
			  WHEN m.tipo_plato = 'TT' THEN ' taza té'
			  WHEN m.tipo_plato = 'TC' THEN ' taza café'
			  WHEN m.tipo_plato = 'TM' THEN ' taza moka'
			  WHEN m.tipo_plato = 'PO' THEN ' postre'
			  WHEN m.tipo_plato = 'PR' THEN ' presentación'
			  WHEN m.tipo_plato = 'PA' THEN ' pasta'
			ELSE ''
		  END

		  ||''||

		  CASE WHEN m.tipo_taza = 'CS' THEN ' café sin plato'
			  WHEN m.tipo_taza = 'CC' THEN ' café con plato'
			  WHEN m.tipo_taza = 'TS' THEN ' té sin plato'
			  WHEN m.tipo_taza = 'TC' THEN ' té con plato'
			  WHEN m.tipo_taza = 'MS' THEN ' moka sin plato'
			  WHEN m.tipo_taza = 'MC' THEN ' moka sin plato'
			  ELSE ''
		  END

		  ||''||

		  CASE WHEN m.forma = 'ova' THEN ' ovalado'
			  WHEN m.forma = 'rec' THEN ' rectangular'
			  WHEN m.forma = 'cua' THEN ' cuadrado'
			  WHEN m.forma = 'red' THEN ' redondo'
			  ELSE ''
		  END

		  ||' '|| m.tamaño
		  ||''|| COALESCE(to_char(m.volumen,'9.9') || 'lts','')
		  ||''|| COALESCE(to_char(m.cant_persona,'9') || 'pers','')

		  AS nombre, f.precio
      FROM molde m inner join pieza p on m.uid_molde = p.uid_molde inner join FAMILIAR_HISTORICO_PRECIO f
	  on p.uid_pieza = f.uid_pieza WHERE p.uid_coleccion = $1 AND f.fecha_fin IS NULL;`;
  const valores = [coleccion];
  pool.query(consulta, valores, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
      res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const PIEZA_X_COLECCION_RESTANTES = (req, res, datos) => {
  const { coleccion} = datos;
  const consulta = `
  SELECT m.uid_molde AS id, 
		  CASE 
        WHEN m.tipo = 'JA' THEN 'Jarra'
			  WHEN m.tipo = 'TT' THEN 'Tetera'
			  WHEN m.tipo = 'LE' THEN 'Lechera'
			  WHEN m.tipo = 'AZ' THEN 'Azucarero'
			  WHEN m.tipo = 'CA' THEN 'Cazuela'
			  WHEN m.tipo = 'BD' THEN 'Bandeja'
			  WHEN m.tipo = 'PL' THEN 'Plato'
			  WHEN m.tipo = 'TA' THEN 'Taza'
			  WHEN m.tipo = 'EN' THEN 'Ensaladera'
		  END 

		  ||''||

		  CASE 
        WHEN m.tipo_plato = 'HO' THEN ' Hondo'
			  WHEN m.tipo_plato = 'LL' THEN ' llano'
			  WHEN m.tipo_plato = 'TT' THEN ' taza té'
			  WHEN m.tipo_plato = 'TC' THEN ' taza café'
			  WHEN m.tipo_plato = 'TM' THEN ' taza moka'
			  WHEN m.tipo_plato = 'PO' THEN ' postre'
			  WHEN m.tipo_plato = 'PR' THEN ' presentación'
			  WHEN m.tipo_plato = 'PA' THEN ' pasta'
			  ELSE ''
		  END

		  ||''||

		  CASE 
        WHEN m.tipo_taza = 'CS' THEN ' café sin plato'
			  WHEN m.tipo_taza = 'CC' THEN ' café con plato'
			  WHEN m.tipo_taza = 'TS' THEN ' té sin plato'
			  WHEN m.tipo_taza = 'TC' THEN ' té con plato'
			  WHEN m.tipo_taza = 'MS' THEN ' moka sin plato'
			  WHEN m.tipo_taza = 'MC' THEN ' moka sin plato'
			  ELSE ''
		  END

		  ||''||

		  CASE 
       		  WHEN m.forma = 'ova' THEN ' ovalado'
			  WHEN m.forma = 'rec' THEN ' rectangular'
			  WHEN m.forma = 'cua' THEN ' cuadrado'
			  WHEN m.forma = 'red' THEN ' redondo'
			  ELSE ''
		  END

		  ||' '|| m.tamaño
		  ||''|| COALESCE(to_char(m.volumen,'9.9') || 'lts','')
		  ||''|| COALESCE(to_char(m.cant_persona,'9') || 'pers','')

		  AS nombre, p.precio
      FROM molde m INNER JOIN pieza p ON m.uid_molde = p.uid_molde WHERE p.uid_coleccion = $1 AND p.precio is not null;`;
  const valores = [coleccion];
  pool.query(consulta, valores, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
      res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const MOLDE = (req, res) => {
  const consulta =  'select * from nombres_moldes;'

  pool.query(consulta, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};


  module.exports = {
    COLECCION,
    MOLDE,
    LINEA_COLECCION,
    PIEZA_X_COLECCION_FAMILIAR,
    PIEZA_X_COLECCION_RESTANTES
  };
