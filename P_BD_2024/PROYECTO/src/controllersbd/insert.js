const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'P_BD_2024',
    password: '1234',
    port: 5432,
});

const PIEZA = (req, res, datos) => {
    const { coleccion, descripcion, precio, molde } = datos;
    const consulta = 'CALL insert_pieza($1, $2, $3, $4);';
      /*
      INSERT INTO PIEZA VALUES($1 , nextval ('pieza_uid_seq'), $2, $3, $4);
      `*/

    
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



  const COLECCION = (req, res, datos) => {
    const { nombre, linea, categoria, descripcion } = datos;
    const consulta = 
      `
      INSERT INTO COLECCION VALUES(nextval ('coleccion_uid_seq'), $1, CURRENT_DATE, $2, $3, $4);
      `
    ;
    const valores = [nombre, linea, categoria, descripcion];
    pool.query(consulta, valores, (error, resultado) => {
      if (error) {
        console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
      } else {
        res.status(200).json(resultado.rows);
      }
    });
  };

  const VAJILLA = (req, res, datos) => {
    const { nombre, capacidad, descripcion } = datos;
    const consulta = 
      `
      SELECT * FROM insertar_vajilla($1, $2, $3);
      `
    ;
    const valores = [nombre, capacidad, descripcion];
    pool.query(consulta, valores, (error, resultado) => {
      if (error) {
        console.error('Error al ejecutar la consulta:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
      } else {
        res.status(200).json(resultado.rows);
      }
    });
  };

  const VAJILLA_PIEZA = async (req, res, datos) => {
    const { vajilla, coleccion, pieza_cantidad } = datos;
    const promises = [];
  
    for (let i = 0; i < pieza_cantidad.length; i++) {
      const consulta = 
      `
        insert into DETALLE_PIEZA_VAJILLA values ($1, $2, $3, $4);
      `;
      const valores = [vajilla, coleccion, parseInt(pieza_cantidad[i].id), parseInt(pieza_cantidad[i].cantidad)];
  
      const promise = pool.query(consulta, valores)
        .catch(error => {
          console.error('Error al ejecutar la consulta:', error);
          return { error: 'Error interno del servidor' };
        });
  
      promises.push(promise);
    }
  
    try {
      const results = await Promise.all(promises);
      const errors = results.filter(result => result.error);
  
      if (errors.length > 0) {
        res.status(500).json(errors);
      } else {
        res.status(200).json({ message: 'Inserción exitosa' });
      }
    } catch (error) {
      console.error('Error al procesar las promesas:', error);
      res.status(500).json({ error: 'Error interno del servidor' });
    }
  };

module.exports = {
    PIEZA,
    FAMILIAR_HISTORICO_PRECIO,
    COLECCION,
    VAJILLA,
    VAJILLA_PIEZA
}
