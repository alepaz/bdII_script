--ALUMNO: FRANCISCO ALEJANDRO PAZ TEJADA

--1. Crear un tablespace con el siguiente nombre: tbl_carnet.
create tablespace tbl_pt132129
logging 
datafile 'C:/tablespace/tbl_pt132129'
size 32m
autoextend off;

--2. Crear un usuario con el siguiente nombre: usr_carnet y asignarle el rol de dba.
create user usr_pt132129 
identified by clave 
default tablespace tbl_pt132129;
grant dba to usr_pt132129;

--CREAR TABLAS
create table libros (
idlibros integer not null,
isbn varchar2(45) not null,
nombre_libro varchar2(350) not null,
autor varchar2(250) not null, 
fecha_publicacion date not null,
numero_edicion integer not null,
total_libros integer,
observaciones long,
constraint pk_libros  primary key(idlibros),
constraint uni_isbn unique (isbn),
constraint check_tlibros check(total_libros > 0)
);

comment on table libros is 'ESTA TABLA CONTIENE EL REGISTRO DE LOS LIBROS A PRESTAR POR PARTE DE LA UNIVERSIDAD';
comment on column libros.total_libros is 'LA CANTIDAD DE LIBROS DEBE SER SIEMPRE MAYOR A CERO';

create table alumnos(
idalumnos integer not null,
carnet varchar2(8) not null,
nombres varchar2(350) not null,
apellidos varchar2(350) not null,
fecha_nacimiento date not null,
dui varchar2(10) null,
nombre_responsable varchar2(350) not null,
telefono varchar2(8) not null,
email varchar2(350) not null,
constraint pk_alumnos primary key(idalumnos),
constraint uni_carnet unique  (carnet)
);
comment on table alumnos is 'ESTA TABLA CONTIENE EL REGISTRO DE TODOS LOS REGISTROS DE TODOS LOS ALUMNOS';

create table prestamos(
idprestamos integer not null,
idalumnos integer not null,
idlibros integer not null,
fecha_prestamo date not null,
fecha_devolucion date,
constraint pk_prestamos primary key(idprestamos)
);
comment on table prestamos is 'ESTA TABLA CONTIENE EL REGISTRO DE TODOS LOS PRESTAMOS REALIZADO POR UN ALUMNO A UN LIBRO';


ALTER TABLE prestamos ADD CONSTRAINT fk_prestamos_reference_alumnos FOREIGN KEY (idalumnos) REFERENCES alumnos(idalumnos);
ALTER TABLE prestamos ADD CONSTRAINT fk_prestamos_reference_libros   FOREIGN KEY (idlibros)  REFERENCES libros(idlibros);


create table bitacora_alumno
(
idbitacora integer not null,
carnet_old varchar2(8) not null,
operacion_efectuada integer not null,
comentario long not null,
fecha_registro date not null,
constraint pk_bitacora  primary key(idbitacora),
constraint check_ope_bit_alum check(operacion_efectuada between 2 and 3)
);

comment on table bitacora_alumno is 'ESTA TABLA CONTIENE EL REGISTRO DE TODAS LAS MODIFICACIONES Y ELIMINACIONES DE LA TABLA ALUMNOS';
comment on column bitacora_alumno.operacion_efectuada is 'ESTE CAMPO DETERMINARA QUE OPERACIOIN SE REALIZO SI MODIFICACION (2) O ELIMINACION (3)';

--3. Para cada llave primaria en cada una de las tablas, crear una secuencia para que la clave primaria sea generada por la secuencia correspondiente.

--TABLA LIBROS
create sequence sqe_libros 
start with 1
increment by 1
minvalue 1
maxvalue 15000;

--TABLA ALUMNOS
create sequence sqe_alumnos
start with 1
increment by 1
minvalue 1
maxvalue 15000;

--TABLA PRESTAMOS
create sequence sqe_prestamos
start with 1
increment by 1
minvalue 1
maxvalue 15000;

--TABLA BITACORA ALUMNOS
create sequence sqe_bitacora_alumno
start with 1
increment by 1
minvalue 1
maxvalue 15000;

commit;

--4. Crear un procedimiento almacenado que permita ingresar un nuevo registro en cada una de las siguientes 
--tablas: libros, alumnos, préstamos. Debe colocar tres instrucciones por cada tabla para realizar el proceso 
--de inserción.

--CREACION INSERT LIBRO
CREATE OR REPLACE PROCEDURE ingresar_libro(
isbn libros.isbn%TYPE,
nombre_libro libros.nombre_libro%TYPE,
autor libros.autor%TYPE,
fecha_publicacion libros.fecha_publicacion%TYPE,
numero_edicion libros.numero_edicion%TYPE,
total_libros libros.total_libros%TYPE,
observaciones libros.observaciones%TYPE
) IS
BEGIN
INSERT INTO libros VALUES(sqe_libros.nextval, isbn, nombre_libro, autor, fecha_publicacion,
numero_edicion, total_libros, observaciones
);
END ingresar_libro;


--CREACION INSERT ALUMNOS
CREATE OR REPLACE PROCEDURE ingresar_alumno(
carnet alumnos.carnet%TYPE,
nombres alumnos.nombres%TYPE,
apellidos alumnos.apellidos%TYPE,
fecha_nacimiento alumnos.fecha_nacimiento%TYPE,
dui alumnos.dui%TYPE,
nombre_responsable alumnos.nombre_responsable%TYPE,
telefono alumnos.telefono%TYPE,
email alumnos.email%TYPE
) IS
BEGIN
INSERT INTO alumnos VALUES(sqe_alumnos.nextval, carnet, nombres, apellidos, fecha_nacimiento,
dui, nombre_responsable, telefono, email
);
END ingresar_alumno;

