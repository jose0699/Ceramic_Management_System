/*
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
		CONSTRAINT check_estado_pedido CHECK(estado in ('A', 'C', 'E')),
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

	Leyenda(tipo_pedido):
	--F: Familiar
	--I: Internacional
*/
--Tablas Intercepcion

BEGIN;	
	CREATE TABLE FACTURA (
		uid_cliente numeric(3) not null,
		uid_pedido numeric(6) not null UNIQUE,
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
	
--------------------------------------------------------------------------------------------------------
--                                           Function                                                --
--------------------------------------------------------------------------------------------------------
--Proceso Venta
--EMPLEADO
--Numero 1	
BEGIN;
	CREATE OR REPLACE FUNCTION GERENCIA_EMPLEADO() RETURNS TRIGGER AS $$ BEGIN
		IF (NEW.cargo = 'ge') AND (new.titulo = 'ba') THEN
			RAISE EXCEPTION 'Error: Para ocupar el cargo de "Gerencia" debe tener la mención de Ingenieros Químicos, Mecánicos, de Producción, Industriales o Geólogos.';
		END IF;

		-- Obtener la fecha actual
		

		-- Calcular la diferencia en años
		IF (NEW.cargo = 'ge') AND (EXTRACT(DAY FROM NOW() - NEW.fecha_nacimiento) / 365) <= 35 THEN
			RAISE EXCEPTION 'Error: Para ocupar el cargo de "Gerencia" debe ser mayor o igual de 35 años.';
		END IF;

		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	-- Numero 2
BEGIN;
	CREATE OR REPLACE FUNCTION DEPARTAMENTO_EMPLEADO() RETURNS TRIGGER AS $$ 
	DECLARE 
		tipo_departamento varchar(2);
		nombre_departamento varchar(45);
	BEGIN
		SELECT d.tipo, d.nombre FROM DEPARTAMENTO d WHERE d.uid_departamento = NEW.trabaja INTO tipo_departamento, nombre_departamento;
		
		IF	(( tipo_departamento = 'GE') AND (NEW.cargo = 'ge') OR ((nombre_departamento = 'Secretaria') AND (NEW.cargo = 'se'))) OR 
			(( tipo_departamento = 'SE') AND (nombre_departamento = 'Mantenimiento') AND ((NEW.cargo = 'me') or (NEW.cargo = 'el'))) OR
			(( tipo_departamento = 'SE') AND (nombre_departamento = 'Control de Calidad') AND (NEW.cargo = 'in')) OR
			((tipo_departamento = 'DE' OR tipo_departamento = 'AL') AND (NEW.cargo = 'og')) THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Cargo no compatible con el Departamento.';
	END;
	$$ LANGUAGE plpgsql;
COMMIT;	
	
	--Numero 3
BEGIN;
	CREATE OR REPLACE FUNCTION SUPERVISOR_DEPARTAMENTO() RETURNS TRIGGER AS $$ 
	DECLARE
		supervisor numeric(4);
	BEGIN
		IF (NEW.cargo <> 'og') OR (new.cargo = 'og') AND (NEW.supervisor IS NULL) THEN 
			RETURN NEW;
		END IF;
		
		SELECT count(*) INTO supervisor FROM empleado e WHERE num_expediente = NEW.supervisor AND e.trabaja = NEW.trabaja;
		IF supervisor > 0 THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El supervisor y el Operario General, pertenecen a distintos departamentos.';		
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	--Numero 4
BEGIN;
	CREATE OR REPLACE FUNCTION NO_SUPERVISION() RETURNS TRIGGER AS $$ 
	Declare 
		cant_supervisados numeric (2);
	BEGIN
		IF (new.cargo <> 'og' and new.supervisor is null) THEN
			RETURN NEW;
		END IF;
		
		SELECT COUNT(*) INTO cant_supervisados FROM empleado e WHERE e.supervisor = NEW.supervisor AND e.supervisor is null; 
		IF ((new.cargo = 'og') AND ((cant_supervisados >= 0))) THEN
			RETURN NEW;		
		END IF;		 
		RAISE EXCEPTION 'Error: El empleado no puede tener supervisor.';
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
	--RESUMEN_REUNION
	--Numero 6
BEGIN;
	CREATE OR REPLACE FUNCTION REUNION_SUPERVISOR() RETURNS TRIGGER AS $$ 
	DECLARE
		supervisor numeric(4);
		cargo_actual varchar(2);
	BEGIN
		SELECT e.supervisor, e.cargo FROM EMPLEADO e WHERE e.num_expediente = NEW.num_expediente INTO supervisor, cargo_actual;
		
		IF (supervisor IS NULL) AND (cargo_actual = 'og') THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El empleado no es un supervisor.';
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	--INASISTENCIA 
	--Numero 7	
BEGIN;
	CREATE OR REPLACE FUNCTION SUPERVISION_CONGRUENTE() RETURNS TRIGGER AS $$
	DECLARE
		cantidad numeric(1);
	BEGIN
		SELECT count(*) INTO cantidad FROM empleado e WHERE e.num_expediente = NEW.num_expediente AND e.supervisor = NEW.num_expediente_supervisor;
		
		IF cantidad = 0 THEN 
			RAISE EXCEPTION 'Error: El empleado no está bajo la supervisión de este supervisor.';
		END IF;
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	
	/*
		Cuando se registre un id_empleado en la tabla, debe crearse un registro de inasistencia en la tabla de det_expediente.
	*/
	--Numero 8
BEGIN;
	CREATE OR REPLACE FUNCTION INASISTENCIA_REGISTRADA() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO det_exp VALUES (NEW.num_expediente, nextval('det_exp_uid_seq'), NEW.fecha_hora, 'in', NULL, NULL, NULL, 'Falto a la ruenión semanal.');
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	--DET_EXP
	--Numero 9
BEGIN;
	CREATE OR REPLACE FUNCTION DET_EXP_CAMPOS() RETURNS  TRIGGER AS $$
	DECLARE
	BEGIN
		IF  ((NEW.motivo = 'in' OR NEW.motivo = 'am') AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'bm' OR NEW.motivo = 'ba') AND (NEW.monto_bono IS NOT NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'lt') AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NOT NULL) AND (NEW.total_hora_extra IS NULL)) OR 
			((NEW.motivo = 'he')  AND (NEW.monto_bono IS NULL) AND(NEW.retraso IS NULL) AND (NEW.total_hora_extra IS NOT NULL)) OR THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Está ingresando información en un campo que no corresponde al motivo..';
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

	
		--Numero 11
BEGIN;
	CREATE OR REPLACE FUNCTION LH_TARDE_EXTRA() RETURNS TRIGGER AS $$
		DECLARE
		existe numeric(1);
		BEGIN
		--Revisa si es diferente a los campos a revisar
		IF (NEW.motivo <> 'lt') AND (NEW.motivo <> 'he') THEN
			RETURN NEW; 
		END IF;

		--Se realiza la consulta;
		Select COUNT(*) INTO existe FROM departamento d, empleado e WHERE d.uid_departamento = e.trabaja and  d.nombre = 'Hornos'  
		and e.num_expediente = NEW.num_exp;
		IF (existe <> 0) AND (NEW.motivo = 'lt') OR (NEW.motivo = 'he')THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: Motivo invalida, porque el empleado no es un Hornero.';
		END;
	$$ LANGUAGE plpgsql;
