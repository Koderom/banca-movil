const pool = require('../database/conexion');
const Movimiento = require('../models/Movimiento');
const Cuenta = {};

Cuenta.getSaldo = async numeroCuenta => {
    try {
        const query = 'select cuenta.saldo from cuenta where cuenta.nro = $1';
        const values = [numeroCuenta];
        const res = await pool.query(query, values);
        return res.rows[0];    
    } catch (error) {
        console.log(error);
    }
    
}

Cuenta.getCliente = async nroCuenta => {
    try{
        const query = 'select cliente.* from cliente, cuenta where cuenta.cliente_ci = cliente.ci and cuenta.nro = $1';
        const values = [nroCuenta];
        const result = await pool.query(query, values);
        const cliente = result.rows[0];
        if(Object.keys(cliente).length === 0) throw new Error('cliente no encontrado');
        return cliente;
    }catch(error){
        throw error;
    }
}

Cuenta.retiro = async (nroCuenta, monto) => {
    try {
        const cuenta_query = 'select * from cuenta where nro = $1';
        const cuenta_values = [nroCuenta];
        const res = await pool.query(cuenta_query, cuenta_values);
        let cuenta = null;
        if(res.rowCount != 0) cuenta = res.rows[0];
        else throw new Error('cuenta no encontrada');

        if(cuenta && monto <= cuenta.saldo){
            const movimiento = Movimiento.registrarMovimiento(nroCuenta, monto*-1);
            if(movimiento){
                let nuevo_saldo = parseFloat(cuenta.saldo) - monto;
                const upd_saldo_query = 'UPDATE cuenta SET saldo = $1 WHERE nro = $2';
                const upd_saldo_values = [nuevo_saldo, nroCuenta]
                await pool.query(upd_saldo_query, upd_saldo_values);
            }
        }else throw new Error('saldo insuficiente');
        
    } catch (error) {
        throw error;
    }
    
}

Cuenta.deposito = async (nroCuenta, monto) => {
    try {
        const cuenta_query = 'select * from cuenta where nro = $1';
        const cuenta_values = [nroCuenta];
        const res = await pool.query(cuenta_query, cuenta_values);
        let cuenta = null;
        if(res.rowCount != 0) cuenta = res.rows[0];
        else throw new Error('cuenta no encontrada');
        console.log(cuenta);
        const movimiento = Movimiento.registrarMovimiento(nroCuenta, monto);
        if(movimiento){
            let nuevo_saldo = parseFloat(cuenta.saldo) + monto;
            const upd_saldo_query = 'UPDATE cuenta SET saldo = $1 WHERE nro = $2';
            const upd_saldo_values = [nuevo_saldo, nroCuenta]
            await pool.query(upd_saldo_query, upd_saldo_values);
        }else throw new Error('error al realizar el deposito');
        
    } catch (error) {
        throw error;
    }
    
}

Cuenta.getMovimientos = async (nroCuenta) => {
    try {
        const query = 'select * from movimiento where movimiento.cuenta_nro = $1';
        const values = [nroCuenta];
        const result = await pool.query(query, values);
        const movimientos = result.rows;
        return movimientos;
    } catch (error) {
        throw error;
    }
}

module.exports = Cuenta;
