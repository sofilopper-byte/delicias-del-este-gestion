-- =====================================================
-- DELICIAS DEL ESTE
-- SISTEMA DE INVENTARIO Y VENTAS
-- SQLITE / MYSQL
-- =====================================================



-- =====================================================
-- ELIMINAR TABLAS SI YA EXISTEN
-- =====================================================

DROP TABLE IF EXISTS Recetas;
DROP TABLE IF EXISTS Transacciones;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Ingredientes;



-- =====================================================
-- TABLA INGREDIENTES
-- Materia prima utilizada en los chocolates
-- =====================================================

CREATE TABLE Ingredientes (

    id INTEGER PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,

    cantidad_disponible DECIMAL(10,2) NOT NULL,

    punto_reposicion DECIMAL(10,2) NOT NULL,

    costo_unitario DECIMAL(10,2) NOT NULL

);



-- =====================================================
--  TABLA PRODUCTOS
-- Productos terminados para la venta
-- =====================================================

CREATE TABLE Productos (

    id INTEGER PRIMARY KEY,

    nombre VARCHAR(100) NOT NULL,

    precio_venta DECIMAL(10,2) NOT NULL,

    stock_actual INT NOT NULL

);



-- =====================================================
-- TABLA RECETAS
-- Relaciona productos con ingredientes
-- =====================================================

CREATE TABLE Recetas (

    id INTEGER PRIMARY KEY,

    id_producto INT NOT NULL,

    id_ingrediente INT NOT NULL,

    cantidad_necesaria DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_producto)
        REFERENCES Productos(id),

    FOREIGN KEY (id_ingrediente)
        REFERENCES Ingredientes(id)

);



-- =====================================================
-- TABLA PEDIDOS
-- Pedidos realizados por clientes
-- =====================================================

CREATE TABLE Pedidos (

    id INTEGER PRIMARY KEY,

    nombre_cliente VARCHAR(100) NOT NULL,

    fecha_entrega DATE NOT NULL,

    medio_pago VARCHAR(50) NOT NULL,

    monto_total DECIMAL(10,2) NOT NULL,

    estado_pago VARCHAR(30) NOT NULL,

    estado_pedido VARCHAR(30) NOT NULL
    CHECK (
        estado_pedido IN (
            'Pendiente',
            'En Produccion',
            'Listo',
            'Entregado'
        )
    )

);



-- =====================================================
-- TABLA TRANSACCIONES
-- Entradas y salidas de stock
-- =====================================================

CREATE TABLE Transacciones (

    id INTEGER PRIMARY KEY,

    tipo VARCHAR(20) NOT NULL
    CHECK (
        tipo IN ('entrada', 'salida')
    ),

    fecha_auto TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_pedido_ref INT,

    cantidad DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_pedido_ref)
        REFERENCES Pedidos(id)

);



-- =====================================================
-- CARGAR INGREDIENTES
-- =====================================================

INSERT INTO Ingredientes
(id, nombre, cantidad_disponible, punto_reposicion, costo_unitario)
VALUES

(1, 'Chocolate SemiAmargo', 12.00, 3.00, 4500),

(2, 'Oreo', 8.00, 2.00, 1800),

(3, 'Queso Crema', 6.00, 2.00, 3200),

(4, 'Pasta de Mani', 5.00, 1.50, 3900),

(5, 'Chocolate de Leche', 10.00, 3.00, 4200),

(6, 'Chocolate Blanco', 9.00, 2.50, 4600),

(7, 'Frutillas', 4.00, 1.00, 2500),

(8, 'Galleta de Chocolate', 7.00, 2.00, 1700),

(9, 'Dulce de Leche', 6.00, 2.00, 2800),

(10, 'Toppins', 3.00, 1.00, 1500);



-- =====================================================
-- CARGAR PRODUCTOS
-- =====================================================

INSERT INTO Productos
(id, nombre, precio_venta, stock_actual)
VALUES

(1, 'Tableta Chocolate Amargo', 4500, 15),

(2, 'Corazon Oreo', 5200, 10),

(3, 'Corazon Chocotorta', 5800, 8),

(4, 'Frutillas Bañadas', 3900, 20);



-- =====================================================
-- CARGAR RECETAS
-- Relacion entre productos e ingredientes
-- =====================================================

INSERT INTO Recetas
(id, id_producto, id_ingrediente, cantidad_necesaria)
VALUES


-- TABLETA CHOCOLATE AMARGO

(1, 1, 1, 0.30),
(2, 1, 10, 0.05),


-- CORAZON OREO

(3, 2, 6, 0.25),
(4, 2, 2, 0.10),
(5, 2, 3, 0.15),


-- CORAZON CHOCOTORTA

(6, 3, 1, 0.20),
(7, 3, 3, 0.15),
(8, 3, 8, 0.10),
(9, 3, 9, 0.12),


-- FRUTILLAS BAÑADAS

(10, 4, 5, 0.18),
(11, 4, 7, 0.20);



-- =====================================================
-- CARGAR PEDIDOS
-- =====================================================

INSERT INTO Pedidos
(id, nombre_cliente, fecha_entrega, medio_pago,
monto_total, estado_pago, estado_pedido)
VALUES

(1, 'Sofia Lopez', '2026-05-10',
'Transferencia', 5200,
'Pagado', 'Pendiente'),

(2, 'Juan Perez', '2026-05-12',
'Efectivo', 3900,
'Pendiente', 'En Produccion');



-- =====================================================
-- CARGAR TRANSACCIONES
-- =====================================================

INSERT INTO Transacciones
(id, tipo, id_pedido_ref, cantidad)
VALUES

(1, 'entrada', NULL, 20),

(2, 'salida', 1, 5),

(3, 'salida', 2, 3);



-- =====================================================
--  CONSULTAS
-- =====================================================



SELECT * FROM Ingredientes;




SELECT * FROM Productos;




SELECT * FROM Recetas;




SELECT * FROM Pedidos;




SELECT * FROM Transacciones;



-- =====================================================
-- CONSULTA:
-- INGREDIENTES POR DEBAJO DEL PUNTO DE REPOSICION
-- =====================================================

SELECT
    nombre,
    cantidad_disponible,
    punto_reposicion
FROM Ingredientes
WHERE cantidad_disponible < punto_reposicion;



-- =====================================================
-- CONSULTA:
-- COSTO TOTAL DE INGREDIENTES DE UN PRODUCTO
-- =====================================================

SELECT
    p.nombre AS producto,

    SUM(
        r.cantidad_necesaria * i.costo_unitario
    ) AS costo_total

FROM Recetas r

INNER JOIN Productos p
    ON r.id_producto = p.id

INNER JOIN Ingredientes i
    ON r.id_ingrediente = i.id

WHERE p.id = 2

GROUP BY p.nombre;



-- =====================================================
-- CONSULTA:
-- PEDIDOS PENDIENTES PARA UNA FECHA
-- =====================================================

SELECT
    nombre_cliente,
    fecha_entrega,
    estado_pedido

FROM Pedidos

WHERE fecha_entrega = '2026-05-10'

AND estado_pedido <> 'Entregado';