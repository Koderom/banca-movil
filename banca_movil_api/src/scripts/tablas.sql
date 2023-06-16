DROP TABLE IF EXISTS movimiento;
DROP TABLE IF EXISTS cuenta;
DROP TABLE IF EXISTS tipo_moneda;
DROP TABLE IF EXISTS tipo_cuenta;
DROP TABLE IF EXISTS banco;
DROP TABLE IF EXISTS cliente;

CREATE TABLE cliente(
	ci integer PRIMARY KEY,
	password integer,
	nombre varchar(50)
);

CREATE TABLE banco(
	id integer PRIMARY KEY,
	nombre varchar(50)
);

CREATE TABLE tipo_cuenta(
	id integer PRIMARY KEY,
	descripcion varchar(50)
);

CREATE TABLE cuenta(
	nro integer PRIMARY KEY,
	saldo decimal(10,2),
	tipo_cuenta_id integer,
	cliente_ci integer,
	banco_id integer,
	
	FOREIGN KEY (tipo_cuenta_id) REFERENCES tipo_cuenta(id),
	FOREIGN KEY (cliente_ci) REFERENCES cliente(ci),
	FOREIGN KEY (banco_id) REFERENCES banco(id)
	
);

CREATE TABLE tipo_moneda(
	id integer PRIMARY KEY,
	nombre varchar(20)
);

CREATE TABLE movimiento(
	id serial PRIMARY KEY,
	monto decimal(10,2),
	fecha_hora TIMESTAMP,
	tipo_movimiento varchar(20),
	tipo_cambio integer,
	
	tipo_moneda_id integer,
	cuenta_nro integer,
	
	FOREIGN KEY (tipo_moneda_id) REFERENCES tipo_moneda(id),
	FOREIGN KEY (cuenta_nro) REFERENCES cuenta(nro)
);