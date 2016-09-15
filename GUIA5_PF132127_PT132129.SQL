

--Nota: Para el campo DUI no se debe guardar el guión y para el campo sexo solo se debe guardar un carácter f o m. 

--7. El archivo SQL debe contener desde la creación del tablespace, creación del usuario,

CREATE TABLESPACE tbl_guia5_PF132127_PT132129
LOGGING
DATAFILE 'C:\tablespace\tarea_guia5.dbf'
SIZE 32m
AUTOEXTEND off;

CREATE USER usr_guia5
IDENTIFIED BY hola1234
DEFAULT TABLESPACE tbl_guia5_PF132127_PT132129;

GRANT dba TO usr_guia5


--1. Escribir todas las instrucciones necesarias para crear las 5 tablas descritas anteriormente, con sus respectivos tipos de datos, llaves primarias, llaves foráneas, check y unique. 

CREATE TABLE categoria(
    cod_categoria int not null,
    nombre_categoria varchar2(30) not null,
    fecha_registro date default sysdate,
    constraint pk_categoria primary key(cod_categoria)
);
comment on table categoria is 'ESTA TABLA CONTIENE EL REGISTRO DE LAS CATEGORIAS DE LAS PELICULAS';

create sequence sqe_categoria
start with 1
increment by 1
minvalue 1
maxvalue 15000;

CREATE TABLE pelicula(
    cod_pelicula int not null,
    cod_categoria int not null,
    nombre_pelicula varchar2(50) not null,
    descripcion varchar2(250),
    trama varchar2(250),
    anio_lanzamiento char(4) not null,
    precio decimal(8,2) not null,
    fecha_registro date default sysdate,
    constraint pk_pelicula primary key(cod_pelicula),
    constraint fk_categoria_pelicula foreign key (cod_categoria) references categoria(cod_categoria)
);
comment on table pelicula is 'ESTA TABLA CONTIENE EL REGISTRO DE TODAS LAS PELICULAS';

create sequence sqe_pelicula
start with 1
increment by 1
minvalue 1
maxvalue 15000;


CREATE TABLE cliente(
    cod_cliente int not null,
    dui char(9) not null,
    apellidos varchar2(50) not null,
    nombres varchar2(50) not null,
    sexo char(1) not null,
    email varchar2(75) not null,
    fecha_nacimiento date not null,
    fecha_registro date default sysdate,
    constraint pk_cliente primary key(cod_cliente),
    constraint uni_dui unique (dui),
    constraint chk_sexo check (sexo = 'f' or sexo = 'm')
);
comment on table cliente is 'ESTA TABLA CONTIENE EL REGISTRO DE TODOS LOS CLIENTES';

create sequence sqe_cliente
start with 1
increment by 1
minvalue 1
maxvalue 15000;

CREATE TABLE renta(
    cod_renta int not null,
    cod_cliente int not null,
    fecha_renta date default sysdate,
    fecha_devolucion date,
    constraint pk_renta primary key(cod_renta),
    constraint fk_cliente_renta foreign key (cod_cliente) references cliente(cod_cliente),
    constraint chk_fechas_renta check (fecha_devolucion >= fecha_renta)
);
comment on table renta is 'ESTA TABLA CONTIENE TODOS LOS REGISTROS DE LAS RENTAS DE PELICULAS REALIZADAS';

create sequence sqe_renta
start with 1
increment by 1
minvalue 1
maxvalue 15000;

CREATE TABLE detalle_renta(
    cod_detallerenta int not null,
    cod_renta int not null,
    cod_pelicula int not null,
    cantidad int not null,
    costo decimal(8,2) not null,
    constraint pk_detallerenta primary key(cod_detallerenta),
    constraint fk_renta_detallerenta foreign key (cod_renta) references renta(cod_renta),
    constraint fk_pelicula_detallerenta foreign key (cod_pelicula) references pelicula(cod_pelicula)
);
comment on table detalle_renta is 'ESTA TABLA CONTIENE LOS REGISTROS DEL DETALLE DE CADA RENTA';
create sequence sqe_detalle_renta
start with 1
increment by 1
minvalue 1
maxvalue 15000;


--Creacion de procedimiento para insertar categorias
CREATE OR REPLACE PROCEDURE insert_categoria(
    nombre categoria.nombre_categoria%TYPE
) IS
BEGIN
INSERT INTO categoria(cod_categoria, nombre_categoria) VALUES(sqe_categoria.nextval, nombre);
END insert_categoria;

--Creacion de procedimiento para insertar peliculas
CREATE OR REPLACE PROCEDURE insert_pelicula(‘’
cod_categoria pelicula.cod_categoria%TYPE,
nombre_pelicula pelicula.nombre_pelicula%TYPE,
descripcion pelicula.descripcion%TYPE,
trama pelicula.trama%TYPE,
anio_lanzamiento pelicula.anio_lanzamiento%TYPE,
precio pelicula.precio%TYPE
) IS
BEGIN
INSERT INTO pelicula(cod_pelicula, cod_categoria, nombre_pelicula, descripcion, trama, anio_lanzamiento, precio) VALUES(sqe_pelicula.nextval, cod_categoria, nombre_pelicula, descripcion, trama, anio_lanzamiento, precio);
END insert_pelicula;

--Creacion de procedimiento para insertar clientes
CREATE OR REPLACE PROCEDURE insert_cliente(
    p_dui cliente.dui%TYPE,
    p_apellidos cliente.apellidos%TYPE,
    p_nombres cliente.nombres%TYPE,
    p_sexo cliente.sexo%TYPE,
    p_email cliente.email%TYPE,
    p_fech_nac cliente.fecha_nacimiento%TYPE
) IS
BEGIN
INSERT INTO cliente(cod_cliente, dui, apellidos, nombres, sexo, email, fecha_nacimiento) VALUES(sqe_cliente.nextval, p_dui, p_apellidos, p_nombres, p_sexo, p_email, p_fech_nac);
END insert_cliente;

--Creacion de procedimiento para insertar rentas
CREATE OR REPLACE PROCEDURE ins_upd_rentas(
    opc int,
    idrenta renta.cod_renta%TYPE,
    idcliente renta.cod_cliente%TYPE,
    fech_dev renta.fecha_devolucion%TYPE
) IS
BEGIN
    IF opc = 1 THEN
        INSERT INTO renta(cod_renta, cod_cliente) values (sqe_renta.nextval, idcliente);
    ELSE
        UPDATE renta SET fecha_devolucion=fech_dev WHERE cod_renta = idrenta;
    END IF; 
