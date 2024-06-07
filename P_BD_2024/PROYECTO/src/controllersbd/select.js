const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'P_BD_2024',
    password: '17101717',
    port: 5432,
});

const COLECCION = (req, res, datos) => {
  const consulta = 'SELECT c.uid_coleccion, c.nombre, c.linea FROM coleccion c;';
  pool.query(consulta, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const MOLDE = (req, res) => {
  const consulta = 
  'SELECT m.uid_molde, '+
  "CASE m.tipo "+
    "WHEN 'JA' THEN 'Jarra' WHEN 'TT' THEN 'Tetera' WHEN 'LE' THEN 'Lechera' WHEN 'AZ' THEN 'Azucarero' "+
		"WHEN 'CA' THEN 'Cazuela' WHEN 'BD' THEN 'Bandeja' WHEN 'PL' THEN 'Plato' WHEN 'TA' THEN 'Taza' WHEN 'EN' THEN 'Enzaladera' "+
  "END AS tipo, "+
  "m.tamaño, m.volumen, m.cant_persona, "+
  "CASE m.tipo_plato "+
    "WHEN 'HO' THEN 'Plato Hondo' WHEN 'LL' THEN 'Plato Llano' WHEN 'PO' THEN 'Plato Postre'	WHEN 'PA' THEN 'Plato Pasta' "+
		"WHEN 'PR' THEN 'Plato Presentación' WHEN 'TT' THEN 'Plato Taza Te' WHEN 'TC' THEN 'Plato Taza Café' "+
  "END AS plato, " +
  "Case m.tipo_taza "+
    "WHEN 'CS' THEN 'Taza Café sin plato'	WHEN 'CC' THEN 'Taza Café con plato' WHEN 'CT' THEN 'Taza Te sin plato' "+
		"WHEN 'TC' THEN 'Taza Te con plato' WHEN 'MC' THEN 'Taza Moka con plato'	WHEN 'MS' THEN 'Taza Moka sin plato' "+
  "END AS taza FROM molde m order by tipo;";+
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
    MOLDE
  };
