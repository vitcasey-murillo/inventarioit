CREATE VIEW desglose_mantenimiento
AS
SELECT 
    a.*,
    ma."idMantenimiento",
    (select m."tipo" from mantenimiento m  where m.id = ma."idMantenimiento")"tipoMantenimiento"
FROM 
    Activo a
LEFT JOIN
    mantenimiento_activo ma
ON 
    a."id" = ma."idActivo"
WHERE 
    ma."idMantenimiento" not in (select m."id" from mantenimiento m  where m."tipo" = 'Descarte') or ma."idActivo" is null