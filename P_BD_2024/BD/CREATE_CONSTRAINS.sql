/*
Este archivo tiene la función de contener toda la información relacionada con las creacions y constrainst del proyecto;
se ordenara segun tres criterios, entres tablas fuertes, medianas y debiles(intercepción).
*/

--Tablas de Ubicación

CREATE TABLE PAIS (
    uid_pais serial not null,
    nombre varchar(100) not null,
    CONSTRAINT pk_pais PRIMARY KEY (uid_pais)
);

CREATE TABLE ESTADO (
    uid_pais int not null,
    uid_estado serial not null,
    nombre varchar(100) not null,
    CONSTRAINT fk_pais_estado FOREIGN KEY (uid_pais) REFERENCES PAIS(uid_pais),
    CONSTRAINT pk_estado PRIMARY KEY (uid_pais, uid_estado)
);

CREATE TABLE CIUDAD(
	uid_pais int not null,
	uid_estado int not null,
	uid_ciudad serial not null,
	nombre varchar(100) not null,
	CONSTRAINT fk_estado_ciudad FOREIGN KEY (uid_pais, uid_estado) REFERENCES ESTADO (uid_pais, uid_estado),
	CONSTRAINT pk_ciudad PRIMARY KEY (uid_pais, uid_estado, uid_ciudad)
);

--------------------------------------------------------------------------------------------------------
--                                         Tablas fuertes                                             --
--------------------------------------------------------------------------------------------------------


--Proceso de Empleado
--Tablas Fuertes
CREATE TABLE CARGO(
	uid_cargo serial not null,
	nombre varchar(60) not null, 
	salario_base float not null,
	CONSTRAINT salario_no_negativo check (salario_base >= 0),
	CONSTRAINT pk_cargo PRIMARY KEY (uid_cargo)
);

CREATE TABLE RESUMEN_REUNION(
	uid_resumen serial not null,
	fecha_hora timestamp not null,
	asunto varchar(100) not null,
	descripcion varchar(512) not null,
	CONSTRAINT pk_resumen_reunion PRIMARY KEY(uid_resumen)
);

CREATE TABLE ESTADO_SALUD(
	uid_salud serial not null,
	nombre varchar(100) not null,
	tipo char(1) not null,
	CONSTRAINT ck_tipo_estado CHECK(tipo in ('A', 'P')),
	CONSTRAINT pk_estado_salud PRIMARY KEY(uid_salud)
);

CREATE TABLE DEPARTAMENTO (
    uid_departamento serial not null,
    nombre varchar(100) not null,
    telefono varchar(20) not null,
    email varchar(256) not null,
    uid_dep_padre int,
    CONSTRAINT fk_departamento FOREIGN KEY (uid_dep_padre) REFERENCES DEPARTAMENTO (uid_departamento),
    CONSTRAINT pk_departamento PRIMARY KEY (uid_departamento)
);

CREATE TABLE EMPLEADO(
	num_expediente serial not null,
	num_cedula int not null UNIQUE,
	fecha_nacimiento date not null,
	tipo_sangre char(3)not null,
	genero char(1)not null,
	calle_avenida varchar(100) not null,
	mencion_profesional char(3) not null,
	primer_nombre varchar(60) not null,
	primer_apellido varchar(60) not null,
	segundo_nombre varchar(60),
	segundo_apellido varchar(60),
	uid_pais int not null,
	uid_estado int not null,
	uid_ciudad int not null,
	CONSTRAINT fk_ciudad_empleado FOREIGN KEY(uid_pais, uid_estado, uid_ciudad) REFERENCES CIUDAD (uid_pais, uid_estado, uid_ciudad),
	CONSTRAINT check_genero CHECK (genero in ('M', 'F')),
	CONSTRAINT check_tipo_sangre CHECK(tipo_sangre in ('A+', 'O+', 'B+', 'AB+', 'A-','O-', 'B-', 'AB-')),
	CONSTRAINT check_mension CHECK (mencion_profesional in ('qui', 'mec', 'pro', 'ind', 'geo')),
	CONSTRAINT pk_empleado PRIMARY KEY (num_expediente)
);

