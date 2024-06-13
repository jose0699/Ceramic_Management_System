/*
Este archivo va a contener todo lo respecto a las inserciones.
	Orden del documento:
		1-Tablas fuertes
		2-Intermedia
		3-Intercepción
Nota: Se ordenara segun el proceso en especifico que participa la tabla.
*/

--Proceso de Catalogo

--Proceso Venta

--Proceso de Control Empleado

 
--Pais					 /*listo*/
insert into pais values( nextval('pais_uid_seq'),'Venezuela');
insert into pais values( nextval('pais_uid_seq'),'Republica Dominicana');
insert into pais values( nextval('pais_uid_seq'),'Chile');
insert into pais values( nextval('pais_uid_seq'),'Estados Unidos');
insert into pais values( nextval('pais_uid_seq'),'Colombia');
insert into pais values( nextval('pais_uid_seq'),'Brasil');

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Empleado                                            --
--------------------------------------------------------------------------------------------------------
/* estados de salud  */					 /*listo*/
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Diabetes', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad cardíaca', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Cáncer', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad pulmonar', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia al polen', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los ácaros del polvo',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los medicamentos',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los alimentos', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a las mascotas', 'A');

--Departamento					 /*listo*/
insert into departamento values (nextval('departamento_uid_seq'),'Gerencia General',1,'GE','Gerencia general de la empresa');  --1
insert into departamento values (nextval('departamento_uid_seq'),'Gerencia de Planta',2,'GE','Gerencia de la fabrica',1);  --2
insert into departamento values(nextval('departamento_uid_seq'),'Secretaria',2,'GE','Departamento de secretaria',2); --3
insert into departamento values(nextval('departamento_uid_seq'),'Gerencia Tecnica',3,'GE','Gerencia Tecnica de la planta',2);--4
insert into departamento values(nextval('departamento_uid_seq'),'Insumos',3,'AL','Almacen de materiales de la empresa',2);--5
insert into departamento values(nextval('departamento_uid_seq'),'Control de Calidad',4,'SE','Departamento para el control de la calidad de los productos',4);--6
insert into departamento values(nextval('departamento_uid_seq'),'Mantenimiento',4,'SE','Departamento para el mantenimiento de las maquinas de la fabrica',4);--7
insert into departamento values(nextval('departamento_uid_seq'),'Producto Terminado',3,'AL','Almacen de todas las piezas terminadas',2);--8
insert into departamento values(nextval('departamento_uid_seq'),'Seleccion','4','DE','Departamento que empaca los productos',4);--9
insert into departamento values(nextval('departamento_uid_seq'),'Esmaltacion y Decoracion','4','DE','Departamento que decora las piezas seleccionadas',4);--10
insert into departamento values(nextval('departamento_uid_seq'),'Colado y Refinado','4','DE','Departamento que cuela la mezcla y refina las piezas',4);--11
insert into departamento values (nextval('departamento_uid_seq'),'Yeseria','4','DE','Departamento que provee de los moldes para las piezas',4);--12
insert into departamento values(nextval('departamento_uid_seq'),'Rotomoldeo','4','DE','Departamento que provee la pieza',4);--13
insert into departamento values(nextval('departamento_uid_seq'),'Preparacion Pasta','4','DE','Departamento que elabora los churros para las piezas',4);--14
insert into departamento values(nextval('departamento_uid_seq'),'Hornos','4','DE','Departamento de Hornos',4);--15



/* Gerentes */					 /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),21474659,'1975-07-21','B-','F','Calle principal de la candelaria','qui','ge',3500,04149116300,1,'María','González','Pérez');-- General  1
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 18934567, '1970-10-24', 'A-', 'F', 'Calle El Triunfo, Res. Las Palmeras', 'mec','ge', 3500, 04167891234, 2, 'Ana', 'Romero', 'Vargas',null);-- Planta  2
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 20876543, '1964-04-25', 'B+', 'M', 'Avenida Bolívar, Urb. La Colina', 'pro','ge', 3500, 04243215678, 4, 'Daniel', 'Guerrero', 'Mendoza',null);-- Tecnica   3


/* Supervisores */  		 /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),27748963,'1987-10-03','A+','M','Avenida Este cero','ind','og',1500,04149116305,5,'Carlos','Torres','Ramírez');--4  
insert into empleado values(nextval('empleado_exp_seq'),27474666,'1989-01-03','O-','M','Avenida Morat','ind','og',1500,04149116307,8,'Luis','Blanco','Fernández');--5 	
insert into empleado values(nextval('empleado_exp_seq'),27474665,'1988-02-03','B-','F','Calle Felicidad','ind','og',1500,04149116306,9,'Carolina','Sánchez','Martínez');--6   
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27474667, '1984-06-03', 'O-', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04149116307, 10, 'María', 'González', 'López');--7
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27441986, '1983-05-20', 'O-', 'M', 'Avenida Trusk', 'ind', 'og', 1500, 04149116107, 11, 'Luis', 'Blanco', 'Rotos');--8 	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27365666, '1982-08-03', 'A-', 'M', 'Avenida Del Moratorio', 'mec', 'og', 1500, 04149112407, 12, 'Carlos', 'Blanco', 'Fernández');--9 	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27364666, '1981-07-03', 'AB-', 'F', 'Avenida Morat', 'ind', 'og', 1500, 04149119007, 13, 'María', 'González', 'López');--10  		
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27363666, '1980-11-03', 'O-', 'M', 'Calle Real, 123', 'ind', 'og', 1500, 04149124569,14, 'Yuritza', 'Castillo', 'Rodriguez');--11	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27362666, '1985-10-03', 'B+', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04145154269, 15, 'Luis', 'Blanco', 'Fernández');--12 

