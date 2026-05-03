-- =========================================================
-- BASE DE DATOS: DELICIAS DEL ESTE
-- Sistema de Gestion de Inventario y Ventas
-- =========================================================

-- =========================================================
-- TABLA: INGREDIENTES
-- Almacena la materia prima utilizada para fabricar chocolates
-- =========================================================

CREATE TABLE Ingredientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad_disponible DECIMAL(10,2) NOT NULL,
    punto_reposicion DECIMAL(10,2) NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL
);

-- =========================================================
-- TABLA: PRODUCTOS
-- Contiene los productos terminados listos para la venta
-- =========================================================

CREATE TABLE Productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL
);

-- =========================================================
-- TABLA: RECETAS
-- Relaciona productos con ingredientes.
-- Define cuantos ingredientes necesita cada producto.
-- (Explosion de materiales)
-- =========================================================

CREATE TABLE Recetas (
    id INT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_necesaria DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_producto)
        REFERENCES Productos(id),

    FOREIGN KEY (id_ingrediente)
        REFERENCES Ingredientes(id)
);

-- =========================================================
-- TABLA: PEDIDOS
-- Guarda los pedidos realizados por los clientes
-- =========================================================

CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
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

-- =========================================================
-- TABLA: TRANSACCIONES
-- Registra movimientos de stock:
-- entradas de materia prima,
-- salidas por produccion o ventas
-- =========================================================

CREATE TABLE Transacciones (
    id INT PRIMARY KEY,

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

-- =========================================================
-- ================= CONSULTAS EJEMPLO =====================
-- =========================================================

-- =========================================================
-- VER INGREDIENTES POR DEBAJO DEL PUNTO DE REPOSICION
-- =========================================================

SELECT
    id,
    nombre,
    cantidad_disponible,
    punto_reposicion
FROM Ingredientes
WHERE cantidad_disponible < punto_reposicion;

-- =========================================================
-- CALCULAR EL COSTO TOTAL DE INGREDIENTES
-- DE UN PRODUCTO ESPECIFICO
-- =========================================================

SELECT
    p.nombre AS producto,
    SUM(r.cantidad_necesaria * i.costo_unitario) AS costo_total
FROM Recetas r
INNER JOIN Productos p
    ON r.id_producto = p.id
INNER JOIN Ingredientes i
    ON r.id_ingrediente = i.id
WHERE p.id = 1
GROUP BY p.nombre;

-- =========================================================
-- VER PEDIDOS PENDIENTES PARA UNA FECHA
-- =========================================================

SELECT
    id,
    nombre_cliente,
    fecha_entrega,
    estado_pedido
FROM Pedidos
WHERE fecha_entrega = '2026-05-10'
AND estado_pedido <> 'Entregado';