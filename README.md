Delicias del Este - Gestión de Inventario y Ventas

Este es un sistema integral de gestión desarrollado para un emprendimiento de repostería artesanal. El proyecto fue diseñado aplicando conceptos de **Ingeniería en Sistemas** para automatizar el control de stock y la organización de pedidos.

Funcionalidades
- **Registro de Pedidos**: Interfaz intuitiva para anotar clientes y ventas.
- **Control de Stock Automático**: Descuento de insumos en tiempo real basado en recetas (BOM).
- **Monitor de Insumos**: Alertas visuales cuando un ingrediente está por debajo del punto de reposición.
- **Historial y Buscador**: Filtro dinámico de pedidos por cliente.

Tecnologías Utilizadas
- **Lenguaje**: Python 3.13
- **Base de Datos**: SQLite (SQL relacional)
- **Interfaz**: Streamlit
- **Modelado**: BPMN y Diagramas de Clases

# Documentación Técnica - Delicias del Este

## 1. Proceso de Negocio (BPMN)
  Este diagrama describe cómo fluye el pedido desde que el cliente consulta hasta que se entrega.
  flowchart LR
  
    flowchart LR
  
  %% =========================
  %% ESTILOS
  %% =========================
  
  classDef documento fill:#fff2cc,stroke:#333,stroke-width:2px,color:#000,font-weight:bold;
  classDef proceso fill:#dae8fc,stroke:#333,stroke-width:1px;
  classDef decision fill:#f8cecc,stroke:#333,stroke-width:1px;
  
  %% =========================
  %% POOL / LANES
  %% =========================
  
  subgraph L1["Cliente"]
  direction TB
  
  C1([Inicio])
  C2[Realiza pedido anticipado]
  
  D1["📄 DOC 1: PEDIDO<br>Cliente - Producto - Fecha<br>Medio de Pago"]
  
  C3[Registra medio de pago]
  C4[Recibe confirmacion]
  C5[Recibe aviso de entrega proxima]
  C6([Fin])
  
  end
  
  subgraph L2["Trabajador"]
  direction TB
  
  T1[Verifica pedido del cliente]
  T2[Controla pago]
  
  D3["📄 DOC 3: AGENDA<br>Produccion y entregas"]
  
  T3[Consulta agenda]
  T4[Gestiona produccion]
  T5[Entrega producto]
  
  end
  
  subgraph L3["Automata"]
  direction TB
  
  A1[Registrar datos del pedido]
  A2[Validar stock de producto final]
  
  D4["📄 DOC 4: INFORME STOCK<br>Productos e ingredientes"]
  
  A3{"¿Hay producto terminado?"}
  
  A4[Verificar stock de ingredientes]
  
  A5{"¿Ingredientes suficientes?"}
  
  A6[Generar orden de produccion]
  
  D6["📄 DOC 6: ORDEN VENTA/PRODUCCION"]
  
  A7[Actualizar agenda de produccion]
  
  A8[Generar factura]
  
  D2["📄 DOC 2: FACTURA<br>Detalle de compra"]
  
  A9[Registrar transaccion]
  
  D5["📄 DOC 5: ARCHIVO TRANSACCIONES<br>Pagos y movimientos"]
  
  A10[Programar notificacion automatica]
  
  A11[Enviar recordatorio de entrega]
  
  end
  
  %% =========================
  %% FLUJO PRINCIPAL
  %% =========================
  
  C1 --> C2
  C2 --> D1
  D1 --> C3
  C3 --> T1
  
  T1 --> T2
  T2 --> A1
  
  A1 --> A2
  A2 --> D4
  D4 --> A3
  
  A3 -- SI --> A8
  
  A3 -- NO --> A4
  A4 --> A5
  
  A5 -- SI --> A6
  A6 --> D6
  D6 --> T4
  
  T4 --> A7
  A7 --> D3
  D3 --> T3
  T3 --> A8
  
  A5 -- NO --> A7
  
  A8 --> D2
  D2 --> A9
  
  A9 --> D5
  D5 --> C4
  
  C4 --> A10
  A10 --> A11
  A11 --> C5
  
  C5 --> T5
  T5 --> C6
  
  %% =========================
  %% CLASES VISUALES
  %% =========================
  
  class D1,D2,D3,D4,D5,D6 documento;
  class A1,A2,A4,A6,A7,A8,A9,A10,A11,T1,T2,T3,T4,T5,C2,C3,C4,C5 proceso;
  class A3,A5 decision;

## 2. Modelo de Datos (UML de Clases)
Este diagrama muestra la estructura de las tablas y la lógica de objetos que usamos en Python y SQL.
---
  config:
    layout: elk
  ---
  classDiagram
      class Pedido {
          +int id
          +date fechaEntrega
          +float monto
          +string medioPago
          +string estadoPago
          +string estadoPedido  // Pendiente, En Producción, Listo, Entregado
          +registrarPago()
          +calcularMonto()
          +generarFactura()
      }
  
      class ProductoTerminado {
          +int id
          +string nombre
          +float precio
          +int stockActual
          +verificarStock()
          +actualizarStock()
          +calcularCostoProduccion()
      }
  
      class Receta {
          +int id
          +float cantidadNecesaria
      }
  
      class Ingrediente {
          +int id
          +string nombre
          +float cantidadDisponible
          +float puntoReposicion
          +float costoUnitario
          +emitirAlertaCompra()
          +actualizarCantidad()
      }
  
      class Transaccion {
          +int id
          +string tipo
          +timestamp fecha
          +float cantidad
          +registrarMovimiento()
      }
  
      Pedido "1" --> "1..*" ProductoTerminado : contiene
      ProductoTerminado "1" --> "1..*" Receta : define
      Receta "1" --> "1" Ingrediente : usa
      Transaccion --> ProductoTerminado : movimientoStock
      Transaccion --> Ingrediente : movimientoStock


Cómo ejecutarlo
1. Clona el repositorio.
2. Instala las dependencias: `pip install streamlit pandas`.
3. Ejecuta la app: `python -m streamlit run app.py`.

---
*Proyecto desarrollado por **Sofía Lopez** - Estudiante de Ingeniería en Sistemas de Información (UTN).*
