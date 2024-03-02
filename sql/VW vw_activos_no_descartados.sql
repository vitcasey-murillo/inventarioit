CREATE VIEW VW_activos_no_descartados
AS
SELECT 
    * 
FROM 
    Activo a
LEFT JOIN
    mantenimiento_activo ma
ON 
    a."id" = ma."idActivo"
WHERE 
    ma."idMantenimiento" not in (select m."id" from mantenimiento m  where m."tipo" = 'Descarte') or ma."idActivo" is null