/*  Secretaria  */ 			/*listo*/
insert into empleado values(nextval('empleado_exp_seq'),25474658,'1991-12-03','A+','M','Avenida siempre viva','ba','se',2100,04149116299,3,'Marcello','Servitad','Jesus','Santos');--13
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24485673, '1990-05-09', 'B-', 'F', 'Avenida Boulevard', 'ba','se', 2100, 04147896543, 3, 'Valentina', 'Harrison', 'Pérez',null );--14
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26321549, '1993-07-08', 'O+', 'M', 'Calle Principal', 'ba','se', 2100, 04265473210, 3, 'Alejandro', 'Guzmán', 'López',null );--15
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24210987, '2000-10-07', 'AB-', 'F', 'Avenida La Paz', 'ba','se', 2100, 04128765432, 3, 'Sandra', 'Mendoza', 'Martínez', null);--16

/* Seccion de control  */--6   		 /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),27403661,'1997-11-03','A+','F','Calle Esperanza de la cruz','pro','in',1400,04149116302,6,'Ana','Romero','Flores',null);--17
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23254321, '2000-03-05', 'B-', 'M', 'Avenida Universidad', 'pro','in', 1400, 04241234567, 6, 'Pedro', 'González', 'López', null);--18

/* Seccion de mantenimiento*/--7		 /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),24360661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','el',850,04149116302,7,'Ana','Romero','Flores',null);--19
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 25147362, '1994-06-07', 'O+', 'M', 'Avenida Libertador', 'pro','me', 850, 04162345678, 7, 'Luis', 'Muñoz', 'García', null);--20

/*  Almacen de insumos */--5 		/*listo*/
insert into empleado values(nextval('empleado_exp_seq'),27474661,'1994-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2000,04149116302,5,'Ana','Romero','Flores',null,4);--21
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23372615, '1987-08-09', 'AB+', 'M', 'Avenida Morán','pro','og', 2000, 04283654721, 5, 'Carlos', 'Blanco', 'Méndez',null,4);--22

/*Almacen de producto terminado */--8		 /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),28568661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2900,04149116302,8,'Ana','Romero','Flores',null,5);--23
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28261548, '2002-06-06', 'B-', 'F', 'Avenida Las Américas','pro','og', 2900, 04125432109, 8, 'María', 'Gómez', 'Pérez',null,5);--24

/*  Operarios */ 			/*listo*/
insert into empleado values(nextval('empleado_exp_seq'),28474660,'2002-04-03','O-','M','Avenida Libertad Solarium','ind','og',2600,04149116301,9,'Pedro','López','García',null,6);--25
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28251432, '2001-06-09', 'A+', 'F', 'Calle Principal', 'ind','og', 2600, 04267345123, 9, 'Gabriela', 'Martínez', 'Silva',null ,6);--26
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 22548736, '1987-07-08', 'B-', 'M', 'Avenida Bolívar', 'ind','og', 2600, 04143256789, 10, 'Luis', 'Ramírez', 'Blanco',null ,7);--27
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24721369, '1991-03-07', 'AB+', 'F', 'Calle Miranda', 'ind','og', 2600, 04281234567, 10, 'Andrea', 'Guerrero', 'Pérez', null,7);--28
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23832147, '2000-11-06', 'O-', 'M', 'Avenida Sucre', 'ind','og', 2600, 04165432109, 11, 'Carlos', 'Suárez', 'López', null,8);--29
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24943258, '2002-06-05', 'A+', 'F', 'Calle Vargas', 'ind','og', 2600, 04242345678, 11, 'Isabel', 'Muñoz', 'García', null,8);--30
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24054369, '2003-03-24', 'B-', 'M', 'Avenida Páez', 'ind','og', 2600, 04187654321, 12, 'Daniel', 'Romero', 'Flores', null,9);--31
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24165470, '1995-01-03', 'AB+', 'F', 'Calle Cedeño', 'ind','og', 2600, 04224321098, 12, 'Jennifer', 'Gómez', 'Pérez', null,9);--32
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24276581, '2001-07-02', 'O-', 'M', 'Avenida Falcón', 'ind','og', 2600, 04145678901, 13, 'José', 'López', 'García', null,10);--33
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24387692, '1990-05-01', 'A+', 'F', 'Calle Carabobo','ind','og', 2600, 04263456789, 13, 'María', 'Ramírez', 'Blanco', null,10);--34

