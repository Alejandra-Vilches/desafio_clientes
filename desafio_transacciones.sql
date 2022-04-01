CREATE DATABASE transacciones;
--1. Cargar el respaldo de la base de datos unidad2.sql. 
psql -U constanza transacciones < unidad2.sql

psql -U constanza -d transacciones;

--2. El cliente usuario01 ha realizado la siguiente compra:
--● producto: producto9.
--● cantidad: 5.
--● fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar si fue efectivamente
--descontado en el stock.
BEGIN TRANSACTION;
INSERT INTO compra (cliente_id, fecha) values (1, now());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (9,
(SELECT max(id) FROM compra), 5);
UPDATE producto p SET stock = stock-5 WHERE p.id = 9;
COMMIT;
SELECT * FROM producto;

--3. El cliente usuario02 ha realizado la siguiente compra:
--● producto: producto1, producto 2, producto 8.
--● cantidad: 3 de cada producto.
--● fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
--se queda sin stock, no se realice la compra
BEGIN TRANSACTION;
INSERT INTO compra (cliente_id, fecha) values (2, now());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (1,
(SELECT max(id) FROM compra), 3);

UPDATE producto p SET stock = stock-3 WHERE p.id = 1;
COMMIT;

BEGIN TRANSACTION;
INSERT INTO compra (cliente_id, fecha) values (2, now());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (2,
(SELECT max(id) FROM compra), 3);

UPDATE producto p SET stock = stock-3 WHERE p.id = 2;
COMMIT;

BEGIN TRANSACTION;
INSERT INTO compra (cliente_id, fecha) values (2, now());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (8,
(SELECT max(id) FROM compra), 3);

UPDATE producto p SET stock = stock-3 WHERE p.id = 8;
COMMIT;

SELECT * FROM producto;

--4.Realizar las siguientes consultas:
--a. Deshabilitar el AUTOCOMMIT .
\set AUTOCOMMIT off

--b. Insertar un nuevo cliente.
INSERT INTO cliente(id, nombre, email) VALUES ('12', 'usuario012', 'usuario012@hotmail.com');

--c. Confirmar que fue agregado en la tabla cliente.
SELECT * FROM cliente;

--d. Realizar un ROLLBACK.
ROLLBACK;

--e. Confirmar que se restauró la información, sin considerar la inserción del punto b.
SELECT * FROM cliente;

--f. Habilitar de nuevo el AUTOCOMMIT.
\set AUTOCOMMIT on



