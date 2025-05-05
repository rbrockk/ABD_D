-- Insertar cliente 1: Ammisadai Miranda Domínguez
INSERT INTO consumo.Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
('AMMD751212PFF', '5512345678', 1, 'ammisadai.miranda@email.com', 'Ammisadai', 'Miranda', 
'Domínguez', 'Veracruz', 'Avenida 1', 'Centro', 'Veracruz', '91700', 12.5);

-- Insertar cliente 2: Iván Ernesto Bazán Méndez
INSERT INTO consumo.Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
    C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
    ('IEBM870912HDF', '5538765432', 2, 'ivan.bazan@email.com', 'Iván Ernesto', 'Bazán', 
    'Méndez', 'Ciudad de México', 'Paseo de la Reforma', 'Juárez', 'CDMX', '06000', 15.0);

-- Insertar cliente 3: Roberto Adonai Flores Rodríguez
INSERT INTO consumo.Clientes (C_rfc, C_telefono, S_num, C_email, C_nombre, C_ap_pat, C_ap_mat, 
    C_ciudad, C_calle, C_colonia, C_estado, C_codigo_postal, C_tasa_interes_anual) 
VALUES 
('RAFR930723HDF', '5598765432', 3, 'roberto.flores@email.com', 'Roberto Adonai', 'Flores', 
    'Rodríguez', 'Guadalajara', 'Avenida Guadalajara', 'Centro', 'Jalisco', '44100', 10.0);

SELECT * FROM consumo.Clientes;