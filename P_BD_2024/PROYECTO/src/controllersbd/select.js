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
    MOLDE
  };
