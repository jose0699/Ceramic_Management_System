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

 
--Pais
insert into pais values( nextval('pais_uid_seq'),'Venezuela');
insert into pais values( nextval('pais_uid_seq'),'Republica Dominicana');
insert into pais values( nextval('pais_uid_seq'),'Chile');
insert into pais values( nextval('pais_uid_seq'),'Estados Unidos');
insert into pais values( nextval('pais_uid_seq'),'Colombia');
insert into pais values( nextval('pais_uid_seq'),'Brasil');

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Empleado                                            --
--------------------------------------------------------------------------------------------------------
/* estados de salud  */
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Diabetes', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad cardíaca', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Cáncer', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad pulmonar', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia al polen', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los ácaros del polvo',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los medicamentos',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los alimentos', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a las mascotas', 'A');

--Departamento
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
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Colado y Refinado','4','DE','Departamento que cuela la mezcla y refina las piezas',4);--11
insert into departamento values (nextval('departamento_uid_seq'),'Yeseria','4','DE','Departamento que provee de los moldes para las piezas',4);--12
insert into departamento values(nextval('departamento_uid_seq'),'Rotomoldeo','4','DE','Departamento que provee la pieza',4);--13
insert into departamento values(nextval('departamento_uid_seq'),'Preparacion Pasta','4','DE','Departamento que elabora los churros para las piezas',4);--14
insert into departamento values(nextval('departamento_uid_seq'),'Hornos','4','DE','Departamento de Hornos',4);--15

/* Gerentes */
insert into empleado values(nextval('empleado_exp_seq'),21474659,'1975-07-21','B-','F','Calle principal de la candelaria','qui','ge',3500,04149116300,1,'María','González','Pérez');-- General  1
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 18934567, '1970-10-24', 'A-', 'F', 'Calle El Triunfo, Res. Las Palmeras', 'mec','ge', 3500, 04167891234, 2, 'Ana', 'Romero', 'Vargas',null);-- Planta  2
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 20876543, '1964-04-25', 'B+', 'M', 'Avenida Bolívar, Urb. La Colina', 'pro','ge', 3500, 04243215678, 4, 'Daniel', 'Guerrero', 'Mendoza',null);-- Tecnica   3


/* Supervisores */
insert into empleado values(nextval('empleado_exp_seq'),27748963,'1987-10-03','A+','M','Avenida Este cero','ind','og',1500,04149116305,5,'Carlos','Torres','Ramírez');--4  
insert into empleado values(nextval('empleado_exp_seq'),27474666,'1989-01-03','O-','M','Avenida Morat','ind','og',1500,04149116307,8,'Luis','Blanco','Fernández');--5 	
insert into empleado values(nextval('empleado_exp_seq'),27474665,'1988-02-03','B-','F','Calle Felicidad','ind','og',1500,04149116306,9,'Carolina','Sánchez','Martínez');--6   
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27474667, '1984-06-03', 'O-', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04149116307, 10, 'María', 'González', 'López');--7
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27441986, '1983-05-20', 'O-', 'M', 'Avenida Trusk', 'ind', 'og', 1500, 04149116107, 11, 'Luis', 'Blanco', 'Rotos');--8 	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27365666, '1982-08-03', 'A-', 'M', 'Avenida Del Moratorio', 'mec', 'og', 1500, 04149112407, 12, 'Carlos', 'Blanco', 'Fernández');--9 	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27364666, '1981-07-03', 'AB-', 'F', 'Avenida Morat', 'ind', 'og', 1500, 04149119007, 13, 'María', 'González', 'López');--10  		
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27363666, '1980-11-03', 'O-', 'M', 'Calle Real, 123', 'ind', 'og', 1500, 04149124569,14, 'Yuritza', 'Castillo', 'Rodriguez');--11	
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27362666, '1985-10-03', 'B+', 'M', 'Avenida Morat', 'ind', 'og', 1500, 04145154269, 15, 'Luis', 'Blanco', 'Fernández');--12 

