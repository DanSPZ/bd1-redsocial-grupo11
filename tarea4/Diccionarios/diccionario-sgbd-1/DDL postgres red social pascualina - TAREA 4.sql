-- Tarea4. Comparar la implementación de un diccionario de datos físico en diferentes SGBD - PostgreSQL
-- Grupo 11
-- Integrante: Daniel Steven Pineda Zafra

-- Se crea tabla estudiante con sus atributos y restricciones
CREATE TABLE ESTUDIANTE (
-- Definicion de atributos
	
	-- identificador unico para estudiante
	CEDULA VARCHAR(12),
	
	-- Nombre del estudiante obligatorio
	NOMBRE VARCHAR(25) NOT NULL,
	
	-- Apellidos del estudiante obligatorio (puede ser simple o compuesto con espacios incluidos)
	APELLIDOS VARCHAR(25) NOT NULL,
	
	-- Correo institucional del estudiante obligatorio y unico, no se puede repetir en otro estudiante
	CORREO_INSTITUCIONAL VARCHAR(50) NOT NULL,
	
	-- Carrera del estudiante obligatorio
	CARRERA VARCHAR(50) NOT NULL,
	
	-- Semestre que cursa el estudiante obligatorio
	SEMESTRE INT NOT NULL,
	
	-- Numero de contacto del estudiante opcional, contemplano un caracter como el +
	NUMERO_CONTACTO VARCHAR(15),
	
-- Definicion de Reglas 
	
	-- Se prefiere definir las restricciones acá abajo para una manipulacion mas limpia en un futuro, pensando en
	-- codificaión modular
	
	-- Definicion de la clave primaria de la tabla estudiante
	CONSTRAINT PK_ESTUDIANTE PRIMARY KEY (CEDULA),
	
	-- Definicion de la unicidad de correo para esta tabla, no pueden hablar dos correos iguales
	CONSTRAINT UQ_CORREO UNIQUE (CORREO_INSTITUCIONAL),
	
	-- Definicion de una regla que solo permita el ingreso de numeros entre el 1 y el 20,
	-- que es logico para la cantidad de semestres en el pascual
	CONSTRAINT CK_SEMESTRE CHECK (SEMESTRE BETWEEN 1 AND 20)
);


-- Se crea tabla interes con sus atributos y restricciones
CREATE TABLE INTERES (
-- Definicion de atributos

	-- Identificador entero generado automaticamente
	id_interes INTEGER GENERATED ALWAYS AS IDENTITY,
	
	-- Nombre del interes obligatorio
	NOMBRE_INTERES VARCHAR(20) NOT NULL,
	
	-- Definicion de Reglas
	
	-- Definicion de la clave primaria para esta tabla
	CONSTRAINT PK_INTERES PRIMARY KEY (ID_INTERES)
);


-- Se crea tabla publicacion con sus atributos y restricciones
CREATE TABLE PUBLICACION (
-- Definicion de atributos

	-- identificador de la publicacion
	-- Se utiliza UUID en lugar de VARCHAR(12) para generar identificadores
	-- automaticamente, reduciendo el riesgo de duplicados.
	-- gen_random_uuid() genera el identificador al crear una publicacion
	-- si no se proporciona uno. La PK garantiza su unicidad.
	ID_PUBLICACION UUID DEFAULT GEN_RANDOM_UUID(),
	
	-- Contenido de la publicación
	CONTENIDO VARCHAR(20000) NOT NULL,
	
	-- Cedula del autor, clave foranea definida en el modulo de abajo
	CEDULA_AUTOR VARCHAR(12) NOT NULL,
	
	-- Fecha de la publicación
	FECHA_PUBLICACION DATE NOT NULL DEFAULT CURRENT_DATE,
	
-- Definicion de Reglas

	--Definicion de la clave primaria
	CONSTRAINT PK_PUBLICACION PRIMARY KEY (ID_PUBLICACION),
	-- Definicion de la clave foranea 
	-- ON DELETE CASCADE elimina las publicaciones del estudiante eliminado.
	-- ON UPDATE CASCADE actualiza las FK si cambia la cedula del estudiante.
	CONSTRAINT FK_PUBLICACION FOREIGN KEY (CEDULA_AUTOR) REFERENCES ESTUDIANTE (CEDULA) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);

