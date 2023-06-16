insert into banco(id, nombre) 
values 
	(1, 'Banco nacional de bolivia'),
	(2, 'Banco fasil'),
	(3, 'Banco ganadero'),
	(4, 'Banco sol'),
	(5, 'Banco fie');

insert into cliente(ci, password, nombre)
values
	(1234567, 1234567,  'Juan Pérez'),
    (2345678, 2345678, 'María González'),
    (3456789, 3456789, 'Pedro López'),
    (4567890, 4567890, 'Ana Martínez'),
    (9876543, 9876543, 'Laura Rodríguez'),
    (8765432, 8765432, 'Roberto Sánchez');
	
insert into tipo_cuenta (id, descripcion)
values 
	(1, 'Cuenta corriente'),
    (2, 'Cuenta de ahorros'),
    (3, 'Cuenta de cheques'),
    (4, 'Cuenta de inversión'),
    (5, 'Cuenta de jubilación'),
    (6, 'Cuenta de depósito a plazo fijo');

insert into cuenta (nro, saldo, tipo_cuenta_id, cliente_ci, banco_id)
values
	('123456789', 00.00, 1, 1234567, 1),
	('234567891', 00.00, 5, 1234567, 2),
	('345678912', 00.00, 2, 1234567, 3),
	('456789123', 00.00, 3, 1234567, 4),
    ('234567890', 00.00, 2, 2345678, 2),
    ('345678901', 00.00, 3, 3456789, 3),
    ('456789012', 00.00, 4, 4567890, 4),
    ('987654321', 00.00, 5, 9876543, 5),
    ('876543210', 00.00, 6, 8765432, 1);

INSERT INTO tipo_moneda (id, nombre)
VALUES
    (1, 'Dólar estadounidense'),
    (2, 'Euro'),
    (3, 'Libra esterlina'),
    (4, 'Yen japonés'),
    (5, 'Dólar canadiense');