/*  Secretaria  */
insert into empleado values(nextval('empleado_exp_seq'),25474658,'1991-12-03','A+','M','Avenida siempre viva','ba','se',2100,04149116299,3,'Marcello','Servitad','Jesus','Santos');--13
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24485673, '1990-05-09', 'B-', 'F', 'Avenida Boulevard', 'ba','se', 2100, 04147896543, 3, 'Valentina', 'Harrison', 'Pérez',null );--14
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26321549, '1993-07-08', 'O+', 'M', 'Calle Principal', 'ba','se', 2100, 04265473210, 3, 'Alejandro', 'Guzmán', 'López',null );--15
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24210987, '2000-10-07', 'AB-', 'F', 'Avenida La Paz', 'ba','se', 2100, 04128765432, 3, 'Sandra', 'Mendoza', 'Martínez', null);--16

/* Seccion de control  */--6
insert into empleado values(nextval('empleado_exp_seq'),27403661,'1997-11-03','A+','F','Calle Esperanza de la cruz','pro','in',1400,04149116302,6,'Ana','Romero','Flores',null);--17
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23254321, '2000-03-05', 'B-', 'M', 'Avenida Universidad', 'pro','in', 1400, 04241234567, 6, 'Pedro', 'González', 'López', null);--18

/* Seccion de mantenimiento*/--7
insert into empleado values(nextval('empleado_exp_seq'),24360661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','el',850,04149116302,7,'Ana','Romero','Flores',null);--19
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 25147362, '1994-06-07', 'O+', 'M', 'Avenida Libertador', 'pro','me', 850, 04162345678, 7, 'Luis', 'Muñoz', 'García', null);--20

/*  Almacen de insumos */--5
insert into empleado values(nextval('empleado_exp_seq'),27474661,'1994-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2000,04149116302,5,'Ana','Romero','Flores',null,4);--21
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23372615, '1987-08-09', 'AB+', 'M', 'Avenida Morán','pro','og', 2000, 04283654721, 5, 'Carlos', 'Blanco', 'Méndez',null,4);--22

/*Almacen de producto terminado */--8
insert into empleado values(nextval('empleado_exp_seq'),28568661,'2001-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2900,04149116302,8,'Ana','Romero','Flores',null,5);--23
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28261548, '2002-06-06', 'B-', 'F', 'Avenida Las Américas','pro','og', 2900, 04125432109, 8, 'María', 'Gómez', 'Pérez',null,5);--24

/*  Operarios */
insert into empleado values(nextval('empleado_exp_seq'),28474660,'2002-04-03','O-','M','Avenida Libertad Solarium','ind','og',2600,04149116301,10,'Pedro','López','García',null,6);--25
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28251432, '2001-06-09', 'A+', 'F', 'Calle Principal', 'ind','og', 2600, 04267345123, 10, 'Gabriela', 'Martínez', 'Silva',null ,6);--26
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 22548736, '1987-07-08', 'B-', 'M', 'Avenida Bolívar', 'ind','og', 2600, 04143256789, 11, 'Luis', 'Ramírez', 'Blanco',null ,7);--27
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24721369, '1991-03-07', 'AB+', 'F', 'Calle Miranda', 'ind','og', 2600, 04281234567, 11, 'Andrea', 'Guerrero', 'Pérez', null,7);--28
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 23832147, '2000-11-06', 'O-', 'M', 'Avenida Sucre', 'ind','og', 2600, 04165432109, 8, 'Carlos', 'Suárez', 'López', null,8);--29
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24943258, '2002-06-05', 'A+', 'F', 'Calle Vargas', 'ind','og', 2600, 04242345678, 8, 'Isabel', 'Muñoz', 'García', null,8);--30
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24054369, '2003-03-24', 'B-', 'M', 'Avenida Páez', 'ind','og', 2600, 04187654321, 13, 'Daniel', 'Romero', 'Flores', null,9);--31
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24165470, '1995-01-03', 'AB+', 'F', 'Calle Cedeño', 'ind','og', 2600, 04224321098, 13, 'Jennifer', 'Gómez', 'Pérez', null,9);--32
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24276581, '2001-07-02', 'O-', 'M', 'Avenida Falcón', 'ind','og', 2600, 04145678901, 14, 'José', 'López', 'García', null,10);--33
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24387692, '1990-05-01', 'A+', 'F', 'Calle Carabobo','ind','og', 2600, 04263456789, 14, 'María', 'Ramírez', 'Blanco', null,10);--34