/* Horneros  */ /*listo*/
insert into empleado values(nextval('empleado_exp_seq'),24474670,'2003-06-03','B-', 'M','Avenida  Solarium','ba','og',2600,04149116301,15,'Paco','Gutierrez','García',null,12);--35
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24509815, '2002-05-30', 'AB+', 'F', 'Calle Boyacá','ba','og', 2600, 04247654321, 15, 'Ana', 'Suárez', 'López',null,12);--36
insert into empleado values(nextval('empleado_exp_seq'),27474663,'2000-06-03','B-','M','Avenida Progreso movimiento','ba','og',1900,0414911703,15,'Juan','Muñoz','Vega',null,12);--37
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26362516, '1997-04-09', 'A+', 'F', 'Calle Libertad','ba','og', 1900, 04283654721, 15, 'Gabriela', 'Pérez', 'García',null,12);--38

/*  otro departamento   */ 			/*listo*/
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 27273645, '1999-06-08', 'B-', 'M', 'Avenida Morán','geo','og', 1900, 04162345678, 14, 'Luis', 'Gómez', 'López',null, 11);--39
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24184756, '1998-06-07', 'AB+', 'F', 'Calle Miranda', 'geo','og', 1900, 04241234567, 14, 'Andrea', 'Blanco', 'Méndez',null,11);--40


/* reunion */ 			/*listo*/
insert into reunion values (4,'2024-06-04','Se comento sobre la productividad general de la fabrica');
insert into reunion values (4,'2024-08-04','asignacion de horarios del mes');
insert into reunion values (5,'2024-07-24','resumen de la semana');
insert into reunion values (5,'2024-02-09','resumen de la semana');
insert into reunion values (7,'2024-01-27','se chequeo el desempeño de esa semana');
insert into reunion values (6,'2024-03-08','se chequeo el desempeño de esa semana');
insert into reunion values (8,'2024-04-08','informacion sobre bonos');
insert into reunion values (8,'2024-03-08','resumen de la semana');
insert into reunion values (9,'2024-05-08','informacion sobre bonos');

/*    horario */				 /*listo*/
insert into HIST_TURNO values (35,'2024-05-01',1);
insert into HIST_TURNO values (36,'2024-05-01',1);
insert into HIST_TURNO values (37,'2024-05-01',2);
insert into HIST_TURNO values (38,'2024-05-01',3);
insert into HIST_TURNO values (36,'2024-06-01',3);
insert into HIST_TURNO values (36,'2024-07-01',2);
insert into HIST_TURNO values (37,'2024-06-01',3);
insert into HIST_TURNO values (38,'2024-06-01',1);
insert into HIST_TURNO values (35,'2024-06-01',3);



/*    Detalle expediente */





/*motivo
inasistencia 
bonos
amonestacion 
llegada tarde 
horas extras */

 /*  Detalle Expediente */				/*listo*/
insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-04','in',null);
insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-14','in',null);
insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-01','in',null);
insert into det_exp values(4,nextval('det_exp_uid_seq'),'2024-06-04','bm',500);
insert into det_exp values(27,nextval('det_exp_uid_seq'),'2023-12-31','ba',1000);
insert into det_exp values(28,nextval('det_exp_uid_seq'),'2024-06-15','am',null,null,null,'Llego falto 3 dias al trabajo en el ultimo mes');
insert into det_exp values(29,nextval('det_exp_uid_seq'),'2024-02-14','lt',null,2);
insert into det_exp values(30,nextval('det_exp_uid_seq'),'2024-02-14','he',null,null,2);
insert into det_exp values(27,nextval('det_exp_uid_seq'),'2024-05-04','lt',null,3);
insert into det_exp values(40,nextval('det_exp_uid_seq'),'2024-06-08','in',null);
insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-01-04','lt',null,2);
insert into det_exp values(6,nextval('det_exp_uid_seq'),'2024-06-04','bm',500);
insert into det_exp values(33,nextval('det_exp_uid_seq'),'2024-06-04','in',null);
insert into det_exp values(40,nextval('det_exp_uid_seq'),'2024-06-14','in',null);
insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-06-01','in',null);
insert into det_exp values(7,nextval('det_exp_uid_seq'),'2024-04-04','bm',500);
insert into det_exp values(34,nextval('det_exp_uid_seq'),'2024-02-04','in',null);
insert into det_exp values(34,nextval('det_exp_uid_seq'),'2024-02-14','in',null);
insert into det_exp values(35,nextval('det_exp_uid_seq'),'2024-06-01','in',null);





/*  tablas de intereseccion  */					/*listo*/
insert into INASISTENCIA values (4,'2024-06-04',26);
insert into INASISTENCIA values (4,'2024-08-04',26);
insert into INASISTENCIA values (5,'2024-07-24',26);
insert into INASISTENCIA values (5,'2024-02-09',40);
insert into INASISTENCIA values (7,'2024-01-27',40);
insert into INASISTENCIA values (6,'2024-03-08',35);
insert into INASISTENCIA values (8,'2024-04-08',34);
insert into INASISTENCIA values (8,'2024-03-08',34);
insert into INASISTENCIA values (9,'2024-05-08',33);

