-- Tabla Zonas
CREATE TABLE Zonas (
    Z_num INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Z_estado CHAR(50) NOT NULL,
    Z_codigo CHAR(5) NOT NULL
);

-- Tabla Sucursal
CREATE TABLE Sucursal (
    S_num SMALLINT PRIMARY KEY AUTO_INCREMENT,
    S_nombre CHAR(100) NOT NULL,
    Z_num INT NOT NULL,
    S_ciudad CHAR(100) NOT NULL,
    S_calle CHAR(100 ) NOT NULL,
    S_colonia CHAR(100 ) NOT NULL,
    S_estado CHAR(50) NOT NULL,
    S_codigo_postal CHAR(5) NOT NULL,
    FOREIGN KEY (Z_num) REFERENCES Zonas(Z_num)
);

-- Tabla Clientes
CREATE TABLE Clientes (
    C_rfc CHAR(13) PRIMARY KEY NOT NULL,
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
    C_tasa_interes_anual DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (S_num) REFERENCES Sucursal(S_num)
);

-- Tabla Solicitud_Credito
CREATE TABLE Solicitud_Credito (
    S_C_folio INT PRIMARY KEY NOT NULL,
    C_rfc CHAR(13) NOT NULL,
    S_C_estado_sol ENUM('Aprobada', 'Rechazada', 'Pendiente') NOT NULL,
    S_C_fecha_sol DATE NOT NULL,
    S_C_fecha_aprob DATE,
    S_C_monto_solicitado DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (C_rfc) REFERENCES Clientes(C_rfc)
);

-- Tabla Creditos
CREATE TABLE Creditos (
    C_num INT PRIMARY KEY,
    C_rfc CHAR(13) NOT NULL,
    S_num SMALLINT NOT NULL,
    C_monto DECIMAL(10,2) DEFAULT 0.00,
    C_fecha_inicio DATE NOT NULL,
    C_fecha_venc DATE NOT NULL,
    C_estado ENUM('Activo', 'Pagado', 'En revisión') NOT NULL,
    C_saldo_pend DECIMAL(10,2) DEFAULT 0.00,
    C_tasa_interes_anual DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    C_saldo_disp DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (C_rfc) REFERENCES Clientes(C_rfc),
    FOREIGN KEY (S_num) REFERENCES Sucursal(S_num)
);



-- Tabla Amortizaciones
CREATE TABLE Amortizaciones (
    A_referencia INT PRIMARY KEY,
    C_num INT NOT NULL,
    A_fecha_venc DATE,
    A_monto DECIMAL(10,2),
    A_estado ENUM('Pagada', 'Pendiente'),
    FOREIGN KEY (C_num) REFERENCES Creditos(C_num)
);

-- Tabla Historial_Estados
CREATE TABLE Historial_Estados (
    H_E_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    H_E_rfc_cliente CHAR(13) NOT NULL,
    S_C_folio INT NOT NULL,
    H_E_estado ENUM('Aprobada', 'Rechazada', 'Pendiente') NOT NULL,
    H_E_fecha_cambio DATE NOT NULL,
    FOREIGN KEY (H_E_rfc_cliente) REFERENCES Clientes(C_rfc),
    FOREIGN KEY (S_C_folio) REFERENCES Solicitud_Credito(S_C_folio)
);ALTER TABLE Creditos 
ADD COLUMN C_saldo_disp DECIMAL(10,2) DEFAULT 0.00 AFTER C_saldo_pend;

-- Tabla Transacciones
CREATE TABLE Transacciones (
    T_referencia INT PRIMARY KEY NOT NULL,
    C_num INT NOT NULL,
    T_amort_pagada DECIMAL(10,2) NOT NULL,
    T_interes_pagado DECIMAL(10,2) NOT NULL,
    T_monto DECIMAL(10,2) NOT NULL,
    T_tipo ENUM('Compra', 'Pago')NOT NULL,
    T_fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (C_num) REFERENCES Creditos(C_num)
);