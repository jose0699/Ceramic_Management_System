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
insert into departamento values(nextval('departamento_uid_seq'),'Gerencia Tecnica',2,'GE','Gerencia Tecnica de la planta',2);--4
insert into departamento values(nextval('departamento_uid_seq'),'Almacen de Insumos',3,'AL','Almacen de materiales de la empresa',2);--5
insert into departamento values(nextval('departamento_uid_seq'),'Seccion de Control de Calidad',3,'AL','Departamento para el control de la calidad de los productos',4);--6
insert into departamento values(nextval('departamento_uid_seq'),'Seccion de Mantenimiento',3,'AL','Departamento para el mantenimiento de las maquinas de la fabrica',4);--7
insert into departamento values(nextval('departamento_uid_seq'),'Almacen Producto Terminado',3,'AL','Almacen de todas las piezas terminadas',2);--8
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Seleccion','4','DE','Departamento que empaca los productos',4);--9
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Esmaltacion y Decoracion','4','DE','Departamento que decora las piezas seleccionadas',4);--10
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Colado y Refinado','4','DE','Departamento que cuela la mezcla y refina las piezas',4);--11
insert into departamento values (nextval('departamento_uid_seq'),'Departamento de Yeseria','4','DE','Departamento que provee de los moldes para las piezas',4);--12
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Rotomoldeo','4','DE','Departamento que provee la pieza',4);--13
insert into departamento values(nextval('departamento_uid_seq'),'Departamento de Preparacion Pasta','4','DE','Departamento que elabora los churros para las piezas',4);--14
insert into departamento values(nextval('departamento_uid_seq'),'Hornos','3','DE','Departamento de Hornos',4);--15

/* Gerentes */
insert into empleado values(nextval('empleado_exp_seq'),27474659,'2011-07-21','B-','F','Calle principal de la candelaria','ba','ge',3500,04149116300,1,'María','González','Pérez');-- General  1
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 28934567, '2001-10-24', 'A-', 'F', 'Calle El Triunfo, Res. Las Palmeras', 'ba','ge', 3500, 04167891234, 2, 'Ana', 'Romero', 'Vargas',1);-- Planta  2
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 29876543, '2004-04-25', 'B+', 'M', 'Avenida Bolívar, Urb. La Colina', 'ba','ge', 3500, 04243215678, 4, 'Daniel', 'Guerrero', 'Mendoza',2);-- Tecnica   3
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 30765432, '2010-05-30', 'O-', 'F', 'Calle Sucre, Barrio El Carmen', 'ba','ge', 3500, 04129876543, 1, 'Isabel', 'Álvarez', 'Ramírez');-- General   4
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 31654321, '2004-07-06', 'AB+', 'M', 'Avenida Miranda, Urb. Los Chorros', 'ba','ge', 3500, 04284563210, 1, 'Carlos', 'Flores', 'López');-- General   5
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 32543210, '1993-09-03', 'A-', 'F', 'Calle Vargas, Res. La Pradera', 'ba','ge', 3500, 04146543219, 2, 'Patricia', 'Sánchez', 'García',2);-- Planta   6
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 33432109, '1992-10-07', 'B+', 'M', 'Avenida Libertador, Urb. Las Mercedes', 'ba','ge', 3500, 04263215432, 1, 'Luis', 'Muñoz', 'Pérez');-- General   7
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 34321098, '1990-11-04', 'O-', 'F', 'Calle Falcón, Res. Los Cedros', 'ba','ge', 3500, 04127654321, 4, 'Carmen', 'Blanco', 'Martínez',3); -- Tecnica   8
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 35210987, '1997-12-08', 'AB+', 'M', 'Avenida Baralt, Urb. El Rosal', 'ba','ge', 3500, 04285674321, 4, 'Francisco', 'Gómez', 'Rodríguez',3);-- Tecnica   9