COMMIT;

		
	--HIST_TURNO
	--Numero 12
BEGIN;
	CREATE OR REPLACE FUNCTION HORNERO_CARGO() RETURNS TRIGGER AS $$
	DECLARE
		existe numeric(1);
	BEGIN
		Select COUNT(*) INTO existe FROM departamento d, empleado e WHERE d.uid_departamento = e.trabaja and  d.nombre = 'Hornos'  
		and e.num_expediente = NEW.num_expediente;
		IF existe = 1 THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Error: El empleado no es un Hornero.';
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

--------------------------------------------------------------------------------------------------------
--                                           Trigger                                                  --
--------------------------------------------------------------------------------------------------------
--Proceso Venta
	--EMPLEADO
	BEGIN; CREATE OR REPLACE TRIGGER GERENTE_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION GERENCIA_EMPLEADO();	COMMIT; --1
	BEGIN; CREATE OR REPLACE TRIGGER DEPARTAMENTO_CARGO_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION DEPARTAMENTO_EMPLEADO();	COMMIT; --2 
	BEGIN; CREATE OR REPLACE TRIGGER SUPERVISOR_DEPARTAMENTO_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION SUPERVISOR_DEPARTAMENTO();	COMMIT; --3
	BEGIN; CREATE OR REPLACE TRIGGER NO_SUPERVISION_EMPLEADO BEFORE INSERT OR UPDATE ON EMPLEADO FOR EACH ROW EXECUTE FUNCTION NO_SUPERVISION();	COMMIT; --4	
	
	--RESUMEN_REUNION
	BEGIN; CREATE OR REPLACE TRIGGER REUNION_SUPERVISOR BEFORE INSERT OR UPDATE ON REUNION FOR EACH ROW EXECUTE FUNCTION REUNION_SUPERVISOR();	COMMIT; --6
	
	--INASISTENCIA 
	BEGIN; CREATE OR REPLACE TRIGGER SUPERVISION_CONGRUENTE_INASISTENCIA BEFORE INSERT OR UPDATE ON REUNION FOR EACH ROW EXECUTE FUNCTION REUNION_SUPERVISOR();	COMMIT; --7
	BEGIN; CREATE OR REPLACE TRIGGER inasistencia_registrada AFTER INSERT ON inasistencia FOR EACH ROW EXECUTE FUNCTION INASISTENCIA_REGISTRADA();	COMMIT;--8
	--DET_EXP
	BEGIN; CREATE OR REPLACE TRIGGER CAMPO_DET_EXP BEFORE INSERT ON DET_EXP FOR EACH ROW EXECUTE FUNCTION DET_EXP_CAMPOS();	COMMIT; --9
	BEGIN; CREATE OR REPLACE TRIGGER  LLEGADA_TARDE_HORAS_EXTRAS_DET_EXP BEFORE INSERT ON DET_EXP FOR EACH ROW EXECUTE FUNCTION LH_TARDE_EXTRA();	COMMIT; --11

	--HIST_TURNO
	BEGIN; CREATE OR REPLACE TRIGGER HORNERO_CARGO_HIST_TURNO BEFORE INSERT ON HIST_TURNO FOR EACH ROW EXECUTE FUNCTION HORNERO_CARGO();	COMMIT; --12

--------------------------------------------------------------------------------------------------------
--                                           INDEX                                                    --
--------------------------------------------------------------------------------------------------------
--Proceso Catalogo
	BEGIN; CREATE INDEX PIE_MOLDE ON PIEZA(uid_molde);	COMMIT;

--Proceso Empleado
	BEGIN; CREATE INDEX EMP_SUPERVISOR ON EMPLEADO (supervisor);	COMMIT;
	BEGIN; CREATE INDEX EMP_DEP ON EMPLEADO(trabaja);	COMMIT;
	BEGIN; CREATE INDEX DEP_PADRE ON DEPARTAMENTO(uid_dep_padre);	COMMIT;

--Proceso Venta
	BEGIN; CREATE INDEX CLI_PAIS ON CLIENTE(uid_pais);	COMMIT;
	BEGIN; CREATE INDEX FAC_PEDIDO ON FACTURA (uid_cliente);	COMMIT;
	BEGIN; CREATE INDEX DET_PED_PIE_JUEGO ON DETALLE_PEDIDO_PIEZA(uid_juego);	COMMIT;
	BEGIN; CREATE INDEX DET_PED_PIE_PIEZA ON DETALLE_PEDIDO_PIEZA(uid_pieza, uid_coleccion);	COMMIT;

--------------------------------------------------------------------------------------------------------
--                                           VIEW                                                     --
--------------------------------------------------------------------------------------------------------
BEGIN;
	CREATE OR REPLACE VIEW nombres_moldes AS
		SELECT m.uid_molde, 
			CASE WHEN m.tipo = 'JA' THEN 'Jarra'
				WHEN m.tipo = 'TT' THEN 'Tetera'
				WHEN m.tipo = 'LE' THEN 'Lechera'
				WHEN m.tipo = 'AZ' THEN 'Azucarero'
				WHEN m.tipo = 'CA' THEN 'Cazuela'
				WHEN m.tipo = 'BD' THEN 'Bandeja'
				WHEN m.tipo = 'PL' THEN 'Plato'
				WHEN m.tipo = 'TA' THEN 'Taza'
				WHEN m.tipo = 'EN' THEN 'Ensaladera'
			END 

			||''||

			CASE WHEN m.tipo_plato = 'HO' THEN ' Hondo'
				WHEN m.tipo_plato = 'LL' THEN ' llano'
				WHEN m.tipo_plato = 'TT' THEN ' taza té'
				WHEN m.tipo_plato = 'TC' THEN ' taza café'
				WHEN m.tipo_plato = 'TM' THEN ' taza moka'
				WHEN m.tipo_plato = 'PO' THEN ' postre'
				WHEN m.tipo_plato = 'PR' THEN ' presentación'
				WHEN m.tipo_plato = 'PA' THEN ' pasta'
				ELSE ''
			END

			||''||

			CASE WHEN m.tipo_taza = 'CS' THEN ' café sin plato'
				WHEN m.tipo_taza = 'CC' THEN ' café con plato'
				WHEN m.tipo_taza = 'TS' THEN ' té sin plato'
				WHEN m.tipo_taza = 'TC' THEN ' té con plato'
				WHEN m.tipo_taza = 'MS' THEN ' moka sin plato'
				WHEN m.tipo_taza = 'MC' THEN ' moka sin plato'
				ELSE ''
			END

			||''||

			CASE WHEN m.forma = 'ova' THEN ' ovalado'
				 WHEN m.forma = 'rec' THEN ' rectangular'
				 WHEN m.forma = 'cua' THEN ' cuadrado'
				 WHEN m.forma = 'red' THEN ' redondo'
				 ELSE ''
			END

			||' '|| m.tamaño
			||''|| COALESCE(to_char(m.volumen,'9.9') || 'lts','')
			||''|| COALESCE(to_char(m.cant_persona,'9') || 'pers','')

			AS molde
		FROM molde m;  
COMMIT;

