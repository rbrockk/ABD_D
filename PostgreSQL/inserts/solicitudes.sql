-- Insertar solicitud de crédito para Ammisadai Miranda Domínguez
INSERT INTO consumo.Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol) 
VALUES ('AMMD751212PFF', 55000.00, '2025-04-29');

-- Insertar solicitud de crédito para Iván Ernesto Bazán Méndez
INSERT INTO consumo.Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol) 
VALUES ('IEBM870912HDF', 5000.00, '2025-05-01');

-- Insertar solicitud de crédito para Roberto Adonai Flores Rodríguez
INSERT INTO consumo.Solicitud_Credito (C_rfc, S_C_monto_solicitado, S_C_fecha_sol) 
VALUES ('RAFR930723HDF', 10000, '2025-04-29');

UPDATE consumo.Solicitud_Credito
SET S_C_estado_sol = 'Rechazada'
WHERE S_C_folio = 202504290001;

UPDATE consumo.Solicitud_Credito 
SET S_C_estado_sol = 'Aprobada',
    S_C_fecha_aprob = CURRENT_DATE
WHERE S_C_folio = 202504290001;

SELECT * FROM consumo.Creditos;
SELECT * FROM consumo.Solicitud_Credito;
SELECT * FROM consumo.Historial_Estados;
SELECT * FROM consumo.Amortizaciones;
SELECT * FROM consumo.Transacciones;