/*Tabla Empleado - Estado de salud*/			/*listo*/

insert into E_E values (1, 1,'Tiene Diabetes 1');
insert into E_E values (4, 2,'Tiene enfermedad de valvulas cardiacas');
insert into E_E values (6, 3,'Tiene cancer de garganta');
insert into E_E values (4, 3,'Tiene cancer de prostata');
insert into E_E values (22, 5,'Es alergico al polen');
insert into E_E values (40, 6,'Es alergico a los acaros');
insert into E_E values (35, 8,'Es alergico al mani');
insert into E_E values (37, 9,'Es a los gatos');
insert into E_E values (20, 8,'Es alergico al chocolate');
insert into E_E values (17, 3,'Tiene cancer de Mama');



--------------------------------------------------------------------------------------------------------
--                                     Proceso de Catalogo                                            --
--------------------------------------------------------------------------------------------------------

/*  si la linea es familiar no puede tener su precio y debe tener un historico*/

--COLECCION		/*listo*/
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Amazonia','2024-06-04','F','cla','Adéntrate en la vibrante belleza del Amazonas con la colección Amazonia de vajillas. Inspirada en la flora y fauna de esta región única, cada pieza presenta un diseño cautivador que celebra la riqueza natural del Amazonas.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Lineal Cereza','2024-06-04','F','cla','La Colección Lineal Cereza aporta un toque de sofisticación y modernidad a tu mesa con su diseño minimalista y elegante. Sus líneas rectas y sencillas combinan a la perfección con cualquier decoración, creando un ambiente armonioso y acogedor.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Campina Inglesa','2024-06-04','F','cou','La Colección Campiña Inglesa te transporta a los idílicos paisajes de la campiña inglesa con su diseño floral y colorido. Sus delicadas flores y estampados campestres crean un ambiente fresco en la mesa.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Desayuno Campestre','2024-06-04','I','cou','La Colección Desayuno Campestre te invita a disfrutar de un delicioso desayuno lleno de sabor y color. Su diseño rústico y alegre, inspirado en los picnics campestres, crea un ambiente informal y acogedor en tu cocina.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Ondas Suaves','2024-06-04','I','mod','La Colección Ondas Suaves rinde homenaje a los movimientos suaves del mar.');




--MOLDE			/*listo*/
insert into molde values(nextval ('molde_uid_seq'),'JA','10x19cm',1.5); --1
insert into molde values(nextval ('molde_uid_seq'),'JA','12x17cm',1); --2
insert into molde values(nextval ('molde_uid_seq'),'TT','10x18cm',null,6); --3
insert into molde values(nextval ('molde_uid_seq'),'TT','12x20cm',null,2); --4
insert into molde values(nextval ('molde_uid_seq'),'LE','18x11cm',null,6); --5
insert into molde values(nextval ('molde_uid_seq'),'LE','19x12cm',null,2); --6
insert into molde values(nextval ('molde_uid_seq'),'AZ','9x10cm',null,9); --7

insert into molde values(nextval ('molde_uid_seq'),'CA','19x12cm'); --8
insert into molde values(nextval ('molde_uid_seq'),'CA','7x6cm'); --9
insert into molde values(nextval ('molde_uid_seq'),'CA','26x20cm'); --10
insert into molde values(nextval ('molde_uid_seq'),'CA','47x38cm'); --11
insert into molde values(nextval ('molde_uid_seq'),'CA','28x5cm'); --12

insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm',null,null,'ova'); --13
insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm',null,null,'rec'); --14
insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm',null,null,'ova'); --15
insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm',null,null,'rec'); --16

insert into molde values(nextval ('molde_uid_seq'),'PL','24cm',null,null,'red','HO'); --17
insert into molde values(nextval ('molde_uid_seq'),'PL','24cm',null,null,'cua','HO'); --18
insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'red','LL'); --19
insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'cua','LL'); --20
insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm',null,null,'rec','LL'); --21
insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TT'); --22
insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TC'); --23
insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm',null,null,null,'TM'); --24
insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'red','PO'); --25
insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'cua','PO'); --26
insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm',null,null,'rec','PO'); --27
insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'red','PR'); --28
insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'cua','PR'); --29
insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm',null,null,'rec','PR'); --30
insert into molde values(nextval ('molde_uid_seq'),'PL','28x28cm',null,null,null,'PA'); --31

