const {Pool} = require('pg');

// const pool = new Pool({
//     user: config.db_user,
//     host: config.db_host,
//     password: config.db_password,
//     database: config.db_name,
//     port: config.bd_port
// });
const pool = new Pool({
    connectionString: process.env.DATABASE_URL||'postgres://banca_movil_api:lH2Xs29uEosqOFh@banca-movil.flycast:5432/banca_movil_api?sslmode=disable'
});
module.exports = pool;