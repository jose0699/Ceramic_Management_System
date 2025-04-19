/*
Este archivo va a contener todo lo respecto a las inserciones.
	Orden del documento:
		1-Tablas fuertes
		2-Intermedia
		3-Intercepción
Nota: Se ordenara segun el proceso en especifico que participa la tabla.
*/

 
--Pais					 
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Venezuela');	COMMIT;
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Republica Dominicana');	COMMIT;
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Chile');	COMMIT;
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Estados Unidos');	COMMIT;
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Colombia');	COMMIT;
BEGIN;	insert into pais values( nextval('pais_uid_seq'),'Brasil');	COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Empleado                                            --
--------------------------------------------------------------------------------------------------------
/* estados de salud  */					 /*listo*/
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Diabetes', 'P');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad cardíaca', 'P');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Cáncer', 'P');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad pulmonar', 'P');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia al polen', 'A');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los ácaros del polvo',  'A');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los medicamentos',  'A');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los alimentos', 'A');	COMMIT;
BEGIN;	insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a las mascotas', 'A');	COMMIT;

--Departamento					 /*listo*/
BEGIN;	insert into departamento values (nextval('departamento_uid_seq'),'Gerencia General',1,'GE','Gerencia general de la empresa');  	COMMIT;--1
BEGIN;	insert into departamento values (nextval('departamento_uid_seq'),'Gerencia de Planta',2,'GE','Gerencia de la fabrica',1);  	COMMIT;--2
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Secretaria',2,'GE','Departamento de secretaria',2); 	COMMIT;--3
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Gerencia Tecnica',3,'GE','Gerencia Tecnica de la planta',2);	COMMIT;--4
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Insumos',3,'AL','Almacen de materiales de la empresa',2);	COMMIT;--5
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Control de Calidad',4,'SE','Departamento para el control de la calidad de los productos',4);	COMMIT;--6
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Mantenimiento',4,'SE','Departamento para el mantenimiento de las maquinas de la fabrica',4);	COMMIT;--7
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Producto Terminado',3,'AL','Almacen de todas las piezas terminadas',2);	COMMIT;--8
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Seleccion','4','DE','Departamento que empaca los productos',4);	COMMIT;--9
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Esmaltacion y Decoracion','4','DE','Departamento que decora las piezas seleccionadas',4);	COMMIT;--10
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Colado y Refinado','4','DE','Departamento que cuela la mezcla y refina las piezas',4);	COMMIT;--11
BEGIN;	insert into departamento values (nextval('departamento_uid_seq'),'Yeseria','4','DE','Departamento que provee de los moldes para las piezas',4);	COMMIT;--12
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Rotomoldeo','4','DE','Departamento que provee la pieza',4);	COMMIT;--13
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Preparacion Pasta','4','DE','Departamento que elabora los churros para las piezas',4);	COMMIT;--14
BEGIN;	insert into departamento values(nextval('departamento_uid_seq'),'Hornos','4','DE','Departamento de Hornos',4);	COMMIT;--15

/* Gerentes */					 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),21474659,'1975-07-21','B-','F','Calle principal de la candelaria','qui','ge',3500,04149116300,1,'María','González',null,'Pérez');	COMMIT;-- General  1
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 18934567, '1970-10-24', 'A-', 'F', 'Calle El Triunfo, Res. Las Palmeras', 'mec','ge', 3500, 04167891234, 2, 'Ana', 'Romero',null, 'Vargas',null);	COMMIT;-- Planta  2
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 20876543, '1964-04-25', 'B+', 'M', 'Avenida Bolívar, Urb. La Colina', 'pro','ge', 3500, 04243215678, 4, 'Daniel', 'Guerrero',null, 'Mendoza',null);	COMMIT;-- Tecnica   3

/* Supervisores */  		 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27748963,'1987-10-03','A+','M','Avenida Este cero','ind','og',1500,04149116305,5,'Carlos','Torres',null,'Ramírez');	COMMIT;--4  
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27474666,'1989-01-03','O-','M','Avenida Morat','ind','og',1500,04149116307,8,'Luis','Blanco',null,'Fernández');	COMMIT;--5 	
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27474665,'1988-02-03','B-','F','Calle Felicidad','ind','og',1500,04149116306,9,'Carolina','Sánchez',null,'Martínez');	COMMIT;--6   
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27474667, '1984-06-03', 'O-', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04149116307, 10, 'María', 'González',null, 'López');	COMMIT;--7
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27441986, '1983-05-20', 'O-', 'M', 'Avenida Trusk', 'ind', 'og', 1500, 04149116107, 11, 'Luis', 'Blanco',null, 'Rotos');	COMMIT;--8 	
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27365666, '1982-08-03', 'A-', 'M', 'Avenida Del Moratorio', 'mec', 'og', 1500, 04149112407, 12, 'Carlos', 'Blanco',null, 'Fernández');	COMMIT;--9 	
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27364666, '1981-07-03', 'AB-', 'F', 'Avenida Morat', 'ind', 'og', 1500, 04149119007, 13, 'María', 'González',null, 'López');	COMMIT;--10  		
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27363666, '1980-11-03', 'O-', 'M', 'Calle Real, 123', 'ind', 'og', 1500, 04149124569,14, 'Yuritza', 'Castillo',null, 'Rodriguez');	COMMIT;--11	
BEGIN;	INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27362666, '1985-10-03', 'B+', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04145154269, 15, 'Luis', 'Blanco',null, 'Fernández');	COMMIT;--12 