/* Supervisores */
insert into empleado values(nextval('empleado_exp_seq'),27748963,'2001-10-03','A+','M','Avenida Este cero','ind','el',1500,04149116305,10,'Carlos','Torres','Ramírez');--1  --10 --esmalte
insert into empleado values(nextval('empleado_exp_seq'),27474666,'2002-01-03','O-','M','Avenida Morat','ind','me',1500,04149116307,12,'Luis','Blanco','Fernández');--2  --11	--Yeseria
insert into empleado values(nextval('empleado_exp_seq'),27474665,'2009-02-03','B-','F','Calle Felicidad','ind','me',1500,04149116306,11,'Carolina','Sánchez','Martínez');--3  --12  --Colado
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27474667, '2024-06-03', 'O-', 'M', 'Avenida Morat', 'ind', 'me', 1500, 04149116307, 14, 'María', 'González', 'López');--4  --13  --Pasta
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27441986, '1994-05-20', 'O-', 'M', 'Avenida Trusk', 'ind', 'me', 1500, 04149116307, 9, 'Luis', 'Blanco', 'Rotos');--5  --14	--seleccion
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27365666, '1995-08-03', 'A-', 'M', 'Avenida Del Moratorio', 'ind', 'me', 1500, 04149116307, 15, 'Carlos', 'Blanco', 'Fernández');--6  --15	--hornos
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27364666, '1996-07-03', 'AB-', 'F', 'Avenida Morat', 'ind', 'me', 1500, 04149116307, 8, 'María', 'González', 'López');--7  --16		--terminado
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27363666, '2000-11-03', 'O-', 'M', 'Calle Real, 123', 'ind', 'me', 1500, 04149116307,7, 'Yuritza', 'Castillo', 'Rodriguez');--8  --17		--mantenimiento
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27362666, '2001-10-03', 'B+', 'M', 'Avenida Morat', 'ind', 'me', 1500, 04149116307, 5, 'Luis', 'Blanco', 'Fernández');--9  --18		--insumos
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27331986, '2004-02-03', 'A-', 'M', 'Avenida Morat', 'ind', 'me', 1500, 04149116307, 6, 'Jose', 'Maria', 'Blanco');--10  --19		--calidad
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27454666, '2002-05-20', 'B-', 'F', 'Calle Real, 123', 'ind', 'me', 1500, 04149116307, 13, 'María', 'Pérez', 'López');--11   --20	--rotomoldeo
INSERT INTO empleado VALUES (nextval('empleado_exp_seq'), 27000666, '2003-04-20', 'B-', 'F', 'Calle Encorium', 'ind', 'me', 1500, 04149116307, 4, 'María', 'Lorena', 'Lóongaza');--12   --21	--secretaria

/*  Secretaria  */
insert into empleado values(nextval('empleado_exp_seq'),27474658,'1991-12-03','A+','M','Avenida siempre viva','qui','se',2100,04149116299,3,'Marcello','Servitad','Jesus','Santos',21);--21
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 37485673, '1990-05-09', 'B-', 'F', 'Avenida Boulevard', 'qui','se', 2100, 04147896543, 3, 'Valentina', 'Harrison', 'Pérez',21 );--22
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 46321549, '1993-07-08', 'O+', 'M', 'Calle Principal', 'qui','se', 2100, 04265473210, 3, 'Alejandro', 'Guzmán', 'López',21 );--23
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 55210987, '2000-10-07', 'AB-', 'F', 'Avenida La Paz', 'qui','se', 2100, 04128765432, 3, 'Sandra', 'Mendoza', 'Martínez', 21);--24

/* Seccion de control  */--6
insert into empleado values(nextval('empleado_exp_seq'),27403661,'1997-11-03','A+','F','Calle Esperanza de la cruz','pro','in',1400,04149116302,6,'Ana','Romero','Flores',19);--25
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 36254321, '2010-03-05', 'B-', 'M', 'Avenida Universidad', 'pro','in', 1400, 04241234567, 6, 'Pedro', 'González', 'López', 19);--26

/* Seccion de mantenimiento*/--7
insert into empleado values(nextval('empleado_exp_seq'),20360661,'2010-06-03','A+','F','Calle Esperanza de la cruz','pro','el',850,04149116302,7,'Ana','Romero','Flores',17);--27
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 35147362, '1994-06-07', 'O+', 'M', 'Avenida Libertador', 'pro','me', 850, 04162345678, 7, 'Luis', 'Muñoz', 'García', 17);--28

/*  Almacen de insumos */--5
insert into empleado values(nextval('empleado_exp_seq'),27474661,'2006-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2000,04149116302,5,'Ana','Romero','Flores',18);--29
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 48372615, '2007-08-09', 'AB+', 'M', 'Avenida Morán','pro','og', 2000, 04283654721, 5, 'Carlos', 'Blanco', 'Méndez', 18);--30


/*Almacen de producto terminado */--8
insert into empleado values(nextval('empleado_exp_seq'),29568661,'2009-06-03','A+','F','Calle Esperanza de la cruz','pro','og',2900,04149116302,8,'Ana','Romero','Flores',16);--31
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 57261548, '2010-06-06', 'B-', 'F', 'Avenida Las Américas','pro','og', 2900, 04125432109, 8, 'María', 'Gómez', 'Pérez', 16);--32

