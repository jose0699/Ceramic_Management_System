/*
Este archivo tiene la función de contener toda la información relacionada con las creacions y constrainst del proyecto;
se ordenara segun tres criterios, entres tablas fuertes, medianas y debiles(intercepción).
*/

--Tablas de Ubicación

CREATE TABLE PAIS (
    uid_pais serial not null,
    nombre varchar(40) not null,
    CONSTRAINT pk_pais PRIMARY KEY (uid_pais)
);

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Empleado                                            --
--------------------------------------------------------------------------------------------------------

--Tablas Fuertes

CREATE TABLE ESTADO_SALUD(
	uid_salud serial not null,
	nombre varchar(40) not null,
	tipo varchar(1) not null,
	CONSTRAINT ck_tipo_estado CHECK(tipo in ('A', 'P')),
	CONSTRAINT pk_estado_salud PRIMARY KEY(uid_salud)
);

CREATE TABLE DEPARTAMENTO (
    uid_departamento serial not null,
    nombre varchar(30) not null,
    nivel numeric(1) not null,
	tipo varchar(2) not null,
	descripcion varchar(60),
    uid_dep_padre numeric(2),
	CONSTRAINT tipo_departamento CHECK (tipo in ('GE', 'SE', 'DE', 'AL')),
	CONSTRAINT nivel_departamento CHECK (nivel between 1 and 4),
    CONSTRAINT fk_departamento FOREIGN KEY (uid_dep_padre) REFERENCES DEPARTAMENTO (uid_departamento),
    CONSTRAINT pk_departamento PRIMARY KEY (uid_departamento)
);

CREATE TABLE EMPLEADO(
	num_expediente serial not null,
	num_cedula numeric(10) not null UNIQUE,
	fecha_nacimiento date not null,
	tipo_sangre varchar(3)not null,
	genero varchar(1)not null,
	calle_avenida varchar(100) not null,
	titulo varchar(3) not null,
	cargo varchar(2) not null,
	sueldo numeric (8,2) not null,
	telefono varchar(15) not null,
	trabaja numeric(2) not null,
	primer_nombre varchar(30) not null,
	primer_apellido varchar(30) not null,
	segundo_nombre varchar(30),
	segundo_apellido varchar(30),
	supervisor numeric(4),
	CONSTRAINT sueldo_empleado CHECK (sueldo >= 0),
	CONSTRAINT check_genero CHECK (genero in ('M', 'F')),
	CONSTRAINT cargo_empleado CHECK (cargo in ('se', 'ge', 'me', 'in', 'og', 'el')),
	CONSTRAINT check_tipo_sangre CHECK(tipo_sangre in ('A+', 'O+', 'B+', 'AB+', 'A-','O-', 'B-', 'AB-')),
	CONSTRAINT check_mension CHECK (titulo in ('ba','qui', 'mec', 'pro', 'ind', 'geo')),
	CONSTRAINT fk_departamento FOREIGN KEY (trabaja) REFERENCES DEPARTAMENTO (uid_departamento),
	CONSTRAINT fk_supervisor FOREIGN KEY (supervisor) REFERENCES EMPLEADO (num_expediente),
	CONSTRAINT pk_empleado PRIMARY KEY (num_expediente)
);

CREATE TABLE RESUMEN_REUNION(
	num_expediente numeric(4) not null,
	fecha_hora date not null,
	resumen varchar(512) not null,
	CONSTRAINT fk_emp_resumen FOREIGN KEY (num_expediente) REFERENCES EMPLEADO (num_expediente),
	CONSTRAINT pk_resumen_reunion PRIMARY KEY( num_expediente, fecha_hora)
);


--Tablas Intermedias
CREATE TABLE RECONOCIMIENTO(
	num_expediente numeric(4) not null,
	uid_reconocimiento serial not null,
	fecha date not null,
	descripcion varchar(64) not null,
	CONSTRAINT fk_empleado_reconocimiento FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_reconocimiento PRIMARY KEY(num_expediente, uid_reconocimiento)
);

CREATE TABLE HORARIO(
	num_expediente numeric(4) not null,
	mesano date not null,
	turno numeric(1) not null,
	CONSTRAINT check_turno CHECK (turno between 1 and 3),
	CONSTRAINT fk_empleado_horario FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_horario PRIMARY KEY (num_expediente, mesano)
);

CREATE TABLE DET_EXP(
	num_exp numeric(4) not null,
	uid serial not null,
	fecha date not null,
	motivo varchar(64) not null,
	monto_bono numeric(8.2),
	retraso numeric(3),
	total_hora_extra numeric(3,2),
	descripcion varchar (126),
	CONSTRAINT monto_bono_det_exp CHECK (monto_bono > 0),
	CONSTRAINT retraso_det_exp CHECK (retraso > 0),
	CONSTRAINT total_hora_det_exp CHECK (total_hora_extra > 0),
	CONSTRAINT motivo_det_exp CHECK (motivo in ('in', 'bm', 'ba', 'am', 'lt', 'he')),
	CONSTRAINT fk_empleado_det_exp FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT pk_det_exp PRIMARY KEY (num_exp, uid)
);