/*  Secretaria  */ 			
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),25474658,'1991-12-03','A+','M','Avenida siempre viva','ba','se',2100,04149116299,3,'Marcello','Servitad','Jesus','Santos');	COMMIT;--13
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24485673, '1990-05-09', 'B-', 'F', 'Avenida Boulevard', 'ba','se', 2100, 04147896543, 3, 'Valentina', 'Harrison',null, 'Pérez',null );	COMMIT;--14
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26321549, '1993-07-08', 'O+', 'M', 'Calle Principal', 'ba','se', 2100, 04265473210, 3, 'Alejandro', 'Guzmán',null, 'López',null );	COMMIT;--15
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24210987, '2000-10-07', 'AB-', 'F', 'Avenida La Paz', 'ba','se', 2100, 04128765432, 3, 'Sandra', 'Mendoza',null, 'Martínez', null);	COMMIT;--16

/* Seccion de control  */--6   		 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27403661,'1997-11-03','A+','F','Calle Esperanza de la cruz','pro','in',1400,04149116302,6,'Ana','Romero',null,'Flores',null);	COMMIT;--17
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23254321, '2000-03-05', 'B-', 'M', 'Avenida Universidad', 'pro','in', 1400, 04241234567, 6, 'Pedro', 'González',null, 'López', null);	COMMIT;--18

/* Seccion de mantenimiento*/--7		 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),24360661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','el',850,04149116302,7,'Ana','Romero',null,'Flores',null);	COMMIT;--19
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 25147362, '1994-06-07', 'O+', 'M', 'Avenida Libertador', 'pro','me', 850, 04162345678, 7, 'Luis', 'Muñoz',null, 'García', null);	COMMIT;--20

/*  Almacen de insumos */--5 		
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27474661,'1994-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2000,04149116302,5,'Ana','Romero',null,'Flores',4);	COMMIT;--21
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23372615, '1987-08-09', 'AB+', 'M', 'Avenida Morán','pro','og', 2000, 04283654721, 5, 'Carlos', 'Blanco',null, 'Méndez',4);	COMMIT;--22

/*Almacen de producto terminado */--8		 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),28568661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2900,04149116302,8,'Ana','Romero',null,'Flores',5);	COMMIT;--23
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28261548, '2002-06-06', 'B-', 'F', 'Avenida Las Américas','pro','og', 2900, 04125432109, 8, 'María', 'Gómez',null, 'Pérez',5);	COMMIT;--24

/*  Operarios */ 			
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),28474660,'2002-04-03','O-','M','Avenida Libertad Solarium','ind','og',2600,04149116301,9,'Pedro','López',null,'García',6);	COMMIT;--25
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28251432, '2001-06-09', 'A+', 'F', 'Calle Principal', 'ind','og', 2600, 04267345123, 9, 'Gabriela', 'Martínez',null, 'Silva',6);	COMMIT;--26
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 22548736, '1987-07-08', 'B-', 'M', 'Avenida Bolívar', 'ind','og', 2600, 04143256789, 10, 'Luis', 'Ramírez',null, 'Blanco',7);	COMMIT;--27
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24721369, '1991-03-07', 'AB+', 'F', 'Calle Miranda', 'ind','og', 2600, 04281234567, 10, 'Andrea', 'Guerrero',null, 'Pérez', 7);	COMMIT;--28
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23832147, '2000-11-06', 'O-', 'M', 'Avenida Sucre', 'ind','og', 2600, 04165432109, 11, 'Carlos', 'Suárez',null, 'López', 8);	COMMIT;--29
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24943258, '2002-06-05', 'A+', 'F', 'Calle Vargas', 'ind','og', 2600, 04242345678, 11, 'Isabel', 'Muñoz',null, 'García',8);	COMMIT;--30
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24054369, '2003-03-24', 'B-', 'M', 'Avenida Páez', 'ind','og', 2600, 04187654321, 12, 'Daniel', 'Romero',null, 'Flores', 9);	COMMIT;--31
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24165470, '1995-01-03', 'AB+', 'F', 'Calle Cedeño', 'ind','og', 2600, 04224321098, 12, 'Jennifer', 'Gómez',null, 'Pérez', 9);	COMMIT;--32
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24276581, '2001-07-02', 'O-', 'M', 'Avenida Falcón', 'ind','og', 2600, 04145678901, 13, 'José', 'López',null, 'García',10);	COMMIT;--33
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24387692, '1990-05-01', 'A+', 'F', 'Calle Carabobo','ind','og', 2600, 04263456789, 13, 'María', 'Ramírez',null, 'Blanco',10);	COMMIT;--34

/* Horneros  */ 
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),24474670,'2003-06-03','B-', 'M','Avenida  Solarium','ba','og',2600,04149116301,15,'Paco','Gutierrez',null,'García',12);	COMMIT;--35
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24509815, '2002-05-30', 'AB+', 'F', 'Calle Boyacá','ba','og', 2600, 04247654321, 15, 'Ana', 'Suárez',null, 'López',12);	COMMIT;--36
BEGIN;	insert into empleado values(nextval('empleado_exp_seq'),27474663,'2000-06-03','B-','M','Avenida Progreso movimiento','ba','og',1900,0414911703,15,'Juan','Muñoz',null,'Vega',12);	COMMIT;--37
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26362516, '1997-04-09', 'A+', 'F', 'Calle Libertad','ba','og', 1900, 04283654721, 15, 'Gabriela', 'Pérez',null, 'García',12);	COMMIT;--38

