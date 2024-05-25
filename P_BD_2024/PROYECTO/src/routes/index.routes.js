const express = require('express');
const router = express.Router();
const path = require('path');

module.exports = router;

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


/*------------------------------------------------------------------------------------------------------------*/
/*                                        Rutas de Vajilla                                                    */ 
/*------------------------------------------------------------------------------------------------------------*/
router.get('/Ceramica_Real/Vajilla', (req, res) => {
    const adminPath = path.join(__dirname, '../../public/views/vajilla.html');
    res.sendFile(adminPath);
});