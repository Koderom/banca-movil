const jwt = require('jsonwebtoken');
const middleware = {};

middleware.ensureToken = (req, res, next) => {
    const bearerHeader = req.headers['authorization'];
    if(typeof bearerHeader !== 'undefined'){
        const bearer = bearerHeader.split(" ");
        const bearerToken = bearer[1];
        req.token = bearerToken;
        next();
    }else{
        res.status(403).send('token no encontrado');
    }
}

middleware.auth = (req, res, next) => {
    middleware.ensureToken(req, res, () => {
        jwt.verify(req.token, config.secret_key, (err, data) => {
            if(err) res.status(403).send('token invalido');
            else{
                req.body.data = {
                    ci: data.cliente.ci,
                    nombre: data.cliente.nombre
                };
                next();
            }
        });
    })
}

module.exports = middleware;