--------------------------------------------------------------------------------------------------------
--                                           Procedure                                                --
--------------------------------------------------------------------------------------------------------
--Programa 1
	BEGIN;
		CREATE OR REPLACE PROCEDURE insercionBonoMensualSupervisor(b_id_supervisor IN empleado.num_expediente%TYPE, mes_inicio date) AS $$
		DECLARE
			porcentaje_sup numeric(5,2);
			inac numeric(5,2);
			calculo  numeric(8,2);
		BEGIN
					porcentaje_sup:=porcentaje_ina_supervisor(b_id_supervisor,mes_inicio);
					inac:=100-porcentaje_sup;

					if(inac<=5) THEN
						SELECT e.sueldo into calculo from empleado e where e.num_expediente = b_id_supervisor;
						calculo:=(calculo*0.15);
					   insert into det_exp values (b_id_supervisor,nextval('det_exp_uid_seq'),current_date,'bm',calculo);
					end if;
		END;
		$$ LANGUAGE plpgsql;	
	COMMIT; 

	BEGIN;
		CREATE OR REPLACE PROCEDURE insercionBonoMensualSupervisores( mes_inicio date,id_dep in departamento.uid_departamento%TYPE) as $$
		DECLARE
			porcentaje_sup numeric(5,2);
			inac numeric(5,2);
			calculo  numeric(8,2);
			supervisores record;
		BEGIN
			for  supervisores  in SELECT e.num_expediente,  e.sueldo from empleado e, departamento d where d.uid_departamento=e.trabaja and  (e.supervisor is null and e.cargo='og') and  d.uid_departamento=id_dep
			LOOP
				porcentaje_sup:=porcentaje_ina_supervisor(supervisores.num_expediente,mes_inicio);
				inac:=100-porcentaje_sup;

				if(inac<=5) THEN
					calculo:=supervisores.sueldo;
					calculo:=(calculo*0.15);
				   insert into det_exp values (supervisores.num_expediente,nextval('det_exp_uid_seq'),current_date,'bm',calculo);
				end if;
			end LOOP;
		END;
		$$ LANGUAGE plpgsql;	
	COMMIT; 
--Fin Programa 1

--Programa 2
BEGIN;
	CREATE OR REPLACE PROCEDURE rotacion_turnos_horneros() AS $$
	DECLARE
		  h record;
			mes_anterior date;
	BEGIN
			SELECT MAX(mesano) into mes_anterior FROM hist_turno;

		  FOR h IN SELECT num_expediente, mesano, turno   
					  FROM hist_turno 
					  WHERE mesano = mes_anterior
		  LOOP
			INSERT INTO hist_turno values (h.num_expediente, h.mesano + interval '1 month', 
										   CASE
											   WHEN h.turno = 1 THEN 2
											   WHEN h.turno = 2 THEN 3
											   WHEN h.turno = 3 THEN 1
										   END);
		  END LOOP;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
--Programa 3
BEGIN;
	CREATE OR REPLACE PROCEDURE division_operarios_departamento(ndept IN departamento.nombre%TYPE) AS $$
		DECLARE
			num_operarios numeric(4);
			nivel_dept numeric(1);
			grupos_operarios numeric(4);
			op_por_grupo numeric(4);
			op_restantes numeric(4);

		BEGIN
			SELECT d.nivel INTO nivel_dept FROM departamento d WHERE UPPER(d.nombre) = UPPER(ndept);

			IF nivel_dept <> 4 OR nivel_dept is null THEN
					raise exception 'Error: El departamento solicitado no contiene operarios generales';
			END IF;

			SELECT COUNT(e.trabaja) INTO num_operarios FROM departamento d, empleado e WHERE d.uid_departamento = e.trabaja AND UPPER(d.nombre) = UPPER(ndept);

			grupos_operarios := floor((num_operarios / 10) + 1);
			op_por_grupo := floor(num_operarios / grupos_operarios);
			op_restantes:= num_operarios % grupos_operarios;

			CASE
				WHEN op_restantes = 0 THEN 
					raise notice 'Para el departamento de % se sugiere una división de: % grupos de % empleados, cada grupo con un operario como Supervisor', ndept, grupos_operarios, op_por_grupo;
				WHEN op_restantes <= op_por_grupo THEN
						raise notice 'Para el departamento de % se sugiere una división de % grupos: % grupos de % empleados, y % grupos de % empleados, cada grupo con un operario como Supervisor', ndept, grupos_operarios, grupos_operarios-op_restantes, op_por_grupo, op_restantes, op_por_grupo+1;
				ELSE
						raise notice 'Para el departamento de % se sugiere una división de % grupos: % grupos de 9 empleados, y % grupos de 10 empleados, cada grupo con un operario como Supervisor', ndept, grupos_operarios, grupos_operarios-op_restantes, grupos_operarios-(grupos_operarios-op_restantes);
			END CASE;
		END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
	
--Programa 4
BEGIN;
	CREATE OR REPLACE PROCEDURE actualizar_precio_coleccion (coleccion numeric(2), tasa_vieja numeric(8,2), tasa_nueva numeric(8,2)) AS $$
	BEGIN
		IF tasa_vieja > tasa_nueva THEN 
			UPDATE FAMILIAR_HISTORICO_PRECIO h SET precio = precio * (((100 * tasa_nueva)/ tasa_vieja)/100) WHERE uid_coleccion = coleccion AND fecha_fin is NULL;
		ELSE
			raise notice 'Nota: La tasa nueva supera el valor de la tasa anterior.';
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE PROCEDURE actualizar_precio(pieza numeric(3), tasa_vieja numeric(8,2), tasa_nueva numeric(8,2)) AS $$
	BEGIN
		IF tasa_vieja > tasa_nueva THEN 
			UPDATE FAMILIAR_HISTORICO_PRECIO h SET precio = precio * (((100 * tasa_nueva)/ tasa_vieja)/100)
						WHERE uid_pieza = pieza AND fecha_fin is NULL;
		ELSE
			raise notice 'Nota: La tasa nueva supera el valor de la tasa anterior.';
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
--Fin Programa 4

--Programa 5
BEGIN;
	CREATE OR REPLACE PROCEDURE chequear_despedido(expediente numeric(4), registro_fecha date) 
		AS $$
		DECLARE
		  contador numeric(2);
		BEGIN
			SELECT count(*) INTO contador FROM DET_EXP d WHERE d.num_exp = 28 
			AND d.motivo = 'am' 
			AND d.fecha BETWEEN (registro_fecha::date - INTERVAL '3 month') AND registro_fecha;

		  IF contador >= 3 THEN 
			RAISE EXCEPTION 'Nota: El empleado posee la cantidad de amonestaciones para su despido.';
		  ELSE
			RAISE NOTICE 'Nota: El empleado no posee la cantidad de amonestaciones para su despido.';
		  END IF;
		END;
	$$ LANGUAGE plpgsql;
COMMIT;


--Programa 9
BEGIN;
	CREATE OR REPLACE PROCEDURE insertar_amonestacion_supervisor(expediente_supervisor numeric(4), chequeo_supervisor date) AS $$
	DECLARE 
	  expediente RECORD;
	BEGIN
	  FOR expediente IN SELECT e.num_expediente FROM empleado e WHERE e.supervisor = expediente_supervisor LOOP
		CALL insertar_amonestaciones_basico(expediente.num_expediente, chequeo_supervisor);
	  END LOOP;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE PROCEDURE insertar_amonestaciones_basico(expediente numeric(4), chequeo date) AS $$ 
	DECLARE
	  num_inasistencias numeric(1);
	BEGIN
		num_inasistencias := contar_inasistencias(expediente, chequeo);
		
		IF num_inasistencias >= 3 THEN
			insert into det_exp values(expediente, nextval('det_exp_uid_seq'), CURRENT_DATE ,'am',null,null,null,'faltó 3 o más dias al trabajo en el mes');
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

