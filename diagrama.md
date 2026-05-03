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