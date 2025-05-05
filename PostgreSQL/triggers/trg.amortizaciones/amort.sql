-- Trigger para generar A_referencia en Amortizaciones
CREATE OR REPLACE FUNCTION consumo.generar_a_referencia_trigger()
RETURNS TRIGGER AS $$
DECLARE
    max_referencia INTEGER;
    fecha_actual CHAR(8);
BEGIN
    -- Obtener la fecha actual en formato YYYYMMDD
    fecha_actual := TO_CHAR(NEW.A_fecha_venc, 'YYYYMMDD');

    -- Obtener el número máximo de referencia del día actual
    SELECT MAX(CAST(SUBSTRING(A_referencia::TEXT FROM 9) AS INTEGER))
    INTO max_referencia
    FROM consumo.Amortizaciones
    WHERE A_referencia::TEXT LIKE fecha_actual || '%';

    -- Si no hay referencias para el día actual, iniciar en 1
    IF max_referencia IS NULL THEN
        max_referencia := 1;
    ELSE
        max_referencia := max_referencia + 1;
    END IF;

    -- Generar la referencia combinando la fecha y el número incremental
    NEW.A_referencia := fecha_actual || LPAD(max_referencia::TEXT, 2, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS generar_a_referencia ON consumo.Amortizaciones;
CREATE TRIGGER generar_a_referencia
BEFORE INSERT ON consumo.Amortizaciones
FOR EACH ROW
EXECUTE FUNCTION consumo.generar_a_referencia_trigger();