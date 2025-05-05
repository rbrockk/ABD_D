-- Trigger para insertar una nueva Sucursal
CREATE OR REPLACE FUNCTION consumo.generar_folio_solicitud()
RETURNS TRIGGER AS $$
DECLARE
    fecha_solicitud CHAR(8);
    max_folio INT;
BEGIN
    -- Obtener la fecha de solicitud en formato YYYYMMDD
    fecha_solicitud := TO_CHAR(NEW.S_C_fecha_sol, 'YYYYMMDD');

    -- Obtener el número máximo de folio del día actual
    SELECT COALESCE(MAX(CAST(SUBSTRING(CAST(S_C_folio AS TEXT) FROM 9) AS INTEGER)), 0) + 1
    INTO max_folio
    FROM consumo.Solicitud_Credito
    WHERE CAST(S_C_folio AS TEXT) LIKE fecha_solicitud || '%';

    -- Generar el folio combinando la fecha y el número incremental
    NEW.S_C_folio := fecha_solicitud || LPAD(max_folio::TEXT, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Reasociar el trigger a la tabla
DROP TRIGGER IF EXISTS generar_folio_solicitud ON consumo.Solicitud_Credito;

CREATE TRIGGER generar_folio_solicitud
BEFORE INSERT ON consumo.Solicitud_Credito
FOR EACH ROW
EXECUTE FUNCTION consumo.generar_folio_solicitud();