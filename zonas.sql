-- Insertar una nueva zona para Veracruz
INSERT INTO Zonas (Z_estado, Z_codigo) VALUES ('Veracruz', '01000');

-- Insertar otra zona para Ciudad de México
INSERT INTO Zonas (Z_estado, Z_codigo) VALUES ('CDMX', '02000');

-- Insertar otra zona para Jalisco
INSERT INTO Zonas (Z_estado, Z_codigo) VALUES ('Jalisco', '03000');

-- Insertar sucursal en Veracruz, en la calle "Avenida 1"
INSERT INTO Sucursal (S_num, S_ciudad, S_calle, S_colonia, S_estado, S_codigo_postal, Z_num) 
VALUES (1, 'Veracruz', 'Avenida 1', 'Centro', 'Veracruz', '91700', 1);

-- Insertar otra sucursal en Veracruz, en la calle "Avenida 2"
INSERT INTO Sucursal (S_num, S_ciudad, S_calle, S_colonia, S_estado, S_codigo_postal, Z_num) 
VALUES (2, 'Veracruz', 'Avenida 2', 'Centro', 'Veracruz', '91701', 1);

-- Insertar sucursal en CDMX, en la calle "Paseo de la Reforma"
INSERT INTO Sucursal (S_num, S_ciudad, S_calle, S_colonia, S_estado, S_codigo_postal, Z_num) 
VALUES (3, 'Ciudad de México', 'Paseo de la Reforma', 'Juárez', 'CDMX', '06000', 2);

-- Insertar sucursal en Jalisco, en la calle "Avenida Guadalajara"
INSERT INTO Sucursal (S_ciudad, S_calle, S_colonia, S_estado, S_codigo_postal, Z_num) 
VALUES ('Guadalajara', 'Avenida Guadalajara', 'Centro', 'Jalisco','44100',3);

SELECT * FROM Zonas;
SELECT * FROM Sucursal;