--------------------------------------------------------------------------------------------------------
--                                            Function                                                --
--------------------------------------------------------------------------------------------------------

--Programa 6
BEGIN;
	CREATE OR REPLACE FUNCTION calcular_precio_vajilla(v_id_vaj IN detalle_pieza_vajilla.uid_juego%TYPE, v_id_col IN detalle_pieza_vajilla.uid_coleccion%TYPE, finc date) RETURNS numeric(8,2) AS $$
	DECLARE
		v record;
		linea varchar(10);
		precio_vaj numeric(8,2);
	BEGIN
		  precio_vaj := 0;
		  SELECT c.linea INTO linea FROM coleccion c WHERE c.uid_coleccion = v_id_col;

		  IF linea = 'I' THEN FOR v IN 
			  SELECT d.cantidad, p.precio FROM detalle_pieza_vajilla d, pieza p WHERE d.uid_pieza = p.uid_pieza  AND d.uid_juego = v_id_vaj AND d.uid_coleccion = v_id_col
			  LOOP
				  precio_vaj := precio_vaj + (v.precio*v.cantidad);
			  END LOOP;

		  ELSE linea = 'F' THEN;
			  FOR v IN 
				SELECT d.cantidad, f.precio FROM detalle_pieza_vajilla d, familiar_historico_precio f, pieza p 
							WHERE d.uid_pieza = p.uid_pieza  AND f.uid_pieza = p.uid_pieza AND (f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza, finc))
							AND d.uid_juego = v_id_vaj AND d.uid_coleccion = v_id_col
			  LOOP
				  precio_vaj := precio_vaj + (v.precio*v.cantidad);
			  END LOOP;
		  END IF;

		  RETURN precio_vaj - (precio_vaj * 0.15);
	  END;
	$$ LANGUAGE plpgsql;
COMMIT;

--Programa 7
BEGIN;
	CREATE OR REPLACE FUNCTION obtener_dias_no_laborales() RETURNS numeric(2) AS $$
	DECLARE
		dias_no_laborales numeric(2);
		dias_feriados numeric(1);
	BEGIN
	   /*
		 Esta SELECT genera una serie con la cual se obtienen los dias del mes_inicio y se le extraen a através del campo DOW(days of weekend)
		 los domingos, que son días que la fábrica no está operativa
	   */
		  SELECT count(*) INTO dias_no_laborales FROM generate_series(date_trunc('month', now()), 
					date_trunc('month', now()) + '1 month'::interval - '1 day'::interval, '1 day'::interval) dias_laborales(d)
		  WHERE extract(DOW FROM dias_laborales.d) IN (0);

		  -- Se verifica en caso de ser un mes con feriado
		  SELECT CASE 
			WHEN to_char(current_date,'MM') = '12' THEN 3
			WHEN to_char(current_date, 'MM') = '01' THEN 1
			WHEN to_char(current_date, 'MM') = '05' THEN 1
			ELSE 0
		  END INTO dias_feriados;

		  dias_no_laborales := dias_no_laborales + dias_feriados;

		  RETURN dias_no_laborales;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION obtener_dias_laborales(v_cargo varchar(2), v_departamento numeric(2)) RETURNS numeric(2) AS $$
	DECLARE
		dias_laborales numeric;
	BEGIN
		SELECT date_part('days', date_trunc('month', now()) + '1 month'::interval - '1 day'::interval)::numeric INTO dias_laborales;

		IF(v_cargo = 'og' AND v_departamento = 15) THEN
			RETURN dias_laborales;
		END IF; 
		  dias_laborales := dias_laborales - obtener_dias_no_laborales();
		RETURN dias_laborales;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;


BEGIN;
	CREATE OR REPLACE FUNCTION contar_inasistencias(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(4) AS $$
	DECLARE
		mes_fin date;
		n_inasistencias numeric(4);
	BEGIN
		  mes_fin := mes_inicio + interval '1 month' - interval '1 day';
		  SELECT COUNT(d.num_exp) INTO n_inasistencias FROM det_exp d WHERE d.num_exp = v_id_empleado AND fecha BETWEEN mes_inicio AND mes_fin;
		  RETURN n_inasistencias;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION porcentaje_inasistencia_empleado(v_id_empleado IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(5,2) AS $$
	DECLARE
		dias_laborales numeric(2);
		inasistencias numeric(2);
		porcentaje_inac numeric(5,2);
		v_cargo varchar(2);
		v_departamento numeric(2);
	BEGIN
		   SELECT e.cargo, e.trabaja FROM EMPLEADO e WHERE e.num_expediente = v_id_empleado INTO v_cargo, v_departamento;

		  dias_laborales := obtener_dias_laborales(v_cargo, v_departamento); 
		  inasistencias := contar_inasistencias(v_id_empleado,mes_inicio);
		  porcentaje_inac := 100-(inasistencias/dias_laborales) * 100;

		  RETURN porcentaje_inac;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION porcentaje_ina_supervisor(v_id_supervisor IN empleado.num_expediente%TYPE, mes_inicio date) RETURNS numeric(5,2) AS $$
	DECLARE
		porcentaje_inac numeric(5,2);
	BEGIN

		  SELECT AVG(porcentaje_inasistencia_empleado(e.num_expediente, mes_inicio)) INTO porcentaje_inac FROM empleado e WHERE e.supervisor = v_id_supervisor;
		  RETURN porcentaje_inac;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
--Fin del programa 7
--Programa 8
BEGIN;
	CREATE OR REPLACE FUNCTION mostrar_empleados_departamento(nom_dept IN departamento.nombre%TYPE) RETURNS
			TABLE (	id_departamento numeric(2)
							, nombre_departamento text 
							, numero_expediente_empleado numeric(4)
							, nombre_completo_empleado text
							, cargo text
				  )
	AS $$
	BEGIN
		RETURN QUERY SELECT d.uid_departamento,
									UPPER(d.nombre) nombre_departamento,
									e.num_expediente,
									CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre_empleado,
									CASE
										WHEN e.cargo = 'se' THEN 'Secretaria'
										WHEN e.cargo = 'ge'	THEN 'Gerente'
										WHEN e.cargo = 'me' THEN 'Mecánico'
										WHEN e.cargo = 'in'	THEN 'Inspector'
										WHEN e.cargo = 'el' THEN 'Electricista'
										WHEN e.cargo = 'og'	THEN 'Operario General'
									END cargo
								FROM empleado e, departamento d	WHERE  d.uid_departamento = e.trabaja AND	 UPPER(d.nombre) = UPPER(nom_dept);
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION mostrar_supervisores_departamento(nom_dept IN departamento.nombre%TYPE) RETURNS
			TABLE (	id_departamento numeric(2)
							, nombre_departamento text 
							, numero_expediente_empleado numeric(4)
							, nombre_completo_supervisor text
				  )
	AS $$
	DECLARE
		nivel numeric(1);
	BEGIN
		SELECT d.nivel INTO nivel FROM departamento d WHERE UPPER(d.nombre) = UPPER(nom_dept);

		IF nivel <> 4 THEN 
		  raise exception 'Error: El departameno Solicitado no es un departamento que contenga Supervisores';
		  RETURN QUERY SELECT;
		END IF;

		IF nivel is null THEN
		  raise exception 'Error: El departameno Solicitado no existe';
		  RETURN QUERY SELECT;
		END IF;

			RETURN QUERY SELECT
					d.uid_departamento,
					UPPER(d.nombre), e.num_expediente,
					CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))
					FROM empleado e, departamento d WHERE  d.uid_departamento = e.trabaja
				  AND  (d.nivel = 4 AND e.supervisor is NULL AND e.cargo = 'og') AND UPPER(d.nombre) = UPPER(nom_dept);
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
BEGIN;
	CREATE OR REPLACE FUNCTION mostrar_supervisados_supervisor(v_uid_supervisor IN empleado.num_expediente%TYPE) RETURNS
			TABLE (	id_departamento numeric(2)
							, nombre_departamento text 
							, numero_expediente_empleado numeric(4)
							, nombre_completo_empleado text
				, nombre_completo_supervisor text
				  )
	AS $$
	DECLARE
		esSupervisor numeric(1);
		cargo varchar(2);
		supervisor numeric(4);
		nombreSupervisor text;
	BEGIN
		  --Se verifica que el empleado sea un supervisor
		  SELECT e.cargo, e.supervisor, CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))
		  INTO cargo, supervisor, nombreSupervisor FROM empleado e WHERE e.num_expediente = v_uid_supervisor;

		  IF (cargo <> 'og') OR (supervisor IS NOT NULL) THEN
			raise exception 'Error: El empleado solicitado no es supervisor';
			RETURN QUERY SELECT;
		  END IF;

			SELECT COUNT(e.num_expediente) INTO esSupervisor
				FROM empleado e, empleado s WHERE s.num_expediente = e.supervisor AND e.supervisor = v_uid_supervisor;

		  IF esSupervisor = 0 THEN
			raise exception 'Error: El empleado solicitado no es supervisor';
			RETURN QUERY SELECT;
		  END IF;

		  RETURN QUERY SELECT d.uid_departamento,
					  UPPER(d.nombre),
					  e.num_expediente,
					  CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')),
					  nombreSupervisor
					FROM empleado e, departamento d
					WHERE  d.uid_departamento = e.trabaja AND  e.supervisor = v_uid_supervisor;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;


	---Mostrar Catalogo
