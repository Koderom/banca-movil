const express = require('express');
const router = express.Router();

const controller = require('../controllers/controller');
const middleware = require('../middlewares/middleware');
const ClienteController = require('../controllers/ClienteController');
const CuentaController = require('../controllers/CuentaController');

router.get('/', controller.index); 
router.get('/start', controller.start); 

// servicios
router.post('/login', ClienteController.login);

router.get('/saldo-cuenta', middleware.auth,  CuentaController.saldoCuenta);
router.get('/cuentas-usuario', middleware.auth, ClienteController.cuentasUsuario);
router.get('/usuario-cuenta', middleware.auth, CuentaController.usuarioCuenta);

router.post('/retiro-cuenta', middleware.auth, CuentaController.retiroCuenta);
router.post('/deposito-cuenta', middleware.auth, CuentaController.depositoCuenta);

router.get('/movimientos-cuenta', middleware.auth, CuentaController.movimientosCuenta);
module.exports = router;