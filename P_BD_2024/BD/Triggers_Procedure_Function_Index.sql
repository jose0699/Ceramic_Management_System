/*
Este archivo tiene la función de contener toda la información relacionada con las funciones, procedimientos, 
triggers e índices del sistema.
	El orden a seguir es:
		1-Procedure
		2-Function
		3-Trigger
		4-Index
*/

--------------------------------------------------------------------------------------------------------
--                                           INDEX                                                    --
--------------------------------------------------------------------------------------------------------
--Proceso Empleado
CREATE INDEX EMP_SUPERVISOR ON EMPLEADO (supervisor);
CREATE INDEX EMP_DEP ON EMPLEADO(trabaja);
CREATE INDEX DEP_PADRE ON DEPARTAMENTO(uid_dep_padre);

--Proceso Venta
CREATE INDEX CLI_PAIS ON CLIENTE(uid_pais);
CREATE INDEX FAC_PEDIDO ON FACTURA (uid_cliente);
CREATE INDEX DET_PED_PIE_JUEGO ON DETALLE_PEDIDO_PIEZA(uid_juego);
CREATE INDEX DET_PED_PIE_PIEZA ON DETALLE_PEDIDO_PIEZA(uid_pieza, uid_coleccion, uid_molde);



