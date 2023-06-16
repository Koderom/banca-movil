const controller = {};
const pool = require('../database/conexion');

controller.index = (req, res) => {
    res.json({
        "mensaje" : "hola mundo"
    });
};

controller.start = async (req, res) => {
    const fs = require('fs');
    const path = require('path');
    try {
        const tablaspath = path.join(__dirname,'../scripts/tablas.sql' );
        const datospath = path.join(__dirname, '../scripts/datos.sql');
        const sqlScriptTablas = fs.readFileSync(tablaspath, 'utf-8');
        const sqlScriptDatos = fs.readFileSync(datospath, 'utf-8');
        
        await pool.query(sqlScriptTablas);
        await pool.query(sqlScriptDatos);
        res.json({
            "mensaje" : "base de datos lista"
        });
    } catch (error) {
        res.status(403).send({error : error.message});
    }
    
}


module.exports = controller;