BEGIN;
	CREATE OR REPLACE FUNCTION mostrar_colecciones(tipo_linea varchar(20)) RETURNS
			TABLE (	id_coleccion numeric(2)
							, nombre_coleccion varchar(40) 
							, categoria text
				  )
	AS $$
	BEGIN
		  tipo_linea := UPPER(substring(tipo_linea FROM 1 FOR 1));

		  RETURN QUERY SELECT c.uid_coleccion, c.nombre,
						CASE
						  WHEN c.categoria = 'cou' THEN 'Country'
						  WHEN c.categoria = 'cla' THEN 'Clásica'
						  WHEN c.categoria = 'mod' THEN 'Moderna'
						END
					FROM coleccion c WHERE  c.linea = tipo_linea;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION mostrar_piezas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE) RETURNS
			TABLE (	  nombre_coleccion varchar(40) 
				, uid_pieza  numeric(3) 
				, molde text
				  )
	AS $$
	BEGIN
		RETURN QUERY SELECT c.nombre coleccion, p.uid_pieza, m.molde
				FROM coleccion c, nombres_moldes m, pieza p WHERE c.uid_coleccion = p.uid_coleccion AND m.uid_molde = p.uid_molde AND c.uid_coleccion = v_id_coleccion;
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION mostrar_vajillas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE) RETURNS
			TABLE (	  nombre_coleccion varchar(40) 
				, uid_pieza  numeric(3) 
				, nombre_vajilla varchar(60)
				  )
	AS $$
	BEGIN
		RETURN QUERY SELECT DISTINCT c.nombre, v.uid_juego, v.nombre
				FROM coleccion c, detalle_pieza_vajilla d, vajilla v
				WHERE c.uid_coleccion = d.uid_coleccion AND v.uid_juego = d.uid_juego AND c.uid_coleccion = v_id_coleccion;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
--Fin de Programa 8

--------------------------------------------------------------------------------------------------------
--   Funciones y Procedimientos Menores       (Apoyo a inserciones, obtener tablas según parametros) --
--------------------------------------------------------------------------------------------------------

--Se utiliza en el BACK
BEGIN;
	CREATE OR REPLACE FUNCTION insertar_vajilla(nombre varchar(60), capacidad numeric(1), descripcion varchar(256)) returns numeric(3) AS $$ 
	BEGIN
		INSERT INTO vajilla values(nextval ('vajilla_uid_seq'),nombre, capacidad, descripcion);
		return lastval();
	END;
	$$ LANGUAGE plpgsql;
COMMIT;


BEGIN;
	CREATE OR REPLACE PROCEDURE insert_pieza(coleccion numeric(2), descripcion varchar(256), precio numeric(8,2), uid_molde numeric(2)) AS $$
	DECLARE
		linea_coleccion varchar(1);
		new_uid_pieza numeric(3);
	BEGIN
		SELECT  c.linea INTO linea_coleccion FROM coleccion c WHERE c.uid_coleccion = coleccion;

		IF linea_coleccion = 'F' THEN 
			INSERT INTO pieza VALUES (coleccion,nextval ('pieza_uid_seq'),descripcion,precio,uid_molde); 
			new_uid_pieza := lastval();

			INSERT INTO familiar_historico_precio values(coleccion, new_uid_pieza ,CURRENT_DATE , precio, NULL);
		ELSE
			INSERT INTO pieza VALUES (coleccion,nextval ('pieza_uid_seq'),descripcion,precio,uid_molde);		
		END IF;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
--	Fin de programas que se utilizan en el back
--Utilizado en reporte
BEGIN;
	CREATE OR REPLACE FUNCTION obtener_fecha_historico(v_id_pieza IN pieza.uid_pieza%TYPE,ffinc date) RETURNS date AS $$
	DECLARE
		fecha_hist date;
		v_fecha timestamp;
	BEGIN
		v_fecha:=ffinc::timestamp;
		SELECT MAX(f.fecha_inicio)::date INTO fecha_hist FROM familiar_historico_precio f WHERE f.uid_pieza = v_id_pieza AND f.fecha_inicio<=v_fecha;

		RETURN fecha_hist;
	END;
	$$ LANGUAGE plpgsql;
COMMIT;

BEGIN;
	CREATE OR REPLACE FUNCTION datos_piezas_coleccion(v_id_coleccion IN coleccion.uid_coleccion%TYPE, finc date) RETURNS 
  TABLE 
               (uid_pieza  numeric(3)   
               , coleccion varchar(40)
               , molde text
               , precio numeric(8,2)
               , linea text
               , categoria text)
