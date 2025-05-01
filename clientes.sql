-- Insertar cliente 1: Ammisadai Miranda Domínguez
INSERT INTO Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
('AMMD751212PFF', '5512345678', 1, 'ammisadai.miranda@email.com', 'Ammisadai', 'Miranda', 
'Domínguez', 'Veracruz', 'Avenida 1', 'Centro', 'Veracruz', '91700', 12.5);

-- Insertar cliente 2: Iván Ernesto Bazán Méndez
INSERT INTO Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
    C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
    ('IEBM870912HDF', '5538765432', 2, 'ivan.bazan@email.com', 'Iván Ernesto', 'Bazán', 
    'Méndez', 'Ciudad de México', 'Paseo de la Reforma', 'Juárez', 'CDMX', '06000', 15.0);

-- Insertar cliente 3: Roberto Adonai Flores Rodríguez
INSERT INTO Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
    C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
('RAFR930723HDF', '5598765432', 3, 'roberto.flores@email.com', 'Roberto Adonai', 'Flores', 
    'Rodríguez', 'Guadalajara', 'Avenida Guadalajara', 'Centro', 'Jalisco', '44100', 10.0);
    
-- Insertar solicitud de crédito para Ammisadai Miranda Domínguez
INSERT INTO Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol ) 
VALUES ('AMMD751212PFF', 55000.00, '2025-04-29');

-- Insertar solicitud de crédito para Iván Ernesto Bazán Méndez
INSERT INTO Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol) 
VALUES ('IEBM870912HDF', 5000.00, '2025-05-01');

-- Insertar solicitud de crédito para Roberto Adonai Flores Rodríguez
INSERT INTO Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol) 
VALUES ('RAFR930723HDF', 10000, '2025-04-29');

SELECT * FROM Clientes;
SELECT * FROM Creditos;
SELECT * FROM Solicitud_Credito;
SELECT * FROM Historial_Estados;

SELECT S_C_folio FROM Solicitud_Credito;

UPDATE Solicitud_Credito 
SET S_C_estado_sol = 'Aprobada',
    S_C_fecha_aprob = CURDATE()
WHERE S_C_folio = 202504291;

UPDATE Solicitud_Credito 
SET S_C_estado_sol = 'Aprobada',
    S_C_fecha_aprob = CURDATE()
WHERE S_C_folio = 202505011;

UPDATE Solicitud_Credito 
SET S_C_estado_sol = 'Aprobada', 
    S_C_fecha_aprob = CURDATE()
WHERE S_C_folio = 202504292;