insert into molde values(nextval ('molde_uid_seq'),'TA','3x7cm',null,null,null,null,'CS'); --32
insert into molde values(nextval ('molde_uid_seq'),'TA','4x10cm',null,null,null,null,'CC'); --33
insert into molde values(nextval ('molde_uid_seq'),'TA','3x8cm',null,null,null,null,'TS'); --34
insert into molde values(nextval ('molde_uid_seq'),'TA','4x6cm',null,null,null,null,'TC'); --35
insert into molde values(nextval ('molde_uid_seq'),'TA','3x8cm',null,null,null,null,'MS'); --36
insert into molde values(nextval ('molde_uid_seq'),'TA','4x6cm',null,null,null,null,'MC'); --37

insert into molde values(nextval ('molde_uid_seq'),'EN','38x22cm'); --38
insert into molde values(nextval ('molde_uid_seq'),'EN','30x18cm'); --39



--VAJILLA		/*Listo */

insert into vajilla values(nextval ('vajilla_uid_seq'),'Guacamaya',4,'Diseño con plumas de guacamaya en colores rojo, amarillo y azul, con detalles en negro que representan los ojos del ave.');--cole 1
insert into vajilla values(nextval ('vajilla_uid_seq'),'Waima',6,'Diseño con ondas azules y verdes que evocan las aguas del río Negro, con detalles en dorado que representan las pepitas de oro que se encuentran en la región.'); --cole 1


insert into vajilla values(nextval ('vajilla_uid_seq'),'Cereza en Flor',6,'Diseño con flores de cerezo en tonos rosados y blancos, con detalles en rojo cereza que representan el fruto.');-- cole 2
insert into vajilla values(nextval ('vajilla_uid_seq'),'Jardín Rojo',4,'Diseño con un jardín de cerezos en flor, con árboles, flores y frutos en tonos rojos, rosados y verdes.');--cole 2

insert into vajilla values(nextval ('vajilla_uid_seq'),'Afternoon Tea',6,'Diseño con tazas de té, sándwiches, pasteles y otros elementos típicos del té de la tarde inglés.');--cole 3
insert into vajilla values(nextval ('vajilla_uid_seq'),'Círculo de Willow',6,'Diseño con el patrón de sauce tradicional, un motivo popular en la cerámica inglesa.');-- cole 3

insert into vajilla values(nextval ('vajilla_uid_seq'),'Desayuno Ingles',2,' Diseño con huevos fritos, tocino, salchichas, frijoles horneados, champiñones, tomates y tostadas, los elementos clásicos de un desayuno inglés completo.');--cole 4
insert into vajilla values(nextval ('vajilla_uid_seq'),'Huevos y Tocino',4,'Diseño con huevos fritos en diferentes estilos (fritos, revueltos, escalfados) y tiras de tocino crujiente.');--cole 4

insert into vajilla values(nextval ('vajilla_uid_seq'),'Perla del Mar',4,'Diseño con una perla grande y brillante en el centro, rodeada de ondas delicadas en tonos blancos y plateados.');--cole 5
insert into vajilla values(nextval ('vajilla_uid_seq'),'Conchas Marinas',2,'Diseño con diferentes tipos de conchas marinas en colores naturales, como blanco, beige y marrón.');--cole 5


--PIEZA			/*Listo */
insert into pieza values(1,nextval ('pieza_uid_seq'),'Guacamaya Regrescante:Inspirado en la belleza serena de Waima Gorge, este plato exquisito encarna la esencia de la armonía y el equilibrio.',null,25);--1
insert into pieza values(1,nextval ('pieza_uid_seq'),'Guacamaya Tropical: Un festín de colores para tu mesa.',null,22);--2
insert into pieza values (1,nextval ('pieza_uid_seq'),'Guacamaya Emblemática: Un homenaje a la belleza de las aves tropicales.',null,23);--5
insert into pieza values (1,nextval ('pieza_uid_seq'),'Guacamaya Artesanal: Un producto elaborado con pasión y cuidado.',null,24);--6




insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Raíces: Un homenaje a la fuerza y la estabilidad.',null,23);--17
insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Abrazo: Un símbolo de unión y comunidad.',null,27);--18
insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Armonía: Comparte momentos agradables con tus seres queridos.',null,26);--22
insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Equilibrio: Un toque de elegancia a tu mesa.',null,1);--23
insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Despertar: Comienza tu día con un toque de energía natural.',null,8);--26
insert into pieza values (1,nextval ('pieza_uid_seq'),'Samauma Recuerdo: Un regalo ideal para revivir momentos especiales.',null,29);--29



insert into pieza values (2,nextval ('pieza_uid_seq'),'Florecer: simple y poético que evoca la belleza de las flores de cerezo en plena floración.',null,24);--31
insert into pieza values (2,nextval ('pieza_uid_seq'),'Primavera Viva: alegre y vibrante que transmite la energía y la frescura de la temporada primaveral.',null,22);--32
insert into pieza values (2,nextval ('pieza_uid_seq'),'Festín Floral:invita a disfrutar de una deliciosa comida en compañía de las hermosas flores de cerezo.',null,26);--33
insert into pieza values (2,nextval ('pieza_uid_seq'),'Lienzo Natural:delicadeza de  diseños pintados a mano y la posibilidad de usar los platos como un lienzo para la creatividad culinaria.',null,27);--34
insert into pieza values (2,nextval ('pieza_uid_seq'),'Brindis Primaveral:invita a celebrar la llegada de la primavera con una bebida refrescante.',null,1);--35
insert into pieza values (2,nextval ('pieza_uid_seq'),'Toque Floral: sencillo y elegante que describe el efecto decorativo que aporta la jarra a la mesa.',null,1);--36