AS $$
  DECLARE
    linea varchar(10);
  BEGIN
        SELECT	c.linea INTO linea
        FROM coleccion c
        WHERE c.uid_coleccion = v_id_coleccion;


    		IF linea = 'F' THEN
          RETURN QUERY
            SELECT p.uid_pieza, 
                c.nombre coleccion, 
                m.molde, 
                f.precio,
                CASE
                  WHEN c.linea = 'F' THEN 'Familiar'
                  WHEN c.linea = 'I' THEN 'Institucional'
                END linea,
                CASE
                  WHEN c.categoria = 'cou' THEN 'Country'
                  WHEN c.categoria = 'cla' THEN 'Clásica'
                  WHEN c.categoria = 'mod' THEN 'Moderna'
                END categoria
            FROM coleccion c, nombres_moldes m, familiar_historico_precio f, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND c.uid_coleccion = f.uid_coleccion AND f.uid_pieza = p.uid_pieza
            AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,finc)
            AND c.uid_coleccion = v_id_coleccion
            ORDER BY c.uid_coleccion, p.uid_pieza ASC;
            
        ELSE

          RETURN QUERY
            SELECT p.uid_pieza, 
                c.nombre coleccion, 
                m.molde, 
                p.precio,
                CASE
                  WHEN c.linea = 'F' THEN 'Familiar'
                  WHEN c.linea = 'I' THEN 'Institucional'
                END linea,
                
                CASE
                  WHEN c.categoria = 'cou' THEN 'Country'
                  WHEN c.categoria = 'cla' THEN 'Clásica'
                  WHEN c.categoria = 'mod' THEN 'Moderna'
                END categoria
            FROM coleccion c, nombres_moldes m, pieza p
            WHERE c.uid_coleccion = p.uid_coleccion
            AND m.uid_molde = p.uid_molde
            AND c.uid_coleccion = v_id_coleccion
            ORDER BY c.uid_coleccion, p.uid_pieza ASC;
        END IF;
  END;
	$$ LANGUAGE plpgsql;
COMMIT;
	
BEGIN;
	CREATE OR REPLACE FUNCTION datos_pieza(v_id_pieza IN pieza.uid_pieza%TYPE,v_id_coleccion IN coleccion.uid_coleccion%TYPE, finc date) RETURNS 
	  TABLE 
				   (uid_pieza  numeric(3)   
				   , coleccion varchar(40)
				   , molde text
				   , precio numeric(8,2)
				   , linea text
				   , categoria text
				   , forma text
				   , descripcion varchar(256))
	AS $$
	  DECLARE
		linea varchar(10);
	  BEGIN
			SELECT	c.linea INTO linea
			FROM coleccion c
			WHERE c.uid_coleccion = v_id_coleccion;


				IF linea = 'F' THEN
			  RETURN QUERY
				SELECT p.uid_pieza, 
					c.nombre coleccion, 
					m.molde, 
					f.precio,
					CASE
					  WHEN c.linea = 'F' THEN 'Familiar'
					  WHEN c.linea = 'I' THEN 'Institucional'
					END linea,
					CASE
					  WHEN c.categoria = 'cou' THEN 'Country'
					  WHEN c.categoria = 'cla' THEN 'Clásica'
					  WHEN c.categoria = 'mod' THEN 'Moderna'
					END categoria,
					CASE 
					  WHEN mo.forma = 'ova' THEN 'Ovalada'
					  WHEN mo.forma = 'rec' THEN 'Rectangular'
					  WHEN mo.forma = 'cua' THEN 'Cuadrado'
					  WHEN mo.forma = 'red' THEN 'Redondo'
					  ELSE ''
					END forma,
					p.descripcion
				FROM coleccion c, molde mo, nombres_moldes m, familiar_historico_precio f, pieza p
				WHERE c.uid_coleccion = p.uid_coleccion
				AND p.uid_pieza = v_id_pieza
				AND m.uid_molde = p.uid_molde
				AND mo.uid_molde = p.uid_molde
				AND c.uid_coleccion = f.uid_coleccion AND f.uid_pieza = p.uid_pieza
				AND f.fecha_inicio::date = obtener_fecha_historico(p.uid_pieza,finc)
				AND c.uid_coleccion = v_id_coleccion
				ORDER BY c.uid_coleccion, p.uid_pieza ASC;

			ELSE

			  RETURN QUERY
				SELECT p.uid_pieza, 
					c.nombre coleccion, 
					m.molde, 
					p.precio,
					CASE
					  WHEN c.linea = 'F' THEN 'Familiar'
					  WHEN c.linea = 'I' THEN 'Institucional'
					END linea,

					CASE
					  WHEN c.categoria = 'cou' THEN 'Country'
					  WHEN c.categoria = 'cla' THEN 'Clásica'
					  WHEN c.categoria = 'mod' THEN 'Moderna'
					END categoria,

					CASE 
					  WHEN mo.forma = 'ova' THEN 'Ovalada'
					  WHEN mo.forma = 'rec' THEN 'Rectangular'
					  WHEN mo.forma = 'cua' THEN 'Cuadrado'
					  WHEN mo.forma = 'red' THEN 'Redondo'
					  ELSE ''
					END forma,
					p.descripcion
				FROM coleccion c, molde mo, nombres_moldes m, pieza p
				WHERE c.uid_coleccion = p.uid_coleccion
				AND p.uid_pieza = v_id_pieza
				AND m.uid_molde = p.uid_molde
				AND mo.uid_molde = p.uid_molde
				AND c.uid_coleccion = v_id_coleccion
				ORDER BY c.uid_coleccion, p.uid_pieza ASC;
			END IF;
	  END;
	$$ LANGUAGE plpgsql;
COMMIT;
--Fin de utilizado en reporte

--------------------------------------------------------------------------------------------------------
--                                           INSERT                                                   --
--------------------------------------------------------------------------------------------------------

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
BEGIN;	insert into det_exp values(36,nextval('det_exp_uid_seq'),'2024-02-14','lt',null,2);	COMMIT;
BEGIN;	insert into det_exp values(37,nextval('det_exp_uid_seq'),'2024-02-14','he',null,null,2);	COMMIT;
BEGIN;	insert into det_exp values(38,nextval('det_exp_uid_seq'),'2024-05-04','lt',null,3);	COMMIT;

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
BEGIN;	insert into contrato values (1,nextval('contrato_uid_seq') ,15 ,'2022-04-10' );	COMMIT;--1
BEGIN;	insert into contrato values (2,nextval('contrato_uid_seq')  ,20 ,'2021-05-01' );	COMMIT;--2
BEGIN;	insert into contrato values (3,nextval('contrato_uid_seq') ,30 ,'2019-06-08'  );	COMMIT;--3
BEGIN;	insert into contrato values (4,nextval('contrato_uid_seq') ,15 , '2018-07-14' );	COMMIT;--4
BEGIN;	insert into contrato values ( 5,nextval('contrato_uid_seq'), 10, '2020-10-16' );	COMMIT;--5
BEGIN;	insert into contrato values (6,nextval('contrato_uid_seq') , 5, '2018-02-12');	COMMIT;--6
BEGIN;	insert into contrato values (7,nextval('contrato_uid_seq') , 10, '2019-04-24' );	COMMIT;--7
BEGIN;	insert into contrato values ( 8,nextval('contrato_uid_seq'), 15, '2023-03-31');	COMMIT;--8
BEGIN;	insert into contrato values ( 9,nextval('contrato_uid_seq'), 20, '2024-01-02');	COMMIT;--9

