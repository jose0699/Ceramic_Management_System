const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'P_BD_2024',
    password: '17101717',
    port: 5432,
});

const PIEZA = (req, res, datos) => {
    const { coleccion, descripcion, precio, molde } = datos;
    const consulta = 
      `
      INSERT INTO PIEZA VALUES($1 , nextval ('pieza_uid_seq'), $2, $3, $4);
      `
    ;
    const valores = [coleccion, descripcion, precio, molde];
    pool.query(consulta, valores, (error, resultado) => {
      if (error) {
        console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
      } else {
        res.status(200).json(resultado.rows);
      }
    });
  };

  const FAMILIAR_HISTORICO_PRECIO = (req, res, datos) => {
    const { coleccion, pieza, inicio, precio } = datos;
    const consulta = 
      `
      INSERT INTO FAMILIAR_HISTORICO_PRECIO VALUES($1 , $2, $3, $4, NULL);
      `
    ;
    const valores = [coleccion, pieza, inicio, precio];
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
    PIEZA,
    FAMILIAR_HISTORICO_PRECIO
}