/*  otro departamento   */ 			
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 27273645, '1999-06-08', 'B-', 'M', 'Avenida Morán','geo','og', 1900, 04162345678, 14, 'Luis', 'Gómez',null, 'López',11);	COMMIT;--39
BEGIN;	INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24184756, '1998-06-07', 'AB+', 'F', 'Calle Miranda', 'geo','og', 1900, 04241234567, 14, 'Andrea', 'Blanco',null, 'Méndez',11);	COMMIT;--40

/* reunion */ 			
BEGIN;	insert into reunion values (4,'2024-05-03','Se comentó sobre la productividad general de la fabrica');	COMMIT;
BEGIN;	insert into reunion values (4,'2024-05-10','Se comentó sobre el rendmiento de la fábrica');	COMMIT;
BEGIN;	insert into reunion values (4,'2024-05-17','Se discutió la falta de comunicación en el equipo');	COMMIT;
BEGIN;	insert into reunion values (4,'2024-05-24','Asignacion de horarios del mes');	COMMIT;
BEGIN;	insert into reunion values (5,'2024-05-03','Resumen de la semana');	COMMIT;
BEGIN;	insert into reunion values (5,'2024-05-10','Resumen de la semana');	COMMIT;
BEGIN;	insert into reunion values (7,'2024-05-03','Se chequeo el desempeño de esa semana');	COMMIT;
BEGIN;	insert into reunion values (6,'2024-05-10','Se chequeo el desempeño de esa sema	COMMIT;na');	COMMIT;
BEGIN;	insert into reunion values (8,'2024-05-24','Informacion sobre bonos');	COMMIT;
BEGIN;	insert into reunion values (8,'2024-05-10','Resumen de la semana');	COMMIT;
BEGIN;	insert into reunion values (9,'2024-05-31','Informacion sobre bonos');	COMMIT;
BEGIN;	insert into reunion values (12,'2024-05-03','Resumen de planificación de la semana');	COMMIT;
BEGIN;	insert into reunion values (12,'2024-05-31','Información sobre nuevos horarios para el mes de Junio');	COMMIT;

/*    horario */				 
BEGIN;	insert into HIST_TURNO values (35,'2024-05-01',1);	COMMIT;
BEGIN;	insert into HIST_TURNO values (36,'2024-05-01',1);	COMMIT;
BEGIN;	insert into HIST_TURNO values (37,'2024-05-01',2);	COMMIT;
BEGIN;	insert into HIST_TURNO values (38,'2024-05-01',3);	COMMIT;
BEGIN;	insert into HIST_TURNO values (12,'2024-05-01',2);	COMMIT;
BEGIN;	insert into HIST_TURNO values (36,'2024-06-01',2);	COMMIT;
BEGIN;	insert into HIST_TURNO values (37,'2024-06-01',2);	COMMIT;
BEGIN;	insert into HIST_TURNO values (38,'2024-06-01',3);	COMMIT;
BEGIN;	insert into HIST_TURNO values (35,'2024-06-01',1);	COMMIT;
BEGIN;	insert into HIST_TURNO values (12,'2024-06-01',3);	COMMIT;

/*    Detalle expediente */				
BEGIN;	insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-04','in',null);	COMMIT;
BEGIN;	insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-14','in',null);	COMMIT;
BEGIN;	insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-01','in',null);	COMMIT;
BEGIN;	insert into det_exp values(4,nextval('det_exp_uid_seq'),'2024-06-04','bm',500);	COMMIT;
BEGIN;	insert into det_exp values(27,nextval('det_exp_uid_seq'),'2023-12-31','ba',1000);	COMMIT;
BEGIN;	insert into det_exp values(28,nextval('det_exp_uid_seq'),'2024-06-01','am',null,null,null,'faltó 3 dias al trabajo en mes de mayo');	COMMIT;
BEGIN;	insert into det_exp values(40,nextval('det_exp_uid_seq'),'2024-06-08','in',null);	COMMIT;
BEGIN;	insert into det_exp values(6,nextval('det_exp_uid_seq'),'2024-05-03','bm',500);	COMMIT;
BEGIN;	insert into det_exp values(33,nextval('det_exp_uid_seq'),'2024-05-03','in',null);	COMMIT;
BEGIN;	insert into det_exp values(40,nextval('det_exp_uid_seq'),'2024-05-10','in',null);	COMMIT;
BEGIN;	insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-05-17','in',null);	COMMIT;
BEGIN;	insert into det_exp values(7,nextval('det_exp_uid_seq'),'2024-04-04','bm',500);	COMMIT;
BEGIN;	insert into det_exp values(34,nextval('det_exp_uid_seq'),'2024-02-04','in',null);	COMMIT;
BEGIN;	insert into det_exp values(34,nextval('det_exp_uid_seq'),'2024-02-14','in',null);	COMMIT;
BEGIN;	insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-05-16','in',null);	COMMIT;
BEGIN;	insert into det_exp values(36,nextval('det_exp_uid_seq'),'2024-05-31','in',null,null,null,'No asistió a la reunión semanal');	COMMIT;
BEGIN;	insert into det_exp values(37,nextval('det_exp_uid_seq'),'2024-05-31','in',null,null,null,'No asistió a la reunión semanal');	COMMIT;
BEGIN;	insert into det_exp values(37,nextval('det_exp_uid_seq'),'2024-05-03','in',null,null,null,'No asistió a la reunión semanal');	COMMIT;
BEGIN;	insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-01-04','lt',null,2);	COMMIT;
--BEGIN;	insert into det_exp values(29,nextval('det_exp_uid_seq'),'2024-02-14','lt',null,2);	COMMIT;
--BEGIN;	insert into det_exp values(30,nextval('det_exp_uid_seq'),'2024-02-14','he',null,null,2);	COMMIT;
--BEGIN;	insert into det_exp values(27,nextval('det_exp_uid_seq'),'2024-05-04','lt',null,3);	COMMIT;

