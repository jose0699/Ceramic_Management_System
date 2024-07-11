/*
Este archivo tiene la función de contener toda la información relacionada con las creacions y constrainst del proyecto;
se ordenara segun tres criterios, entres tablas fuertes, medianas y debiles(intercepción).
*/

--Tablas de Ubicación
BEGIN;
	CREATE TABLE PAIS (
		uid_pais numeric(2) not null,
		nombre varchar(40) not null,
		CONSTRAINT pk_pais PRIMARY KEY (uid_pais)
	);
COMMIT;
--------------------------------------------------------------------------------------------------------
--                                     Proceso de Empleado                                            --
--------------------------------------------------------------------------------------------------------

--Tablas Fuertes
BEGIN;
	CREATE TABLE ESTADO_SALUD(
		uid_salud numeric(4) not null,
		nombre varchar(40) not null,
		tipo varchar(1) not null,
		descripcion varchar(256),
		CONSTRAINT ck_tipo_estado CHECK(tipo in ('A', 'P')),
		CONSTRAINT pk_estado_salud PRIMARY KEY(uid_salud)
	);
COMMIT;
/*
	LEYENDA(TIPO):
	--A: Alergia
	--P: Particular
*/

BEGIN;
	CREATE TABLE DEPARTAMENTO (
		uid_departamento numeric(2) NOT NULL,
		nombre varchar(45) NOT NULL,
		nivel numeric(1) NOT NULL,
		tipo varchar(2) NOT NULL,
		descripcion varchar(65),
		uid_dep_padre numeric(2),
		CONSTRAINT cK_nivel_departamento CHECK (nivel BETWEEN 1 AND 4),
		CONSTRAINT tipo_departamento CHECK (tipo IN ('GE', 'SE', 'DE', 'AL')),
		CONSTRAINT fk_departamento FOREIGN KEY (uid_dep_padre) REFERENCES DEPARTAMENTO (uid_departamento), 
		CONSTRAINT pk_departamento PRIMARY KEY (uid_departamento)
	);
COMMIT;	
/*
	leyenda (tipo): 
	--GE: Gerencia
	--SE: Sección
	--DE: Departamento 
	--AL: Almacen
	
	leyenda (nivel):
	--1: Gerencia General
	--2: Gerencia Planta
	--3: GerenciaTecnica, Almacen
	--4: Seccion, Departamento
*/

BEGIN;
	CREATE TABLE EMPLEADO(
		num_expediente numeric(4) not null,
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
		CONSTRAINT check_genero CHECK (genero in ('M', 'F')),
		CONSTRAINT check_mension CHECK (titulo in ('ba','qui', 'mec', 'pro', 'ind', 'geo')),
		CONSTRAINT cargo_empleado CHECK (cargo in ('se', 'ge', 'me', 'in', 'og', 'el')),
		CONSTRAINT check_tipo_sangre CHECK(tipo_sangre in ('A+', 'O+', 'B+', 'AB+', 'A-','O-', 'B-', 'AB-')),
		CONSTRAINT fk_departamento FOREIGN KEY (trabaja) REFERENCES DEPARTAMENTO (uid_departamento),
		CONSTRAINT fk_supervisor FOREIGN KEY (supervisor) REFERENCES EMPLEADO (num_expediente),
		CONSTRAINT pk_empleado PRIMARY KEY (num_expediente)
	);
COMMIT;
/*
	Leyenda(genero):
	--M: Masculino
	--F: Femenino
	
	Leyenda(cargo):
	--se: Secretaria
	--ge: Gerente
	--me: Mecanico
	--in: Inspector
	--og: Obrero general
	--el: Electricista
	
	Leyenda(titulo):
	--ba: Bachiller
	--qui: Quimico
	--mec: Mecanico
	--pro: produccion
	--ind: Industrial
	--geo: Geologo
	*/
BEGIN;
	CREATE TABLE REUNION(
		num_expediente numeric(4) not null,
		fecha_hora date not null,
		resumen varchar(512) not null,
		CONSTRAINT fk_emp_resumen FOREIGN KEY (num_expediente) REFERENCES EMPLEADO (num_expediente),
		CONSTRAINT pk_resumen_reunion PRIMARY KEY( num_expediente, fecha_hora)
	);
COMMIT;
--Tablas Intermedias

BEGIN;
	CREATE TABLE HIST_TURNO(
		num_expediente numeric(4) not null,
		mesano date not null,
		turno numeric(1) not null,
		CONSTRAINT ck_turno_horario CHECK (turno BETWEEN 1 AND 3),
		CONSTRAINT fk_empleado_horario FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
		CONSTRAINT pk_horario PRIMARY KEY (num_expediente, mesano)
	);
