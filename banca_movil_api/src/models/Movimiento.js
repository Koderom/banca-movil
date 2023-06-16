const pool = require('../database/conexion');
const moment_tz = require('moment-timezone');
moment_tz.tz.setDefault('America/La_Paz');

const Movimiento = {};

Movimiento.registrarMovimiento = async (nroCuenta, monto) => {
    try{
        
        const now = moment_tz();
        const tipo_movimiento = (monto > 0) ? 'deposito' : 'retiro';
        monto = Math.abs(monto);
        const fecha_hora = now.format('YYYY-MM-DD HH:mm:ss');
        console.log(fecha_hora);
        const query = 'insert into movimiento(monto, fecha_hora, tipo_movimiento, tipo_moneda_id, cuenta_nro) values ($1, $2, $3, $4, $5) RETURNING *';
        const values = [monto, `${fecha_hora}`, tipo_movimiento, 5, nroCuenta];

        const res = await pool.query(query, values);
        pool.query('COMMIT');
        return res.rows[0];
    }catch(error){
        console.log(error);
        pool.query('ROLLBACK');
        return null;
    }
}

module.exports = Movimiento;