/*  tablas de intereseccion  */					
BEGIN;	insert into INASISTENCIA values (4,'2024-05-03',26);	COMMIT;
BEGIN;	insert into INASISTENCIA values (4,'2024-05-24',26);	COMMIT;
BEGIN;	insert into INASISTENCIA values (5,'2024-05-03',26);	COMMIT;
BEGIN;	insert into INASISTENCIA values (5,'2024-05-10',40);	COMMIT;
BEGIN;	insert into INASISTENCIA values (7,'2024-05-03',40);	COMMIT;
BEGIN;	insert into INASISTENCIA values (6,'2024-05-10',35);	COMMIT;
BEGIN;	insert into INASISTENCIA values (8,'2024-05-24',34);	COMMIT;
BEGIN;	insert into INASISTENCIA values (8,'2024-05-10',34);	COMMIT;
BEGIN;	insert into INASISTENCIA values (9,'2024-05-31',33);	COMMIT;
BEGIN;	insert into INASISTENCIA values (12,'2024-05-31',36);	COMMIT;
BEGIN;	insert into INASISTENCIA values (12,'2024-05-31',37);	COMMIT;
BEGIN;	insert into INASISTENCIA values (12,'2024-05-03',37);	COMMIT;

/*Tabla Empleado - Estado de salud*/			
BEGIN;	insert into E_E values (1, 1,'Tiene Diabetes 1');	COMMIT;
BEGIN;	insert into E_E values (4, 2,'Tiene enfermedad de valvulas cardiacas');	COMMIT;
BEGIN;	insert into E_E values (6, 3,'Tiene cancer de garganta');	COMMIT;
BEGIN;	insert into E_E values (4, 3,'Tiene cancer de prostata');	COMMIT;
BEGIN;	insert into E_E values (22, 5,'Es alergico al polen');	COMMIT;
BEGIN;	insert into E_E values (40, 6,'Es alergico a los acaros');	COMMIT;
BEGIN;	insert into E_E values (35, 8,'Es alergico al mani');	COMMIT;
BEGIN;	insert into E_E values (37, 9,'Es a los gatos');	COMMIT;
BEGIN;	insert into E_E values (20, 8,'Es alergico al chocolate');	COMMIT;
BEGIN;	insert into E_E values (17, 3,'Tiene cancer de Mama');	COMMIT;
BEGIN;	insert into E_E values (35, 2,'Tiene enfermedad de válvulas cardiacas');	COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Catalogo                                            --
--------------------------------------------------------------------------------------------------------

--COLECCION	
BEGIN;	insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Amazonia','2024-06-04','F','cla','Adéntrate en la vibrante belleza del Amazonas con la colección Amazonia de vajillas. Inspirada en la flora y fauna de esta región única, cada pieza presenta un diseño cautivador que celebra la riqueza natural del Amazonas.');	COMMIT;
BEGIN;	insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Lineal Cereza','2024-06-04','F','cla','La Colección Lineal Cereza aporta un toque de sofisticación y modernidad a tu mesa con su diseño minimalista y elegante. Sus líneas rectas y sencillas combinan a la perfección con cualquier decoración, creando un ambiente armonioso y acogedor.');	COMMIT;
BEGIN;	insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Campina Inglesa','2024-06-04','F','cou','La Colección Campiña Inglesa te transporta a los idílicos paisajes de la campiña inglesa con su diseño floral y colorido. Sus delicadas flores y estampados campestres crean un ambiente fresco en la mesa.');	COMMIT;
BEGIN;	insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Desayuno Campestre','2024-06-04','I','cou','La Colección Desayuno Campestre te invita a disfrutar de un delicioso desayuno lleno de sabor y color. Su diseño rústico y alegre, inspirado en los picnics campestres, crea un ambiente informal y acogedor en tu cocina.');	COMMIT;
BEGIN;	insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Ondas Suaves','2024-06-04','I','mod','La Colección Ondas Suaves rinde homenaje a los movimientos suaves del mar.');	COMMIT;