COMMIT;

BEGIN;
	CREATE TABLE DET_EXP(
		num_exp numeric(4) not null,
		uid numeric(7) not null,
		fecha date not null,
		motivo varchar(2) not null,
		monto_bono numeric(8,2),
		retraso numeric(3),
		total_hora_extra numeric(3,2),
		descripcion varchar (126),
		CONSTRAINT motivo_det_exp CHECK (motivo in ('in', 'bm', 'ba', 'am', 'lt', 'he')),
		CONSTRAINT fk_empleado_det_exp FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
		CONSTRAINT pk_det_exp PRIMARY KEY (num_exp, uid)
	);
COMMIT;
/*
	Leyenda(DET_EXP):
	--in: Inasistencia
	--bm: Bono Mensual
	--ba: Bono Anual
	--am: amonestacion 
	--lt: LLegada Tarde
	--he: Horas Extras
*/
--Tablas intercepccion
BEGIN;
	CREATE TABLE INASISTENCIA(
		num_expediente_supervisor numeric(4) not null,
		fecha_hora date not null,
		num_expediente numeric(4) not null,
		CONSTRAINT fk_empleado_e_r FOREIGN KEY (num_expediente) REFERENCES EMPLEADO(num_expediente),
		CONSTRAINT fk_E_R_Reunion FOREIGN KEY (num_expediente_supervisor, fecha_hora) REFERENCES REUNION (num_expediente, fecha_hora),
		CONSTRAINT pk_e_r PRIMARY KEY (num_expediente_supervisor, fecha_hora, num_expediente)
	);
COMMIT;

BEGIN;
	CREATE TABLE E_E(
		num_exp numeric(4) not null,
		uid_salud numeric(3) not null,
		descripcion varchar(256),
		CONSTRAINT fk_empleado_e_e FOREIGN KEY (num_exp) REFERENCES EMPLEADO(num_expediente),
		CONSTRAINT fk_salud_e_e FOREIGN KEY (uid_salud) REFERENCES ESTADO_SALUD(uid_salud),
		CONSTRAINT pk_e_e PRIMARY KEY (num_exp, uid_salud)
	);
COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Catalogo                                            --
--------------------------------------------------------------------------------------------------------
--Tablas Fuertes

BEGIN;
	CREATE TABLE COLECCION(
		uid_coleccion numeric(2) not null,
		nombre varchar(40) not null UNIQUE,
		fecha_lanzamiento date not null, 
		linea varchar(1) not null,
		categoria varchar(3) not null,
		descripcion_mot_color varchar (512) not null,
		CONSTRAINT check_linea_coleccion CHECK(linea in ('I', 'F')),
		CONSTRAINT check_categoria_coleccion CHECK(categoria in ('cla', 'cou', 'mod')),
		CONSTRAINT pk_coleccion PRIMARY KEY(uid_coleccion)
	);
COMMIT;

BEGIN;
	CREATE TABLE MOLDE(
		uid_molde numeric(2) not null,
		tipo varchar (2) not null,
		tamaño varchar(10) not null,
		volumen numeric(3,2),
		cant_persona numeric(1),
		forma varchar(3),
		tipo_plato varchar(2),
		tipo_taza varchar(2),
		CONSTRAINT tipo_molde CHECK (tipo in ('JA', 'TT', 'LE', 'AZ', 'CA', 'BD', 'PL', 'TA', 'EN')),
		CONSTRAINT plato_molde CHECK (tipo_plato in ('HO', 'LL', 'PO', 'PA', 'PR', 'TT', 'TC','TM')),
		CONSTRAINT taza_molde CHECK (tipo_taza in ('CS', 'CC', 'TS', 'TC', 'MC', 'MS')),
		CONSTRAINT forma_molde CHECK (forma in ('red','rec','cua','ova')),
		CONSTRAINT pk_molde PRIMARY KEY (uid_molde)
	);
COMMIT;
/*
	Leyenda(tipo):
	--JA: Jarra
	--TT: Tetera
	--LE: Lechera
	--AZ: Azucarero
	--CA: Cazuela
	--BD: Bandeja
	--PL: Plato
	--TA: Taza
	--EN: Enzaladera

	Leyenda(tipo_plato):
	--HO: Hondo
	--LL: LLano
	--PO: Postre
	--PA: Pasta
	--PR: Presentación
	--TT: Taza Te
	--TC: Taza Cafe
	--TM: Taza Moka
	
	Leyenda(tipo_taza): 
	--CS: Cafe sin plato
	--CC: Cafe con plato
	--TS: Te sin plato
	--TC: Te con plato
	--MC: Moka con plato
	--MS: Moka sin plato
	
	Leyenda(forma):
	--red: Redondo
	--rec: Rectangular
	--cua: Cuadrado
	--ova: Ovalado
*/

