const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'P_BD_2024',
    password: '17101717',
    port: 5432,
});

const COLECCION = (req, res, datos) => {
  const consulta = 'SELECT uid_coleccion, nombre FROM COLECCION;';
  pool.query(consulta, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

const MOLDE = (req, res, datos) => {
  const {  } = datos;
  const consulta = '';
  const valores = [];
  pool.query(consulta, valores, (error, resultado) => {
    if (error) {
      console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } else {
      res.status(200).json(resultado.rows);
    }
  });
};

  module.exports = {

  };
