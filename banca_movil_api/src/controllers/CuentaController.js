const Cuenta = require('../models/Cuenta');
const CuentaController = {};

CuentaController.saldoCuenta = async (req, res) => {
    const nroCuenta = Number(req.query.nroCuenta);
    const saldo = await Cuenta.getSaldo(nroCuenta);
    if(saldo)res.json(saldo);
    else res.sendStatus(403);
}

CuentaController.usuarioCuenta = async (req, res) => {
    try {
        const nroCuenta = Number(req.query.nroCuenta)
        const cliente = await Cuenta.getCliente(nroCuenta);
        res.json({cliente});
    } catch (error) {
        res.status(403).send(error.message);
    }
}

CuentaController.retiroCuenta = async (req, res) => {
    try {
        await Cuenta.retiro(req.body.nroCuenta, req.body.monto);
        res.json({
            mensaje: "retiro exitoso"
        });
    }catch(error){
        res.status(403).send({error : error.message});
    }
}

CuentaController.depositoCuenta = async (req, res) => {
    try {
        await Cuenta.deposito(req.body.nroCuenta, req.body.monto);
        res.json({
            mensaje: "deposito exitoso"
        });
    }catch(error){
        res.status(403).send({error : error.message});
    }
}

CuentaController.movimientosCuenta = async (req, res) => {
    try {
        const nroCuenta = Number(req.query.nroCuenta)
        const movimientos = await Cuenta.getMovimientos(nroCuenta);
        res.json({movimientos});
    } catch (error) {
        res.status(403).send(error.message)
    }
}
module.exports = CuentaController;