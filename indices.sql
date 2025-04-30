-- Índice en la columna 'C_saldo_pend' para optimizar el cálculo de intereses.
CREATE INDEX idx_creditos_saldo_pend ON Creditos(C_saldo_pend);

-- Índice en la columna 'C_fecha_venc' para optimizar la detección de pagos tardíos.
CREATE INDEX idx_creditos_fecha_venc ON Creditos(C_fecha_venc);

-- Índice en la columna 'C_estado' para filtrar créditos activos.
CREATE INDEX idx_creditos_estado ON Creditos(C_estado);

-- Consulta para calcular intereses generados y detectar pagos tardíos.
SELECT 
    C_num AS Numero_Credito,
    C_rfc AS RFC_Cliente,
    C_saldo_pend AS Saldo_Pendiente,
    (C_saldo_pend * C_tasa_interes_anual / 100) AS Interes_Generado,
    CASE 
        WHEN CURDATE() > C_fecha_venc THEN 'Pago Tardío'
        ELSE 'En Tiempo'
    END AS Estado_Pago
FROM Creditos
WHERE C_estado = 'Activo' AND C_saldo_pend > 0;