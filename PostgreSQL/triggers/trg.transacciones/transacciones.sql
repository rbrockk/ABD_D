-- Trigger para generar T_referencia en Transacciones
CREATE OR REPLACE FUNCTION consumo.generar_t_referencia_trigger()
RETURNS TRIGGER AS $$
DECLARE
    max_referencia INTEGER;
    fecha_actual CHAR(8);
BEGIN
    -- Usar T_fecha si se proporciona, de lo contrario usar CURRENT_DATE
    IF NEW.T_fecha IS NULL THEN
        NEW.T_fecha := CURRENT_DATE;
    END IF;

    -- Obtener la fecha en formato YYYYMMDD
    fecha_actual := TO_CHAR(NEW.T_fecha, 'YYYYMMDD');

    -- Obtener el número máximo de referencia del día actual
    SELECT MAX(CAST(SUBSTRING(T_referencia::TEXT FROM 9) AS INTEGER))
    INTO max_referencia
    FROM consumo.Transacciones
    WHERE T_referencia::TEXT LIKE fecha_actual || '%';

    -- Si no hay referencias para el día actual, iniciar en 1
    IF max_referencia IS NULL THEN
        max_referencia := 1;
    ELSE
        max_referencia := max_referencia + 1;
    END IF;

    -- Generar la referencia combinando la fecha y el número incremental
    NEW.T_referencia := fecha_actual || LPAD(max_referencia::TEXT, 2, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS generar_t_referencia ON consumo.Transacciones;
CREATE TRIGGER generar_t_referencia
BEFORE INSERT ON consumo.Transacciones
FOR EACH ROW
EXECUTE FUNCTION consumo.generar_t_referencia_trigger();