--MOLDE			
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'JA','10x19cm',1.5);	COMMIT; --1
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'JA','12x17cm',1);	COMMIT; --2
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TT','10x18cm',null,6);	COMMIT; --3
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TT','12x20cm',null,2);	COMMIT; --4
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'LE','18x11cm',null,6);	COMMIT; --5
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'LE','19x12cm',null,2);	COMMIT; --6
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'AZ','9x10cm',null,6);	COMMIT; --7
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'CA','19x12cm');	COMMIT; --8
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'CA','7x6cm');	COMMIT; --9
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'CA','26x20cm');	COMMIT; --10
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'CA','47x38cm');	COMMIT; --11
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'CA','28x5cm');	COMMIT; --12
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm',null,null,'ova');	COMMIT; --13
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm',null,null,'rec');	COMMIT; --14
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm',null,null,'ova');	COMMIT; --15
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm',null,null,'rec');	COMMIT; --16
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','24cm',null,null,'red','HO');	COMMIT; --17
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','24cm',null,null,'cua','HO');	COMMIT; --18
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'red','LL');	COMMIT; --19
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'cua','LL');	COMMIT; --20
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'rec','LL');	COMMIT; --21
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TT');	COMMIT; --22
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TC');	COMMIT; --23
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TM');	COMMIT; --24
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'red','PO');	COMMIT; --25
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'cua','PO');	COMMIT; --26
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'rec','PO');	COMMIT; --27
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'red','PR');	COMMIT; --28
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'cua','PR');	COMMIT; --29
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'rec','PR');	COMMIT; --30
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'PL','28x28cm',null,null,null,'PA'); 	COMMIT;--31
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','3x7cm',null,null,null,null,'CS');	COMMIT; --32
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','4x10cm',null,null,null,null,'CC');	COMMIT; --33
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','3x8cm',null,null,null,null,'TS');	COMMIT; --34
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','4x6cm',null,null,null,null,'TC');	COMMIT; --35
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','3x8cm',null,null,null,null,'MS');	COMMIT; --36
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'TA','4x6cm',null,null,null,null,'MC');	COMMIT; --37
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'EN','38x22cm');	COMMIT; --38
BEGIN;	insert into molde values(nextval ('molde_uid_seq'),'EN','30x18cm');	COMMIT; --39

--VAJILLA
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Guacamaya',4,'Diseño con plumas de guacamaya en colores rojo, amarillo y azul, con detalles en negro que representan los ojos del ave.');	COMMIT;--cole 1
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Waima',6,'Diseño con ondas azules y verdes que evocan las aguas del río Negro, con detalles en dorado que representan las pepitas de oro que se encuentran en la región.');	COMMIT; --cole 1
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Cereza en Flor',6,'Diseño con flores de cerezo en tonos rosados y blancos, con detalles en rojo cereza que representan el fruto.');	COMMIT;-- cole 2
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Jardín Rojo',4,'Diseño con un jardín de cerezos en flor, con árboles, flores y frutos en tonos rojos, rosados y verdes.');	COMMIT;--cole 2
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Afternoon Tea',6,'Diseño con tazas de té, sándwiches, pasteles y otros elementos típicos del té de la tarde inglés.');	COMMIT;--cole 3
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Círculo de Willow',6,'Diseño con el patrón de sauce tradicional, un motivo popular en la cerámica inglesa.');	COMMIT;-- cole 3
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Desayuno Ingles',2,' Diseño con huevos fritos, tocino, salchichas, frijoles horneados, champiñones, tomates y tostadas, los elementos clásicos de un desayuno inglés completo.');	COMMIT;--cole 4
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Huevos y Tocino',4,'Diseño con huevos fritos en diferentes estilos (fritos, revueltos, escalfados) y tiras de tocino crujiente.');	COMMIT;--cole 4
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Perla del Mar',4,'Diseño con una perla grande y brillante en el centro, rodeada de ondas delicadas en tonos blancos y plateados.');	COMMIT;--cole 5
BEGIN;	insert into vajilla values(nextval ('vajilla_uid_seq'),'Conchas Marinas',2,'Diseño con diferentes tipos de conchas marinas en colores naturales, como blanco, beige y marrón.');	COMMIT;--cole 5