/*pedido*/
BEGIN;	insert into pedido values(1,nextval('pedido_uid_seq') ,'2024-01-18' ,'2024-03-18','2024-03-18' , 'A','F' );	COMMIT;--1
BEGIN;  insert into pedido values(2,nextval('pedido_uid_seq') ,'2024-02-17' ,'2024-04-17','2024-04-17'  , 'E','I' );	COMMIT;--2
BEGIN;	insert into pedido values(3,nextval('pedido_uid_seq') ,'2024-03-16' ,'2024-05-16','2024-05-16'  , 'A','F' );	COMMIT;--3
BEGIN;	insert into pedido values(4,nextval('pedido_uid_seq') ,'2024-04-15' ,'2024-06-15','2024-06-15'  , 'A','I' );	COMMIT;--4
BEGIN;	insert into pedido values(5,nextval('pedido_uid_seq') ,'2024-05-14' ,'2024-07-14','2024-07-14'  , 'A','I' );	COMMIT;--5
BEGIN;	insert into pedido values(6,nextval('pedido_uid_seq') ,'2024-06-13' ,'2024-08-13','2024-08-13' , 'E','I' );	COMMIT;--6
BEGIN;	insert into pedido values(7,nextval('pedido_uid_seq') ,'2024-07-12' ,'2024-09-12','2024-09-12'  , 'E','I' );	COMMIT;--7
BEGIN;	insert into pedido values(2,nextval('pedido_uid_seq') ,'2024-08-11' ,'2024-10-11','2024-10-11'  , 'A','F' );	COMMIT;--8
BEGIN;	insert into pedido values(3,nextval('pedido_uid_seq') ,'2024-09-10' ,'2024-11-10','2024-11-10' , 'A','F' );	COMMIT;--9
--Tablas Intercepcion

/*Factura*/
BEGIN;	insert into factura values( 1,1,nextval('factura_uid_seq') ,'2024-01-18' , 605.8 );	COMMIT;--1
BEGIN;	insert into factura values( 9,9,nextval('factura_uid_seq') ,'2024-09-10', 43.20 );	COMMIT; --2 
BEGIN;	insert into factura values( 3,3,nextval('factura_uid_seq') ,'2024-03-16' , 420 );	COMMIT;--3
BEGIN;	insert into factura values( 5,5,nextval('factura_uid_seq') ,'2024-05-14' , 324);	COMMIT; --4
BEGIN;	insert into factura values( 8,8,nextval('factura_uid_seq') ,'2024-08-11', 1621.80 );	COMMIT; --5
BEGIN;	insert into factura values( 4,4,nextval('factura_uid_seq') ,'2024-08-15', 249.65 );	COMMIT; --6

/*Detalle pedido Pieza*/	
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 1,2 ,1);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 2,5 ,null,1,1);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 3,5 ,null,1,2);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 4,2 ,null,1,3);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1,1 , 5,2 ,null,1,4);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 3, 3, 1,24 , null, 1, 10);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 5, 5, 1,30 ,null , 2,19);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 1,15 ,2 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 2,15 ,null,1,5);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 3,15 ,null,1,6);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 4,15 ,null,1,7 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 5,15 ,null,1,8 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 6,15 ,null,1,9);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 8, 8, 7,15 ,null,1,10 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 9, 9, 1,18 ,null, 3,27);	COMMIT;

BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 4, 4, 1,15 ,null,4,35 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 4, 4, 2,15 ,null, 4,38);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 4, 4, 3,2,7);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 4, 4, 4,2,8);	COMMIT;

BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1, 1, 6,8 ,null, 2,16);	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1, 1, 7,8 ,null,2,20 );	COMMIT;
BEGIN;	insert into DETALLE_PEDIDO_PIEZA values( 1, 1, 8,3,3);	COMMIT;

--------------------------------------------------------------------------------------------------------
--                                      CONSULTAS REPORTES                                            --
--------------------------------------------------------------------------------------------------------

