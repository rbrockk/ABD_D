- Trigger para insertar solicitudes de crédito con el estado 'Pendiente'
CREATE OR REPLACE FUNCTION consumo.set_estado_solicitud_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Asignar automáticamente el estado 'Pendiente' solo si no se proporciona un valor
    IF NEW.S_C_estado_sol IS NULL THEN
        NEW.S_C_estado_sol := 'Pendiente';
    END IF;

    -- Asignar automáticamente la fecha de solicitud solo si no se proporciona un valor
    IF NEW.S_C_fecha_sol IS NULL THEN
        NEW.S_C_fecha_sol := CURRENT_DATE - INTERVAL '1 month';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_estado_solicitud
BEFORE INSERT ON consumo.Solicitud_Credito
FOR EACH ROW
EXECUTE FUNCTION consumo.set_estado_solicitud_trigger();