--PIEZA			
BEGIN;	insert into pieza values(1,nextval ('pieza_uid_seq'),'Guacamaya Regrescante:Inspirado en la belleza serena de Waima Gorge, este plato exquisito encarna la esencia de la armonía y el equilibrio.',null,25);	COMMIT;--1
BEGIN;	insert into pieza values(1,nextval ('pieza_uid_seq'),'Guacamaya Tropical: Un festín de colores para tu mesa.',null,26);	COMMIT;--2
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Guacamaya Emblemática: Un homenaje a la belleza de las aves tropicales.',null,27);	COMMIT;--5
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Guacamaya Artesanal: Un producto elaborado con pasión y cuidado.',null,28);	COMMIT;--6
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Raíces: Un homenaje a la fuerza y la estabilidad.',null,21);	COMMIT;--17
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Abrazo: Un símbolo de unión y comunidad.',null,27);	COMMIT;--18
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Armonía: Comparte momentos agradables con tus seres queridos.',null,26);	COMMIT;--22
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Equilibrio: Un toque de elegancia a tu mesa.',null,1);	COMMIT;--23
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Despertar: Comienza tu día con un toque de energía natural.',null,8);	COMMIT;--26
BEGIN;	insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Recuerdo: Un regalo ideal para revivir momentos especiales.',null,29);	COMMIT;--29
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Florecer: simple y poético que evoca la belleza de las flores de cerezo en plena floración.',null,25);	COMMIT;--31
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Primavera Viva: alegre y vibrante que transmite la energía y la frescura de la temporada primaveral.',null,20);	COMMIT;--32
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Festín Floral:invita a disfrutar de una deliciosa comida en compañía de las hermosas flores de cerezo.',null,26);	COMMIT;--33
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Lienzo Natural:delicadeza de  diseños pintados a mano y la posibilidad de usar los platos como un lienzo para la creatividad culinaria.',null,27);	COMMIT;--34
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Brindis Primaveral:invita a celebrar la llegada de la primavera con una bebida refrescante.',null,1);	COMMIT;--35
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Toque Floral: sencillo y elegante que describe el efecto decorativo que aporta la jarra a la mesa.',null,1);	COMMIT;--36
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Jardín Encantado: Delicados platos de cerámica pintados a mano con motivos de un jardín rojo en flor,',null,20);	COMMIT;--46
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Sinfonía de Colores: Disfruta de tus comidas en estos vibrantes platos adornados con flores y follaje de un jardín rojo, disponibles en una variedad de colores para combinar con tu decoración.',null,26);	COMMIT;--46
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Sabores del Verano: Sirve tus platos favoritos con estilo en estos platos de cerámica con diseños de jardines rojos, ideales para cualquier ocasión.',null,26);	COMMIT;--46
BEGIN;	insert into pieza values (2,nextval ('pieza_uid_seq'),'Un Oasis en tu Mesa: La belleza de un jardín floreciente se refleja en cada plato, con detalles pintados a mano que evocan la frescura y la vitalidad del verano.',null,8);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Lienzo de Otoño: Una bandeja con bordes ligeramente elevados, perfecta para servir aperitivos o postres, adornada con una escena otoñal del río rodeado de árboles de colores vibrantes, reflejándose en la superficie del agua.',null,14);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Picnic junto al Río: Una bandeja con bordes bajos, ideal para disfrutar de un picnic al aire libre, decorada con una escena de una familia disfrutando de un mantel extendido en la hierba junto al río, bajo la sombra de un árbol.',null,15);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Pícnic Romántico: Una bandeja  con bordes ondulados, perfecta para una escapada romántica, adornada con una escena de una pareja cenando a la luz de las velas junto al río, con el cielo estrellado como telón de fondo.',null,16);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Cúpula del Sauce: Una azucarera con forma de cúpula y tapa, ideal para endulzar el café o el té, decorada con una delicada ilustración de un sauce llorón que se inclina sobre el río, creando un efecto de cúpula natural.',null,7);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Barco Navegante: Una azucarera con forma de bote con tapa, perfecta para agregar un toque de diversión a la mesa, adornada con una escena de un pequeño bote navegando por el río, con las velas desplegadas y el viento en la popa.',null,7);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Molino de Agua: Una azucarera con forma de molino de agua con tapa, ideal para crear un ambiente rústico y acogedor, decorada con una escena detallada de un molino de agua junto al río, con sus ruedas girando y creando una sensación de movimiento.',null,7);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Delicia Elegante: Delicados platos de cerámica pintados a mano con motivos de la tradicional hora del té,',null,27); COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Sinfonía de Sabores: Disfruta de tus dulces y salados favoritos en estos vibrantes platos adornados con tazas de té, sándwiches y pasteles, disponibles en una variedad de colores para combinar con tu decoración.',null,25);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Un Momento de Paz: Sirve tus delicias con estilo en estos platos de cerámica con diseños de la hora del té, ideales para cualquier ocasión especial o simplemente para disfrutar de un momento de tranquilidad.',null,28);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Brindis por la Alegría: Eleva tus celebraciones con esta jarra de cerámica decorada con motivos de la hora del té, perfecta para servir té, café o chocolate caliente con estilo.',null,2);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Un Toque de Refinamiento a tu Mesa: Disfruta de tus bebidas favoritas en esta jarra de cerámica con un diseño encantador de la hora del té, ideal para agregar un toque de elegancia a cualquier reunión.',null,2);	COMMIT;--46
BEGIN;	insert into pieza values (3,nextval ('pieza_uid_seq'),'Mañana de Té: Comienza tu día con una sonrisa con esta taza de cerámica decorada con motivos de la hora del té, perfecta para disfrutar de tu café o té matutino.',null,31);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Amanecer Británico: Un plato ideal para la comida principal, adornado con una escena rústica de una granja inglesa al amanecer, con el humo que sale de la chimenea y el aroma del desayuno recién hecho flotando en el aire.',3.5,18);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Earl Grey: Una taza cilíndrica con asa, perfecta para disfrutar de una taza de té Earl Grey, la bebida tradicional del desayuno inglés, decorada con una ilustración de una tetera humeante y una taza elegante, rodeados de hojas de té aromáticas.',3.5,31);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Desayuno Campestre: Una bandeja con bordes ligeramente elevados, perfecta para servir un desayuno completo, adornada con un diseño alegre de huevos fritos con yemas soleadas, crujientes tiras de tocino y rebanadas de pan tostado.',3,14);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Brunch Dominguero: Una bandeja con bordes bajos, ideal para disfrutar de un brunch familiar, decorada con un diseño colorido de huevos revueltos, tocino en forma de corazón, gofres con arándanos y un vaso de jugo de naranja.',4,15);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Picnic Picante: Una bandeja  con bordes ondulados, perfecta para un picnic picante, adornada con un diseño rústico de huevos rancheros con salsa picante, tortillas calientes, frijoles refritos y aguacate fresco.',4,15);	COMMIT;--46
BEGIN;	insert into pieza values (4,nextval ('pieza_uid_seq'),'Nube Dorada: Una jarra de forma cilíndrica con asa y pico vertedor, ideal para servir café o té caliente, decorada con un diseño de huevos revueltos en forma de nube, con yemas doradas que se derraman sobre crujientes tiras de tocino.',4,2);	COMMIT;--46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Ostra Brillante: Un plato con bordes curvos que evoca la forma de una ostra abierta, perfecto para sopas o guisos, adornado con una perla iridiscente en el centro, como una joya marina.',3,17);	COMMIT;--46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Concha de Tesoro: Un plato y ancho con bordes ligeramente elevados, ideal para ensaladas o acompañamientos, decorado con una concha marina abierta que revela una perla resplandeciente, como un tesoro escondido.',3,19);	COMMIT;--46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Plato Espuma de las Olas: Un plato , perfecto para la comida principal, adornado con un diseño de olas rompiendo en la orilla, dejando tras de sí una espuma blanca nacarada que recuerda a las perlas.',3.5,28);	COMMIT;--46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Sirena Encantada: Una taza cilíndrica con asa, ideal para iniciar el día con una taza de café o té caliente, decorada con una ilustración de una sirena nadando entre perlas, con su cola iridiscente brillando bajo el agua.',1.5,34);	COMMIT;--46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Caracola Sonriente: Un plato  con bordes curvos que evocan la forma de una caracola marina, perfecto para sopas o guisos, adornado con una ilustración de una caracola con una sonrisa tallada en su espiral, como si cantara una melodía del mar.',3.5,20);	COMMIT; --46
BEGIN;	insert into pieza values (5,nextval ('pieza_uid_seq'),'Tesoro Escondido: Un plato  con bordes ligeramente elevados, ideal para ensaladas o acompañamientos, decorado con un diseño de una concha marina abierta que revela un collar de perlas y pequeñas piedras preciosas, como un tesoro escondido bajo las olas.',3.5,26);	COMMIT; --46