--CREACION INSERT PRESTAMO
CREATE OR REPLACE PROCEDURE ingresar_prestamo(
idalumnos prestamos.idalumnos%TYPE,
idlibros prestamos.idlibros%TYPE,
fecha_prestamo prestamos.fecha_prestamo%TYPE,
fecha_devolucion prestamos.fecha_devolucion%TYPE
) IS
BEGIN
INSERT INTO prestamos VALUES(sqe_prestamos.nextval, idalumnos, idlibros, fecha_prestamo, fecha_devolucion
);
END ingresar_prestamo;

--LLAMADAS
CALL ingresar_libro('1234567890', 'Brave Bird', 'Satoshi Ketchup', TO_DATE('2016/05/09', 'yyyy/mm/dd'), 6, 6, 'breve resumen de como perder una liga');
CALL ingresar_libro('4223467890', '!Como perder una liga!', 'Satoshi Ketchup', TO_DATE('2016/02/19', 'yyyy/mm/dd'), 6, 6, 'Guia resumen de mas de 20 anios!');
CALL ingresar_libro('1234542570', 'Arduino Cookbook', 'Wolf Grey', TO_DATE('2015/01/14', 'yyyy/mm/dd'), 1, 1, 'Libro para principiantes');
SELECT * FROM libros;

CALL ingresar_alumno('PT132129', 'Francisco Alejandro', 'Paz Tejada', TO_DATE('1995/04/07', 'yyyy/mm/dd'), '26358512', 'Irma Yolanda', '71548722', 'alepazte@hotmail.com');
CALL ingresar_alumno('PF132127', 'Jonathan Alexander', 'Palma Flores', TO_DATE('1995/04/04', 'yyyy/mm/dd'), '24233534', 'Claudia Pilar', '78965852', 'tan_palma@hotmail.com');
CALL ingresar_alumno('MJ132115', 'Jonatan Armando', 'Martinez Javier', TO_DATE('1994/01/14', 'yyyy/mm/dd'), '23356987', 'Maria Javier', '73258966', 'jr-javier@hotmail.com');
SELECT * FROM alumnos;

CALL ingresar_prestamo('1', '1', TO_DATE('2016/08/25', 'yyyy/mm/dd'), null);
CALL ingresar_prestamo('2', '2', TO_DATE('2016/08/24', 'yyyy/mm/dd'), null);
CALL ingresar_prestamo('3', '3', TO_DATE('2016/08/23', 'yyyy/mm/dd'), null);
SELECT * FROM prestamos;

--5. Crear un trigger que permita actualizar el campo TOTAL_LIBROS de la 
--tabla LIBROS para disminuirlos en uno, cuando se realice un nuevo 
--registro en la tabla préstamos.

CREATE OR REPLACE TRIGGER update_total_ventas
BEFORE INSERT ON prestamos
FOR EACH ROW
DECLARE
  -- Descuenta un una unidad la cantidad de libros
  stock INTEGER;  
BEGIN
  SELECT total_libros INTO stock FROM libros WHERE idlibros = :new.idlibros;
    UPDATE libros SET total_libros = total_libros-1 WHERE idlibros = :new.idlibros;
END update_total_ventas;

--6. Crear un trigger que permita actualizar el campo TOTAL_LIBROS de la tabla 
--LIBROS sumando en una unidad, después de modificar el campo FECHA_DEVOLUCION 
--de la tabla PRÉSTAMOS.

CREATE OR REPLACE TRIGGER update_fecha_devolucion
AFTER UPDATE OF fecha_devolucion ON prestamos
FOR EACH ROW
BEGIN
    UPDATE libros SET total_libros = total_libros+1 WHERE idlibros = :new.idlibros;
END update_fecha_devolucion;

--PRUEBA
SELECT * FROM PRESTAMOS;
UPDATE prestamos SET fecha_devolucion = TO_DATE('2016/08/29', 'yyyy/mm/dd') WHERE idprestamos=1;
SELECT * FROM LIBROS;

--7. Crear un trigger que permita registrar posterior a la modificación o eliminación de un alumno, 
--registrar en la tabla bitacora_alumno, en el campo operación determinar si es modificación (valor = 2) 
--o eliminación (valor = 3) y registra el valor del carnet del estudiante que sufrió una 
--operación update o delete.

CREATE OR REPLACE TRIGGER trg_update_delete_alumno
AFTER DELETE OR UPDATE ON alumnos
FOR EACH ROW
BEGIN
  CASE
    WHEN DELETING THEN
      INSERT INTO bitacora_alumno 
        VALUES(sqe_bitacora_alumno.nextval, :old.carnet, '3', 'SE HA ELIMINADO EL ALUMNO', SYSDATE);
    WHEN UPDATING THEN
      INSERT INTO bitacora_alumno 
        VALUES(sqe_bitacora_alumno.nextval, :old.carnet, '2', 'SE HA MODIFICADO LOS DATOS DEL ALUMNO', SYSDATE);
  END CASE;  
END trg_update_delete_alumno;

COMMIT;
--PRUEBA
UPDATE alumnos SET nombres = 'Fernando Carlos' WHERE idalumnos=2;
SELECT * FROM bitacora_alumno;

--9. Realizar el proceso de backup completo para la tabla LIBROS.
exp usr_pt132129/clave file=C:\backup\libros_backup.dmp tables(libros) buffer=100000000