insert into pieza values (2,nextval ('pieza_uid_seq'),'Jardín Encantado: Delicados platos de cerámica pintados a mano con motivos de un jardín rojo en flor,',null,22);--46
insert into pieza values (2,nextval ('pieza_uid_seq'),'Sinfonía de Colores: Disfruta de tus comidas en estos vibrantes platos adornados con flores y follaje de un jardín rojo, disponibles en una variedad de colores para combinar con tu decoración.',null,26);--46
insert into pieza values (2,nextval ('pieza_uid_seq'),'Sabores del Verano: Sirve tus platos favoritos con estilo en estos platos de cerámica con diseños de jardines rojos, ideales para cualquier ocasión.',null,24);--46
insert into pieza values (2,nextval ('pieza_uid_seq'),'Un Oasis en tu Mesa: La belleza de un jardín floreciente se refleja en cada plato, con detalles pintados a mano que evocan la frescura y la vitalidad del verano.',null,8);--46


insert into pieza values (3,nextval ('pieza_uid_seq'),'Lienzo de Otoño: Una bandeja con bordes ligeramente elevados, perfecta para servir aperitivos o postres, adornada con una escena otoñal del río rodeado de árboles de colores vibrantes, reflejándose en la superficie del agua.',null,14);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Picnic junto al Río: Una bandeja con bordes bajos, ideal para disfrutar de un picnic al aire libre, decorada con una escena de una familia disfrutando de un mantel extendido en la hierba junto al río, bajo la sombra de un árbol.',null,15);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Pícnic Romántico: Una bandeja  con bordes ondulados, perfecta para una escapada romántica, adornada con una escena de una pareja cenando a la luz de las velas junto al río, con el cielo estrellado como telón de fondo.',null,16);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Cúpula del Sauce: Una azucarera con forma de cúpula y tapa, ideal para endulzar el café o el té, decorada con una delicada ilustración de un sauce llorón que se inclina sobre el río, creando un efecto de cúpula natural.',null,7);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Barco Navegante: Una azucarera con forma de bote con tapa, perfecta para agregar un toque de diversión a la mesa, adornada con una escena de un pequeño bote navegando por el río, con las velas desplegadas y el viento en la popa.',null,7);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Molino de Agua: Una azucarera con forma de molino de agua con tapa, ideal para crear un ambiente rústico y acogedor, decorada con una escena detallada de un molino de agua junto al río, con sus ruedas girando y creando una sensación de movimiento.',null,7);--46


insert into pieza values (3,nextval ('pieza_uid_seq'),'Delicia Elegante: Delicados platos de cerámica pintados a mano con motivos de la tradicional hora del té,',null,22);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Sinfonía de Sabores: Disfruta de tus dulces y salados favoritos en estos vibrantes platos adornados con tazas de té, sándwiches y pasteles, disponibles en una variedad de colores para combinar con tu decoración.',null,24);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Un Momento de Paz: Sirve tus delicias con estilo en estos platos de cerámica con diseños de la hora del té, ideales para cualquier ocasión especial o simplemente para disfrutar de un momento de tranquilidad.',null,28);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Brindis por la Alegría: Eleva tus celebraciones con esta jarra de cerámica decorada con motivos de la hora del té, perfecta para servir té, café o chocolate caliente con estilo.',null,2);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Un Toque de Refinamiento a tu Mesa: Disfruta de tus bebidas favoritas en esta jarra de cerámica con un diseño encantador de la hora del té, ideal para agregar un toque de elegancia a cualquier reunión.',null,2);--46
insert into pieza values (3,nextval ('pieza_uid_seq'),'Mañana de Té: Comienza tu día con una sonrisa con esta taza de cerámica decorada con motivos de la hora del té, perfecta para disfrutar de tu café o té matutino.',null,31);--46


insert into pieza values (4,nextval ('pieza_uid_seq'),'Amanecer Británico: Un plato ideal para la comida principal, adornado con una escena rústica de una granja inglesa al amanecer, con el humo que sale de la chimenea y el aroma del desayuno recién hecho flotando en el aire.',10,22);--46
insert into pieza values (4,nextval ('pieza_uid_seq'),'Earl Grey: Una taza cilíndrica con asa, perfecta para disfrutar de una taza de té Earl Grey, la bebida tradicional del desayuno inglés, decorada con una ilustración de una tetera humeante y una taza elegante, rodeados de hojas de té aromáticas.',10,31);--46