END ins_upd_rentas;

--Creacion de procedimiento para insertar registros de cada renta
CREATE OR REPLACE PROCEDURE insert_detallesrenta(
    idrenta detalle_renta.cod_renta%TYPE,
    idpelicula detalle_renta.cod_pelicula%TYPE,
    cant detalle_renta.cantidad%TYPE,
    cost detalle_renta.costo%TYPE
) IS
BEGIN
INSERT INTO detalle_renta VALUES(sqe_detalle_renta.nextval, idrenta, idpelicula, cant, cost);
END insert_detallesrenta;

--2. Para la tabla categoría agregar 5 registros, en las tablas películas y clientes agregar 50 registros, en la tabla renta agregar 10 y en la tabla detalle_renta agregar tres películas por cada renta registrada.

--5 registros tabla categoría
CALL insert_categoria('acción');
CALL insert_categoria('Infantiles');
CALL insert_categoria('Terror');
CALL insert_categoria('Romantica');
CALL insert_categoria('Ciencia ficción‎');
SELECT * FROM categoria;

--50 registros tabla peliculas
CALL insert_pelicula(2, 'Avengers', 'son un grupo de superhéroes formado por personajes de la editorial estadounidense Marvel Cómics.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(3, 'HP y la piedra filosofal', 'Es una película de fantasía y aventuras basada en el libro homónimo de J. K. Rowling, dirigida por el cineasta Chris Columbus y estrenada en 2001', 'El día de su 11º cumpleaños, Harry Potter (Daniel Radcliffe) descubre que es un mago y que tiene la oportunidad de estudiar en el Colegio Hogwarts de Magia y Hechicería. ', '2001', 8.99);
CALL insert_pelicula(4, 'HP y la cámara secreta', 'Está basada en la novela homónima de J. K. Rowling. La película, que constituye el segundo episodio en la saga de películas de Harry Potter', 'Preparándose para una visita de un cliente potencial del tío Vernon, los Dursley confinan a Harry Potter a su cuarto. Allí encuentra a Dobby, un elfo doméstico, que le advierte que no debe regresar a Hogwarts.', '2002', 7.99);
CALL insert_pelicula(5, 'Pokémon: Mewtwo Strikes', 'Conocida en Estados Unidos como Pokémon: Mewtwo Strikes Back o Pokémon: Mewtwo vs. Mew es la primera película basada en la serie de anime Pokémon.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(5, 'Pokémon 2: El poder de uno', 'conocida en Estados Unidos como Pokémon: The Movie 2000: The Power of One, es la segunda película del anime Pokémon, que complementa la saga de las Islas Naranja y presenta a varios nuevos Pokémon, incluyendo a Lugia y Slowking.', 'Las tres aves legendarias, Articuno, Zapdos y Moltres, sobre las que recae bastante el argumento de la película, se introducen mostrándonos el tema de un delicado balance entre las fuerzas de la naturaleza.', '1999', 7.99);
CALL insert_pelicula(3, 'Avatar', ' película de ciencia ficción estadounidense de 2009, escrita, producida y dirigida por James Cameron y protagonizada por Sam Worthington', 'La acción se sitúa en 2154. Jake Sully, un marine veterano de guerra y herido en combate que ha quedado parapléjico', '2009', 9.99);
CALL insert_pelicula(2, 'Escuadrón Suicida', 'Es una película de supervillanos4 estadounidense de 2016, basada en el equipo de antihéroes homónimo de DC Comics.', 'Después de la muerte de Superman en Batman v Superman: Dawn of Justice, la agente de inteligencia Amanda Waller ensambla un equipo de criminales peligrosos', '2016', 19.99);
CALL insert_pelicula(4, 'Batman v Superman', 'Es una película de superhéroes estadounidense basada en los personajes Batman y Superman de DC Comics, distribuida por Warner Bros. Pictures. Es la segunda entrega del Universo Extendido de DC Comics y la secuela de El Hombre de Acero.', 'Superman se ha convertido en la figura más controvertida del mundo. Mientras que muchos siguen creyendo que es un emblema de esperanza, otro gran número de personas lo consideran una amenaza para la humanidad.', '2016', 3.99);
CALL insert_pelicula(5, 'X-Men: Apocalipsis', 'X-Men: Apocalipsis es una película de acción y aventura de 2016 perteneciente a la saga fílmica de X-Men.', 'Desde los albores de la civilización, fue adorado como un dios. Apocalypse, el primer y más poderoso mutante del universo X-Men de Marvel, acumuló los poderes de muchos otros mutantes,', '2016', 19.99);
CALL insert_pelicula(3, 'Titanic', 'Titanic es una película estadounidense dramática-de catástrofe de 1997 dirigida y escrita por James Cameron y protagonizada por Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates, Gloria Stuart y Bill Paxton', 'En 1996, el buscador de tesoros Brock Lovett (interpretado por Bill Paxton) y su equipo de exploración acuden al pecio del RMS Titanic, con el propósito de sumergirse hasta los restos del barco hundido', '1997', 6.99);

CALL insert_pelicula(2, 'Avengers II', 'son un grupo de superhéroes formado por personajes de la editorial estadounidense Marvel Cómics.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(3, 'HP y la piedra filosofal II', 'Es una película de fantasía y aventuras basada en el libro homónimo de J. K. Rowling, dirigida por el cineasta Chris Columbus y estrenada en 2001', 'El día de su 11º cumpleaños, Harry Potter (Daniel Radcliffe) descubre que es un mago y que tiene la oportunidad de estudiar en el Colegio Hogwarts de Magia y Hechicería. ', '2001', 8.99);
CALL insert_pelicula(4, 'HP y la cámara secreta II', 'Está basada en la novela homónima de J. K. Rowling. La película, que constituye el segundo episodio en la saga de películas de Harry Potter', 'Preparándose para una visita de un cliente potencial del tío Vernon, los Dursley confinan a Harry Potter a su cuarto. Allí encuentra a Dobby, un elfo doméstico, que le advierte que no debe regresar a Hogwarts.', '2002', 7.99);
CALL insert_pelicula(5, 'Pokémon: Mewtwo Strikes fight', 'Conocida en Estados Unidos como Pokémon: Mewtwo Strikes Back o Pokémon: Mewtwo vs. Mew es la primera película basada en la serie de anime Pokémon.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(5, 'Pokémon 2: El poder de dos', 'conocida en Estados Unidos como Pokémon: The Movie 2000: The Power of One, es la segunda película del anime Pokémon, que complementa la saga de las Islas Naranja y presenta a varios nuevos Pokémon, incluyendo a Lugia y Slowking.', 'Las tres aves legendarias, Articuno, Zapdos y Moltres, sobre las que recae bastante el argumento de la película, se introducen mostrándonos el tema de un delicado balance entre las fuerzas de la naturaleza.', '1999', 7.99);
CALL insert_pelicula(3, 'Avatar II', ' película de ciencia ficción estadounidense de 2009, escrita, producida y dirigida por James Cameron y protagonizada por Sam Worthington', 'La acción se sitúa en 2154. Jake Sully, un marine veterano de guerra y herido en combate que ha quedado parapléjico', '2009', 9.99);
CALL insert_pelicula(2, 'Escuadrón Suicida II', 'Es una película de supervillanos4 estadounidense de 2016, basada en el equipo de antihéroes homónimo de DC Comics.', 'Después de la muerte de Superman en Batman v Superman: Dawn of Justice, la agente de inteligencia Amanda Waller ensambla un equipo de criminales peligrosos', '2016', 19.99);
CALL insert_pelicula(4, 'Batman v Aquaman', 'Es una película de superhéroes estadounidense basada en los personajes Batman y Superman de DC Comics, distribuida por Warner Bros. Pictures. Es la segunda entrega del Universo Extendido de DC Comics y la secuela de El Hombre de Acero.', 'Superman se ha convertido en la figura más controvertida del mundo. Mientras que muchos siguen creyendo que es un emblema de esperanza, otro gran número de personas lo consideran una amenaza para la humanidad.', '2016', 3.99);
CALL insert_pelicula(5, 'X-Men: Computer', 'X-Men: Apocalipsis es una película de acción y aventura de 2016 perteneciente a la saga fílmica de X-Men.', 'Desde los albores de la civilización, fue adorado como un dios. Apocalypse, el primer y más poderoso mutante del universo X-Men de Marvel, acumuló los poderes de muchos otros mutantes,', '2016', 19.99);
CALL insert_pelicula(3, 'Titanic II', 'Titanic es una película estadounidense dramática-de catástrofe de 1997 dirigida y escrita por James Cameron y protagonizada por Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates, Gloria Stuart y Bill Paxton', 'En 1996, el buscador de tesoros Brock Lovett (interpretado por Bill Paxton) y su equipo de exploración acuden al pecio del RMS Titanic, con el propósito de sumergirse hasta los restos del barco hundido', '1997', 6.99);

CALL insert_pelicula(2, 'Avengers Ultron', 'son un grupo de superhéroes formado por personajes de la editorial estadounidense Marvel Cómics.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(3, 'HP y la piedra de coca', 'Es una película de fantasía y aventuras basada en el libro homónimo de J. K. Rowling, dirigida por el cineasta Chris Columbus y estrenada en 2001', 'El día de su 11º cumpleaños, Harry Potter (Daniel Radcliffe) descubre que es un mago y que tiene la oportunidad de estudiar en el Colegio Hogwarts de Magia y Hechicería. ', '2001', 8.99);
CALL insert_pelicula(4, 'HP y la cámara fotografica', 'Está basada en la novela homónima de J. K. Rowling. La película, que constituye el segundo episodio en la saga de películas de Harry Potter', 'Preparándose para una visita de un cliente potencial del tío Vernon, los Dursley confinan a Harry Potter a su cuarto. Allí encuentra a Dobby, un elfo doméstico, que le advierte que no debe regresar a Hogwarts.', '2002', 7.99);
CALL insert_pelicula(5, 'Pokémon: Mewtree', 'Conocida en Estados Unidos como Pokémon: Mewtwo Strikes Back o Pokémon: Mewtwo vs. Mew es la primera película basada en la serie de anime Pokémon.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(5, 'Pokémon 2: El poder de tres', 'conocida en Estados Unidos como Pokémon: The Movie 2000: The Power of One, es la segunda película del anime Pokémon, que complementa la saga de las Islas Naranja y presenta a varios nuevos Pokémon, incluyendo a Lugia y Slowking.', 'Las tres aves legendarias, Articuno, Zapdos y Moltres, sobre las que recae bastante el argumento de la película, se introducen mostrándonos el tema de un delicado balance entre las fuerzas de la naturaleza.', '1999', 7.99);
CALL insert_pelicula(3, 'Avatar III', ' película de ciencia ficción estadounidense de 2009, escrita, producida y dirigida por James Cameron y protagonizada por Sam Worthington', 'La acción se sitúa en 2154. Jake Sully, un marine veterano de guerra y herido en combate que ha quedado parapléjico', '2009', 9.99);
CALL insert_pelicula(2, 'Escuadrón Suicida', 'Es una película de supervillanos4 estadounidense de 2016, basada en el equipo de antihéroes homónimo de DC Comics.', 'Después de la muerte de Superman en Batman v Superman: Dawn of Justice, la agente de inteligencia Amanda Waller ensambla un equipo de criminales peligrosos', '2016', 19.99);
CALL insert_pelicula(4, 'Batman v hackerman (JP)', 'Es una película de superhéroes estadounidense basada en los personajes Batman y Superman de DC Comics, distribuida por Warner Bros. Pictures. Es la segunda entrega del Universo Extendido de DC Comics y la secuela de El Hombre de Acero.', 'Superman se ha convertido en la figura más controvertida del mundo. Mientras que muchos siguen creyendo que es un emblema de esperanza, otro gran número de personas lo consideran una amenaza para la humanidad.', '2016', 3.99);
CALL insert_pelicula(5, 'X-Men: Desapocalipsis', 'X-Men: Apocalipsis es una película de acción y aventura de 2016 perteneciente a la saga fílmica de X-Men.', 'Desde los albores de la civilización, fue adorado como un dios. Apocalypse, el primer y más poderoso mutante del universo X-Men de Marvel, acumuló los poderes de muchos otros mutantes,', '2016', 19.99);
CALL insert_pelicula(3, 'Titanic III', 'Titanic es una película estadounidense dramática-de catástrofe de 1997 dirigida y escrita por James Cameron y protagonizada por Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates, Gloria Stuart y Bill Paxton', 'En 1996, el buscador de tesoros Brock Lovett (interpretado por Bill Paxton) y su equipo de exploración acuden al pecio del RMS Titanic, con el propósito de sumergirse hasta los restos del barco hundido', '1997', 6.99);

CALL insert_pelicula(2, 'Avengers IV', 'son un grupo de superhéroes formado por personajes de la editorial estadounidense Marvel Cómics.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(3, 'HP y la patata Filosofal', 'Es una película de fantasía y aventuras basada en el libro homónimo de J. K. Rowling, dirigida por el cineasta Chris Columbus y estrenada en 2001', 'El día de su 11º cumpleaños, Harry Potter (Daniel Radcliffe) descubre que es un mago y que tiene la oportunidad de estudiar en el Colegio Hogwarts de Magia y Hechicería. ', '2001', 8.99);
CALL insert_pelicula(4, 'HP y la tabla de diseño', 'Está basada en la novela homónima de J. K. Rowling. La película, que constituye el segundo episodio en la saga de películas de Harry Potter', 'Preparándose para una visita de un cliente potencial del tío Vernon, los Dursley confinan a Harry Potter a su cuarto. Allí encuentra a Dobby, un elfo doméstico, que le advierte que no debe regresar a Hogwarts.', '2002', 7.99);
CALL insert_pelicula(5, 'Pokémon: Mewfour fight', 'Conocida en Estados Unidos como Pokémon: Mewtwo Strikes Back o Pokémon: Mewtwo vs. Mew es la primera película basada en la serie de anime Pokémon.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(5, 'Pokémon 2: El poder de cuatro', 'conocida en Estados Unidos como Pokémon: The Movie 2000: The Power of One, es la segunda película del anime Pokémon, que complementa la saga de las Islas Naranja y presenta a varios nuevos Pokémon, incluyendo a Lugia y Slowking.', 'Las tres aves legendarias, Articuno, Zapdos y Moltres, sobre las que recae bastante el argumento de la película, se introducen mostrándonos el tema de un delicado balance entre las fuerzas de la naturaleza.', '1999', 7.99);
CALL insert_pelicula(3, 'Avatar IV', ' película de ciencia ficción estadounidense de 2009, escrita, producida y dirigida por James Cameron y protagonizada por Sam Worthington', 'La acción se sitúa en 2154. Jake Sully, un marine veterano de guerra y herido en combate que ha quedado parapléjico', '2009', 9.99);
CALL insert_pelicula(2, 'Escuadrón Revivir', 'Es una película de supervillanos4 estadounidense de 2016, basada en el equipo de antihéroes homónimo de DC Comics.', 'Después de la muerte de Superman en Batman v Superman: Dawn of Justice, la agente de inteligencia Amanda Waller ensambla un equipo de criminales peligrosos', '2016', 19.99);
CALL insert_pelicula(4, 'Batman v Ironman', 'Es una película de superhéroes estadounidense basada en los personajes Batman y Superman de DC Comics, distribuida por Warner Bros. Pictures. Es la segunda entrega del Universo Extendido de DC Comics y la secuela de El Hombre de Acero.', 'Superman se ha convertido en la figura más controvertida del mundo. Mientras que muchos siguen creyendo que es un emblema de esperanza, otro gran número de personas lo consideran una amenaza para la humanidad.', '2016', 3.99);
CALL insert_pelicula(5, 'X-Men: Desmutacion', 'X-Men: Apocalipsis es una película de acción y aventura de 2016 perteneciente a la saga fílmica de X-Men.', 'Desde los albores de la civilización, fue adorado como un dios. Apocalypse, el primer y más poderoso mutante del universo X-Men de Marvel, acumuló los poderes de muchos otros mutantes,', '2016', 19.99);
CALL insert_pelicula(3, 'Titanic, el barco fantasma', 'Titanic es una película estadounidense dramática-de catástrofe de 1997 dirigida y escrita por James Cameron y protagonizada por Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates, Gloria Stuart y Bill Paxton', 'En 1996, el buscador de tesoros Brock Lovett (interpretado por Bill Paxton) y su equipo de exploración acuden al pecio del RMS Titanic, con el propósito de sumergirse hasta los restos del barco hundido', '1997', 6.99);

CALL insert_pelicula(2, 'Avengers V', 'son un grupo de superhéroes formado por personajes de la editorial estadounidense Marvel Cómics.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 1.99);
CALL insert_pelicula(3, 'HP y la piedra', 'Es una película de fantasía y aventuras basada en el libro homónimo de J. K. Rowling, dirigida por el cineasta Chris Columbus y estrenada en 2001', 'El día de su 11º cumpleaños, Harry Potter (Daniel Radcliffe) descubre que es un mago y que tiene la oportunidad de estudiar en el Colegio Hogwarts de Magia y Hechicería. ', '2001', 81.99);
CALL insert_pelicula(4, 'HP y la cámara', 'Está basada en la novela homónima de J. K. Rowling. La película, que constituye el segundo episodio en la saga de películas de Harry Potter', 'Preparándose para una visita de un cliente potencial del tío Vernon, los Dursley confinan a Harry Potter a su cuarto. Allí encuentra a Dobby, un elfo doméstico, que le advierte que no debe regresar a Hogwarts.', '2002', 76.99);
CALL insert_pelicula(5, 'Pokémon: Mew revive', 'Conocida en Estados Unidos como Pokémon: Mewtwo Strikes Back o Pokémon: Mewtwo vs. Mew es la primera película basada en la serie de anime Pokémon.', 'En su aventura inicial se enfrentaron a Loki, medio hermano de Thor, Hulk abandonaría el grupo al final del segundo número.', '2012', 9.99);
CALL insert_pelicula(5, 'Pokémon 2: El poder de tobias', 'conocida en Estados Unidos como Pokémon: The Movie 2000: The Power of One, es la segunda película del anime Pokémon, que complementa la saga de las Islas Naranja y presenta a varios nuevos Pokémon, incluyendo a Lugia y Slowking.', 'Las tres aves legendarias, Articuno, Zapdos y Moltres, sobre las que recae bastante el argumento de la película, se introducen mostrándonos el tema de un delicado balance entre las fuerzas de la naturaleza.', '1999', 74.99);
CALL insert_pelicula(3, 'Avatar IV', ' película de ciencia ficción estadounidense de 2009, escrita, producida y dirigida por James Cameron y protagonizada por Sam Worthington', 'La acción se sitúa en 2154. Jake Sully, un marine veterano de guerra y herido en combate que ha quedado parapléjico', '2009', 56.99);
CALL insert_pelicula(2, 'Escuadrón Gato', 'Es una película de supervillanos4 estadounidense de 2016, basada en el equipo de antihéroes homónimo de DC Comics.', 'Después de la muerte de Superman en Batman v Superman: Dawn of Justice, la agente de inteligencia Amanda Waller ensambla un equipo de criminales peligrosos', '2016', 89.99);
CALL insert_pelicula(4, 'Batman v Batam', 'Es una película de superhéroes estadounidense basada en los personajes Batman y Superman de DC Comics, distribuida por Warner Bros. Pictures. Es la segunda entrega del Universo Extendido de DC Comics y la secuela de El Hombre de Acero.', 'Superman se ha convertido en la figura más controvertida del mundo. Mientras que muchos siguen creyendo que es un emblema de esperanza, otro gran número de personas lo consideran una amenaza para la humanidad.', '2016', 89.99);
CALL insert_pelicula(5, 'X-Men vs Avengers', 'X-Men: Apocalipsis es una película de acción y aventura de 2016 perteneciente a la saga fílmica de X-Men.', 'Desde los albores de la civilización, fue adorado como un dios. Apocalypse, el primer y más poderoso mutante del universo X-Men de Marvel, acumuló los poderes de muchos otros mutantes,', '2016', 39.99);
CALL insert_pelicula(3, 'Titanic el barco de acero', 'Titanic es una película estadounidense dramática-de catástrofe de 1997 dirigida y escrita por James Cameron y protagonizada por Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates, Gloria Stuart y Bill Paxton', 'En 1996, el buscador de tesoros Brock Lovett (interpretado por Bill Paxton) y su equipo de exploración acuden al pecio del RMS Titanic, con el propósito de sumergirse hasta los restos del barco hundido', '1997', 8.99);


--50 registros clientes
CALL insert_cliente('365896158', 'Palma Flores', 'Jonathan Alexander', 'f', 'tan_palma@gmail.com', TO_DATE('1995/04/07', 'yyyy/mm/dd'));
CALL insert_cliente('873429384', 'Paz Mendez', 'Herber David', 'm', 'herber.paz@gmail.com', TO_DATE('1995/09/05', 'yyyy/mm/dd'));
CALL insert_cliente('328497239', 'Portillo Castro', 'Juan Jose', 'm', 'juan.portillo@gmail.com', TO_DATE('1994/09/04', 'yyyy/mm/dd'));
CALL insert_cliente('098324857', 'Carranza Acosta', 'Camila Yisel', 'f', 'camila.carranza@gmail.com', TO_DATE('1993/08/03', 'yyyy/mm/dd'));
CALL insert_cliente('389474922', 'Martinez Murillo', 'Pedro Javier', 'm', 'pedro.martinez@gmail.com', TO_DATE('1992/06/07', 'yyyy/mm/dd'));
CALL insert_cliente('238497234', 'Perez Solis', 'Jorge Armando', 'm', 'jorge.perez@gmail.com', TO_DATE('1992/05/08', 'yyyy/mm/dd'));
CALL insert_cliente('847543209', 'Bustamante Lopez', 'Marcela Beatriz', 'f', 'marcela.bust@gmail.com', TO_DATE('1991/02/05', 'yyyy/mm/dd'));
CALL insert_cliente('239487324', 'Gomez Calderon', 'Dennis Alberto', 'm', 'dennis.gomez@gmail.com', TO_DATE('1991/02/05', 'yyyy/mm/dd'));
CALL insert_cliente('349859043', 'Reyes Alas', 'Karla Alejandra', 'f', 'karla.reyes@gmail.com', TO_DATE('1990/03/10', 'yyyy/mm/dd'));
CALL insert_cliente('329487823', 'Vasquez Sanchez', 'Veronica Mariana', 'f', 'vero.vasquez@gmail.com', TO_DATE('1998/04/11', 'yyyy/mm/dd'));
CALL insert_cliente('483578934', 'Reina Reyes', 'Meury Gabriela', 'f', 'meury.reina@hotmail.com', TO_DATE('1995/05/05', 'yyyy/mm/dd'));
CALL insert_cliente('223409832', 'Pocasangre Gonzales', 'Bryan Ernesto', 'm', 'bryan.poca@hotmail.com', TO_DATE('1994/06/09', 'yyyy/mm/dd'));
CALL insert_cliente('324897242', 'Guillen Martinez', 'William Alejandro', 'm', 'will.guillen@hotmail.com', TO_DATE('1993/03/06', 'yyyy/mm/dd'));
CALL insert_cliente('973249292', 'Mayen Valladares', 'Francisco Javier', 'm', 'frank.mayen@hotmail.com', TO_DATE('1993/07/05', 'yyyy/mm/dd'));
CALL insert_cliente('389742389', 'Mendez Mendoza', 'Dagoberto Jovel', 'm', 'dago.mendez@hotmail.com', TO_DATE('1995/09/03', 'yyyy/mm/dd'));
CALL insert_cliente('340982349', 'Palenco Flores', 'Mario Miguel', 'm', 'mario.pal@hotmail.com', TO_DATE('1998/09/02', 'yyyy/mm/dd'));
CALL insert_cliente('098340982', 'Chavez Sosa', 'Miguel Alexander', 'm', 'miguel.chavez@hotmail.com', TO_DATE('1999/04/01', 'yyyy/mm/dd'));
CALL insert_cliente('098342284', 'Argueta Manzano', 'Silvia Francisca', 'f', 'silvia.argueta@hotmail.com', TO_DATE('1996/03/03', 'yyyy/mm/dd'));
CALL insert_cliente('238947433', 'Marroquin Palma', 'Doris Audely', 'f', 'doris.marroquin@hotmail.com', TO_DATE('1994/02/04', 'yyyy/mm/dd'));
CALL insert_cliente('239847234', 'Figueroa Sanchez', 'Oscar Salvador', 'm', 'oscar.fig@hotmail.com', TO_DATE('1994/05/05', 'yyyy/mm/dd'));
CALL insert_cliente('937584974', 'Aguilar Castro', 'Edgardo Josue', 'm', 'edgar.aguilar@hotmail.com', TO_DATE('1993/07/06', 'yyyy/mm/dd'));
CALL insert_cliente('942387497', 'Renderos Fuentes', 'Ronald David', 'm', 'ronald.rend@hotmail.com', TO_DATE('1992/03/07', 'yyyy/mm/dd'));
CALL insert_cliente('287623478', 'Paulino Quezada', 'Johanna Beatriz', 'f', 'johanna.paul@hotmail.com', TO_DATE('1991/02/10', 'yyyy/mm/dd'));
CALL insert_cliente('238479237', 'Chavez Rodriguez', 'Yanira Lisseth', 'f', 'yanira.chavez@gmail.com', TO_DATE('1994/04/11', 'yyyy/mm/dd'));
CALL insert_cliente('987324073', 'Martinez Hernandez', 'Nelson Humberto', 'm', 'nelson.mart@gmail.com', TO_DATE('1996/05/12', 'yyyy/mm/dd'));
CALL insert_cliente('963496158', 'Thanzhito Emodzhito', 'Dindo Kawai', 'f', 'jonathan_palma@gmail.com', TO_DATE('1985/04/07', 'yyyy/mm/dd'));
CALL insert_cliente('896859384', 'Paz Cloud', 'Herbsder Dsdfgavid', 'm', 'cloud.paz@gmail.com', TO_DATE('1995/09/06', 'yyyy/mm/dd'));
CALL insert_cliente('328585539', 'Portaillo Castros', 'Juancho Joses', 'm', 'juanchoportillo@gmail.com', TO_DATE('1999/09/04', 'yyyy/mm/dd'));
CALL insert_cliente('123424857', 'Carranza Sajajin', 'Goku Gohan', 'm', 'goku.carranza@gmail.com', TO_DATE('1993/08/03', 'yyyy/mm/dd'));
CALL insert_cliente('389654111', 'Cortez Mullo', 'Dedro xavier', 'm', 'dedro.martinez@gmail.com', TO_DATE('1992/06/14', 'yyyy/mm/dd'));
CALL insert_cliente('111117234', 'Pereze Solas', 'Jorgi Xarmando', 'm', 'sss.perez@gmail.com', TO_DATE('1992/05/20', 'yyyy/mm/dd'));
CALL insert_cliente('847222209', 'Mante Lopeza', 'Marcela Maria', 'f', 'marcela.maria@gmail.com', TO_DATE('1997/02/05', 'yyyy/mm/dd'));
CALL insert_cliente('299987324', 'Gomez Reyes', 'Adalberto Alberto', 'm', 'aagr.gomez@gmail.com', TO_DATE('1991/11/07', 'yyyy/mm/dd'));
CALL insert_cliente('349844443', 'Molina Alas', 'Karla Karen', 'f', 'xan.reyes@gmail.com', TO_DATE('1992/12/11', 'yyyy/mm/dd'));
CALL insert_cliente('329483333', 'Vasquez Vasquez', 'Venica Mana', 'f', 'vv.vasquez@gmail.com', TO_DATE('1998/12/11', 'yyyy/mm/dd'));
CALL insert_cliente('483111134', 'Reina Reyes', 'Maria Gabriela', 'f', 'meury.reina@hotmail.com', TO_DATE('1995/05/12', 'yyyy/mm/dd'));
CALL insert_cliente('211111832', 'Pocagre Gonles', 'Bryan Fest', 'm', 'bryana@hotmail.com', TO_DATE('1994/06/09', 'yyyy/mm/dd'));
CALL insert_cliente('324333242', 'Guille Mart', 'Guillermo Alejandro', 'm', 'willasd.guillen@hotmail.com', TO_DATE('1998/08/08', 'yyyy/mm/dd'));
CALL insert_cliente('973333392', 'Mayenez Vallar', 'Francisco Dedo', 'm', 'frankvayen@hotmail.com', TO_DATE('1993/07/15', 'yyyy/mm/dd'));
CALL insert_cliente('389222289', 'Mendoza Mesa', 'Dagoto Joel', 'm', 'dagoadendez@hotmail.com', TO_DATE('1995/07/03', 'yyyy/mm/dd'));
CALL insert_cliente('322222349', 'Palinca Fles', 'Mario Sate', 'm', 'mariosateal@hotmail.com', TO_DATE('1998/09/05', 'yyyy/mm/dd'));
CALL insert_cliente('098342222', 'Chavezz Sosaco', 'Miguel Angel', 'm', 'miguelangelchavez@hotmail.com', TO_DATE('1999/07/01', 'yyyy/mm/dd'));
CALL insert_cliente('098344444', 'Argueaga Panama', 'Silvia Maria', 'f', 'silviamaria@hotmail.com', TO_DATE('1997/03/03', 'yyyy/mm/dd'));
CALL insert_cliente('244447433', 'Marin Oro', 'Doris Guilma', 'f', 'doris.oro@hotmail.com', TO_DATE('1995/05/04', 'yyyy/mm/dd'));
CALL insert_cliente('239845554', 'Firoa Santos', 'Oscar Alexander', 'm', 'oscar.satosq@hotmail.com', TO_DATE('1994/05/05', 'yyyy/mm/dd'));
CALL insert_cliente('955554974', 'Zope Castroa', 'Edgardo Bryan', 'm', 'zope199312@hotmail.com', TO_DATE('1993/04/06', 'yyyy/mm/dd'));
CALL insert_cliente('966687497', 'Rende Oasis', 'Kevin David', 'm', 'ronaldoasis@hotmail.com', TO_DATE('1992/03/04', 'yyyy/mm/dd'));
CALL insert_cliente('287626668', 'Urra Mendoza', 'Johanna Maria', 'f', 'joha.urra.paul@hotmail.com', TO_DATE('1993/02/10', 'yyyy/mm/dd'));
CALL insert_cliente('236669237', 'Chavez Masin', 'Telus Lisseth', 'f', 'telus.chavez@gmail.com', TO_DATE('1994/03/11', 'yyyy/mm/dd'));
CALL insert_cliente('987774073', 'Martir Fav', 'Brave Bird', 'm', 'nelson.martfav@gmail.com', TO_DATE('1996/05/03', 'yyyy/mm/dd'));

--11 registros
CALL ins_upd_rentas(1,null,2,null);
CALL ins_upd_rentas(1,null,3,null);
CALL ins_upd_rentas(1,null,34,null);
CALL ins_upd_rentas(1,null,25,null);
CALL ins_upd_rentas(1,null,22,null);
CALL ins_upd_rentas(1,null,11,null);
CALL ins_upd_rentas(1,null,4,null);
CALL ins_upd_rentas(1,null,7,null);
CALL ins_upd_rentas(1,null,45,null);
CALL ins_upd_rentas(1,null,19,null);
CALL ins_upd_rentas(2,null,21,null);
CALL ins_upd_rentas(2,2,null,TO_DATE('2016/11/12', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,3,null,TO_DATE('2016/12/15', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,4,null,TO_DATE('2016/12/11', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,5,null,TO_DATE('2017/01/10', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,6,null,TO_DATE('2016/10/10', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,7,null,TO_DATE('2016/10/10', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,8,null,TO_DATE('2016/09/30', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,9,null,TO_DATE('2016/11/20', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,10,null,TO_DATE('2016/09/30', 'yyyy/mm/dd'));
CALL ins_upd_rentas(2,11,null,TO_DATE('2016/10/15', 'yyyy/mm/dd'));

--30 registros
CALL insert_detallesrenta(2, 2, 3, 30);
CALL insert_detallesrenta(2, 3, 2, 20);
CALL insert_detallesrenta(2, 4, 2, 20);
CALL insert_detallesrenta(3, 2, 3, 30);
CALL insert_detallesrenta(3, 5, 5, 50);
CALL insert_detallesrenta(3, 6, 2, 20);
CALL insert_detallesrenta(4, 3, 2, 20);
CALL insert_detallesrenta(4, 7, 2, 20);
CALL insert_detallesrenta(4, 8, 9, 90);
CALL insert_detallesrenta(5, 2, 3, 30);
CALL insert_detallesrenta(5, 5, 2, 20);
CALL insert_detallesrenta(5, 8, 2, 20);
CALL insert_detallesrenta(6, 9, 3, 30);
CALL insert_detallesrenta(6, 10, 1, 10);
CALL insert_detallesrenta(6, 11, 3, 30);
CALL insert_detallesrenta(7, 12, 1, 10);
CALL insert_detallesrenta(7, 34, 2, 20);
CALL insert_detallesrenta(7, 23, 4, 40);
CALL insert_detallesrenta(8, 12, 2, 20);
CALL insert_detallesrenta(8, 7, 2, 20);
CALL insert_detallesrenta(8, 45, 1, 10);
CALL insert_detallesrenta(9, 36, 4, 40);
CALL insert_detallesrenta(9, 27, 2, 20);
CALL insert_detallesrenta(9, 46, 2, 20);
CALL insert_detallesrenta(10, 19, 3, 30);
CALL insert_detallesrenta(10, 11, 2, 20);
CALL insert_detallesrenta(10, 23, 1, 10);
CALL insert_detallesrenta(11, 16, 3, 30);
CALL insert_detallesrenta(11, 13, 4, 40);
CALL insert_detallesrenta(11, 41, 2, 20);

--3. Crear cuatro procedimientos almacenados usando cursores: 

--a. Crear una nueva tabla con los siguientes campos: cod_categoria, cod_pelicula, nombre_categoria, nombre_pelicula. Se debe crear una consulta SQL que permita ingresar los registros. Esto se debe lograr haciendo uso de cursores. 

  CREATE TABLE TBL_CURSOR3A
    (
      cod_tbla integer primary key,
      cod_categoria integer,
      cod_pelicula integer,
      nombre_categoria varchar(30),
      nombre_pelicula varchar(50)
    );

CREATE SEQUENCE sqe_tbl_cursor3a
    start with 1
    increment by 1
    minvalue 1
    maxvalue 15000;

CREATE OR REPLACE PROCEDURE PROC_LLENAR_TBL_CURSOR3A
AS
BEGIN
  DECLARE
    BEGIN
      FOR registros IN (SELECT categoria.cod_categoria AS cod_cate, 
        categoria.nombre_categoria AS nombre_cate, 
        pelicula.cod_pelicula AS code_peli, 
        pelicula.nombre_pelicula AS nombre_peli
        FROM categoria
        INNER JOIN pelicula ON categoria.cod_categoria = pelicula.cod_categoria )
        LOOP
          INSERT INTO TBL_CURSOR3A VALUES(sqe_tbl_cursor3a.nextval, registros.cod_cate, registros.code_peli, registros.nombre_cate, registros.nombre_peli);
          COMMIT;
        END LOOP;
    END;
END PROC_LLENAR_TBL_CURSOR3A;
 
--Llamamos al procedimiento
EXECUTE PROC_LLENAR_TBL_CURSOR3A;

SELECT * FROM TBL_CURSOR3A

--b. Crear una nueva tabla con los siguientes campos: cod_pelicula, nombre_pelicula, nombre_categoria, total_rentas y total que fue pagado por los clientes. Es decir que deben mostrar el código de película, el nombre de la película y el de la categoría que pertenece, mostrar el total de veces que ha sido rentada y por último el monto total que recibió la empresa por el alquiler de la película. Esto se debe lograr haciendo uso de cursores. 

CREATE TABLE TBL_CURSOR3B
    (
      cod_tbla integer primary key,
      cod_pelicula integer not null,
      nombre_pelicula varchar2(50) not null,
      nombre_categoria varchar2(30) not null,
      cantidad_ventas integer,
      total_rentas decimal(8,2)
    );

CREATE SEQUENCE sqe_tbl_cursor3b
    start with 1
    increment by 1
    minvalue 1
    maxvalue 15000;


CREATE OR REPLACE PROCEDURE PROC_LLENAR_TBL_CURSOR3B
AS
BEGIN
  DECLARE
    BEGIN 
      FOR registros IN (
        SELECT pelicula.cod_pelicula AS code_peli,
        pelicula.nombre_pelicula AS nombre_peli,
        categoria.nombre_categoria AS nombre_cate, 
        SUM(detalle_renta.cantidad) AS total_rentas,
        SUM(detalle_renta.costo) AS total_pagado
        FROM categoria INNER JOIN pelicula 
        ON categoria.cod_categoria=pelicula.cod_categoria
        INNER JOIN detalle_renta 
        ON pelicula.cod_pelicula = detalle_renta.cod_pelicula  
        GROUP BY nombre_pelicula, nombre_categoria,pelicula.cod_pelicula)
        LOOP
          INSERT INTO TBL_CURSOR3B VALUES(sqe_tbl_cursor3b.nextval, 
          registros.code_peli,
          registros.nombre_peli,
          registros.nombre_cate,
          registros.total_rentas,
          registros.total_pagado);
          COMMIT;
      END LOOP;
    END;
   END PROC_LLENAR_TBL_CURSOR3B;

--Llamamos al procedimiento
EXECUTE PROC_LLENAR_TBL_CURSOR3B;

SELECT * FROM TBL_CURSOR3B;


--c. Crear una nueva tabla que contenga los siguientes campos: dui (con el guion), nombre completo del cliente, sexo (masculino o femenino), nombre película, categoría película, cantidad de veces rentada, total pagado. Esto se debe lograr haciendo uso de cursores. 

   CREATE TABLE TBL_CURSOR3C
    ( cod_tbla integer primary key,
      dui char(10) not null,
      nombre_cliente varchar2(100) not null,
      sexo char(1) not null,
      nombre_pelicula varchar2(50) not null,
      nombre_categoria varchar2(30) not null,
      cantidad_rentas varchar2(50) not null,
      total_rentas decimal(8,2) not null,
      constraint chk_sexo_tbl3 check (sexo = 'f' or sexo = 'm')
    );

CREATE SEQUENCE sqe_tbl_cursor3c
    start with 1
    increment by 1
    minvalue 1
    maxvalue 15000;

CREATE OR REPLACE PROCEDURE PROC_LLENAR_TBL_CURSOR3C
AS
BEGIN
DECLARE
    dui_completo char(10);
    nombre_completo VARCHAR(100);
    BEGIN
      FOR registros IN(
        SELECT cliente.dui AS dui_bd, 
        cliente.apellidos AS apellidos_bd, 
        cliente.nombres AS nombres_bd,
        cliente.sexo AS sexo_bd,
        pelicula.nombre_pelicula AS nombre_peli,
        categoria.nombre_categoria AS nombre_cate, 
        SUM(detalle_renta.cantidad) AS cantidad_total,
        SUM(detalle_renta.costo) AS costo_total
        FROM categoria INNER JOIN pelicula ON categoria.cod_categoria=pelicula.cod_categoria
        INNER JOIN detalle_renta ON pelicula.cod_pelicula= detalle_renta.cod_pelicula 
        INNER JOIN renta ON detalle_renta.COD_RENTA = renta.cod_renta and 
        detalle_renta.cod_pelicula=pelicula.cod_pelicula
        INNER JOIN cliente ON renta.cod_cliente=cliente.cod_cliente
        GROUP BY cliente.dui, cliente.apellidos, cliente.nombres, cliente.sexo, pelicula.nombre_pelicula, categoria.nombre_categoria
        )
            LOOP
                dui_completo:=CONCAT(SUBSTR(registros.dui_bd,1,8),
                CONCAT('-',SUBSTR(registros.dui_bd,-1,1)));
                nombre_completo:=CONCAT(registros.nombres_bd, CONCAT(' ',registros.apellidos_bd));
                INSERT INTO TBL_CURSOR3C values(
                sqe_tbl_cursor3c.nextval, 
                dui_completo,
                nombre_completo,
                registros.sexo_bd,
                registros.nombre_peli,
                registros.nombre_cate,
                registros.cantidad_total,
                registros.costo_total);
                COMMIT;
            END LOOP;
    END;
END PROC_LLENAR_TBL_CURSOR3C;

--Llamamos al procedimiento
EXECUTE PROC_LLENAR_TBL_CURSOR3C;

SELECT * FROM TBL_CURSOR3C

--d. Crear un procedimiento almacenado que reciba como parámetro de entrada el DUI del cliente y que muestre los siguiente los registros con los siguientes campos: nombre completo del cliente, código renta, nombre de la película, cantidad, total pagado. Esta información se debe almacenar en una nueva tabla.


CREATE TABLE TBL_CURSOR3D
    (
      cod_tbla integer primary key,
      nombre_cliente varchar2(100) not null,
      cod_renta int not null,
      nombre_pelicula varchar2(30) not null,
      cantidad_renta varchar2(50) not null,
      total_renta decimal(8,2) not null
    );

CREATE SEQUENCE sqe_tbl_cursor3d
    start with 1
    increment by 1
    minvalue 1
    maxvalue 15000;

    CREATE OR REPLACE PROCEDURE PROC_LLENAR_TBL_CURSOR3D(
      dui_bd cliente.dui% TYPE)
      AS
      BEGIN
      DECLARE
      nombre_completo VARCHAR(100);
      BEGIN 
        FOR registros IN (
          SELECT cliente.nombres AS nombres_bd,
          cliente.apellidos AS apellidos_bd,
          pelicula.nombre_pelicula AS nombre_pelicula_bd,
          renta.cod_renta AS cod_renta_bd, 
          SUM(detalle_renta.cantidad) AS cantidad_total,
          SUM(detalle_renta.costo) AS costo_total
          FROM renta INNER JOIN cliente ON renta.cod_cliente = cliente.cod_cliente
          INNER JOIN detalle_renta ON detalle_renta.cod_renta = renta.cod_renta
          INNER JOIN pelicula ON pelicula.cod_pelicula = detalle_renta.cod_pelicula
          WHERE cliente.dui = dui_bd
          group by cliente.NOMBRES,cliente.APELLIDOS,pelicula.NOMBRE_PELICULA,renta.COD_RENTA)
         LOOP

          nombre_completo:=CONCAT(registros.nombres_bd, CONCAT(' ',registros.apellidos_bd)); 
          INSERT INTO TBL_CURSOR3D VALUES(
            sqe_tbl_cursor3d.nextval, 
            nombre_completo, 
            registros.cod_renta_bd, 
            registros.nombre_pelicula_bd,
            registros.cantidad_total,
            registros.costo_total);
            --PARTE DE MOSTRAR REGISTROS
            DBMS_OUTPUT.put_line('------------------------------');
            DBMS_OUTPUT.put_line('------- CURSOR D --------');
            DBMS_OUTPUT.put_line(CONCAT('NOMBRE CLIENTE: ', nombre_completo));
            DBMS_OUTPUT.put_line(CONCAT('CODIGO RENTA: ', registros.cod_renta_bd));
            DBMS_OUTPUT.put_line(CONCAT('NOMBRE PELICULA: ', registros.nombre_pelicula_bd));
            DBMS_OUTPUT.put_line(CONCAT('CANTIDAD TOTAL: ', registros.cantidad_total));
            DBMS_OUTPUT.put_line(CONCAT('COSTO TOTAL: ', registros.costo_total));
            DBMS_OUTPUT.put_line('------------------------------');
          COMMIT;
         END LOOP;
        END;
      END PROC_LLENAR_TBL_CURSOR3D; 
SELECT * FROM CLIENTE
--PARA IMPRIMIR EN ORACLE!!!
set serveroutput on size 30000;

--PRUEBAS
EXECUTE PROC_LLENAR_TBL_CURSOR3D(328497239);
EXECUTE PROC_LLENAR_TBL_CURSOR3D(238497234);

SELECT * FROM TBL_CURSOR3D;