/* Horneros  */
insert into empleado values(nextval('empleado_exp_seq'),24474669,'2003-06-03','B-', 'M','Avenida  Solarium','geo','og',2600,04149116301,9,'Paco','Gutierrez','García',null,12);--35
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24509814, '2002-05-30', 'AB+', 'F', 'Calle Boyacá','geo','og', 2600, 04247654321, 9, 'Ana', 'Suárez', 'López',null,12);--36
insert into empleado values(nextval('empleado_exp_seq'),27474662,'2000-06-03','B-','M','Avenida Progreso movimiento','geo','og',1900,0414911703,15,'Juan','Muñoz','Vega',null,12);--37
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 26362514, '1997-04-09', 'A+', 'F', 'Calle Libertad','geo','og', 1900, 04283654721, 15, 'Gabriela', 'Pérez', 'García',null,12);--38

/*  otro departamento   */
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 27273645, '1999-06-08', 'B-', 'M', 'Avenida Morán','geo','og', 1900, 04162345678, 15, 'Luis', 'Gómez', 'López',null, 11);--39
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 24184756, '1998-06-07', 'AB+', 'F', 'Calle Miranda', 'geo','og', 1900, 04241234567, 15, 'Andrea', 'Blanco', 'Méndez',null,11);--40


/* reunion */
insert into reunion values (4,'2024-06-04','Se comento sobre la productividad general de la fabrica');
insert into reunion values (4,'2024-08-04','asignacion de horarios del mes');
insert into reunion values (5,'2024-07-24','resumen de la semana');
insert into reunion values (5,'2024-02-09','resumen de la semana');
insert into reunion values (7,'2024-01-27','se chequeo el desempeño de esa semana');
insert into reunion values (6,'2024-03-08','se chequeo el desempeño de esa semana');
insert into reunion values (8,'2024-04-08','informacion sobre bonos');
insert into reunion values (8,'2024-03-08','resumen de la semana');
insert into reunion values (9,'2024-05-08','informacion sobre bonos');

/*    horario */
insert into HIST_TURNO values (5,'2024-05-01',1);
insert into HIST_TURNO values (4,'2024-05-01',1);
insert into HIST_TURNO values (2,'2024-05-01',2);
insert into HIST_TURNO values (3,'2024-05-01',3);



/*    Detalle expediente */





/*motivo
inasistencia 
bonos
amonestacion 
llegada tarde 
horas extras */


insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-04','in',null);
insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-14','in',null);
insert into det_exp values(26,nextval('det_exp_uid_seq'),'2024-06-01','in',null);
insert into det_exp values(4,nextval('det_exp_uid_seq'),'2024-06-04','bm',500);
insert into det_exp values(27,nextval('det_exp_uid_seq'),'2023-12-31','ba',1000);
insert into det_exp values(28,nextval('det_exp_uid_seq'),'2024-06-15','am',null,null,null,'Llego falto 3 dias al trabajo en el ultimo mes );
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





/*  tablas de intereseccion  */
insert into INASISTENCIA values (4,'2024-06-04',26);
insert into INASISTENCIA values (4,'2024-06-14',26);
insert into INASISTENCIA values (4,'2024-06-01',26);
insert into INASISTENCIA values (12,'2024-06-08',40);
insert into INASISTENCIA values (12,'2024-06-04',33);
insert into INASISTENCIA values (8,'2024-06-14',40);
insert into INASISTENCIA values (9,'2024-06-01',35);
insert into INASISTENCIA values (10,'2024-02-04',34);
insert into INASISTENCIA values (7,'2024-02-14',34);
insert into INASISTENCIA values (5,'2024-06-01',33);


/* estados de salud  */
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Diabetes', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad cardíaca', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Cáncer', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Enfermedad pulmonar', 'P');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia al polen', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los ácaros del polvo',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los medicamentos',  'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a los alimentos', 'A');
insert into estado_salud values(nextval('estado_salud_uid_seq'),'Alergia a las mascotas', 'A');