insert into pieza values (4,nextval ('pieza_uid_seq'),'Desayuno Campestre: Una bandeja con bordes ligeramente elevados, perfecta para servir un desayuno completo, adornada con un diseño alegre de huevos fritos con yemas soleadas, crujientes tiras de tocino y rebanadas de pan tostado.',10,14);--46
insert into pieza values (4,nextval ('pieza_uid_seq'),'Brunch Dominguero: Una bandeja con bordes bajos, ideal para disfrutar de un brunch familiar, decorada con un diseño colorido de huevos revueltos, tocino en forma de corazón, gofres con arándanos y un vaso de jugo de naranja.',10,15);--46
insert into pieza values (4,nextval ('pieza_uid_seq'),'Picnic Picante: Una bandeja  con bordes ondulados, perfecta para un picnic picante, adornada con un diseño rústico de huevos rancheros con salsa picante, tortillas calientes, frijoles refritos y aguacate fresco.',10,15);--46
insert into pieza values (4,nextval ('pieza_uid_seq'),'Nube Dorada: Una jarra de forma cilíndrica con asa y pico vertedor, ideal para servir café o té caliente, decorada con un diseño de huevos revueltos en forma de nube, con yemas doradas que se derraman sobre crujientes tiras de tocino.',10,2);--46




insert into pieza values (5,nextval ('pieza_uid_seq'),'Ostra Brillante: Un plato con bordes curvos que evoca la forma de una ostra abierta, perfecto para sopas o guisos, adornado con una perla iridiscente en el centro, como una joya marina.',10,22);--46
insert into pieza values (5,nextval ('pieza_uid_seq'),'Concha de Tesoro: Un plato y ancho con bordes ligeramente elevados, ideal para ensaladas o acompañamientos, decorado con una concha marina abierta que revela una perla resplandeciente, como un tesoro escondido.',10,24);--46
insert into pieza values (5,nextval ('pieza_uid_seq'),'Plato Espuma de las Olas: Un plato , perfecto para la comida principal, adornado con un diseño de olas rompiendo en la orilla, dejando tras de sí una espuma blanca nacarada que recuerda a las perlas.',10,28);--46
insert into pieza values (5,nextval ('pieza_uid_seq'),'Sirena Encantada: Una taza cilíndrica con asa, ideal para iniciar el día con una taza de café o té caliente, decorada con una ilustración de una sirena nadando entre perlas, con su cola iridiscente brillando bajo el agua.',10,34);--46



insert into pieza values (5,nextval ('pieza_uid_seq'),'Caracola Sonriente: Un plato  con bordes curvos que evocan la forma de una caracola marina, perfecto para sopas o guisos, adornado con una ilustración de una caracola con una sonrisa tallada en su espiral, como si cantara una melodía del mar.',10,22);--46
insert into pieza values (5,nextval ('pieza_uid_seq'),'Tesoro Escondido: Un plato  con bordes ligeramente elevados, ideal para ensaladas o acompañamientos, decorado con un diseño de una concha marina abierta que revela un collar de perlas y pequeñas piedras preciosas, como un tesoro escondido bajo las olas.',10,24);--46






/*Familiar_historico_precio */		/*Listo */


insert into familiar_historico_precio values(1,1,'2010-01-08 04:05:06' ,10);
insert into familiar_historico_precio values(1,2,'2012-03-15 21:13:42' ,2);
insert into familiar_historico_precio values(1,3,'2014-07-22 18:29:19' ,3);
insert into familiar_historico_precio values(1,4,'2017-11-09 06:54:33' ,10);
insert  into familiar_historico_precio values(1,5,'2011-05-24 10:32:11' ,6);
insert into familiar_historico_precio values(1,6,'2019-08-03 00:18:27' ,9);
insert into familiar_historico_precio values(1,7,'2010-12-28 14:48:02' ,1);
insert into familiar_historico_precio values(1,8,'2015-04-11 05:23:58' ,7);
insert into familiar_historico_precio values(1,9,'2021-09-20 23:47:16' ,1);
insert into familiar_historico_precio values(1,10,'2013-06-07 12:15:45' ,25);

insert into familiar_historico_precio values(2,11,'2018-02-26 08:51:23' ,1);
insert into familiar_historico_precio values(2,12,'2016-10-04 17:09:34' ,11);
insert into familiar_historico_precio values(2,13,'2010-03-23 09:21:56' ,14);
insert into familiar_historico_precio values(2,14,'2014-12-31 22:30:01' ,10);
insert into familiar_historico_precio values(2,15,'2017-05-16 01:42:43' ,2);
insert into familiar_historico_precio values(2,16,'2011-09-08 15:58:50' ,3);
insert into familiar_historico_precio values(2,17,'2019-02-12 11:06:14' ,5);
insert into familiar_historico_precio values(2,18,'2010-08-10 20:33:29' ,4);
insert into familiar_historico_precio values(2,19,'2015-01-29 03:17:32' ,12);
insert into familiar_historico_precio values(2,20,'2021-03-05 07:24:48' ,17);


