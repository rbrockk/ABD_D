# ABD_D
Espacio de trabajo para el proyecto basado en una base de datos relacional para la gestion de un credito de consumo.

# Propuesta: Sistema de Base de Datos para Créditos de Consumo

## **1. Descripción del Proyecto**
El proyecto busca desarrollar un sistema de base de datos eficiente y seguro para gestionar toda la información relacionada con los créditos de consumo. Esto incluye clientes, productos de crédito, pagos, plazos, estados financieros y reportes de saldos. El sistema optimiza el seguimiento de créditos, garantizando la integridad, accesibilidad y confidencialidad de los datos.

---

## **2. Objetivos**

### **Objetivo General**
Desarrollar un sistema de base de datos que permita gestionar de manera eficiente y segura la información relacionada con los créditos de consumo.

### **Objetivos Específicos**
1. Calcular intereses generados sobre el saldo pendiente y cargos relacionados con pagos tardíos.
2. Implementar un historial completo de pagos (amortizaciones) para cada cliente.
3. Emitir reportes detallados sobre:
   - Saldos pendientes por cliente.
   - Créditos otorgados en un periodo.
   - Créditos vencidos en un periodo.
   - Tabla de pagos y amortizaciones por crédito.

---

## **3. Entidades Principales**
1. **Banco**: Administra las sucursales que gestionan los créditos.
2. **Sucursal**: Oficina bancaria donde clientes gestionan sus productos.
3. **Clientes**: Personas que solicitan créditos.
4. **Solicitudes de Crédito**: Solicitudes realizadas por los clientes.
5. **Créditos**: Créditos otorgados a los clientes.
6. **Transacciones**: Registro de pagos, amortizaciones e intereses.
7. **Historial de Estados** (Opcional): Registro de cambios de estado de solicitudes y créditos.
8. **Configuración Financiera** (Opcional): Tasas de interés y penalizaciones.

---

## **4. Esquema de Base de Datos**
El sistema se organiza en el esquema `credito`, con las siguientes tablas:

1. **Banco**: Representa los bancos que administran las sucursales.
2. **Sucursal**: Representa las sucursales del banco.
3. **Clientes**: Información de los clientes.
4. **Solicitud_Credito**: Registra las solicitudes de los clientes.
5. **Creditos**: Detalla los créditos otorgados.
6. **Transacciones**: Registro de pagos, amortizaciones e intereses.
7. **Historial_Estados** (Opcional): Cambios en los estados de solicitudes y créditos.
8. **Configuracion_Financiera** (Opcional): Configuraciones globales.

---

## **5. Consultas Esenciales**

### **1. Cálculo de Intereses y Amortizaciones**
```sql
SELECT 
    c.id_credito,
    c.monto_original,
    c.saldo_pendiente,
    c.tasa_interes_anual,
    (c.saldo_pendiente * (c.tasa_interes_anual / 100) / 12) AS interes_mensual
FROM credito.Creditos c;
```

### **2. Historial de Pagos**
```sql
SELECT 
    t.id_transaccion,
    t.id_credito,
    t.fecha_transaccion,
    t.monto_transaccion,
    t.interes_pagado,
    t.amortizacion_pagada,
    (c.saldo_pendiente - t.amortizacion_pagada) AS saldo_restante
FROM credito.Transacciones t
JOIN credito.Creditos c ON t.id_credito = c.id_credito
ORDER BY t.fecha_transaccion ASC;
```

### **3. Reportes**
**a. Tabla de Pagos por Crédito**:
```sql
SELECT 
    c.id_credito,
    t.fecha_transaccion,
    t.amortizacion_pagada,
    (c.monto_original - SUM(t.amortizacion_pagada) OVER (PARTITION BY c.id_credito ORDER BY t.fecha_transaccion)) AS saldo_restante
FROM credito.Transacciones t
JOIN credito.Creditos c ON t.id_credito = c.id_credito
WHERE t.tipo_transaccion = 'Pago'
ORDER BY c.id_credito, t.fecha_transaccion;
```