insert into E_E values (1, 1,'Tiene Diabetes 1');
insert into E_E values (4, 2,'Tiene enfermedad de valvulas cardiacas');
insert into E_E values (6, 3,'Tiene cancer de garganta');
insert into E_E values (4, 3,'Tiene cancer de prostata);
insert into E_E values (22, 5,'Es alergico al polen');
insert into E_E values (40, 6,'Es alergico a los acaros');
insert into E_E values (35, 8,'Es alergico a los alimentos');
insert into E_E values (37, 9,'Es a las mascotas');
insert into E_E values (20, 8,'Es alergico a los alimentos');
insert into E_E values (17, 3,'Tiene cancer de Mama');
.


--------------------------------------------------------------------------------------------------------
--                                     Proceso de Catalogo                                            --
--------------------------------------------------------------------------------------------------------

--COLECCION
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Amazonia','2024-06-04','F','cla','Adéntrate en la vibrante belleza del Amazonas con la colección Amazonia de vajillas. Inspirada en la flora y fauna de esta región única, cada pieza presenta un diseño cautivador que celebra la riqueza natural del Amazonas.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Lineal Cereza','2024-06-04','F','cla','La Colección Lineal Cereza aporta un toque de sofisticación y modernidad a tu mesa con su diseño minimalista y elegante. Sus líneas rectas y sencillas combinan a la perfección con cualquier decoración, creando un ambiente armonioso y acogedor.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Campina Inglesa','2024-06-04','F','cou','La Colección Campiña Inglesa te transporta a los idílicos paisajes de la campiña inglesa con su diseño floral y colorido. Sus delicadas flores y estampados campestres crean un ambiente fresco en la mesa.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Desayuno Campestre','2024-06-04','I','cou','La Colección Desayuno Campestre te invita a disfrutar de un delicioso desayuno lleno de sabor y color. Su diseño rústico y alegre, inspirado en los picnics campestres, crea un ambiente informal y acogedor en tu cocina.');
insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Era Moderna','2024-06-04','I','mod','La Colección Era Moderna rinde homenaje a los movimientos de diseño más emblemáticos del siglo XX, capturando su esencia atemporal y llevándola a tu mesa.');
--insert into coleccion values(nextval ('coleccion_uid_seq ') ,'Coleccion Ondas Suaves','2024-06-04','I','mod','La Colección Ondas Suaves te transporta a la tranquilidad del mar con su diseño ondulado y minimalista. Sus líneas suaves y colores relajantes crean un ambiente sereno y armonioso en tu mesa, perfecto para disfrutar de momentos especiales con tus seres queridos.');


/*forma : red,rec,cua,ova*/
--MOLDE
insert into molde values(nextval ('molde_uid_seq'),'JA','100x190mm',1.5);
insert into molde values(nextval ('molde_uid_seq'),'JA','12x17cm',1);
insert into molde values(nextval ('molde_uid_seq'),'TT','10x18cm',6);
insert into molde values(nextval ('molde_uid_seq'),'TT','12x20cm',2);
insert into molde values(nextval ('molde_uid_seq'),'LE','18x11cm',6);
insert into molde values(nextval ('molde_uid_seq'),'LE','19x12cm',2);
insert into molde values(nextval ('molde_uid_seq'),'AZ',20,2.5,9);
insert into molde values(nextval ('molde_uid_seq'),'CA','19x12cm');
insert into molde values(nextval ('molde_uid_seq'),'CA','7x6cm');
insert into molde values(nextval ('molde_uid_seq'),'CA','26x20cm');
insert into molde values(nextval ('molde_uid_seq'),'CA','47x38cm');
insert into molde values(nextval ('molde_uid_seq'),'CA','28x5cm');
insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm');
insert into molde values(nextval ('molde_uid_seq'),'BD','44x22cm');
insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm');
insert into molde values(nextval ('molde_uid_seq'),'BD','35x18cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','24cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','27x27cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','14x11cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','23x23cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','35x35cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','28x28cm');
insert into molde values(nextval ('molde_uid_seq'),'PL','35x18cm');
insert into molde values(nextval ('molde_uid_seq'),'TA','3x7cm');
insert into molde values(nextval ('molde_uid_seq'),'TA','4x10cm');
insert into molde values(nextval ('molde_uid_seq'),'TA','3x8cm');
insert into molde values(nextval ('molde_uid_seq'),'TA','4x6cm');
insert into molde values(nextval ('molde_uid_seq'),'EN','38x22cm');
insert into molde values(nextval ('molde_uid_seq'),'EN','30x18cm');


--VAJILLA
insert into vajilla values(nextval ('vajilla_uid_seq'),'Waima',6,'Diseño con ondas azules y verdes que evocan las aguas del río Negro, con detalles en dorado que representan las pepitas de oro que se encuentran en la región.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Guacamaya',4,'Diseño con plumas de guacamaya en colores rojo, amarillo y azul, con detalles en negro que representan los ojos del ave.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Samauma',2,'Diseño con escamas de caimán en verde oscuro y marrón, con detalles en dorado que representan los colmillos del animal.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Curupira',2,' Diseño con la corteza del árbol samauma en marrón oscuro, con detalles en verde que representan las hojas del árbol.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Cereza en Flor',6,'Diseño con flores de cerezo en tonos rosados y blancos, con detalles en rojo cereza que representan el fruto.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Jardín Rojo',4,'Diseño con un jardín de cerezos en flor, con árboles, flores y frutos en tonos rojos, rosados y verdes.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Dulce Fruta',4,'Diseño con cerezas maduras de diferentes tamaños y colores, con hojas verdes y detalles en blanco.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Rojo Pasión',2,'Diseño con un corazón rojo grande en el centro, rodeado de salpicaduras de rojo que representan la pasión.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Afternoon Tea',6,'Diseño con tazas de té, sándwiches, pasteles y otros elementos típicos del té de la tarde inglés.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Círculo de Willow',6,'Diseño con el patrón de sauce tradicional, un motivo popular en la cerámica inglesa.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Cabaña Cotswold',2,'Diseño con flores y plantas inspiradas en los famosos jardines de Sissinghurst.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Té de las Cinco',6,'Diseño con la imagen de una típica cabaña de piedra de Cotswold, con detalles en madera y tejas rojas.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Desayuno Ingles',6,' Diseño con huevos fritos, tocino, salchichas, frijoles horneados, champiñones, tomates y tostadas, los elementos clásicos de un desayuno inglés completo.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Huevos y Tocino',4,'Diseño con huevos fritos en diferentes estilos (fritos, revueltos, escalfados) y tiras de tocino crujiente.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Tostadas y Te',2,'Diseño con tostadas de diferentes tipos (pan blanco, pan integral, pan de centeno) con mantequilla, mermelada y miel.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Muesli y Frutos Secos',6,'Diseño con muesli de diferentes tipos (granola, avena, cereales) con frutas frescas, frutos secos y yogur');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Perla del Mar',4,'Diseño con una perla grande y brillante en el centro, rodeada de ondas delicadas en tonos blancos y plateados.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Conchas Marinas',2,'Diseño con diferentes tipos de conchas marinas en colores naturales, como blanco, beige y marrón.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Espuma de Mar',4,'Diseño con ondas blancas y delicadas que simulan la espuma de mar, con detalles en azul claro y verde turquesa.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Elegancia Costera',6,'Diseño con un patrón de rayas horizontales en tonos azul marino, blanco y beige, inspirado en las cabañas de playa.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Vida Urbana',2,'Diseño simple y funcional con bordes redondeados, ideal para el uso diario en cocinas modernas.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Cocina Inteligente',4,'Fabricados con materiales resistentes al calor, aptos para microondas, horno y lavavajillas, para mayor comodidad y facilidad de limpieza.');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Ahorro de Espacio',6,'Diseño apilable que permite optimizar el espacio de almacenamiento en gabinetes y alacenas. ');
insert into vajilla values(nextval ('vajilla_uid_seq'),'Materiales Sostenibles',6,'Fabricados con materiales resistentes a los golpes y rayones, aptos para lavavajillas industriales y domésticos.');

