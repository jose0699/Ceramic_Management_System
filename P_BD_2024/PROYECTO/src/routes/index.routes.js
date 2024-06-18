const express = require('express');
const router = express.Router();
const path = require('path');

module.exports = router;

//Controladores
    const select = require('../controllersbd/select');
    const insert = require('../controllersbd/insert');

router.get('/Ceramica_Real', (req, res) => {
    const adminPath = path.join(__dirname, '../../public/views/principal.html');
    res.sendFile(adminPath);
});

/*------------------------------------------------------------------------------------------------------------*/
/*                                          Rutas de Pieza                                                    */ 
/*------------------------------------------------------------------------------------------------------------*/
router.get('/Ceramica_Real/Pieza', (req, res) => {
    const adminPath = path.join(__dirname, '../../public/views/pieza.html');
    res.sendFile(adminPath);
});
router.post('/Ceramica_Real/Pieza', (req, res) => {
    const datos = req.body;
  switch (parseInt(datos.pet)){
    case 1:
        select.COLECCION(req, res);
    break;

    case 2:
        select.MOLDE(req, res);
    break;

    case 3:
        insert.PIEZA(req, res, datos);
    break;

    case 4:
        insert.FAMILIAR_HISTORICO_PRECIO(req, res, datos);
    break;
  }
});

/*------------------------------------------------------------------------------------------------------------*/
/*                                        Rutas de Vajilla                                                    */ 
/*------------------------------------------------------------------------------------------------------------*/
router.get('/Ceramica_Real/Vajilla', (req, res) => {
    const adminPath = path.join(__dirname, '../../public/views/vajilla.html');
    res.sendFile(adminPath);
});
router.post('/Ceramica_Real/Vajilla', (req, res) => {
    const datos = req.body;
  switch (parseInt(datos.pet)){
    case 1:
        select.COLECCION(req, res);
    break;

    case 2:
        select.LINEA_COLECCION(req, res, datos);
    break;

    case 3:
        select.PIEZA_X_COLECCION_FAMILIAR(req, res, datos);
    break;

    case 4:
        select.PIEZA_X_COLECCION_RESTANTES(req, res, datos);
    break;

    case 5:
        insert.VAJILLA(req, res, datos);
    break;

    case 6:
        insert.VAJILLA_PIEZA(req, res, datos);
    break;
  }
});

/*------------------------------------------------------------------------------------------------------------*/
/*                                        Rutas de Colección                                                  */ 
/*------------------------------------------------------------------------------------------------------------*/
router.get('/Ceramica_Real/Coleccion', (req, res) => {
    const adminPath = path.join(__dirname, '../../public/views/coleccion.html');
    res.sendFile(adminPath);
});
router.post('/Ceramica_Real/Coleccion', (req, res) => {
    const datos = req.body;
    switch (parseInt(datos.pet)){
        case 1:
            insert.COLECCION(req, res, datos);
        break;
        
      }
});