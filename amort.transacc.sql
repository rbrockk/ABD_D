-- Insertar amortización 1
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202503291, '2025-04-29', 1000.00, 'Pendiente');

-- Insertar amortización 2
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202503291, '2025-04-29', 1500.00, 'Pendiente');

-- Insertar amortización 3 (día siguiente)
INSERT INTO Amortizaciones (C_num, A_fecha_venc, A_monto, A_estado) 
VALUES (202503291, '2025-04-30', 2000.00, 'Pendiente');

-- Insertar transacción 1
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202503291, 500.00, 50.00, 550.00, 'Pago');

-- Insertar transacción 2
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202503291, 1000.00, 100.00, 1100.00, 'Pago');

-- Insertar transacción 3 (día siguiente)
INSERT INTO Transacciones (C_num, T_amort_pagada, T_interes_pagado, T_monto, T_tipo) 
VALUES (202503291, 1500.00, 150.00, 1650.00, 'Pago');