-- Función y Trigger para Zonas y Sucursales

-- 1. Función para obtener el próximo número de zona

-- Esta función se usará para asignar un número único a la nueva zona cuando se inserte un estado:

DELIMITER $$

CREATE FUNCTION obtener_siguiente_numero_zona() 
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE siguiente_num INT;
    
    -- Obtener el siguiente número de zona de forma secuencial
    SELECT MAX(Z_num) + 1 INTO siguiente_num
    FROM Zonas;
    
    -- Si no hay zonas registradas, iniciar desde 1
    IF siguiente_num IS NULL THEN
        SET siguiente_num = 1;
    END IF;

    RETURN siguiente_num;
END$$

DELIMITER;

-- 2. Trigger para insertar una nueva Zona

-- Este trigger se activará al insertar una nueva zona. La zona será definida por el estado 
-- (por ejemplo, "Veracruz"), y se asignará automáticamente un número de zona usando la función obtener_siguiente_numero_zona():

DELIMITER $$

CREATE TRIGGER insertar_zona 
BEFORE INSERT ON Zonas
FOR EACH ROW
BEGIN
    -- Asignar automáticamente el número de zona
    SET NEW.Z_num = obtener_siguiente_numero_zona();
END$$

DELIMITER ;

-- 3. Función para asignar nombre de sucursal

-- Ahora, necesitamos una función para crear el nombre de la sucursal. En este caso, 
-- el nombre será una combinación de la ciudad y la calle donde se registra la sucursal:

DELIMITER $$

CREATE TRIGGER insertar_sucursal
BEFORE INSERT ON Sucursal
FOR EACH ROW
BEGIN
    -- Asignar nombre de sucursal basado en ciudad y calle
    SET NEW.S_nombre = CONCAT(NEW.S_ciudad, ' - ', NEW.S_colonia);
END$$

DELIMITER ;

-- 4. Trigger para insertar una nueva Sucursal

-- Este trigger se activará al insertar una nueva sucursal. Se le asignará el nombre de 
-- la sucursal automáticamente basado en la ciudad y la calle donde se registre, y se asociará a la zona correspondiente.

DELIMITER $$

CREATE TRIGGER insertar_sucursal 
BEFORE INSERT ON Sucursal
FOR EACH ROW
BEGIN
    -- Asignar nombre de sucursal basado en ciudad y calle
    SET NEW.S_nombre = obtener_nombre_sucursal(NEW.S_ciudad, NEW.S_calle);
END$$

DELIMITER ;


-- 5. Trigger para insertar solicitudes de crédito con el estado 'Pendiente':

DELIMITER $$

CREATE TRIGGER set_estado_solicitud 
BEFORE INSERT ON Solicitud_Credito
FOR EACH ROW
BEGIN
    -- Asignar automáticamente el estado 'Pendiente' solo si no se proporciona un valor
    IF NEW.S_C_estado_sol IS NULL THEN
        SET NEW.S_C_estado_sol = 'Pendiente';
    END IF;
    
    -- Asignar automáticamente la fecha de solicitud solo si no se proporciona un valor
    IF NEW.S_C_fecha_sol IS NULL THEN
        SET NEW.S_C_fecha_sol = CURDATE() - INTERVAL 1 MONTH;
    END IF;
END$$

DELIMITER ;

-- 6. Trigger para registrar los cambios de estado

DELIMITER $$

CREATE TRIGGER registrar_historial_estado
AFTER UPDATE ON Solicitud_Credito
FOR EACH ROW
BEGIN
    -- Verificar si el estado de la solicitud ha cambiado
    IF OLD.S_C_estado_sol != NEW.S_C_estado_sol THEN
        -- Insertar un nuevo registro en Historial_Estados con el RFC del cliente como H_E_rfc_cliente
        INSERT INTO Historial_Estados (H_E_rfc_cliente, S_C_folio, H_E_estado, H_E_fecha_cambio) 
        VALUES (NEW.C_rfc, NEW.S_C_folio, NEW.S_C_estado_sol, CURDATE());
    END IF;
END$$

DELIMITER ;

-- Trigger para generar T_referencia en Transacciones
DELIMITER $$

