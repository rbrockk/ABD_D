# Sistema de Gestión de Créditos y Transacciones Bancarias

Este proyecto es un sistema de base de datos diseñado para gestionar de manera eficiente y segura la información relacionada con clientes, productos de crédito, pagos, plazos y estados financieros. Está optimizado para el seguimiento de créditos de consumo, garantizando la integridad, accesibilidad y confidencialidad de los datos.

---

## **Objetivo General**
Desarrollar un sistema de base de datos eficiente y seguro que gestione la información relacionada con los clientes, los productos de crédito, los pagos, los plazos y los estados financieros, con el fin de optimizar el seguimiento de los créditos de consumo, garantizando la integridad, la accesibilidad y la confidencialidad de los datos.

---

## **Alcances del Proyecto**

1. **Cálculo de Intereses y Pagos**:
   - Consultas que calculan los intereses generados sobre el saldo pendiente.
   - Consultas que calculan los cargos por pagos tardíos.

2. **Historial de Pagos**:
   - Consultas avanzadas para visualizar el historial completo de pagos de un cliente.
   - Detalle de montos pagados, fechas y saldos después de cada pago.

3. **Tabla de Amortización**:
   - Generación de una tabla de pagos (amortizaciones) por cada crédito otorgado, que incluye fechas de vencimiento, montos a pagar y estado del pago (pendiente o completado).

4. **Reporte de Saldos Pendientes**:
   - Generación de un reporte que muestra los saldos pendientes por acreditado a una fecha específica, ordenados de mayor a menor monto.

5. **Reporte de Créditos Otorgados**:
   - Generación de un reporte que muestra los créditos otorgados en un período específico, ordenados del más antiguo al más reciente.

6. **Reporte de Créditos Pagados**:
   - Generación de un reporte que muestra los créditos pagados en un período específico, ordenados cronológicamente.

---

## **Características del Sistema**

### **1. Estructura de Tablas**
El sistema incluye las siguientes tablas principales:
- **`zonas`**: Gestión de zonas geográficas para agrupar sucursales.
- **`sucursal`**: Información de sucursales bancarias.
- **`clientes`**: Detalles de los clientes registrados.
- **`solicitud_credito`**: Registro de solicitudes de crédito de los clientes.
- **`creditos`**: Información detallada de los créditos otorgados.
- **`transacciones`**: Registro de pagos y movimientos financieros.
- **`historial_estados`**: Seguimiento de cambios en el estado de las solicitudes de crédito.
- **`bitacora`**: Auditoría de cambios realizados en las tablas.

### **2. Funcionalidades Avanzadas**
- **Triggers**:
  - Automatización de cálculos y validaciones al insertar o actualizar datos.
  - Registro automático en bitácoras y cambios de estado.
- **Particiones**:
  - La tabla `transacciones` está particionada por año para optimizar consultas y almacenamiento.
- **Segmentación**:
  - La tabla `sucursal` está segmentada por región geográfica (`VER`, `MTY`, `CDMX`).
- **Índices**:
  - Índices optimizados para mejorar el rendimiento de consultas frecuentes.
- **Funciones SQL**:
  - Cálculo dinámico de saldos pendientes.
  - Generación de reportes personalizados.

---

## **Consultas Clave del Sistema**

### 1. **Cálculo de Intereses Generados**
```sql
SELECT 
    C.C_numero AS Credito,
    C.C_saldo_pend AS Saldo_Pendiente,
    C.C_tasa_interes_anual AS Tasa_Interes,
    ROUND(C.C_saldo_pend * (C.C_tasa_interes_anual / 100), 2) AS Interes_Generado
FROM 
    creditos C
WHERE 
    C.C_estado = 'Activo';
```

### 2. **Historial de Pagos de un Cliente**
```sql
SELECT 
    T.T_fecha AS Fecha_Pago,
    T.T_monto AS Monto_Pagado,
    T.amort_pagada AS Amortizacion,
    T.interes_pagado AS Interes,
    C.C_saldo_pend AS Saldo_Despues
FROM 
    transacciones T
JOIN 
    creditos C ON T.C_numero = C.C_numero
WHERE 
    C.C_rfc = 'RFC_DEL_CLIENTE'
ORDER BY 
    T.T_fecha DESC;
```

### 3. **Tabla de Amortización**
```sql
SELECT 
    C.C_numero AS Credito,
    DATE_ADD(C.C_fecha_inicio, INTERVAL (T.num_pago - 1) MONTH) AS Fecha_Vencimiento,
    ROUND(C.C_monto / C.C_plazos, 2) AS Monto_Pago,
    CASE 
        WHEN T.T_pago_realizado IS NOT NULL THEN 'Pagado'
        ELSE 'Pendiente'
    END AS Estado
FROM 
    creditos C
LEFT JOIN 
    (SELECT DISTINCT C_numero, 1 AS num_pago, NULL AS T_pago_realizado
     UNION ALL SELECT DISTINCT C_numero, 2 AS num_pago, NULL AS T_pago_realizado
     UNION ALL SELECT DISTINCT C_numero, 3 AS num_pago, NULL AS T_pago_realizado) T
    ON C.C_numero = T.C_numero;
```

### 4. **Reporte de Saldos Pendientes**
```sql
SELECT 
    C.C_rfc AS RFC,
    C.C_numero AS Credito,
    C.C_saldo_pend AS Saldo_Pendiente
FROM 
    creditos C
WHERE 
    C.C_estado = 'Activo'
ORDER BY 
    C.C_saldo_pend DESC;
```

### 5. **Reporte de Créditos Otorgados**
```sql
SELECT 
    C.C_rfc AS RFC,
    C.C_numero AS Credito,
    C.C_fecha_inicio AS Fecha_Otorgado
FROM 
    creditos C
WHERE 
    C.C_fecha_inicio BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY 
    C.C_fecha_inicio ASC;
```

### 6. **Reporte de Créditos Pagados**
```sql
SELECT 
    C.C_rfc AS RFC,
    C.C_numero AS Credito,
    C.C_fecha_inicio AS Fecha_Otorgado,
    C.C_fecha_venc AS Fecha_Pagado
FROM 
    creditos C
WHERE 
    C.C_estado = 'Pagado'
  AND C.C_fecha_venc BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY 
    C.C_fecha_venc ASC;
```

---

## **Requisitos Técnicos**

- **Base de Datos**: MySQL 8.0 o superior.
- **Espacio de Almacenamiento**: Configuración para tablespaces con múltiples particiones.
- **Permisos de Usuario**: Crear y gestionar triggers, funciones y tablas particionadas.

---

## **Contribuciones**
Si deseas mejorar este proyecto, abre un **issue** o envía un **pull request** con tus sugerencias o cambios.

---

## **Licencia**
Este proyecto está bajo la licencia [MIT](./LICENSE).