insert into familiar_historico_precio values(3,21,'2013-11-22 16:02:51' ,24);
insert into familiar_historico_precio values(3,22,'2018-07-01 19:45:04' ,3);
insert into familiar_historico_precio values(3,23,'2016-03-18 13:37:19' ,8);
insert into familiar_historico_precio values(3,24,'2010-04-15 08:12:31' ,1);
insert into familiar_historico_precio values(3,25,'2014-08-27 14:49:25' ,9);
insert into familiar_historico_precio values(3,26,'2013-11-22 16:02:51' ,24);
insert into familiar_historico_precio values(3,27,'2018-07-01 19:45:04' ,3);
insert into familiar_historico_precio values(3,28,'2016-03-18 13:37:19' ,8);
insert into familiar_historico_precio values(3,29,'2010-04-15 08:12:31' ,1);
insert into familiar_historico_precio values(3,30,'2014-08-27 14:49:25' ,9);
insert into familiar_historico_precio values(3,31,'2013-11-22 16:02:51' ,24);
insert into familiar_historico_precio values(3,32,'2018-07-01 19:45:04' ,3);





/*Detalle pieza */		/*Listo */



insert into DETALLE_PIEZA_VAJILLA values (1,1,1,10);
insert into DETALLE_PIEZA_VAJILLA values (1,1,2,12);
insert into DETALLE_PIEZA_VAJILLA values (1,1,3,8);
insert into DETALLE_PIEZA_VAJILLA values (1,1,4,24);

insert into DETALLE_PIEZA_VAJILLA values (2,1,5,32);
insert into DETALLE_PIEZA_VAJILLA values (2,1,6,10);
insert into DETALLE_PIEZA_VAJILLA values (2,1,7,22);
insert into DETALLE_PIEZA_VAJILLA values (2,1,8,20);
insert into DETALLE_PIEZA_VAJILLA values (2,1,9,28);
insert into DETALLE_PIEZA_VAJILLA values (2,1,10,50);

insert into DETALLE_PIEZA_VAJILLA values (3,2,11,40);
insert into DETALLE_PIEZA_VAJILLA values (3,2,12,32);
insert into DETALLE_PIEZA_VAJILLA values (3,2,13,28);
insert into DETALLE_PIEZA_VAJILLA values (3,2,14,22);
insert into DETALLE_PIEZA_VAJILLA values (3,2,15,28);
insert into DETALLE_PIEZA_VAJILLA values (3,2,16,34);


insert into DETALLE_PIEZA_VAJILLA values (4,2,17,42);
insert into DETALLE_PIEZA_VAJILLA values (4,2,18,44);
insert into DETALLE_PIEZA_VAJILLA values (4,2,19,46);
insert into DETALLE_PIEZA_VAJILLA values (4,2,20,18);


insert into DETALLE_PIEZA_VAJILLA values (5,3,21,30);
insert into DETALLE_PIEZA_VAJILLA values (5,3,22,28);
insert into DETALLE_PIEZA_VAJILLA values (5,3,23,26);
insert into DETALLE_PIEZA_VAJILLA values (5,3,24,24);
insert into DETALLE_PIEZA_VAJILLA values (5,3,25,28);
insert into DETALLE_PIEZA_VAJILLA values (5,3,26,24);

insert into DETALLE_PIEZA_VAJILLA values (6,3,27,38);
insert into DETALLE_PIEZA_VAJILLA values (6,3,28,40);
insert into DETALLE_PIEZA_VAJILLA values (6,3,29,50);
insert into DETALLE_PIEZA_VAJILLA values (6,3,30,48);
insert into DETALLE_PIEZA_VAJILLA values (6,3,31,46);
insert into DETALLE_PIEZA_VAJILLA values (6,3,32,20);

insert into DETALLE_PIEZA_VAJILLA values (7,4,33,30);
insert into DETALLE_PIEZA_VAJILLA values (7,4,34,12);

insert into DETALLE_PIEZA_VAJILLA values (8,4,35,40);
insert into DETALLE_PIEZA_VAJILLA values (8,4,36,50);
insert into DETALLE_PIEZA_VAJILLA values (8,4,37,48);
insert into DETALLE_PIEZA_VAJILLA values (8,4,38,36);

insert into DETALLE_PIEZA_VAJILLA values (9,5,39,32);
insert into DETALLE_PIEZA_VAJILLA values (9,5,40,30);
insert into DETALLE_PIEZA_VAJILLA values (9,5,41,28);
insert into DETALLE_PIEZA_VAJILLA values (9,5,42,26);

insert into DETALLE_PIEZA_VAJILLA values (10,5,43,40);
insert into DETALLE_PIEZA_VAJILLA values (10,5,44,18);


--------------------------------------------------------------------------------------------------------
--                                     Proceso de Venta                                               --
--------------------------------------------------------------------------------------------------------

/*
	                                   Tablas listas
	                                 Proceso Empleado
	--horario
	--reconocimiento
	--resumen_reunion
	--empleado
	--estado_salud	
	                                Proceso Molde
	--Pieza
	--vajilla
	--molde
	--coleccion

*/