**b. Créditos Otorgados en un Periodo**:
```sql
SELECT 
    c.id_cliente,
    c.id_credito,
    c.monto_original,
    c.fecha_inicio,
    c.fecha_vencimiento
FROM credito.Creditos c
WHERE c.fecha_inicio BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY c.fecha_inicio ASC;
```

**c. Créditos Vencidos**:
```sql
SELECT 
    c.id_cliente,
    c.id_credito,
    c.saldo_pendiente,
    c.fecha_vencimiento
FROM credito.Creditos c
WHERE c.fecha_vencimiento < CURRENT_DATE
ORDER BY c.fecha_vencimiento ASC;
```

---

## **6. Archivo SQL**
El archivo completo para crear el esquema y las tablas se encuentra en el siguiente archivo:

````sql name=credito_esquema.sql
-- Crear el esquema "credito"
CREATE SCHEMA credito;

-- Tabla Banco
CREATE TABLE credito.Banco (
    id_banco SERIAL PRIMARY KEY,
    nombre_banco VARCHAR(100) NOT NULL
);

-- Tabla Sucursal
CREATE TABLE credito.Sucursal (
    id_sucursal SERIAL PRIMARY KEY,
    nombre_sucursal VARCHAR(100) NOT NULL,
    direccion_sucursal VARCHAR(255) NOT NULL,
    id_banco INT NOT NULL,
    FOREIGN KEY (id_banco) REFERENCES credito.Banco(id_banco)
);

-- Tabla Clientes
CREATE TABLE credito.Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_creacion DATE NOT NULL DEFAULT CURRENT_DATE,
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES credito.Sucursal(id_sucursal)
);

-- Tabla Solicitud de Crédito
CREATE TABLE credito.Solicitud_Credito (
    id_solicitud SERIAL PRIMARY KEY,
    folio_solicitud VARCHAR(50) NOT NULL UNIQUE,
    estado_solicitud VARCHAR(20) NOT NULL,
    fecha_solicitud DATE NOT NULL DEFAULT CURRENT_DATE,
    id_cliente INT NOT NULL,
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES credito.Clientes(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES credito.Sucursal(id_sucursal)
);

-- Tabla Créditos
CREATE TABLE credito.Creditos (
    id_credito SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    monto_original DECIMAL(15, 2) NOT NULL,
    saldo_pendiente DECIMAL(15, 2) NOT NULL,
    tasa_interes_anual DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado_credito VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES credito.Clientes(id_cliente)
);

-- Tabla Transacciones
CREATE TABLE credito.Transacciones (
    id_transaccion SERIAL PRIMARY KEY,
    id_credito INT NOT NULL,
    tipo_transaccion VARCHAR(20) NOT NULL,
    monto_transaccion DECIMAL(15, 2) NOT NULL,
    interes_pagado DECIMAL(15, 2),
    amortizacion_pagada DECIMAL(15, 2),
    fecha_transaccion DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_credito) REFERENCES credito.Creditos(id_credito)
);

-- Tabla Historial de Estados (Opcional)
CREATE TABLE credito.Historial_Estados (
    id_historial SERIAL PRIMARY KEY,
    id_solicitud INT,
    id_credito INT,
    estado VARCHAR(50) NOT NULL,
    fecha_cambio DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_solicitud) REFERENCES credito.Solicitud_Credito(id_solicitud),
    FOREIGN KEY (id_credito) REFERENCES credito.Creditos(id_credito)
);

-- Tabla Configuración Financiera (Opcional)
CREATE TABLE credito.Configuracion_Financiera (
    id_configuracion SERIAL PRIMARY KEY,
    tasa_interes_anual DECIMAL(5, 2) NOT NULL,
    penalizacion_mora DECIMAL(15, 2) NOT NULL,
    fecha_vigencia DATE NOT NULL DEFAULT CURRENT_DATE
);