/*

-- REPORTE HORARIO MENSUAL DE HORNEROS

SELECT e.num_expediente, 
              CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre,
              to_char(h.mesano, 'TMMONTH "DE" YYYY') as fecha_turno,
              e.num_cedula,
              h.turno,  
		CASE WHEN h.turno = 1 THEN '7:00 am a 3:00 pm'
			 WHEN h.turno = 2 THEN '3:00 pm a 11:00 pm'
			 WHEN h.turno = 3 THEN '11:00 pm a 7:00 am'
		END AS horario
FROM empleado e, hist_turno h
WHERE h.num_expediente = e.num_expediente AND  h.mesano = date_trunc('month',to_date(CONCAT( $P{Año},'-',$P{Numero_mes} ,'-','01'),'YYYY MM DD')::timestamp) 
ORDER BY h.turno;



--REPORTE MINUTA SEMANAL 
--Reporte Principal
SELECT e.num_expediente,
	e.num_cedula,
		CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')) as nombre,
		to_char(i.fecha_hora, 'TMDAY DD "DE" TMMONTH "DE" YYYY') fecha_hora,
	  CASE 
	    WHEN i.num_expediente IS NULL THEN 'ASISTENTES'
	    ELSE 'INASISTENTES'
	  END AS asistencia,
   e.supervisor
FROM inasistencia i
RIGHT OUTER JOIN empleado e 
ON  i.num_expediente = e.num_expediente AND i.num_expediente_supervisor = e.supervisor AND i.fecha_hora =  $P{fecha de la reunion} 
WHERE e.supervisor = $P{Id Supervisor} 
ORDER BY asistencia ASC;

--Subreporte 1
  SELECT e.resumen
  FROM reunion e
  WHERE e.num_expediente =  $P{Id Supervisor}
  AND e.fecha_hora =  $P{fecha de la reunion}

--Subreporte 2
  SELECT e.num_expediente,
      e.primer_nombre ||' '|| e.primer_apellido ||' '|| COALESCE(e.segundo_nombre,'') ||' '|| COALESCE(e.segundo_apellido,'') as nombre,
      e.num_cedula,
      upper(d.nombre) ndepart,
      cargo
  FROM departamento d, empleado e
  WHERE d.uid_departamento =(SELECT DISTINCT id_departamento FROM mostrar_supervisores_departamento( $P{nombre departamento} ))
  AND d.nivel = 4 
  AND e.cargo = 'og' 
  AND e.supervisor is NULL
  AND e.num_expediente =  $P{Id Supervisor}


--REPORTE ASISTENCIAS POR DEPARTAMENTO Y SUPERVISOR
  SELECT e.num_expediente,
        upper(CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, ''))) as nombre,
        upper(d.nombre) ndepart,
        e.num_cedula,
        e.cargo,
        e.supervisor,
        upper(CONCAT(s.primer_nombre, ' ', COALESCE(s.segundo_nombre, ''), ' ', s.primer_apellido, ' ', COALESCE(s.segundo_apellido, ''))) as nombre_supervisor,
        s.num_cedula,
        contar_inasistencias(e.num_expediente,to_date(CONCAT(to_char($P{Año},'9999'),'-',to_char( $P{Numero_mes}  ,'9999'),'-','01'),'YYYY MM DD')) inasistencias,
        porcentaje_inasistencia_empleado(e.num_expediente, to_date(CONCAT(to_char($P{Año},'9999'),'-',to_char( $P{Numero_mes}  ,'9999'),'-','01'),'YYYY MM DD')) pinac
    FROM departamento d, empleado s, empleado e
    WHERE s.num_expediente = e.supervisor
    AND d.uid_departamento = s.trabaja
    AND d.uid_departamento = e.trabaja
    AND e.supervisor =  $P{id supervisor} 
    AND s.num_expediente =  $P{id supervisor}



--REPORTE DETALLE EXPEDIENTE

  SELECT 
    upper(CONCAT(e.primer_nombre, ' ', COALESCE(e.segundo_nombre, ''), ' ', e.primer_apellido, ' ', COALESCE(e.segundo_apellido, '')))as nombre,
    upper(CONCAT(e.primer_nombre, ' ', e.primer_apellido)) as nom,
    e.num_expediente,
    e.num_cedula,
    to_char(e.fecha_nacimiento,'DD-TMMM-YYYY') fecha_nacimiento,
    e.tipo_sangre,
    e.genero,
    e.calle_avenida,
    CASE
      WHEN e.titulo = 'ba' THEN 'Bachiller'
      WHEN e.titulo = 'qui' THEN 'Ingeniero Químico'
      WHEN e.titulo = 'mec' THEN 'Ingeniero Mecánico'
      WHEN e.titulo = 'pro' THEN 'Ingeniero de Producción'
      WHEN e.titulo = 'ind' THEN 'Ingeniero Industrial'
      WHEN e.titulo = 'geo' THEN 'Geólogo'
    END titulo,

		CASE
			WHEN e.cargo = 'se' THEN 'Secretaria'
			WHEN e.cargo = 'ge'	THEN 'Gerente'
			WHEN e.cargo = 'me' THEN 'Mecánico'
			WHEN e.cargo = 'in'	THEN 'Inspector'
			WHEN e.cargo = 'el' THEN 'Electricista'
			WHEN e.cargo = 'og'	THEN 'Operario General'
		END cargo,

	e.sueldo,

	CONCAT('0',substring(e.telefono,1,3),'-',substring(e.telefono FROM 4)) telefono
	
FROM empleado e 
WHERE e.num_expediente =$P{id Empleado} ;

  --SubReporte 1
    SELECT s.nombre,
      CASE 
        WHEN s.tipo = 'A' THEN 'ALERGIAS'
        WHEN s.tipo = 'P' THEN 'PARTICULARES'
      END tipo,
      e.descripcion descripcion_salud_emp
    FROM ESTADO_SALUD s, E_E e 
    WHERE s.uid_salud = e.uid_salud AND e.num_exp = $P{id Empleado} 
    ORDER BY s.tipo ASC;

  --SubReporte 2
  WITH esSupervisor AS(
	     SELECT CASE 
	  			  WHEN COUNT(e.num_expediente) > 0 THEN 'Sí'
	  		 	  ELSE 'No'
	  		 END 
	  FROM empleado e, empleado s
	  WHERE s.num_expediente = e.supervisor
	  AND e.supervisor = $P{id Empleado}
  )

	SELECT 
			d.nombre nombre_dep,
			to_char(e.sueldo,'L99999990.00') sueldo,
			CASE
				WHEN e.cargo = 'se' THEN 'Secretaria'
				WHEN e.cargo = 'ge'	THEN 'Gerente'
				WHEN e.cargo = 'me' THEN 'Mecánico'
				WHEN e.cargo = 'in'	THEN 'Inspector'
				WHEN e.cargo = 'el' THEN 'Electricista'
				WHEN e.cargo = 'og'	THEN 'Operario General'
			END cargo,
			esSupervisor.case esSuper
	FROM departamento d, empleado e, esSupervisor
	WHERE d.uid_departamento = e.trabaja 
	AND e.num_expediente = $P{id Empleado} ;


  --SubReporte 3
  SELECT
			d.num_exp,
			d.uid,
			to_char(d.fecha,'DD-TMMM-YYYY') fecha,
			CASE
				WHEN d.motivo = 'in' THEN 'INASISTENCIAS'
				WHEN d.motivo = 'bm' OR d.motivo = 'ba' THEN 'BONOS'
				WHEN d.motivo = 'am' THEN 'AMONESTACIONES'
				WHEN d.motivo = 'lt' THEN 'LLEGADAS TARDE'
				WHEN d.motivo = 'he' THEN 'HORAS EXTRA'
			END motivo,
			
			to_char(d.monto_bono,'L99999990.00') monto_bono,
		
			CASE 
				WHEN d.retraso is not null THEN CONCAT(to_char(d.retraso,'9'),' minutos')
				ELSE null
			END retraso,
			
			CASE
				WHEN d.total_hora_extra is not null THEN CONCAT(to_char(d.total_hora_extra,'9'),' horas')
				ELSE null
			END total_hora_extra,
			
			COALESCE(d.descripcion, 'No se adjuntó descripción') descripcion
	FROM det_exp d, empleado e
	WHERE d.num_exp = e.num_expediente
	AND e.num_expediente = $P{id Empleado}
	AND d.fecha BETWEEN  $P{fecha inicial} AND $P{fecha final} 
	ORDER BY motivo DESC,d.uid DESC,fecha ASC;


--REPORTE CATÁLOGO

SELECT 
	c.nombre coleccion,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea,
	
	CASE
        WHEN c.categoria = 'cou' THEN 'Country'
        WHEN c.categoria = 'cla' THEN 'Clásica'
         WHEN c.categoria = 'mod' THEN 'Moderna'
     END categoria
     
FROM coleccion c
WHERE c.uid_coleccion =  $P{id coleccion}

--Subreporte 1
SELECT * FROM datos_piezas_coleccion($P{id coleccion}, $P{fecha_precios});


--Subreporte 2
SELECT DISTINCT
	v.uid_juego,
	v.nombre,
	calcular_precio_vajilla(v.uid_juego, d.uid_coleccion, $P{fecha_precios}) precio,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea
FROM coleccion c, vajilla v, detalle_pieza_vajilla d 
WHERE v.uid_juego = d.uid_juego
AND c.uid_coleccion = d.uid_coleccion
AND d.uid_coleccion = $P{id coleccion}


--REPORTE FICHAS PIEZA Y VAJILLA

--Pieza
SELECT * FROM datos_pieza( $P{id de la Pieza} ,$P{id coleccion}, $P{fecha_precio} );


--Vajilla

WITH precios_vaj AS (
	SELECT DISTINCT
	c.nombre,
	v.uid_juego,
	calcular_precio_vajilla(v.uid_juego, d.uid_coleccion,  $P{fecha_precio}  ) precio,
	CASE
	  WHEN c.linea = 'F' THEN 'Familiar'
	  WHEN c.linea = 'I' THEN 'Institucional'
	END linea
	FROM coleccion c, vajilla v, detalle_pieza_vajilla d 
	WHERE v.uid_juego = d.uid_juego
	AND v.uid_juego = $P{id vajilla} 
	AND c.uid_coleccion = d.uid_coleccion
	AND d.uid_coleccion = $P{id coleccion} 
)

SELECT 
	v.uid_juego,
	x.nombre coleccion,
	v.nombre vajilla,
	m.molde,
	v.capacidad,
	p.uid_pieza,
	d.cantidad,
	x.precio,
	v.descripcion,
	x.linea
FROM vajilla v, detalle_pieza_vajilla d, nombres_moldes m, precios_vaj x, pieza p
WHERE v.uid_juego = d.uid_juego
AND v.uid_juego = $P{id vajilla} 
AND v.uid_juego =  x.uid_juego
AND d.uid_pieza = p.uid_pieza
AND m.uid_molde = p.uid_molde
AND d.uid_coleccion = $P{id coleccion} 

*/







	