/*Familiar_historico_precio */	
BEGIN;	insert into familiar_historico_precio values(1,1,'2024-03-01 04:05:06' ,10);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,2,'2024-03-01 21:13:42' ,2);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,3,'2024-03-01 18:29:19' ,3);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,4,'2024-03-01 06:54:33' ,10);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,5,'2024-03-01 10:32:11' ,6);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,6,'2024-03-01 00:18:27' ,9);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,7,'2024-03-01 14:48:02' ,1);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,8,'2024-03-01 05:23:58' ,7);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,9,'2024-03-01 23:47:16' ,1);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(1,10,'2024-03-01 12:15:45' ,25);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,11,'2024-03-01 08:51:23' ,1);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,12,'2024-03-01 17:09:34' ,11);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,13,'2024-03-01 09:21:56' ,14);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,14,'2024-03-01 22:30:01' ,10);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,15,'2024-03-01 01:42:43' ,2);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,16,'2024-03-01 15:58:50' ,3);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,17,'2024-03-01 11:06:14' ,5);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,18,'2024-03-01 20:33:29' ,4);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,19,'2024-03-01 03:17:32' ,12);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(2,20,'2024-03-01 07:24:48' ,17);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,21,'2024-03-01 16:02:51' ,24);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,22,'2024-03-01 19:45:04' ,3);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,23,'2024-03-01 13:37:19' ,8);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,24,'2024-03-01 08:12:31' ,1);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,25,'2024-03-01 14:49:25' ,9);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,26,'2024-03-01 16:02:51' ,24);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,27,'2024-03-01 19:45:04' ,3);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,28,'2024-03-01 13:37:19' ,8);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,29,'2024-03-01 08:12:31' ,1);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,30,'2024-03-01 14:49:25' ,9);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,31,'2024-03-01 16:02:51' ,24);	COMMIT;
BEGIN;	insert into familiar_historico_precio values(3,32,'2024-03-01 19:45:04' ,3);	COMMIT;

