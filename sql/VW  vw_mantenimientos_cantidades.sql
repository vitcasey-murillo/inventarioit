create VIEW vw_mantenimientos_cantidades
as
select 
    m.*, 
    (select count(1) from mantenimiento_activo ma where ma."idMantenimiento" = m.id )"cantidad"
from mantenimiento m