--PIEZA
insert into pieza values(1,nextval ('pieza_uid_seq'),'Inspirado en la belleza serena de Waima Gorge, este plato exquisito encarna la esencia de la armonía y el equilibrio.',90,7);
insert into pieza values(1,nextval ('pieza_uid_seq'),'Plato Guacamaya Tropical: Un festín de colores para tu mesa.',90,7);
insert into pieza values(1,nextval ('pieza_uid_seq'),'Plato Guacamaya Vibrante: Un lienzo para tus creaciones culinarias más coloridas.',90,7);
insert into pieza values(1,nextval ('pieza_uid_seq'),'Plato Guacamaya Exótica: Un toque de selva tropical en tu comedor.',90,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Guacamaya Emblemática: Un homenaje a la belleza de las aves tropicales.',90,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Guacamaya Artesanal: Un producto elaborado con pasión y cuidado.',90,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Guacamaya Refrescante: Disfruta de bebidas frías con un toque de color.',90,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Guacamaya Festiva: Comparte momentos alegres con tus seres queridos.',90,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Guacamaya Artesanal: Un producto elaborado con pasión y cuidado.',90,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Guacamaya Elegante: Un toque de sofisticación a tu mesa.',90,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Guacamaya Despertar: Comienza tu día con un toque de energía tropical.',90,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Guacamaya Relajante: Disfruta de tus bebidas calientes con un toque de tranquilidad.',90,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Guacamaya Creativa: Deja que tu imaginación vuele con cada sorbo.',90,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Guacamaya Aventurera: Un compañero perfecto para tus escapadas.',90,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Guacamaya Amigable: Un regalo ideal para tus seres queridos.',90,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Majestuosidad: Un tributo a la grandeza del árbol Samauma.',90,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Raíces: Un homenaje a la fuerza y la estabilidad.',120,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Abrazo: Un símbolo de unión y comunidad.',150,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Vida: Una celebración de la exuberancia de la selva amazónica.',20,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Artesanía: Un producto elaborado con técnicas ancestrales.',40,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Frescor: Disfruta de bebidas refrescantes con un toque de naturaleza.',140,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Armonía: Comparte momentos agradables con tus seres queridos.',130,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Equilibrio: Un toque de elegancia a tu mesa.',70,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Tradición: Un legado de artesanía y buen gusto.',60,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Durabilidad: Un producto que te acompañará en tus celebraciones.',50,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Despertar: Comienza tu día con un toque de energía natural.',70,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Inspiración: Deja que tu creatividad fluya con cada sorbo.',30,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Tranquilidad: Disfruta de tus bebidas calientes con un toque de paz.',10,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Conexión: Un símbolo de unión y comunidad.',70,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Recuerdo: Un regalo ideal para revivir momentos especiales.',10,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Majestuosidad: Un tributo a la grandeza del árbol Samauma.',240,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Raíces: Un homenaje a la fuerza y la estabilidad.',120,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Abrazo: Un símbolo de unión y comunidad.',90,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Vida: Una celebración de la exuberancia de la selva amazónica.',40,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Plato Samauma Artesanía: Un producto elaborado con técnicas ancestrales.',45,7);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Frescor: Disfruta de bebidas refrescantes con un toque de naturaleza.',72,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Armonía: Comparte momentos agradables con tus seres queridos.',95,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Equilibrio: Un toque de elegancia a tu mesa.',105,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Tradición: Un legado de artesanía y buen gusto.',300,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Jarra Samauma Durabilidad: Un producto que te acompañará en tus celebraciones.',45,1);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Despertar: Comienza tu día con un toque de energía natural.',50,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Inspiración: Deja que tu creatividad fluya con cada sorbo.',70,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Tranquilidad: Disfruta de tus bebidas calientes con un toque de paz.',60,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Conexión: Un símbolo de unión y comunidad.',40,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Recuerdo: Un regalo ideal para revivir momentos especiales.',30,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Alegría: Disfruta de tus bebidas calientes con una sonrisa.',20,8);
insert into pieza values (1,nextval ('pieza_uid_seq'),'Taza Samauma Sabor: Un toque de tradición amazónica en cada sorbo.',10,8);

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