-- Se crea tabla estudiante_interes con sus atributos y restricciones, resuelve la relacion muchos a muchos entre
-- estudiante e interes
CREATE TABLE ESTUDIANTE_INTERES (
-- Definicion de atributos

	-- Cedula del estudiante que tiene un interes
	CEDULA VARCHAR(12),
	
	-- ID del interes existente: INTEGER como en la tabla padre.
	id_interes INTEGER NOT NULL,
	
-- Definicion de Reglas

	-- Creacion de la clave primaria compuesta
	CONSTRAINT PK_COMPUESTA_ESTUDIANTE_INTERES PRIMARY KEY (CEDULA, ID_INTERES),
	
	-- Creacion de las claves foraneas
	
	-- Clave foranea hacia estudiante, al eliminar un estudiante se eliminan sus asociaciones
	CONSTRAINT FK_1_ESTUDIANTE FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	
	-- Clave foranea hacia interes, al eliminar un interes se eliminan sus asociaciones
	CONSTRAINT FK_2_INTERES FOREIGN KEY (ID_INTERES) REFERENCES INTERES (ID_INTERES)
	ON UPDATE CASCADE 
	ON DELETE CASCADE
);



-- Se crea tabla habilidad con sus atributos y restricciones
CREATE TABLE HABILIDAD (
-- Definicion de atributos
	
	-- Identificador unico de cada habilidad generado automaticamente
	ID_HABILIDAD INTEGER GENERATED ALWAYS AS IDENTITY,
	
	-- Nombre de la habilidad, obligatorio
	NOMBRE_HABILIDAD VARCHAR(25) NOT NULL,
	
-- Definicion de Reglas
	CONSTRAINT PK_HABILIDAD PRIMARY KEY (ID_HABILIDAD)
);


-- Se crea la tabla deporte para almacenar los deportes
-- que pueden registrar los estudiantes de la red social.
CREATE TABLE DEPORTE (
-- Definicion de atributos

	-- Identificador unico de cada deporte registrado y autoincremental.
	ID_DEPORTE INTEGER GENERATED ALWAYS AS IDENTITY,
	
	-- Nombre del deporte, campo obligatorio.
	NOMBRE_DEPORTE VARCHAR(25) NOT NULL,
	
	-- Clasificacion del deporte, por ejemplo:
	-- individual, de equipo, acuatico o de contacto.
	TIPO_DEPORTE VARCHAR(25) NOT NULL,
	
-- Definicion de reglas
	-- Clave primaria que identifica cada deporte,
	-- impidiendo valores nulos e identificadores duplicados.
	CONSTRAINT PK_DEPORTE PRIMARY KEY (ID_DEPORTE)
);

-- Se crea la tabla grupo para almacenar los grupos
-- academicos, sociales o de intereses de los estudiantes.

CREATE TABLE GRUPO (
-- Definicion de atributos
	
	-- Identificador unico del grupo, generado automaticamente.
	ID_GRUPO UUID DEFAULT GEN_RANDOM_UUID(),
	
	-- Cedula del estudiante que creo el grupo.
	CEDULA_CREADOR VARCHAR(12) NOT NULL,
	
	-- Nombre del grupo, obligatorio.
	NOMBRE_GRUPO VARCHAR(50) NOT NULL,
	
	-- Descripcion opcional del proposito del grupo.
	DESCRIPCION VARCHAR(200),
	
	-- Fecha de creacion, por defecto la fecha actual.
	FECHA_CREACION DATE NOT NULL DEFAULT CURRENT_DATE,
	
	-- Indica si el grupo es publico o privado.
	-- Se debe mantener una convencion para TRUE=privado y FALSE=publico.
	PRIVACIDAD BOOLEAN NOT NULL,
-- Definicion de reglas
	
	-- Clave primaria que identifica cada grupo.
	CONSTRAINT PK_GRUPO PRIMARY KEY (ID_GRUPO),
	
	-- Clave foranea hacia el estudiante creador.
	-- ON UPDATE CASCADE actualiza la cedula si cambia.
	-- ON DELETE RESTRICT impide eliminar al estudiante
	-- mientras tenga grupos creados.
	CONSTRAINT FK_CEDULA_CREADOR FOREIGN KEY (CEDULA_CREADOR) REFERENCES ESTUDIANTE (CEDULA) 
	ON UPDATE CASCADE 
	ON DELETE RESTRICT
);