BEGIN;
	CREATE TABLE VAJILLA (
		uid_juego numeric(3) not null,
		nombre varchar(60) not null, 
		capacidad numeric(1) not null,
		descripcion varchar(256),
		CONSTRAINT capacidad_vajilla CHECK (capacidad in (2,4,6)),
		CONSTRAINT pk_vajilla PRIMARY KEY (uid_juego)
	);
COMMIT;

--Tablas Intermedias
BEGIN;
	CREATE TABLE PIEZA (
		uid_coleccion numeric(2) not null,
		uid_pieza numeric(3) not null,
		descripcion varchar(256),
		precio numeric(8,2),
		uid_molde numeric(2) not null,
		CONSTRAINT fk_coleccion_pieza FOREIGN KEY (uid_coleccion) REFERENCES COLECCION(uid_coleccion),
		CONSTRAINT fk_molde_pieza FOREIGN KEY (uid_molde) REFERENCES MOLDE(uid_molde),
		CONSTRAINT pk_pieza PRIMARY KEY (uid_coleccion, uid_pieza)
	);
COMMIT;

BEGIN;
	CREATE TABLE FAMILIAR_HISTORICO_PRECIO(
		uid_coleccion numeric(2) not null,
		uid_pieza numeric(3) not null,
		fecha_inicio timestamp not null,
		precio numeric(8,2) not null,
		fecha_fin timestamp,
		CONSTRAINT fk_pieza_historico FOREIGN KEY (uid_coleccion ,uid_pieza) REFERENCES PIEZA (uid_coleccion, uid_pieza),
		CONSTRAINT pk_historico_precio PRIMARY KEY (uid_coleccion, uid_pieza, fecha_inicio)
	);
COMMIT;

BEGIN;
	CREATE TABLE DETALLE_PIEZA_VAJILLA (
		uid_juego numeric(3) not null,
		uid_coleccion numeric(2) not null,
		uid_pieza numeric(3) not null,
		cantidad numeric(2) not null,
		CONSTRAINT fk_juego_detalle FOREIGN KEY (uid_juego) REFERENCES VAJILLA (uid_juego),
		CONSTRAINT fk_pieza_detalle FOREIGN KEY (uid_coleccion, uid_pieza) REFERENCES PIEZA (uid_coleccion, uid_pieza),
		CONSTRAINT pk_detalle PRIMARY KEY (uid_coleccion, uid_juego, uid_pieza )
	);
COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Proceso de Venta                                               --
--------------------------------------------------------------------------------------------------------
--Tablas Fuertes

BEGIN;
	CREATE TABLE CLIENTE(
		uid_cliente numeric(3) not null,
		nombre varchar(50) not null,
		telefono varchar(15) not null,
		email varchar(256) not null,
		uid_pais numeric(2) not null,
		CONSTRAINT fk_pais_cliente FOREIGN KEY(uid_pais) REFERENCES PAIS(uid_pais),
		CONSTRAINT pk_cliente PRIMARY KEY(uid_cliente)
	);
COMMIT;

--Tabla Intermedias

BEGIN;
	CREATE TABLE CONTRATO(
		uid_cliente numeric(3) not null,
		num_contrato numeric(5) not null,
		porcentaje_descuento numeric(3) not null,
		fecha_hora_emision timestamp not null,
		fecha_hora_fin timestamp,
		CONSTRAINT fk_cliente_contrato FOREIGN KEY(uid_cliente) REFERENCES CLIENTE(uid_cliente),
		CONSTRAINT pk_contrato PRIMARY KEY ( uid_cliente, num_contrato)
	);
COMMIT;

BEGIN;
	CREATE TABLE PEDIDO(
		uid_cliente numeric(3) not null,
		uid_pedido numeric(6) not null,
		fecha_emision date not null,
		fecha_entrega date,
		fecha_entrega_deseada date not null,
		estado varchar(1) not null,
		tipo_pedido varchar(1) not null,
		CONSTRAINT check_estado_pedido CHECK(estado in ('A', 'C', 'E','P')),
		CONSTRAINT tipo_pedido CHECK (tipo_pedido in ('F', 'I')),
		CONSTRAINT fk_cliente_pedido FOREIGN KEY( uid_cliente) REFERENCES CLIENTE( uid_cliente),
		CONSTRAINT pk_pedido PRIMARY KEY( uid_cliente, uid_pedido)
	);
