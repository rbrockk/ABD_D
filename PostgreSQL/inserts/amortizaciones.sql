-- Insertar amortización 1
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505051, '2025-04-29', 1000.00, 'Pendiente');

-- Insertar amortización 2
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505051, '2025-04-29', 1500.00, 'Pendiente');

-- Insertar amortización 3 (día siguiente)
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505051, '2025-04-30', 2000.00, 'Pendiente');

SELECT * FROM consumo.Creditos;