CREATE TRIGGER generar_t_referencia
BEFORE INSERT ON Transacciones
FOR EACH ROW
BEGIN
    DECLARE max_referencia INT;
    DECLARE fecha_actual CHAR(8);

    -- Obtener la fecha actual en formato YYYYMMDD
    SET fecha_actual = DATE_FORMAT(CURDATE(), '%Y%m%d');

    -- Obtener el número máximo de referencia del día actual
    SELECT MAX(CAST(SUBSTRING(T_referencia, 9) AS UNSIGNED))
    INTO max_referencia
    FROM Transacciones
    WHERE T_referencia LIKE CONCAT(fecha_actual, '%');

    -- Si no hay referencias para el día actual, iniciar en 1
    IF max_referencia IS NULL THEN
        SET max_referencia = 1;
    ELSE
        SET max_referencia = max_referencia + 1;
    END IF;

    -- Generar la referencia combinando la fecha y el número incremental
    SET NEW.T_referencia = CONCAT(fecha_actual, LPAD(max_referencia, 3, '0'));

    -- Establecer la fecha predeterminada si no se proporciona
    IF NEW.T_fecha IS NULL THEN
        SET NEW.T_fecha = CURDATE();
    END IF;
END$$

DELIMITER ;

-- Trigger para generar A_referencia en Amortizaciones
DELIMITER $$

CREATE TRIGGER generar_a_referencia
BEFORE INSERT ON Amortizaciones
FOR EACH ROW
BEGIN
    DECLARE max_referencia INT;
    DECLARE fecha_actual CHAR(8);

    -- Obtener la fecha actual en formato YYYYMMDD
    SET fecha_actual = DATE_FORMAT(NEW.A_fecha_venc, '%Y%m%d');

    -- Obtener el número máximo de referencia del día actual
    SELECT MAX(CAST(SUBSTRING(A_referencia, 9) AS UNSIGNED))
    INTO max_referencia
    FROM Amortizaciones
    WHERE A_referencia LIKE CONCAT(fecha_actual, '%');

    -- Si no hay referencias para el día actual, iniciar en 1
    IF max_referencia IS NULL THEN
        SET max_referencia = 1;
    ELSE
        SET max_referencia = max_referencia + 1;
    END IF;

    -- Generar la referencia combinando la fecha y el número incremental
    SET NEW.A_referencia = CONCAT(fecha_actual, LPAD(max_referencia, 2, '0'));
END$$

DELIMITER ;

-- Trigger para generar el folio de la solicitud de crédito (S_C_folio) basado en la fecha de solicitud y un número incremental por día
DELIMITER $$

CREATE TRIGGER generar_folio_solicitud
BEFORE INSERT ON Solicitud_Credito
FOR EACH ROW
BEGIN
    DECLARE fecha_solicitud INT;
    DECLARE max_folio INT;

    -- Obtener la fecha de solicitud en formato YYYYMMDD como entero
    SET fecha_solicitud = DATE_FORMAT(NEW.S_C_fecha_sol, '%Y%m%d');

    -- Obtener el número máximo de folio del día actual
    SELECT MAX(CAST(SUBSTRING(S_C_folio, 9) AS UNSIGNED))
    INTO max_folio
    FROM Solicitud_Credito
    WHERE S_C_folio LIKE CONCAT(fecha_solicitud, '%');

    -- Si no hay folios para el día actual, iniciar en 1
    IF max_folio IS NULL THEN
        SET max_folio = 1;
    ELSE
        SET max_folio = max_folio + 1;
    END IF;

    -- Generar el folio combinando la fecha y el número incremental
    SET NEW.S_C_folio = CONCAT(fecha_solicitud, LPAD(max_folio, 1, '0'));
END$$

DELIMITER ;

-- Trigger para actualizar la tabla Creditos cuando el estado de una solicitud de crédito cambie a 'Aprobada'
DELIMITER $$

CREATE TRIGGER actualizar_credito_aprobado
AFTER UPDATE ON Solicitud_Credito
FOR EACH ROW
BEGIN
    -- Verificar si el estado cambió a 'Aprobada'
    IF NEW.S_C_estado_sol = 'Aprobada' AND OLD.S_C_estado_sol != 'Aprobada' THEN
        -- Actualizar el crédito aprobado en la tabla Creditos
        UPDATE Creditos
        SET C_monto = NEW.S_C_monto_solicitado,
            C_fecha_inicio = CURDATE(),
            C_fecha_venc = CURDATE() + INTERVAL 1 YEAR,
            C_estado = 'Activo',
            C_saldo_pend = NEW.S_C_monto_solicitado
        WHERE C_num = NEW.S_C_folio;
    END IF;
END$$

DELIMITER ;

-- Trigger para actualizar la tabla Creditos cuando se haga una solicitud aparezca en la tabla creditos como en revision

DELIMITER $$

