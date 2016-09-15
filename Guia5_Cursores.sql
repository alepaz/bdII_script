create table editoriales
(
	ideditorial		integer not null,
	nombre			varchar(250) not null,
	fecha_registro  date default SYSDATE  not null,
	CONSTRAINT pk_editoriales primary key(ideditorial)
);

create sequence sqe_editorial 
start with 1
increment by 1
minvalue 1
maxvalue 15000;

insert into EDITORIALES (ideditorial,nombre) values (sqe_editorial.nextval,'COLECCION MONTE SINAI');
insert into EDITORIALES (ideditorial,nombre) values (sqe_editorial.nextval,UPPER('Mcgrawhill'));
insert into EDITORIALES (ideditorial,nombre) values (sqe_editorial.nextval,UPPER('Edit Planeta'));
insert into EDITORIALES (ideditorial,nombre) values (sqe_editorial.nextval,UPPER('Edit clio'));
insert into EDITORIALES (ideditorial,nombre) values (sqe_editorial.nextval,UPPER('Larousse'));
COMMIT;
select * from editoriales;


create sequence sqe_libros 
start with 1
increment by 1
minvalue 1
maxvalue 15000;
/*
LOS TIPOS DE GENEROS PUEDEN SER 4:
1=> COMEDIA
2=> TRAGEDIA
3=> TECNOLOGIA
4=> CIENCIA
*/

create table libros
(
	idlibro			integer,
	ideditorial		integer	not null,
	isbn			  varchar(20) not null,
	nombre			varchar(150) not null,
	genero			integer not null,
	descripcion		varchar(350) null,
	precio			decimal(10,2)not null,
	cantidad_disponibles int not null,
	CONSTRAINT pk_libros primary key(idlibro),
	CONSTRAINT	uni_isbn	UNIQUE (isbn),
	CONSTRAINT chk_cantidad_disponibles CHECK(cantidad_disponibles >= 0),
  CONSTRAINT chk_genero CHECK(genero between 1 and 4)
);
ALTER TABLE libros ADD CONSTRAINT fk_libros_ref_editoriales FOREIGN KEY (ideditorial) REFERENCES editoriales(ideditorial);

insert into libros (idlibro,ideditorial,isbn,nombre,genero,descripcion,precio,cantidad_disponibles) values (sqe_libros.nextval,1,'140-1450','MATEMATICA CUARTO GRADO',4,'EL MEJOR LIBRO',7.90,6);
insert into libros (idlibro,ideditorial,isbn,nombre,genero,descripcion,precio,cantidad_disponibles) values (sqe_libros.nextval,2,'150-1450','FISICA APLICADA',3,'EL MEJOR LIBRO',45.99,10);
insert into libros (idlibro,ideditorial,isbn,nombre,genero,descripcion,precio,cantidad_disponibles) values (sqe_libros.nextval,3,'160-1450','EL PRINCIPITO',2,'EL MEJOR LIBRO',45.99,8);
insert into libros (idlibro,ideditorial,isbn,nombre,genero,descripcion,precio,cantidad_disponibles) values (sqe_libros.nextval,4,'170-1450','LENGUAJE DE PROGRAMACION PHP',3,'EL MEJOR LIBRO',65.99,15);
insert into libros (idlibro,ideditorial,isbn,nombre,genero,descripcion,precio,cantidad_disponibles) values (sqe_libros.nextval,5,'180-1450','DICCIONARIO DE RISAS',1,'EL MEJOR LIBRO',10.99,100);
COMMIT;

SELECT * FROM LIBROS;

create sequence sqe_alumnos
start with 1
increment by 1
minvalue 1
maxvalue 15000;

create table alumnos
(
	idalumno	integer,
	carnet		varchar(8) not null,
	dui			varchar(9) not null,
	apellidos   varchar(350) not null,
	nombres		varchar(350) not null,
	telefono    varchar(15) null,
	fecha_registro	date default SYSDATE not null,
	CONSTRAINT pk_alumnos primary key(idalumno),
	CONSTRAINT	uni_carnet	UNIQUE (carnet),
	CONSTRAINT	uni_dui	UNIQUE (dui)
);


INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'YT870377','474072277','Lucas','Cameran','(771) 921-3091');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'KI224466','214685602','Joyner','Heidi','(406) 725-2047');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'HW563683','938383942','Short','Hayley','(207) 869-1315');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'TW537855','986827626','Randall','Conan','(664) 850-6652');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'XL947843','530963581','Lee','Maisie','(353) 832-9763');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'OJ303418','702230835','Mills','Kylynn','(276) 716-0893');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'OT301427','018734293','Perry','Yasir','(995) 156-1044');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'JY253625','352580219','Compton','Murphy','(467) 909-3167');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'EO292800','858180652','Larson','Florence','(250) 914-5069');
INSERT INTO alumnos(idalumno,carnet,dui,apellidos,nombres,telefono) VALUES(sqe_alumnos.nextval,'PJ678312','172428729','Glass','Brenna','(733) 535-0098');
commit;