/*Detalle pieza */	
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (1,1,1,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (1,1,2,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (1,1,3,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (1,1,8,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,5,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,6,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,7,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,8,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,9,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (2,1,10,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,11,4);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,12,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,13,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,14,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,15,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (3,2,20,4);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (4,2,17,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (4,2,18,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (4,2,19,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (4,2,20,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,21,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,22,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,23,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,24,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,25,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (5,3,26,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (6,3,28,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (6,3,29,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (6,3,30,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (6,3,31,1);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (6,3,32,5);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (7,4,33,10);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (7,4,34,10);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (8,4,35,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (8,4,36,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (8,4,37,3);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (8,4,38,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (9,5,39,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (9,5,40,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (9,5,41,2);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (9,5,42,6);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (10,5,43,15);	COMMIT;
BEGIN;	insert into DETALLE_PIEZA_VAJILLA values (10,5,44,15);	COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Venta                                               --
--------------------------------------------------------------------------------------------------------
/*Clientes */
BEGIN;	insert into cliente values(nextval('cliente_uid_seq') ,'Casa Pakea' ,'0212 5551212' ,'Casa_Pakea@gmail.com' , 1);	COMMIT;--1
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'),'El Leñador' ,'0414 2223333' ,'El_Leñador@gmail.com' , 1);	COMMIT;--2
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Posada Margot','0416 4243032' ,'Posada_Margot@gmail.com' ,1 );	COMMIT;--3
BEGIN;	insert into cliente values(nextval('cliente_uid_seq') , 'Holiday Inn Hotel & Suites','323 444-3333' , 'Holiday_Inn@gmail.com',4 );	COMMIT;--4
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Hard Rock Cafe NY', '212 555212','HardRockCafer@gmail.com' , 4);	COMMIT;--5
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Pearl Urban Lounge Santo Domingo','809 555-1212' ,'PearlUrban@gmail.com' , 2);	COMMIT;--6
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Cayo Levantado Resort','829 444-3333' ,'CayoLevantado @gmail.com' ,2 );	COMMIT;--7
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Máxima Marea','571 555-1212' ,'MáximaMarea@gmail.com' , 5);	COMMIT;--8
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'),'La Santa Guadalupe Medellin' , '314 444-3333', 'LaSantaGuadalupe@gmail.com', 5);	COMMIT;--9
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Dona Firmina','55 11 5555-1212' ,'DonaFirmina@gmail.com' , 6);	COMMIT;--10
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Vista Cafe', '55 21 4444-3333', 'VistaCafe@gmail.com', 6);	COMMIT;--11
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Oporto Cafe', '56 9 5555-1212', 'OportoCafe@gmail.com',3 );	COMMIT;--12
BEGIN;	insert into cliente values( nextval('cliente_uid_seq'), 'Zanzibar',' 56 2 2222-3333' , 'Zanzibar@gmail.com', 3);	COMMIT;--13

--Tabla Intermedias

/*Contratos*/
BEGIN;	insert into contrato values (1,nextval('contrato_uid_seq') ,15 ,'2022-04-10 08:51:00' );	COMMIT;--1
BEGIN;	insert into contrato values (2,nextval('contrato_uid_seq')  ,20 ,'2021-05-01 14:57:00' );	COMMIT;--2
BEGIN;	insert into contrato values (3,nextval('contrato_uid_seq') ,30 ,'2019-06-08 15:49:00'  );	COMMIT;--3
BEGIN;	insert into contrato values (4,nextval('contrato_uid_seq') ,15 , '2018-07-14 16:25:00' );	COMMIT;--4
BEGIN;	insert into contrato values ( 5,nextval('contrato_uid_seq'), 10, '2020-10-16 09:21:00' );	COMMIT;--5
BEGIN;	insert into contrato values (6,nextval('contrato_uid_seq') , 5, '2018-02-12 10:30:00');	COMMIT;--6
BEGIN;	insert into contrato values (7,nextval('contrato_uid_seq') , 10, '2019-04-24 11:12:00' );	COMMIT;--7
BEGIN;	insert into contrato values ( 8,nextval('contrato_uid_seq'), 15, '2023-03-31 17:45:00');	COMMIT;--8
BEGIN;	insert into contrato values ( 9,nextval('contrato_uid_seq'), 20, '2024-01-02 10:50:00');	COMMIT;--9

/*pedido*/
BEGIN;	insert into pedido values(1,nextval('pedido_uid_seq') ,'2024-01-18 10:50:00' ,null,'2024-03-18 10:50:00' , 'A','F' );	COMMIT;--1
BEGIN;  insert into pedido values(2,nextval('pedido_uid_seq') ,'2024-02-17 10:50:00' ,null,'2024-04-17 10:50:00'  , 'E','I' );	COMMIT;--2
BEGIN;	insert into pedido values(3,nextval('pedido_uid_seq') ,'2024-03-16 10:50:00' ,null,'2024-05-16 10:50:00'  , 'A','I' );	COMMIT;--3
BEGIN;	insert into pedido values(4,nextval('pedido_uid_seq') ,'2024-04-15 10:50:00' ,null,'2024-06-15 10:50:00'  , 'E','I' );	COMMIT;--4
BEGIN;	insert into pedido values(5,nextval('pedido_uid_seq') ,'2024-05-14 10:50:00' ,null,'2024-07-14 10:50:00'  , 'A','I' );	COMMIT;--5
BEGIN;	insert into pedido values(6,nextval('pedido_uid_seq') ,'2024-06-13 10:50:00' ,null,'2024-08-13 10:50:00' , 'E','I' );	COMMIT;--6
BEGIN;	insert into pedido values(7,nextval('pedido_uid_seq') ,'2024-07-12 10:50:00' ,null,'2024-09-12 10:50:00'  , 'E','I' );	COMMIT;--7
BEGIN;	insert into pedido values(8,nextval('pedido_uid_seq') ,'2024-08-11 10:50:00' ,null,'2024-10-11 10:50:00'  , 'A','I' );	COMMIT;--8
BEGIN;	insert into pedido values(9,nextval('pedido_uid_seq') ,'2024-09-10 10:50:00' ,null,'2024-11-10 10:50:00' , 'A','I' );	COMMIT;--9
--Tablas Intercepcion

/*Factura*/
BEGIN;	insert into factura values( 1,1,nextval('factura_uid_seq') ,'2024-01-18 10:50:00' , 943.5 );	COMMIT;--1
BEGIN;	insert into factura values( 9,9,nextval('factura_uid_seq') ,'2024-09-10 10:50:00', 186.4 );	COMMIT; --5 
BEGIN;	insert into factura values( 3,3,nextval('factura_uid_seq') ,'2024-03-16 10:50:00' , 420 );	COMMIT;--2
BEGIN;	insert into factura values( 5,5,nextval('factura_uid_seq') ,'2024-05-14 10:50:00' , 324 );	COMMIT; --3
BEGIN;	insert into factura values( 8,8,nextval('factura_uid_seq') ,'2024-08-11 10:50:00', 1107.25 );	COMMIT; --4

/*Detalle pedido Pieza*/	
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 1,1 ,1);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 2,1 ,null,1,1);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 3,1 ,null,1,2);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 4,1 ,null,1,3);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 5,1 ,null,1,4);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 3, 3, 7,24 , null, 1, 10);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 5, 5, 8,30 ,null , 2,19);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 9,15 ,2 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 10,15 ,null,1,5);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 11,15 ,null,1,6);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 12,15 ,null,1,7 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 13,15 ,null,1,8 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 14,15 ,null,1,9);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 15,15 ,null,1,10 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 9, 9, 5,18 ,null , 3,27);	COMMIT;