--Tablas intercepccion

CREATE TABLE E_R(
	num_expediente numeric(4) not null,
	fecha_hora date not null,
	num_exp_faltante numeric(4) not null,
	discripcion varchar(128),
	CONSTRAINT fk_empleado_e_r FOREIGN KEY (num_exp_faltante) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_resumen_e_r FOREIGN KEY (num_expediente, fecha_hora) REFERENCES RESUMEN_REUNION(num_expediente, fecha_hora),
	CONSTRAINT pk_e_r PRIMARY KEY (num_expediente, fecha_hora, num_exp_faltante)
);

CREATE TABLE E_E(
	num_exp numeric(4) not null,
	uid_salud numeric(3) not null,
	CONSTRAINT fk_empleado_e_e FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
	CONSTRAINT fk_salud_e_e FOREIGN KEY (uid_salud) REFERENCES ESTADO_SALUD(uid_salud),
	CONSTRAINT pk_e_e PRIMARY KEY (num_exp, uid_salud)
);

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Catalogo                                            --
--------------------------------------------------------------------------------------------------------
--Tablas Fuertes

CREATE TABLE COLECCION(
	uid_coleccion serial not null,
	nombre varchar(40) not null UNIQUE,
	fecha_lanzamiento date not null, 
	linea varchar(1) not null,
	categoria varchar(3) not null,
	descripcion_mot_color varchar (256) not null,
	CONSTRAINT check_linea_coleccion CHECK(linea in ('I', 'F')),
	CONSTRAINT check_categoria_coleccion CHECK(categoria in ('cla', 'cou', 'mod')),
	CONSTRAINT pk_coleccion PRIMARY KEY(uid_coleccion)
);

CREATE TABLE MOLDE(
	uid_molde serial not null,
	tipo varchar (2) not null,
	tamaño varchar(10) not null,
	volumen numeric(3,2) not null,
	cant_persona numeric(1),
	tipo_plato varchar(2),
	tipo_taza varchar(2),
	CONSTRAINT volumen_molde CHECK(volumen > 0),
	CONSTRAINT cant_persona_molde CHECK (cant_persona > 0),
	CONSTRAINT tipo_molde CHECK (tipo in ('JA', 'TT', 'LE', 'AZ', 'CA', 'BD', 'PL', 'TA', 'EN')),
	CONSTRAINT plato_molde CHECK (tipo_plato in ('HO', 'LL', 'PO', 'PA', 'PR', 'TT', 'TC')),
	CONSTRAINT taza_molde CHECK (tipo_taza in ('CS', 'CC', 'CT', 'TC', 'MC', 'MS')),
	CONSTRAINT pk_molde PRIMARY KEY (uid_molde)
);

CREATE TABLE VAJILLA (
	uid_juego serial not null,
	nombre varchar(60) not null, 
	capacidad numeric(1) not null,
	descripcion varchar(256),
	CONSTRAINT check_capacidad_vajilla CHECK (capacidad = 2 or capacidad = 4 or capacidad = 6),
	CONSTRAINT pk_vajilla PRIMARY KEY (uid_juego)
);

--Tablas Intermedias

CREATE TABLE PIEZA (
	uid_pieza serial not null,
	uid_coleccion numeric(2) not null,
	uid_molde numeric(2) not null,
	descripcion varchar(128),
	precio numeric(8,2),
	CONSTRAINT precio_pieza CHECK(precio >= 0),
	CONSTRAINT fk_coleccion_pieza FOREIGN KEY (uid_coleccion) REFERENCES COLECCION(uid_coleccion),
	CONSTRAINT fk_molde_pieza FOREIGN KEY (uid_molde) REFERENCES MOLDE(uid_molde),
	CONSTRAINT pk_pieza PRIMARY KEY (uid_pieza, uid_coleccion, uid_molde)
);


CREATE TABLE FAMILIAR_HISTORICO_PRECIO(
	uid_pieza numeric(3) not null,
	uid_coleccion numeric(2) not null,
	uid_molde numeric(2) not null,
	fecha_inicio timestamp not null,
	precio numeric(8,2) not null,
	fecha_fin timestamp,
	CONSTRAINT fk_pieza_historico FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA (uid_pieza, uid_coleccion, uid_molde),
	CONSTRAINT no_negativo_historico_precio CHECK (precio >= 0),
	CONSTRAINT fecha_historico_precio CHECK (fecha_inicio < fecha_fin),
	CONSTRAINT pk_historico_precio PRIMARY KEY (uid_pieza, uid_coleccion, uid_molde, fecha_inicio)
	
);