--Tablas Intermedias
CREATE TABLE AMONESTACION(
	num_expediente int not null,
	fecha date not null,
	motivo varchar(100) not null,
	CONSTRAINT fk_empleado_amonestacion FOREIGN KEY(num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_amonestacion PRIMARY KEY(num_expediente, fecha)
);

CREATE TABLE BONO(
	num_expediente int not null,
	uid_bono serial not null,
	fecha date,
	tipo char(2),
	CONSTRAINT check_tipo_bono CHECK(tipo in ('AD', 'AQ')),
	CONSTRAINT fk_empleado_bono FOREIGN KEY(num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_bono PRIMARY KEY (num_expediente, uid_bono)
);
 
CREATE TABLE RECONOCIMIENTO(
	num_expediente int not null,
	uid_reconocimiento serial not null,
	fecha date not null,
	descripcion varchar(256) not null,
	CONSTRAINT fk_empleado_reconocimiento FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_reconocimiento PRIMARY KEY(num_expediente, uid_reconocimiento)
);

CREATE TABLE HORARIO(
	num_expediente int not null,
	uid_horario serial not null,
	turno int not null,
	fecha_inicio timestamp not null,
	fecha_fin timestamp,
	CONSTRAINT fk_empleado_horario FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT check_turno CHECK (turno > 0 and turno < 4),
	CONSTRAINT check_fecha CHECK (fecha_inicio < fecha_fin),
	CONSTRAINT pk_horario PRIMARY KEY (num_expediente, uid_horario)
);

CREATE TABLE INASISTENCIA(
	num_expediente int not null,
	uid_inasistencia serial not null,
	fecha date,
	CONSTRAINT fk_empleado_inasistencia FOREIGN KEY(num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_inasistencia PRIMARY KEY(num_expediente, uid_inasistencia)
);

CREATE TABLE ATRASO_LLEGADA(
	num_expediente_atraso int not null,
	fecha date not null,
	hora_llegada time not null,
	horas_atraso time not null,
	num_expediente_cubre int not null,
	CONSTRAINT fk_empleado_atraso FOREIGN KEY(num_expediente_atraso) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_empleado_cubre FOREIGN KEY (num_expediente_cubre) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT check_empleado_distintos_atraso CHECK ( num_expediente_atraso <> num_expediente_cubre),
	CONSTRAINT pk_atraso PRIMARY KEY(num_expediente_atraso, fecha)
);

CREATE TABLE SUPERVISION(
	num_expediente_supervisor int not null,
	num_expediente_supervisado int not null,
	fecha_inicio timestamp not null,
	fecha_fin timestamp,
	CONSTRAINT fk_supervisor_supervision FOREIGN KEY(num_expediente_supervisor) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_supervisado_supervision FOREIGN KEY (num_expediente_supervisado) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT check_fecha_supervision CHECK(fecha_inicio < fecha_fin),
	CONSTRAINT check_no_igual_supervision CHECK(num_expediente_supervisor <> num_expediente_supervisado),
	CONSTRAINT pk_supervision PRIMARY KEY (num_expediente_supervisor, num_expediente_supervisado, fecha_inicio)
);

--Tablas intercepccion

CREATE TABLE C_D(
	uid_cargo int not null,
	uid_departamento int not null,
	CONSTRAINT fk_cargo FOREIGN KEY (uid_cargo) REFERENCES CARGO(uid_cargo),
	CONSTRAINT fk_departamento FOREIGN KEY(uid_departamento) REFERENCES DEPARTAMENTO(uid_departamento),
	CONSTRAINT pk_c_d PRIMARY KEY (uid_cargo, uid_departamento)
);

CREATE TABLE E_R(
	num_exp int not null,
	uid_resumen int not null,
	CONSTRAINT fk_empleado_e_r FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_resumen_e_r FOREIGN KEY (uid_resumen) REFERENCES RESUMEN_REUNION(uid_resumen),
	CONSTRAINT pk_e_r PRIMARY KEY (num_exp, uid_resumen)
);

CREATE TABLE E_E(
	num_exp int not null,
	uid_salud int not nulSl,
	CONSTRAINT fk_empleado_e_e FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_salud_e_e FOREIGN KEY (uid_salud) REFERENCES ESTADO_SALUD(uid_salud),
	CONSTRAINT pk_e_e PRIMARY KEY (num_exp, uid_salud)
);

CREATE TABLE HISTORICO_TRABAJO(
	num_exp int not null,
	uid_cargo int not null,
	uid_departamento int not null,
	fecha_inicio_trabajo timestamp not null,
	fecha_fin timestamp,
	supervisor bool,
	CONSTRAINT fk_empleado_historico FOREIGN KEY (num_exp) REFERENCES EMPLEADO (num_expediente),
	CONSTRAINT fk_c_d_historico FOREIGN KEY(uid_cargo, uid_departamento) REFERENCES C_D(uid_cargo, uid_departamento),
	CONSTRAINT check_fecha_historico CHECK(fecha_inicio_trabajo < fecha_fin),
	CONSTRAINT pk_historico PRIMARY KEY (num_exp, uid_cargo, uid_departamento, fecha_inicio_trabajo)
);

--Proceso de Catalogo
--Tablas Fuertes
CREATE TABLE COLOR(
	uid_color serial not null,
	nombre varchar(60) not null,
	CONSTRAINT pk_color PRIMARY KEY(uid_color)
);

CREATE TABLE ESTILO(
	uid_estilo serial not null,
	nombre varchar(100) not null,
	CONSTRAINT pk_estilo PRIMARY KEY(uid_estilo)
);

CREATE TABLE COLECCION(
	uid_coleccion serial not null,
	nombre varchar(60) not null UNIQUE,
	fecha_lanzamiento date not null, 
	linea char(1) not null,
	categoria char(3) not null,
	CONSTRAINT check_linea_coleccion CHECK(linea in ('I', 'F')),
	CONSTRAINT check_categoria_coleccion CHECK(categoria in ('cla', 'cou', 'mod')),
	CONSTRAINT pk_coleccion PRIMARY KEY(uid_coleccion)
);

CREATE TABLE MOLDE(
	uid_molde serial not null,
	tipo varchar(30) not null,
	alto float,
	largo float,
	capacidad int,
	unidad_capacidad char(1),
	forma char(3),
	CONSTRAINT no_negativo_alto_molde CHECK(alto > 0),
	CONSTRAINT no_negativo_largo_molde CHECK(largo > 0),
	CONSTRAINT no_negativo_capacidad_molde CHECK (capacidad > 0),
	CONSTRAINT check_unidad_molde CHECK (unidad_capacidad in ('P', 'I')),
	CONSTRAINT check_forma_molde CHECK (forma in ('red', 'rec', 'cua', 'ova')),
	CONSTRAINT pk_molde PRIMARY KEY (uid_molde)
);

--Tablas Intermedias
CREATE TABLE VAJILLA (
	uid_juego serial not null,
	nombre varchar(60) not null, 
	capacidad int not null,
	coleccion int not null,
	CONSTRAINT fk_coleccion_vajilla FOREIGN KEY (coleccion) REFERENCES COLECCION(uid_coleccion),
	CONSTRAINT check_capacidad_vajilla CHECK (capacidad > 0),
	CONSTRAINT pk_vajilla PRIMARY KEY (uid_juego)
);

CREATE TABLE PIEZA (
	uid_pieza serial not null,
	uid_coleccion int not null,
	uid_molde int not null,
	CONSTRAINT fk_coleccion_pieza FOREIGN KEY (uid_coleccion) REFERENCES COLECCION(uid_coleccion),
	CONSTRAINT fk_molde_pieza FOREIGN KEY (uid_molde) REFERENCES MOLDE(uid_molde),
	CONSTRAINT pk_pieza PRIMARY KEY (uid_pieza, uid_coleccion, uid_molde)
);


CREATE TABLE HISTORICO_PRECIO(
	uid_pieza int not null,
	uid_coleccion int not null,
	uid_molde int not null,
	fecha_inicio timestamp not null,
	precio_base float not null,
	fecha_fin timestamp,
	CONSTRAINT fk_pieza_historico FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA (uid_pieza, uid_coleccion, uid_molde),
	CONSTRAINT no_negativo_historico_precio CHECK (precio_base >= 0),
	CONSTRAINT fecha_historico_precio CHECK (fecha_inicio < fecha_fin),
	CONSTRAINT pk_historico_precio PRIMARY KEY (uid_pieza, uid_coleccion, uid_molde, fecha_inicio)
	
);

CREATE TABLE DETALLE_PIEZA_VAJILLA (
	uid_juego int not null,
	uid_pieza int not null,
	uid_coleccion int not null,
	uid_molde int not null,
	cantidad int not null,
	CONSTRAINT fk_juego_detalle FOREIGN KEY (uid_juego) REFERENCES VAJILLA (uid_juego),
	CONSTRAINT fk_pieza_detalle FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA (uid_pieza, uid_coleccion, uid_molde),
	CONSTRAINT no_negativo_pieza CHECK(cantidad > 0),
	CONSTRAINT pk_detalle PRIMARY KEY (uid_juego, uid_pieza, uid_coleccion, uid_molde )
);

CREATE TABLE C_C(
	uid_coleccion int not null,
	uid_color int not null,
	CONSTRAINT fk_coleccion_c_c FOREIGN KEY (uid_coleccion) REFERENCES COLECCION(uid_coleccion),
	CONSTRAINT fk_color_c_c FOREIGN KEY (uid_color) REFERENCES COLOR (uid_color),
	CONSTRAINT pk_c_c PRIMARY KEY(uid_coleccion, uid_color)
);

CREATE TABLE C_E(
	uid_coleccion int not null,
	uid_estilo int not null,
	CONSTRAINT fk_coleccion_c_e FOREIGN KEY (uid_coleccion) REFERENCES COLECCION(uid_coleccion),
	CONSTRAINT fk_estilo_c_e FOREIGN KEY (uid_estilo) REFERENCES ESTILO (uid_estilo),
	CONSTRAINT pk_c_e PRIMARY KEY (uid_coleccion, uid_estilo)
);

--Proceso de Venta
--Tablas Fuertes
CREATE TABLE HISTORICO_CONVERSION(
	uid_conversion serial not null,
	monto_conversion float not null,
	fecha_inicio timestamp not null,
	fecha_fin timestamp,
	CONSTRAINT check_no_negativo_conversion CHECK(monto_conversion >= 0),
	CONSTRAINT check_fecha_conversion CHECK(fecha_inicio < fecha_fin),
	CONSTRAINT pk_conversion PRIMARY KEY (uid_conversion)
);

CREATE TABLE CLIENTE(
	uid_pais int not null,
	dni varchar(20) not null,
	nombre varchar(100) not null,
	telefono varchar(20) not null,
	email varchar(256) not null,
	CONSTRAINT fk_pais_cliente FOREIGN KEY(uid_pais) REFERENCES PAIS(uid_pais),
	CONSTRAINT pk_cliente PRIMARY KEY(uid_pais, dni)
);

--Tabla Intermedias
CREATE TABLE CONTRATO(
	uid_pais int not null,
	dni varchar(20) not null,
	num_contrato serial not null,
	porcentaje_descuento int not null,
	fecha_hora_emision timestamp not null,
	fecha_hora_fin timestamp,
	CONSTRAINT fk_cliente_contrato FOREIGN KEY(uid_pais, dni) REFERENCES CLIENTE(uid_pais, dni),
	CONSTRAINT check_porcentaje_contrato CHECK(porcentaje_descuento > 0 and porcentaje_descuento <= 100),
	CONSTRAINT check_fecha_contrato CHECK(fecha_hora_emision < fecha_hora_fin),
	CONSTRAINT pk_contrato PRIMARY KEY (uid_pais, dni, num_contrato)
);

CREATE TABLE PEDIDO(
	uid_pais int not null,
	dni varchar(20) not null,
	uid_pedido serial not null,
	fecha_emision timestamp not null,
	fecha_entrega timestamp not null,
	estado char(1) not null,
	CONSTRAINT fk_cliente_pedido FOREIGN KEY(uid_pais, dni) REFERENCES CLIENTE(uid_pais, dni),
	CONSTRAINT check_estado_pedido CHECK(estado in ('A', 'C', 'E')),
	CONSTRAINT check_fecha_pedido CHECK(fecha_emision < fecha_entrega),
	CONSTRAINT pk_pedido PRIMARY KEY(uid_pais, dni, uid_pedido)
);

--Tablas Intercepcion
CREATE TABLE FACTURA (
    uid_pais int not null,
    dni varchar(20) not null,
    uid_pedido int not null,
    numero_factura serial not null,
    fecha_emision timestamp not null,
    monto_total float not null,
    uid_conversion int not null,
    CONSTRAINT fk_pedido FOREIGN KEY (uid_pais, dni, uid_pedido) REFERENCES PEDIDO (uid_pais, dni, uid_pedido),
    CONSTRAINT fk_conversion FOREIGN KEY (uid_conversion) REFERENCES HISTORICO_CONVERSION (uid_conversion),
    CONSTRAINT check_monto_factura CHECK (monto_total >= 0),
    CONSTRAINT pk_factura PRIMARY KEY (uid_pais, dni, uid_pedido, numero_factura)
);

CREATE TABLE DETALLE_PEDIDO_PIEZA(
	uid_pais int not null,
	dni varchar(20) not null,
	uid_pedido int not null, 
	uid_detalle serial not null,
	cantidad int not null,
	uid_juego int,
	uid_pieza int,
	uid_coleccion int,
	uid_molde int,
	CONSTRAINT fk_juego_detalle_pedido FOREIGN KEY(uid_juego) REFERENCES VAJILLA(uid_juego),
	CONSTRAINT fk_pieza_detalle_pedido FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA(uid_pieza, uid_coleccion, uid_molde),
	CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (uid_pais, dni, uid_pedido) REFERENCES PEDIDO (uid_pais, dni, uid_pedido),
	CONSTRAINT check_cantidad_detalle_pedido CHECK (cantidad > 0),
	CONSTRAINT pk_detalle_pedido PRIMARY KEY (uid_pais, dni, uid_pedido, uid_detalle)
);




