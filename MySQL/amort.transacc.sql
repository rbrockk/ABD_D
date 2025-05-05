-- Insertar amortización 1
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505011, '2025-04-29', 1000.00, 'Pendiente');

-- Insertar amortización 2
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505011, '2025-04-29', 1500.00, 'Pendiente');

-- Insertar amortización 3 (día siguiente)
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202505011, '2025-04-30', 2000.00, 'Pendiente');

SELECT * FROM Amortizaciones;

-- Insertar transacción 1
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505011, 500.00, 50.00, 550.00, 'Compra');

-- Insertar transacción 2
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505011, 1000.00, 100.00, 1100.00, 'Pago');

-- Insertar transacción 3 (día siguiente)
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505011, 1500.00, 150.00, 1650.00, 'Pago');

SELECT * FROM Transacciones;
SELECT * FROM Creditos;

INSERT INTO Transacciones (
    C_num, 
    T_amort_pagada, 
    T_interes_pagado, 
    T_monto, 
    T_tipo
) VALUES (
    202505011,           -- Número del crédito asociado
    500.00,          -- Monto de la amortización pagada
    50.00,           -- Interés pagado
    550.00,          -- Monto total del pago (amortización + interés)
    'Pago'           -- Tipo de transacción
);