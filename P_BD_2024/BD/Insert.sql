/*
Este archivo va a contener todo lo respecto a las inserciones.
	Orden del documento:
		1-Tablas fuertes
		2-Intermedia
		3-Intercepción
Nota: Se ordenara segun el proceso en especifico que participa la tabla.
*/

/*----------Tablas Fuertes----------*/
--Proceso de Catalogo

--Proceso Venta

--Proceso de Control Empleado

/*----------Tablas Intermedia----------*/
--Proceso de Catalogo

--Proceso Venta

--Proceso de Control Empleado

/*----------Tablas Intercepción----------*/
--Proceso de Catalogo

--Proceso Venta

--Proceso de Control Empleado


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