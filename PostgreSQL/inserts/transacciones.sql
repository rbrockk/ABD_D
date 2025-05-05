-- Insertar transacción 1
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505051, 500.00, 50.00, 550.00, 'Compra');

-- Insertar transacción 2
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505051, 2000.00, 100.00, 1100.00, 'Pago');

-- Insertar transacción 3 (día siguiente)
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202505051, 1500.00, 150.00, 1650.00, 'Pago');

SELECT * FROM consumo.Transacciones;
SELECT * FROM consumo.Creditos;