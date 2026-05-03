import streamlit as st
import sqlite3
import pandas as pd
from datetime import datetime

# =====================================================
# CONFIGURACION GENERAL
# =====================================================

st.set_page_config(
    page_title="Delicias del Este",
    layout="wide"
)

st.title("Delicias del Este")
st.subheader("Sistema de Gestion de Pedidos e Inventario")

# =====================================================
# CONEXION A LA BASE DE DATOS
# =====================================================

conn = sqlite3.connect("delicias.db", check_same_thread=False)
cursor = conn.cursor()

# =====================================================
# FUNCIONES AUXILIARES
# =====================================================

def obtener_productos():
    query = "SELECT id, nombre FROM Productos"
    return pd.read_sql_query(query, conn)

def obtener_ingredientes():
    query = """
    SELECT
        id,
        nombre,
        cantidad_disponible,
        punto_reposicion
    FROM Ingredientes
    """
    return pd.read_sql_query(query, conn)

def obtener_pedidos():
    query = """
    SELECT
        id,
        nombre_cliente,
        fecha_entrega,
        medio_pago,
        monto_total,
        estado_pedido
    FROM Pedidos
    ORDER BY fecha_entrega ASC
    """
    return pd.read_sql_query(query, conn)

def registrar_pedido(
    nombre_cliente,
    id_producto,
    fecha_entrega,
    monto
):

    # =================================================
    # INSERTAR PEDIDO
    # =================================================

    query_insert = """
    INSERT INTO Pedidos (
        nombre_cliente,
        fecha_entrega,
        medio_pago,
        monto_total,
        estado_pago,
        estado_pedido
    )
    VALUES (?, ?, ?, ?, ?, ?)
    """

    cursor.execute(
        query_insert,
        (
            nombre_cliente,
            fecha_entrega,
            "Transferencia",
            monto,
            "Pendiente",
            "Pendiente"
        )
    )

    id_pedido = cursor.lastrowid

    # =================================================
    # CONSULTAR RECETA DEL PRODUCTO
    # =================================================

    query_receta = """
    SELECT
        id_ingrediente,
        cantidad_necesaria
    FROM Recetas
    WHERE id_producto = ?
    """

    cursor.execute(query_receta, (id_producto,))
    receta = cursor.fetchall()

    # =================================================
    # DESCONTAR INGREDIENTES
    # =================================================

    for ingrediente in receta:

        id_ingrediente = ingrediente[0]
        cantidad_necesaria = ingrediente[1]

        query_update = """
        UPDATE Ingredientes
        SET cantidad_disponible =
            cantidad_disponible - ?
        WHERE id = ?
        """

        cursor.execute(
            query_update,
            (
                cantidad_necesaria,
                id_ingrediente
            )
        )

    # =================================================
    # REGISTRAR TRANSACCION
    # =================================================

    query_transaccion = """
    INSERT INTO Transacciones (
        tipo,
        id_pedido_ref,
        cantidad
    )
    VALUES (?, ?, ?)
    """

    cursor.execute(
        query_transaccion,
        (
            "salida",
            id_pedido,
            1
        )
    )

    conn.commit()

# =====================================================
# LAYOUT PRINCIPAL
# =====================================================

col1, col2 = st.columns([2, 1])

# =====================================================
# SECCION PRINCIPAL
# =====================================================

with col1:

    st.header("Formulario de Pedidos")

    productos_df = obtener_productos()

    productos_dict = {
        row["nombre"]: row["id"]
        for _, row in productos_df.iterrows()
    }

    nombre_cliente = st.text_input(
        "Nombre del Cliente"
    )

    producto_nombre = st.selectbox(
        "Producto",
        list(productos_dict.keys())
    )

    fecha_entrega = st.date_input(
        "Fecha de Entrega"
    )

    monto = st.number_input(
        "Monto",
        min_value=0.0,
        step=100.0
    )

    if st.button("Registrar Pedido"):

        if nombre_cliente == "":
            st.error("Ingrese el nombre del cliente")

        else:

            registrar_pedido(
                nombre_cliente,
                productos_dict[producto_nombre],
                fecha_entrega,
                monto
            )

            st.success("Pedido registrado correctamente")

    st.divider()

    # =================================================
    # BUSCADOR
    # =================================================

    st.header("Buscar Pedido")

    busqueda = st.text_input(
        "Buscar por nombre de cliente"
    )

    pedidos_df = obtener_pedidos()

    if busqueda != "":

        pedidos_df = pedidos_df[
            pedidos_df["nombre_cliente"]
            .str.contains(busqueda, case=False)
        ]

    st.header("Calendario de Entregas")

    st.dataframe(
        pedidos_df,
        use_container_width=True
    )

# =====================================================
# PANEL LATERAL
# =====================================================

with col2:

    st.header("Monitor de Stock")

    ingredientes_df = obtener_ingredientes()

    for _, row in ingredientes_df.iterrows():

        nombre = row["nombre"]
        cantidad = row["cantidad_disponible"]
        reposicion = row["punto_reposicion"]

        if cantidad <= reposicion:

            st.error(
                f"{nombre}: {cantidad} ⚠ Bajo Stock"
            )

        else:

            st.success(
                f"{nombre}: {cantidad}"
            )

# =====================================================
# CIERRE DE CONEXION
# =====================================================

conn.close()