-- Se crea la tabla ingreso_grupo para registrar los estudiantes
-- que pertenecen a cada grupo y el rol que desempeñan.
create table ingreso_grupo (

-- Definicion de atributos

    -- Cedula del estudiante que ingresa al grupo.
    cedula varchar(12),

    -- Identificador UUID del grupo al que pertenece.
    id_grupo uuid,

    -- Fecha de ingreso, por defecto la fecha actual.
    fecha_ingreso date not null DEFAULT current_date,

    -- Rol del estudiante dentro del grupo, obligatorio.
    rol varchar(25) not null,

-- Definicion de Reglas

    -- Clave primaria compuesta que impide registrar
    -- dos veces al mismo estudiante en el mismo grupo.
    CONSTRAINT pk_comp_cedula_idgrupo PRIMARY key (cedula, id_grupo),

    -- Clave foranea hacia estudiante.
    -- CASCADE actualiza la cedula y elimina sus membresias
    -- si el estudiante es eliminado.
    CONSTRAINT fk1_estudiante FOREIGN key (cedula) REFERENCES estudiante(cedula)
    ON update cascade
    on delete cascade,

    -- Clave foranea hacia grupo.
    -- CASCADE actualiza el ID y elimina las membresias
    -- cuando se elimina el grupo.
    CONSTRAINT fk2_idgrupo FOREIGN key (id_grupo) REFERENCES grupo(id_grupo)
    ON update cascade
    on delete cascade
);

