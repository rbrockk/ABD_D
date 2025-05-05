--Trigger para que el credito solicitado aparezca como 'En revisión' en la tabla Creditos
CREATE OR REPLACE FUNCTION consumo.actualizar_credito_al_insertar_solicitud()
RETURNS TRIGGER AS $$
BEGIN
    -- Depuración: Verificar si el trigger se ejecuta
    RAISE NOTICE 'Trigger ejecutado para C_rfc=%, S_C_folio=%', NEW.C_rfc, NEW.S_C_folio;

    -- Realizar un UPDATE en la tabla Creditos si ya existe el registro
    UPDATE consumo.Creditos
    SET C_monto = NEW.S_C_monto_solicitado,
        C_fecha_inicio = CURRENT_DATE,
        C_fecha_venc = CURRENT_DATE + INTERVAL '1 year',
        C_estado = 'En revisión',
        C_saldo_pend = NEW.S_C_monto_solicitado,
        C_tasa_interes_anual = (SELECT C_tasa_interes_anual FROM consumo.Clientes WHERE C_rfc = NEW.C_rfc)
    WHERE C_rfc = NEW.C_rfc AND C_num = NEW.S_C_folio;

    -- Depuración: Confirmar si el registro fue actualizado
    IF FOUND THEN
        RAISE NOTICE 'Registro actualizado en Creditos para C_rfc=%, S_C_folio=%', NEW.C_rfc, NEW.S_C_folio;
    ELSE
        RAISE NOTICE 'No se encontró registro en Creditos para actualizar con C_rfc=%, S_C_folio=%', NEW.C_rfc, NEW.S_C_folio;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_solicitud_insert ON consumo.Solicitud_Credito;

CREATE TRIGGER after_solicitud_insert
AFTER INSERT ON consumo.Solicitud_Credito
FOR EACH ROW
EXECUTE FUNCTION consumo.actualizar_credito_al_insertar_solicitud();

CREATE OR REPLACE FUNCTION consumo.actualizar_creditos_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que el estado de la solicitud sea 'Aprobada'
    IF NEW.S_C_estado_sol = 'Aprobada' THEN
        -- Actualizar la tabla Creditos solo si el estado es 'En revisión'
        UPDATE consumo.Creditos
        SET C_monto = NEW.S_C_monto_solicitado,
            C_saldo_disp = NEW.S_C_monto_solicitado,
            C_estado = 'Activo',
            C_saldo_pend = 0.00
        WHERE C_rfc = NEW.C_rfc
          AND C_estado = 'En revisión';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS actualizar_creditos ON consumo.Solicitud_Credito;
CREATE TRIGGER actualizar_creditos
AFTER UPDATE ON consumo.Solicitud_Credito
FOR EACH ROW
EXECUTE FUNCTION consumo.actualizar_creditos_trigger();

-- 
CREATE OR REPLACE FUNCTION consumo.actualizar_saldo_credito_compra_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la transacción es de tipo 'Compra'
    IF NEW.T_tipo = 'Compra' THEN
        -- Actualizar el saldo disponible en la tabla Creditos
        UPDATE consumo.Creditos
        SET C_saldo_disp = C_saldo_disp - NEW.T_monto,
            C_saldo_pend = C_saldo_pend - NEW.T_monto
        WHERE C_num = NEW.C_num;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS actualizar_saldo_credito_compra ON consumo.Transacciones;
CREATE TRIGGER actualizar_saldo_credito_compra
AFTER INSERT ON consumo.Transacciones
FOR EACH ROW
EXECUTE FUNCTION consumo.actualizar_saldo_credito_compra_trigger();


--
CREATE OR REPLACE FUNCTION consumo.actualizar_saldo_credito_pago_trigger()
RETURNS TRIGGER AS $$
DECLARE
    monto_restante NUMERIC(10, 2);
    amortizacion_monto NUMERIC(10, 2);
    amortizacion_id INT;
    fin INT DEFAULT 0;
BEGIN
    -- Verificar si la transacción es de tipo 'Pago'
    IF NEW.T_tipo = 'Pago' THEN
        -- Inicializar el monto restante con el monto de la amortización pagada
        monto_restante := NEW.T_amort_pagada;

        -- Aplicar el pago a las amortizaciones pendientes
        WHILE monto_restante > 0 AND fin = 0 LOOP
            -- Seleccionar la amortización más antigua pendiente
            SELECT A_referencia, A_monto
            INTO amortizacion_id, amortizacion_monto
            FROM consumo.Amortizaciones
            WHERE C_num = NEW.C_num AND A_estado = 'Pendiente'
            ORDER BY A_fecha_venc ASC
            LIMIT 1;

            -- Si no hay más amortizaciones pendientes, salir del bucle
            IF amortizacion_id IS NULL THEN
                fin := 1;
            ELSE
                -- Calcular el monto a aplicar a la amortización
                IF monto_restante >= amortizacion_monto THEN
                    -- El pago cubre completamente esta amortización
                    monto_restante := monto_restante - amortizacion_monto;

                    -- Marcar la amortización como pagada
                    UPDATE consumo.Amortizaciones
                    SET A_monto = 0, A_estado = 'Pagada'
                    WHERE A_referencia = amortizacion_id;
                ELSE
                    -- El pago cubre parcialmente esta amortización
                    UPDATE consumo.Amortizaciones
                    SET A_monto = A_monto - monto_restante
                    WHERE A_referencia = amortizacion_id;

                    monto_restante := 0;
                END IF;
            END IF;
        END LOOP;

        -- Actualizar el saldo pendiente en la tabla Creditos
        UPDATE consumo.Creditos
        SET C_saldo_pend = C_saldo_pend + NEW.T_amort_pagada
        WHERE C_num = NEW.C_num;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_saldo_credito_pago
AFTER INSERT ON consumo.Transacciones
FOR EACH ROW
EXECUTE FUNCTION consumo.actualizar_saldo_credito_pago_trigger();