CREATE TRIGGER after_solicitud_insert
AFTER INSERT ON Solicitud_Credito
FOR EACH ROW
BEGIN
    -- Declarar variables
    DECLARE fecha_actual VARCHAR(8);
    DECLARE contador INT;

    -- Obtener la fecha actual en formato YYYYMMDD
    SET fecha_actual = DATE_FORMAT(CURDATE(), '%Y%m%d');

    -- Contar cuántos registros ya existen con la misma fecha
    SELECT COUNT(*) + 1 INTO contador
    FROM Creditos
    WHERE LEFT(C_num, 8) = fecha_actual;

    -- Generar el C_num como fecha + contador
    INSERT INTO Creditos (C_num, C_rfc, S_num, C_monto, C_fecha_inicio, C_fecha_venc, C_estado, C_saldo_pend, C_tasa_interes_anual)
    VALUES (
        CONCAT(fecha_actual, LPAD(contador, 1, '0')), -- Formato: YYYYMMDD + número autoincremental de 4 dígitos
        NEW.C_rfc, -- RFC del cliente de la solicitud
        (SELECT S_num FROM Clientes WHERE C_rfc = NEW.C_rfc), -- Sucursal asociada al cliente
        0.00, -- Monto inicial del crédito
        CURDATE(), -- Fecha de inicio del crédito (fecha actual)
        DATE_ADD(CURDATE(), INTERVAL 1 YEAR), -- Fecha de vencimiento (1 año después)
        'En revisión', -- Estado inicial del crédito
        0.00, -- Saldo pendiente inicial
        (SELECT C_tasa_interes_anual FROM Clientes WHERE C_rfc = NEW.C_rfc) -- Tasa de interés anual del cliente
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER actualizar_creditos
AFTER UPDATE ON Solicitud_Credito
FOR EACH ROW
BEGIN
    -- Verificar que el estado de la solicitud sea 'Aprobada'
    IF NEW.S_C_estado_sol = 'Aprobada' THEN
        -- Actualizar la tabla Creditos solo si el estado es 'En revisión'
        UPDATE Creditos
        SET C_monto = NEW.S_C_monto_solicitado,
            C_saldo_disp = NEW.S_C_monto_solicitado,
            C_estado = 'Activo'
        WHERE C_rfc = NEW.C_rfc
          AND C_estado = 'En revisión';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER actualizar_saldo_credito_compra
AFTER INSERT ON Transacciones
FOR EACH ROW
BEGIN
    -- Verificar si la transacción es de tipo 'Compra'
    IF NEW.T_tipo = 'Compra' THEN
        -- Actualizar el saldo disponible en la tabla Creditos
        UPDATE Creditos
        SET C_saldo_disp = C_saldo_disp - NEW.T_monto,
            C_saldo_pend = C_saldo_pend - NEW.T_monto
        WHERE C_num = NEW.C_num;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER actualizar_saldo_credito_pago
AFTER INSERT ON Transacciones
FOR EACH ROW
BEGIN
    -- Declarar variables al inicio del bloque
    DECLARE monto_restante DECIMAL(10,2);
    DECLARE amortizacion_monto DECIMAL(10,2);
    DECLARE amortizacion_id INT;
    DECLARE fin INT DEFAULT 0;

    -- Verificar si la transacción es de tipo 'Pago'
    IF NEW.T_tipo = 'Pago' THEN
        -- Inicializar el monto restante con el monto de la amortización pagada
        SET monto_restante = NEW.T_amort_pagada;

        -- Aplicar el pago a las amortizaciones pendientes
        WHILE monto_restante > 0 AND fin = 0 DO
            -- Seleccionar la amortización más antigua pendiente
            SELECT A_referencia, A_monto
            INTO amortizacion_id, amortizacion_monto
            FROM Amortizaciones
            WHERE C_num = NEW.C_num AND A_estado = 'Pendiente'
            ORDER BY A_fecha_venc ASC
            LIMIT 1;

            -- Si no hay más amortizaciones pendientes, salir del bucle
            IF amortizacion_id IS NULL THEN
                SET fin = 1;
            ELSE
                -- Calcular el monto a aplicar a la amortización
                IF monto_restante >= amortizacion_monto THEN
                    -- El pago cubre completamente esta amortización
                    SET monto_restante = monto_restante - amortizacion_monto;

                    -- Marcar la amortización como pagada
                    UPDATE Amortizaciones
                    SET A_monto = 0, A_estado = 'Pagada'
                    WHERE A_referencia = amortizacion_id;
                ELSE
                    -- El pago cubre parcialmente esta amortización
                    UPDATE Amortizaciones
                    SET A_monto = A_monto - monto_restante
                    WHERE A_referencia = amortizacion_id;

                    SET monto_restante = 0;
                END IF;
            END IF;
        END WHILE;

        -- Actualizar el saldo pendiente en la tabla Creditos
        UPDATE Creditos
        SET C_saldo_pend = C_saldo_pend + NEW.T_amort_pagada
        WHERE C_num = NEW.C_num;
    END IF;
END$$

DELIMITER ;

