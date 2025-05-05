-- Crear el esquema 'consumo'
CREATE SCHEMA consumo;

-- Tabla Zonas
CREATE TABLE consumo.Zonas (
    Z_num SERIAL PRIMARY KEY,
    Z_estado CHAR(50) NOT NULL,
    Z_codigo CHAR(5) NOT NULL
);

-- Tabla Sucursal
CREATE TABLE consumo.Sucursal (
    S_num SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    S_nombre CHAR(100) NOT NULL,
    Z_num INT NOT NULL,
    S_ciudad CHAR(100) NOT NULL,
    S_calle CHAR(100) NOT NULL,
    S_colonia CHAR(100) NOT NULL,
    S_estado CHAR(50) NOT NULL,
    S_codigo_postal CHAR(5) NOT NULL,
    FOREIGN KEY (Z_num) REFERENCES consumo.Zonas(Z_num)
);

-- Tabla Clientes
CREATE TABLE consumo.Clientes (
    C_rfc CHAR(13) PRIMARY KEY,
    C_telefono CHAR(10) NOT NULL,
    S_num SMALLINT NOT NULL,
    C_email VARCHAR(100) NOT NULL,
    C_nombre CHAR(100) NOT NULL,
    C_ap_pat CHAR(50) NOT NULL,
    C_ap_mat CHAR(50) NOT NULL,
    C_ciudad CHAR(100) NOT NULL,
    C_calle CHAR(100) NOT NULL,
    C_colonia CHAR(100) NOT NULL,
    C_estado CHAR(50) NOT NULL,
    C_codigo_postal CHAR(5) NOT NULL,
    C_tasa_interes_anual NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (S_num) REFERENCES consumo.Sucursal(S_num)
);

-- Tabla Solicitud_Credito
CREATE TABLE consumo.Solicitud_Credito (
    S_C_folio BIGINT PRIMARY KEY,
    C_rfc CHAR(13) NOT NULL,
    S_C_estado_sol VARCHAR(10) CHECK (S_C_estado_sol IN ('Aprobada', 'Rechazada', 'Pendiente')) NOT NULL,    S_C_fecha_sol DATE NOT NULL,
    S_C_fecha_aprob DATE,
    S_C_monto_solicitado NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (C_rfc) REFERENCES consumo.Clientes(C_rfc)
);

-- Tabla Creditos
CREATE TABLE consumo.Creditos (
    C_num BIGINT PRIMARY KEY,
    C_rfc CHAR(13) NOT NULL,
    S_num SMALLINT NOT NULL,
    C_monto NUMERIC(10,2) DEFAULT 0.00,
    C_fecha_inicio DATE NOT NULL,
    C_fecha_venc DATE NOT NULL,
    C_estado VARCHAR(15) CHECK (C_estado IN ('Activo', 'Pagado', 'En revisión')) NOT NULL,
    C_saldo_pend NUMERIC(10,2) DEFAULT 0.00,
    C_tasa_interes_anual NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    C_saldo_disp NUMERIC(10,2) DEFAULT 0.00,
    FOREIGN KEY (C_rfc) REFERENCES consumo.Clientes(C_rfc),
    FOREIGN KEY (S_num) REFERENCES consumo.Sucursal(S_num)
);

-- Tabla Amortizaciones
CREATE TABLE consumo.Amortizaciones (
    A_referencia INT PRIMARY KEY,
    C_num INT NOT NULL,
    A_fecha_venc DATE,
    A_monto NUMERIC(10,2),
    A_estado VARCHAR(10) CHECK (A_estado IN ('Pagada', 'Pendiente')),
    FOREIGN KEY (C_num) REFERENCES consumo.Creditos(C_num)
);

-- Tabla Historial_Estados
CREATE TABLE consumo.Historial_Estados (
    H_E_id SERIAL PRIMARY KEY,
    H_E_rfc_cliente CHAR(13) NOT NULL,
    S_C_folio BIGINT NOT NULL,
    H_E_estado VARCHAR(10) CHECK (H_E_estado IN ('Aprobada', 'Rechazada', 'Pendiente')) NOT NULL,
    H_E_fecha_cambio DATE NOT NULL,
    FOREIGN KEY (H_E_rfc_cliente) REFERENCES consumo.Clientes(C_rfc),
    FOREIGN KEY (S_C_folio) REFERENCES consumo.Solicitud_Credito(S_C_folio)
);

-- Tabla Transacciones
CREATE TABLE consumo.Transacciones (
    T_referencia INT PRIMARY KEY,
    C_num INT NOT NULL,
    T_amort_pagada NUMERIC(10,2) NOT NULL,
    T_interes_pagado NUMERIC(10,2) NOT NULL,
    T_monto NUMERIC(10,2) NOT NULL,
    T_tipo VARCHAR(10) CHECK (T_tipo IN ('Compra', 'Pago')) NOT NULL,
    T_fecha DATE DEFAULT CURRENT_DATE NOT NULL,
    FOREIGN KEY (C_num) REFERENCES consumo.Creditos(C_num)
);