-- Se crea la tabla evento para registrar las actividades
-- academicas, deportivas o sociales de los estudiantes.
create table evento (

-- Definicion de atributos

    -- Identificador unico del evento, generado automaticamente.
    id_evento uuid default GEN_RANDOM_UUID(),

    -- Cedula del estudiante que crea el evento.
    cedula_creador varchar(12) not null,

    -- Nombre del evento, obligatorio.
    nombre_evento varchar(50) not null,

    -- Descripcion opcional de la actividad.
    descripcion varchar(200),

    -- Fecha y hora programadas para el evento.
    fecha_hora_evento timestamp NOT NULL,

    -- Lugar donde se realizara el evento, obligatorio.
    lugar_evento varchar(100) NOT NULL,
    -- Datos opcionales de geolocalizacion obtenidos mediante GPS.
    -- PostgreSQL utiliza JSONB para almacenar informacion semiestructurada
    -- como latitud, longitud, precision y fuente de ubicacion.
    ubicacion_gps JSONB,

-- Definicion de reglas

    -- Clave primaria que identifica cada evento.
    CONSTRAINT pk_evento PRIMARY KEY(id_evento),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE RESTRICT impide eliminar al estudiante
    -- mientras tenga eventos creados.
    CONSTRAINT fk_estudiante FOREIGN KEY (cedula_creador) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Se crea la tabla conexion para registrar las relaciones
-- de seguimiento entre estudiantes de la red social.
CREATE TABLE conexion (
-- Definicion de atributos

    -- Cedula del estudiante que realiza el seguimiento.
    cedula_seguidor VARCHAR(12),

    -- Cedula del estudiante que es seguido.
    cedula_seguido VARCHAR(12),

    -- Fecha de conexion, por defecto la fecha actual.
    fecha_conexion DATE NOT NULL DEFAULT CURRENT_DATE,

-- Definicion de reglas

    -- Clave primaria compuesta que evita conexiones duplicadas.
    CONSTRAINT pk_comp_seguidor_seguido PRIMARY KEY (cedula_seguidor, cedula_seguido),

    -- Clave foranea hacia el estudiante seguidor.
    -- CASCADE actualiza la cedula y elimina sus conexiones
    -- si el estudiante es eliminado.
    CONSTRAINT fk1_seguidor FOREIGN KEY (cedula_seguidor) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia el estudiante seguido.
    -- CASCADE actualiza la cedula y elimina sus conexiones
    -- si el estudiante es eliminado.
    CONSTRAINT fk2_seguido FOREIGN KEY (cedula_seguido) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Impide que un estudiante se siga a si mismo.
    CONSTRAINT ck_no_autoseguimiento CHECK (cedula_seguidor <> cedula_seguido)
);


-- Se crea la tabla mentoria para registrar las relaciones
-- de orientacion academica entre estudiantes.
CREATE TABLE mentoria (

-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    id_mentoria INTEGER GENERATED ALWAYS AS IDENTITY,

    -- Cedula del estudiante que ofrece la mentoria.
    cedula_mentor VARCHAR(12) NOT NULL,

    -- Cedula del estudiante que recibe la mentoria.
    cedula_aprendiz VARCHAR(12) NOT NULL,

    -- Fecha de inicio, por defecto la fecha actual.
    fecha_inicio_mentoria DATE NOT NULL DEFAULT CURRENT_DATE,

    -- Fecha de finalizacion opcional, puede permanecer NULL.
    fecha_fin_mentoria DATE,

    -- Descripcion del objetivo de la mentoria, obligatoria.
    descripcion VARCHAR(200) NOT NULL,

-- Definicion de reglas

    -- Clave primaria de la mentoria.
    CONSTRAINT pk_mentoria PRIMARY KEY (id_mentoria),

    -- Clave foranea hacia el estudiante mentor.
    -- CASCADE actualiza su cedula y elimina sus mentorias
    -- si el estudiante es eliminado.
    CONSTRAINT fk1_mentor FOREIGN KEY (cedula_mentor) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia el estudiante aprendiz.
    -- CASCADE actualiza su cedula y elimina sus mentorias
    -- si el estudiante es eliminado.
    CONSTRAINT fk2_aprendiz FOREIGN KEY (cedula_aprendiz) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Impide que un estudiante sea su propio mentor.
    CONSTRAINT ck_mentoria CHECK (cedula_mentor <> cedula_aprendiz),

    -- Impide que la fecha de finalizacion sea anterior al inicio.
    -- Permite NULL cuando la mentoria sigue activa.
    CONSTRAINT ck_fechas_mentoria CHECK (
        fecha_fin_mentoria IS NULL
        OR fecha_fin_mentoria >= fecha_inicio_mentoria
    )
);

-- Se crea la tabla asistencia para registrar la participacion
-- de los estudiantes en los eventos de la red social.
CREATE TABLE asistencia (

-- Definicion de atributos

    -- Cedula del estudiante que responde al evento.
    cedula VARCHAR(12),

    -- Identificador UUID del evento correspondiente.
    id_evento UUID,

    -- Confirmacion de asistencia: TRUE = si, FALSE = no.
    respuesta BOOLEAN NOT NULL,

    -- Fecha y hora en que el estudiante registra su respuesta.
    fecha_respuesta TIMESTAMP NOT NULL,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces al mismo estudiante en el mismo evento.
    CONSTRAINT pk_asistencia PRIMARY KEY (cedula, id_evento),

    -- Clave foranea hacia estudiante.
    -- CASCADE actualiza su cedula y elimina sus asistencias
    -- cuando el estudiante es eliminado.
    CONSTRAINT fk1_cedula FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Clave foranea hacia evento.
    -- CASCADE actualiza el identificador y elimina las asistencias
    -- si el evento es eliminado.
    CONSTRAINT fk2_evento FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- Se crea la tabla actividad_fisica para registrar los deportes
-- que practican los estudiantes y su frecuencia.
CREATE TABLE actividad_fisica (

-- Definicion de atributos

    -- Cedula del estudiante que practica el deporte.
    cedula VARCHAR(12),

    -- Identificador del deporte asociado al estudiante.
    id_deporte INTEGER,

    -- Frecuencia con la que practica el deporte.
    frecuencia VARCHAR(25),

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces el mismo deporte para un estudiante.
    CONSTRAINT pk_comp_actfisica PRIMARY KEY (cedula, id_deporte),

    -- Clave foranea hacia estudiante.
    -- CASCADE actualiza la cedula y elimina sus asociaciones
    -- deportivas si el estudiante es eliminado.
    CONSTRAINT fk1_estudiante FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia deporte.
    -- CASCADE actualiza el identificador y elimina las asociaciones
    -- correspondientes si se elimina el deporte.
    CONSTRAINT fk2_deporte FOREIGN KEY (id_deporte) REFERENCES deporte(id_deporte)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


-- Se crea la tabla estudiante_habilidad para registrar las
-- habilidades de cada estudiante y su nivel de dominio.
CREATE TABLE estudiante_habilidad (

-- Definicion de atributos

    -- Cedula del estudiante que posee la habilidad.
    cedula VARCHAR(12),

    -- Identificador de la habilidad asociada.
    id_habilidad INTEGER,

    -- Nivel de dominio de la habilidad, opcional.
    nivel_habilidad VARCHAR(20),

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces la misma habilidad para un estudiante.
    CONSTRAINT pk_estuhabilidad PRIMARY KEY (cedula, id_habilidad),

    -- Clave foranea hacia estudiante.
    -- CASCADE actualiza la cedula y elimina sus asociaciones
    -- con habilidades cuando se elimina el estudiante.
    CONSTRAINT fk1_estudiante FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia habilidad.
    -- CASCADE actualiza el identificador y elimina las asociaciones
    -- correspondientes cuando se elimina una habilidad.
    CONSTRAINT fk2_habilidad FOREIGN KEY (id_habilidad) REFERENCES habilidad(id_habilidad)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);