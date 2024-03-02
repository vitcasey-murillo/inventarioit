CREATE OR REPLACE FUNCTION insertar_mantenimiento_y_activos(
    tipo_param varchar,
    descripcion_param VARCHAR,
    fecha_param DATE,
    ids_activos_param INT[])
RETURNS void AS $$
DECLARE
    id_mantenimiento INT;
    i INT;
BEGIN
    -- Inserta en Mantenimiento y obtiene el ID
    INSERT INTO Mantenimiento(tipo, descripcion, fecha)
    VALUES (tipo_param, descripcion_param, fecha_param);
    
    SELECT max(id) INTO id_mantenimiento FROM mantenimiento;

    -- Recorre el array de IDs de activos e inserta en Mantenimiento_Activo
    FOREACH i IN ARRAY ids_activos_param LOOP
        INSERT INTO Mantenimiento_Activo
        VALUES (id_mantenimiento, i);

        if(tipo_param = 'Descarte')
        then
            UPDATE Activo
            set
                estado = 'Descarte' -- Los activos cambian de estado
            where id = i;
        end if;
    END LOOP;

    -- Si todo va bien, la transacción se confirma automáticamente
EXCEPTION
    WHEN OTHERS THEN
        -- Si hay algún error, se revierte la transacción
        RAISE;
END;
$$ LANGUAGE plpgsql;