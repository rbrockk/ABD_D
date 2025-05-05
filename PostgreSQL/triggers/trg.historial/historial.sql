-- Trigger para registrar los cambios de estado
CREATE OR REPLACE FUNCTION consumo.registrar_historial_estado_al_insertar()
RETURNS TRIGGER AS $$
BEGIN
    -- Insertar un nuevo registro en Historial_Estados al insertar una nueva solicitud
    INSERT INTO consumo.Historial_Estados (H_E_rfc_cliente, S_C_folio, H_E_estado, H_E_fecha_cambio)
    VALUES (NEW.C_rfc, NEW.S_C_folio, 'Pendiente', CURRENT_DATE);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger asociado a la tabla Solicitud_Credito
DROP TRIGGER IF EXISTS registrar_historial_estado_insert ON consumo.Solicitud_Credito;

CREATE TRIGGER registrar_historial_estado_insert
AFTER INSERT ON consumo.Solicitud_Credito
FOR EACH ROW
EXECUTE FUNCTION consumo.registrar_historial_estado_al_insertar();