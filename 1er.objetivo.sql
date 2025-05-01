-- 1.  Cálculo de Intereses Generados sobre el Saldo Pendiente
SELECT
    C_num, -- Número de crédito
    C_saldo_pend, -- Saldo pendiente
    C_tasa_interes_anual, -- Tasa de interés anual
    (C_saldo_pend * (C_tasa_interes_anual / 100) / 365) AS Interes_Diario,  -- Interés diario (simplificado)
    (C_saldo_pend * (C_tasa_interes_anual / 100) / 12) AS Interes_Mensual -- Interés mensual (simplificado)
FROM
    Creditos
WHERE
    C_estado = 'Activo'; -- Solo para créditos activos

-- 2.  Cargos por Pagos Tardíos

SELECT
    A.C_num, -- Número de crédito
    A.A_fecha_venc, -- Fecha de vencimiento de la amortización
    A.A_monto, -- Monto de la amortización
    CASE
        WHEN CURDATE() > A.A_fecha_venc AND A.A_estado = 'Pendiente' THEN A.A_monto * 0.05  -- 5% de cargo por retraso (ejemplo)
        ELSE 0
    END AS Cargo_por_Retraso
FROM
    Amortizaciones A
WHERE
    CURDATE() > A.A_fecha_venc AND A.A_estado = 'Pendiente';
