const Cliente = require('../models/Cliente');
const jwt = require('jsonwebtoken');

const ClienteController = {}

ClienteController.login = async (req, res) => {
    const cliente = await Cliente.validateClientCredentials(req.body.ci, req.body.password);
    if(cliente){
        const token = jwt.sign({cliente}, config.secret_key);
        res.json(token);
    }else{
        res.sendStatus(403);
    }
}

ClienteController.cuentasUsuario = async (req, res) => {
    try {
        let clienteCi = Number(req.query.clienteCi);
        const cuentas = await Cliente.getCuentas(clienteCi);
        res.json(cuentas);
    } catch (error) {
        req.status(403).send(error.message);
    }

    
}


module.exports = ClienteController;