CREATE TABLE DETALLE_PIEZA_VAJILLA (
	uid_juego numeric(3) not null,
	uid_pieza numeric(3) not null,
	uid_coleccion numeric(2) not null,
	uid_molde numeric(2) not null,
	cantidad numeric(2) not null,
	CONSTRAINT no_negativo_pieza CHECK(cantidad > 0),
	CONSTRAINT fk_juego_detalle FOREIGN KEY (uid_juego) REFERENCES VAJILLA (uid_juego),
	CONSTRAINT fk_pieza_detalle FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA (uid_pieza, uid_coleccion, uid_molde),
	CONSTRAINT pk_detalle PRIMARY KEY (uid_juego, uid_pieza, uid_coleccion, uid_molde )
);

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Venta                                               --
--------------------------------------------------------------------------------------------------------
--Tablas Fuertes

CREATE TABLE CLIENTE(
	uid_cliente serial not null,
	nombre varchar(30) not null,
	telefono varchar(15) not null,
	email varchar(256) not null,
	uid_pais (2) not null,
	CONSTRAINT fk_pais_cliente FOREIGN KEY(uid_pais) REFERENCES PAIS(uid_pais),
	CONSTRAINT pk_cliente PRIMARY KEY(uid_cliente)
);

--Tabla Intermedias
CREATE TABLE CONTRATO(
	uid_cliente numeric(3) not null,
	num_contrato serial not null,
	porcentaje_descuento numeric(3) not null,
	fecha_hora_emision timestamp not null,
	fecha_hora_fin timestamp,
	CONSTRAINT fk_cliente_contrato FOREIGN KEY(uid_cliente) REFERENCES CLIENTE(uid_cliente),
	CONSTRAINT check_porcentaje_contrato CHECK(porcentaje_descuento between 1 and 100),
	CONSTRAINT check_fecha_contrato CHECK(fecha_hora_emision < fecha_hora_fin),
	CONSTRAINT pk_contrato PRIMARY KEY ( uid_cliente, num_contrato)
);

CREATE TABLE PEDIDO(
	uid_cliente numeric(3) not null,
	uid_pedido serial not null,
	fecha_emision timestamp not null,
	fecha_entrega timestamp,
	fecha_entrega_deseada timestamp not null,
	estado varchar(1) not null,
	tipo_pedido varchar(1) not null,
	CONSTRAINT check_estado_pedido CHECK(estado in ('A', 'C', 'E')),
	CONSTRAINT tipo_pedido CHECK (tipo_pedido in ('F', 'I')),
	CONSTRAINT check_fecha_pedido CHECK(fecha_emision < fecha_entrega_deseada AND fecha_emision < fecha_entrega),
	CONSTRAINT fk_cliente_pedido FOREIGN KEY( uid_cliente) REFERENCES CLIENTE( uid_cliente),
	CONSTRAINT pk_pedido PRIMARY KEY( uid_cliente, uid_pedido)
);

--Tablas Intercepcion
CREATE TABLE FACTURA (
    uid_cliente numeric(3) not null,
    uid_pedido int not null,
    numero_factura serial not null,
    fecha_emision timestamp not null,
    monto_total numeric(8,2) not null,
    CONSTRAINT check_monto_factura CHECK (monto_total >= 0),
    CONSTRAINT fk_pedido FOREIGN KEY ( uid_cliente, uid_pedido) REFERENCES PEDIDO ( uid_cliente, uid_pedido),
    CONSTRAINT pk_factura PRIMARY KEY ( uid_cliente, uid_pedido, numero_factura)
);

CREATE TABLE DETALLE_PEDIDO_PIEZA (
    uid_cliente numeric(3) NOT NULL,
    uid_pedido int NOT NULL, 
    uid_detalle serial NOT NULL,
    cantidad numeric(4) NOT NULL,
    uid_juego numeric(3),
    uid_pieza numeric(3),
    uid_coleccion numeric(3),
    uid_molde numeric(2),
    CONSTRAINT fk_juego_detalle_pedido FOREIGN KEY(uid_juego) REFERENCES VAJILLA(uid_juego),
    CONSTRAINT fk_pieza_detalle_pedido FOREIGN KEY (uid_pieza, uid_coleccion, uid_molde) REFERENCES PIEZA(uid_pieza, uid_coleccion, uid_molde),
    CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (uid_cliente, uid_pedido) REFERENCES PEDIDO (uid_cliente, uid_pedido),
    CONSTRAINT check_cantidad_detalle_pedido CHECK (cantidad > 0),
    CONSTRAINT check_exclusive_arcs CHECK ((uid_juego IS NOT NULL AND uid_pieza IS NULL AND uid_coleccion IS NULL AND uid_molde IS NULL)
                                        OR (uid_juego IS NULL AND uid_pieza IS NOT NULL AND uid_coleccion IS NOT NULL AND uid_molde IS NOT NULL)),
    CONSTRAINT pk_detalle_pedido PRIMARY KEY (uid_cliente, uid_pedido, uid_detalle)
);




