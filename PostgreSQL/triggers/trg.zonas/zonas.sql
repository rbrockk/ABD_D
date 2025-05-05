-- Crear función para obtener el próximo número de zona
CREATE OR REPLACE FUNCTION consumo.obtener_siguiente_numero_zona()
RETURNS INTEGER AS $$
DECLARE
    siguiente_num INTEGER;
BEGIN
    -- Obtener el siguiente número de zona de forma secuencial
    SELECT MAX(Z_num) + 1 INTO siguiente_num
    FROM consumo.Zonas;

    -- Si no hay zonas registradas, iniciar desde 1
    IF siguiente_num IS NULL THEN
        siguiente_num := 1;
    END IF;

    RETURN siguiente_num;
END;
$$ LANGUAGE plpgsql;

-- Trigger para insertar una nueva Zona
CREATE OR REPLACE FUNCTION consumo.insertar_zona_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Asignar automáticamente el número de zona
    NEW.Z_num := consumo.obtener_siguiente_numero_zona();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_zona
BEFORE INSERT ON consumo.Zonas
FOR EACH ROW
EXECUTE FUNCTION consumo.insertar_zona_trigger();