/*  Operarios */
insert into empleado values(nextval('empleado_exp_seq'),27474660,'2002-04-03','O-','M','Avenida Libertad Solarium','ind','og',2600,04149116301,10,'Pedro','López','García',10);--33
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 34251432, '2001-06-09', 'A+', 'F', 'Calle Principal', 'ind','og', 2600, 04267345123, 10, 'Gabriela', 'Martínez', 'Silva',10 );--34
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 12548736, '2010-07-08', 'B-', 'M', 'Avenida Bolívar', 'ind','og', 2600, 04143256789, 11, 'Luis', 'Ramírez', 'Blanco',11 );--35
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 45721369, '2011-03-07', 'AB+', 'F', 'Calle Miranda', 'ind','og', 2600, 04281234567, 11, 'Andrea', 'Guerrero', 'Pérez', 11);--36
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 56832147, '2005-11-06', 'O-', 'M', 'Avenida Sucre', 'ind','og', 2600, 04165432109, 8, 'Carlos', 'Suárez', 'López', 16);--37
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 67943258, '2006-06-05', 'A+', 'F', 'Calle Vargas', 'ind','og', 2600, 04242345678, 8, 'Isabel', 'Muñoz', 'García', 16);--38
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 78054369, '2005-03-24', 'B-', 'M', 'Avenida Páez', 'ind','og', 2600, 04187654321, 13, 'Daniel', 'Romero', 'Flores', 11);--39
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 89165470, '2004-01-03', 'AB+', 'F', 'Calle Cedeño', 'ind','og', 2600, 04224321098, 13, 'Jennifer', 'Gómez', 'Pérez', 11);--40
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 10276581, '2001-07-02', 'O-', 'M', 'Avenida Falcón', 'ind','og', 2600, 04145678901, 14, 'José', 'López', 'García', 13);--41
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 11387692, '1990-05-01', 'A+', 'F', 'Calle Carabobo','ind','og', 2600, 04263456789, 14, 'María', 'Ramírez', 'Blanco', 13);--42
insert into empleado values(nextval('empleado_exp_seq'),27474669,'2003-06-03','B-', 'M','Avenida  Solarium','ind','og',2600,04149116301,9,'Paco','Gutierrez','García',14);--43
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 20509814, '2002-05-30', 'AB+', 'F', 'Calle Boyacá','ind','og', 2600, 04247654321, 9, 'Ana', 'Suárez', 'López',14 );--44

/* Horneros  */
insert into empleado values(nextval('empleado_exp_seq'),27474662,'2000-06-03','B-','M','Avenida Progreso movimiento','geo','ho',1900,0414911703,15,'Juan','Muñoz','Vega',15);--45
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 48362514, '1997-04-09', 'A+', 'F', 'Calle Libertad','geo','ho', 1900, 04283654721, 15, 'Gabriela', 'Pérez', 'García', 15);--46
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 59273645, '1999-06-08', 'B-', 'M', 'Avenida Morán','geo','ho', 1900, 04162345678, 15, 'Luis', 'Gómez', 'López',15 );--47
INSERT INTO empleado VALUES(nextval('empleado_exp_seq'), 60184756, '1998-06-07', 'AB+', 'F', 'Calle Miranda', 'geo','ho', 1900, 04241234567, 15, 'Andrea', 'Blanco', 'Méndez',15 );--48


/* resumen reunion */
insert into resumen_reunion values (12,'2024-06-04','Se comento sobre la productividad general de la fabrica');
insert into resumen_reunion values (13,'2024-08-04','asignacion de horarios del mes');
insert into resumen_reunion values (14,'2024-07-24','resumen de la semana');
insert into resumen_reunion values (12,'2024-02-09','resumen de la semana');
insert into resumen_reunion values (12,'2024-01-27','se chequeo el desempeño de esa semana');
insert into resumen_reunion values (14,'2024-03-08','se chequeo el desempeño de esa semana');
insert into resumen_reunion values (14,'2024-04-08','informacion sobre bonos');
insert into resumen_reunion values (13,'2024-03-08','resumen de la semana');
insert into resumen_reunion values (14,'2024-05-08','informacion sobre bonos');

/* reconocimiento*/
insert into reconocimiento values (1,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber llegado temprano al trabajo todos los dias del ultimo año');
insert into reconocimiento values (1,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber trabajado horas extras');
insert into reconocimiento values (2,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber llegado temprano al trabajo todos los dias del ultimo año');
insert into reconocimiento values (3,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber gestionado las mejores ventas del año');
insert into reconocimiento values (4,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber trabajado horas extras');
insert into reconocimiento values (5,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber trabajado horas extras');
insert into reconocimiento values (6,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber llegado temprano al trabajo todos los dias del ultimo año');
insert into reconocimiento values (7,nextval('reconocimiento_uid_seq'),'2024-06-04','por ser un empleado ejemplar');
insert into reconocimiento values (8,nextval('reconocimiento_uid_seq'),'2024-06-04','por haber trabajado horas extras');
insert into reconocimiento values (9,nextval('reconocimiento_uid_seq'),'2024-06-04','por ser un empleado ejemplar');

/*    horario */
insert into HIST_TURNO values (5,'2024-08-24',1);
insert into HIST_TURNO values (4,'2024-06-04',1);
insert into HIST_TURNO values (2,'2024-05-03',2);
insert into HIST_TURNO values (3,'2024-07-04',3);
insert into HIST_TURNO values (5,'2024-09-24',1);
insert into HIST_TURNO values (5,'2024-10-24',1);
insert into HIST_TURNO values (2,'2024-06-24',1);
insert into HIST_TURNO values (2,'2024-07-24',1);
insert into HIST_TURNO values (3,'2024-08-24',1);
insert into HIST_TURNO values (2,'2024-09-24',1);


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