create sequence sqe_prestamos
start with 1
increment by 1
minvalue 1
maxvalue 15000;

create table prestamos
(
	idprestamos	integer not null,
	idlibro int	not null,
	idalumno int not null,
	estado integer default 1 not null,
	fecha_prestamo date default SYSDATE not null,
	fecha_devolucion date not null,
	CONSTRAINT pk_prestamos primary key(idprestamos),
	CONSTRAINT	chk_fechas_prestamos CHECK(fecha_devolucion >= fecha_prestamo),
	CONSTRAINT	chk_estado_prestamos CHECK(estado between 1 and 2),
	CONSTRAINT fk_prestamos_reference_libros FOREIGN KEY (idlibro)
      REFERENCES libros (idlibro)  ,
	CONSTRAINT fk_prestamos_reference_alumnos FOREIGN KEY (idalumno)
      REFERENCES alumnos (idalumno)
);


--Analisis de resultados
SET SERVER OUTPUT ON

--Cursor 1
CREATE OR REPLACE PROCEDURE PROC_LISTADO_LIBROS (i_existencia IN INTEGER)
AS
BEGIN
  DECLARE
    CURSOR cur_libros IS SELECT isbn, nombre FROM libros WHERE cantidad_disponibles >= i_existencia ORDER BY idlibro ASC;
    v_isbn libros.isbn%TYPE;
    v_nombre libros.nombre%TYPE;
    BEGIN
      OPEN CUR_LIBROS;
        LOOP
          FETCH CUR_LIBROS INTO v_isbn, v_nombre;
          EXIT WHEN cur_libros%NOTFOUND;
          DBMS_OUTPUT.put_line('------------------------------');
        DBMS_OUTPUT.put_line('------- CURSOR 1 --------');
          DBMS_OUTPUT.put_line(CONCAT('NOMBRE LIBRO: ', v_nombre));
          DBMS_OUTPUT.put_line(CONCAT('CODIGO ISBN: ', v_isbn));
          DBMS_OUTPUT.put_line('------------------------------');
        END LOOP;
      CLOSE CUR_LIBROS;
      NULL;
    END;
END PROC_LISTADO_LIBROS;

execute PROC_LISTADO_LIBROS(0);

--Cursor 2
CREATE OR REPLACE PROCEDURE proc_libros_genero (i_genero IN INTEGER)
AS
BEGIN
  DECLARE
    BEGIN
      FOR registros IN (SELECT isbn, nombre FROM libros WHERE genero = i_genero ORDER BY idlibro ASC)
      LOOP
        DBMS_OUTPUT.put_line('------------------------------');
        DBMS_OUTPUT.put_line('------- CURSOR 2 --------');
        DBMS_OUTPUT.put_line(CONCAT('NOMBRE LIBRO: ', registros.nombre));
        DBMS_OUTPUT.put_line(CONCAT('CODIGO ISBN: ', registros.isbn));
        DBMS_OUTPUT.put_line('------------------------------');
      END LOOP;
    END;
END proc_libros_genero;

EXECUTE proc_libros_genero(1);



--Cursor 3
--crear tabla libros_exceso;
CREATE TABLE libros_exceso(
  idlibro_exceso integer,
  idlibro integer not null,
  nombre varchar(150) not null,
  precio decimal(10,2)not null
);

create sequence sqc_libros_exceso
start with 1
increment by 1
minvalue 1
maxvalue 15000;

--Crear un cursos que consulte los libros con existencias determinado por una variable de entrada e ingresarlos en la tabla "libros_exceso"
CREATE OR REPLACE PROCEDURE proc_libros_existencia (i_existencia IN INTEGER)
AS
BEGIN
  DECLARE
    BEGIN
      FOR registros IN (SELECT idlibro, nombre, precio FROM libros WHERE cantidad_disponibles > i_existencia ORDER BY idlibro ASC)
      LOOP
        INSERT INTO libros_exceso VALUES (sqc_libros_exceso.nextval, registros.idlibro, registros.nombre, registros.precio);
        COMMIT;
      END LOOP;
    END;
END proc_libros_existencia;

EXECUTE proc_libros_existencia(0);

SELECT * FROM libros_exceso;