COMMIT;
/*
	Leyenda(estado):
	--A: Aprobado
	--C: Cancelado
	--E: Emitido
	--P: en Proceso

	Leyenda(tipo_pedido):
	--F: Familiar
	--I: Internacional
*/
--Tablas Intercepcion

BEGIN;	
	CREATE TABLE FACTURA (
		uid_cliente numeric(3) not null,
		uid_pedido numeric(6) not null,
		numero_factura numeric(6) not null,
		fecha_emision date not null,
		monto_total numeric(8,2) not null,
		CONSTRAINT unique_pedido UNIQUE (uid_pedido),
		CONSTRAINT fk_pedido FOREIGN KEY ( uid_cliente, uid_pedido) REFERENCES PEDIDO ( uid_cliente, uid_pedido),
		CONSTRAINT pk_factura PRIMARY KEY ( uid_cliente, uid_pedido, numero_factura)
	);
COMMIT;

BEGIN;
	CREATE TABLE DETALLE_PEDIDO_PIEZA (
		uid_cliente numeric(3) NOT NULL,
		uid_pedido numeric(6) NOT NULL, 
		uid_detalle numeric(8) NOT NULL,
		cantidad numeric(4) NOT NULL,
		uid_juego numeric(3),
		uid_coleccion numeric(3),
		uid_pieza numeric(3),
		CONSTRAINT check_exclusive_arcs CHECK ((uid_juego IS NOT NULL AND uid_pieza IS NULL AND uid_coleccion IS NULL)
										OR (uid_juego IS NULL AND uid_pieza IS NOT NULL AND uid_coleccion IS NOT NULL)),
		CONSTRAINT fk_juego_detalle_pedido FOREIGN KEY(uid_juego) REFERENCES VAJILLA(uid_juego),
		CONSTRAINT fk_pieza_detalle_pedido FOREIGN KEY (uid_coleccion, uid_pieza) REFERENCES PIEZA(uid_coleccion, uid_pieza),
		CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (uid_cliente, uid_pedido) REFERENCES PEDIDO (uid_cliente, uid_pedido),
		CONSTRAINT pk_detalle_pedido PRIMARY KEY (uid_cliente, uid_pedido, uid_detalle)
	);
COMMIT;
--------------------------------------------------------------------------------------------------------
--                                     Secuencia                                                      --
--------------------------------------------------------------------------------------------------------
	BEGIN; CREATE SEQUENCE pais_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE estado_salud_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE departamento_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE empleado_exp_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE det_exp_uid_seq START 1 INCREMENT BY 1; COMMIT;
	
	--BEGIN; CREATE SEQUENCE reconocimiento_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE coleccion_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE molde_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE vajilla_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE cliente_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE contrato_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE pieza_uid_seq START 1 INCREMENT BY 1; COMMIT;	
	BEGIN; CREATE SEQUENCE pedido_uid_seq START 1 INCREMENT BY 1; COMMIT;
	BEGIN; CREATE SEQUENCE factura_uid_seq START 1 INCREMENT BY 1; COMMIT;

--------------------------------------------------------------------------------------------------------
--                                     Update                                                         --
--------------------------------------------------------------------------------------------------------
	BEGIN; UPDATE PAIS SET uid_pais = nextval('pais_uid_seq'); COMMIT;
	BEGIN; UPDATE ESTADO_SALUD SET uid_salud = nextval('estado_salud_uid_seq'); COMMIT; 
	BEGIN; UPDATE DEPARTAMENTO SET uid_departamento = nextval('departamento_uid_seq'); COMMIT; 
	BEGIN; UPDATE EMPLEADO SET num_expediente = nextval('empleado_exp_seq'); COMMIT;
	BEGIN; UPDATE DET_EXP SET uid = nextval('det_exp_uid_seq'); COMMIT;
	BEGIN; UPDATE COLECCION SET uid_coleccion = nextval('coleccion_uid_seq'); COMMIT;
	BEGIN; UPDATE MOLDE SET uid_molde = nextval('molde_uid_seq'); COMMIT;
	BEGIN; UPDATE VAJILLA SET uid_juego = nextval('vajilla_uid_seq'); COMMIT;
	BEGIN; UPDATE CLIENTE SET uid_cliente = nextval('cliente_uid_seq'); COMMIT;
	BEGIN; UPDATE CONTRATO SET num_contrato = nextval('contrato_uid_seq'); COMMIT;
	BEGIN; UPDATE PIEZA SET uid_pieza = nextval('pieza_uid_seq'); COMMIT;
	BEGIN; UPDATE PEDIDO SET uid_pedido = nextval('pedido_uid_seq'); COMMIT;
	BEGIN; UPDATE FACTURA SET numero_factura = nextval('factura_uid_seq'); COMMIT;
	