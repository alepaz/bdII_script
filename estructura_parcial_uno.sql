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

create table alumnos2(
idalumnos integer not null,
carnet varchar2(8) not null,
nombres varchar2(350) not null,
apellidos varchar2(350) not null,
fecha_nacimiento date not null,
dui varchar2(10) null,
nombre_responsable varchar2(350) not null,
telefono varchar2(8) not null,
email varchar2(350) not null,
constraint pk_alumnos2 primary key(idalumnos),
constraint uni_carnet2 unique  (carnet)
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


ALTER TABLE prestamos ADD CONSTRAINT fk_prestamos_reference_alumnos FOREIGN KEY (idalumnos) REFERENCES alumnos2(idalumnos);
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




