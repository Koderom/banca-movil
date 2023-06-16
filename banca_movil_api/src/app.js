
const express = require('express');
config = require('./config.json');

global.config = config;

const app = express();
app.set('json spaces', 2);
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const routes = require('./routes/routes');
app.use(routes);

app.listen(config.server_port, () => {
    console.log(`servidor corriendo en el puerto ${config.server_port}`);
});