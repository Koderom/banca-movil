const pool = require('../database/conexion');

const Cliente = {};

Cliente.getCliente = async clienteCi => {
    try {
        const query = 'select * from cliente where cliente.ci = $1';
        const values = [clienteCi];
        const res = await pool.query(query, values);
        return res.rows[0];
    } catch (error) {
        console.log(error);
    }
}
Cliente.validateClientCredentials = async (clienteCi, clientePassword) => {
    try{
        const cliente = await Cliente.getCliente(clienteCi);
        console.log(cliente);
        if(cliente != null){
            if(cliente.password === clientePassword) return cliente;
        }
        return null;
    }catch(error){
        console.log(error);
    }
}

Cliente.getCuentas = async (clienteCi) => {
    try {
        const query = 'select cuenta.* from cliente, cuenta where cliente.ci = cuenta.cliente_ci and cliente.ci = $1';
        const values = [clienteCi];
        const res = await pool.query(query, values);
        return res.rows;    
    } catch (error) {
        throw error;
    }
    
}

Cliente.getClienteFromNroCuenta = async nroCuenta => {
    try {
        const query = 'select cliente.* from cliente, cuenta where cliente.ci = cuenta.cliente_ci and cuenta.nro = $1';
        const values = [nroCuenta];
        const res = await pool.query(query, values);
        return res.rows[0];    
    } catch (error) {
        console.log(error);
    }
    
}
module.exports = Cliente;