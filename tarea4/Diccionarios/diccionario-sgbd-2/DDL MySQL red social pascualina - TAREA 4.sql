-- Tarea4. Comparar la implementación de un diccionario de datos físico en diferentes SGBD - MySQL
-- Grupo 11
-- Integrante: Daniel Steven Pineda Zafra


CREATE TABLE estudiante (
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

-- Definicion de reglas
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

CREATE TABLE INTERES (
-- Definicion de atributos

	-- Identificador entero generado automaticamente
	id_interes INTEGER AUTO_INCREMENT,
	
	-- Nombre del interes obligatorio
	NOMBRE_INTERES VARCHAR(20) NOT NULL,
	
	-- Definicion de Reglas
	
	-- Definicion de la clave primaria para esta tabla
	CONSTRAINT PK_INTERES PRIMARY KEY (ID_INTERES)
);


-- Se crea tabla publicacion con sus atributos y restricciones
CREATE TABLE PUBLICACION (
-- Definicion de atributos

    -- Identificador unico de la publicacion.
    -- MySQL utiliza CHAR(36) para almacenar el UUID como texto.
    -- UUID() genera automaticamente el identificador cuando no se proporciona.
    -- La clave primaria garantiza que no existan identificadores duplicados.
    ID_PUBLICACION CHAR(36) DEFAULT (UUID()),

    -- Contenido obligatorio de la publicacion.
    -- MEDIUMTEXT permite textos extensos.
    -- Su longitud se limita a 20000 caracteres mediante una regla CHECK.
    CONTENIDO MEDIUMTEXT NOT NULL,

    -- Cedula del autor, clave foranea hacia estudiante.
    CEDULA_AUTOR VARCHAR(12) NOT NULL,

    -- Fecha de la publicacion, por defecto la fecha actual.
    FECHA_PUBLICACION DATE NOT NULL DEFAULT (CURRENT_DATE()),

-- Definicion de Reglas

    -- Definicion de la clave primaria.
    CONSTRAINT PK_PUBLICACION PRIMARY KEY (ID_PUBLICACION),

    -- Definicion de la clave foranea.
    -- ON DELETE CASCADE elimina las publicaciones del estudiante eliminado.
    -- ON UPDATE CASCADE actualiza las FK si cambia la cedula del estudiante.
    CONSTRAINT FK_PUBLICACION FOREIGN KEY (CEDULA_AUTOR) REFERENCES ESTUDIANTE (CEDULA)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Limita el contenido a un maximo de 20000 caracteres,
    -- manteniendo la restriccion de longitud definida en PostgreSQL.
    CONSTRAINT CK_CONTENIDO CHECK (CHAR_LENGTH(CONTENIDO) <= 20000)
);

-- Se crea tabla estudiante_interes con sus atributos y restricciones.
-- Resuelve la relacion muchos a muchos entre estudiante e interes.
CREATE TABLE ESTUDIANTE_INTERES (
-- Definicion de atributos

    -- Cedula del estudiante que tiene un interes.
    CEDULA VARCHAR(12),

    -- ID del interes existente: INTEGER como en la tabla padre.
    ID_INTERES INTEGER NOT NULL,

-- Definicion de reglas

    -- Creacion de la clave primaria compuesta.
    CONSTRAINT PK_COMPUESTA_ESTUDIANTE_INTERES PRIMARY KEY (CEDULA, ID_INTERES),

    -- Creacion de las claves foraneas.
    -- En MySQL los nombres de las restricciones FOREIGN KEY deben ser
    -- unicos en toda la base de datos, no solo dentro de cada tabla.

    -- Clave foranea hacia estudiante.
    -- Al eliminar un estudiante se eliminan sus asociaciones.
    CONSTRAINT FK_ESTUDIANTE_INTERES_ESTUDIANTE
        FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia interes.
    -- Al eliminar un interes se eliminan sus asociaciones.
    CONSTRAINT FK_ESTUDIANTE_INTERES_INTERES
        FOREIGN KEY (ID_INTERES) REFERENCES INTERES (ID_INTERES)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Se crea tabla habilidad con sus atributos y restricciones
CREATE TABLE HABILIDAD (
-- Definicion de atributos
	
	-- Identificador unico autoincremental.
	-- MySQL utiliza AUTO_INCREMENT en lugar de GENERATED ALWAYS AS IDENTITY de PostgreSQL.
	ID_HABILIDAD INTEGER AUTO_INCREMENT,
	
	-- Nombre de la habilidad, obligatorio
	NOMBRE_HABILIDAD VARCHAR(25) NOT NULL,
	
-- Definicion de Reglas
	CONSTRAINT PK_HABILIDAD PRIMARY KEY (ID_HABILIDAD)
);

-- Se crea la tabla deporte para almacenar los deportes
-- que pueden registrar los estudiantes de la red social.
CREATE TABLE DEPORTE (
-- Definicion de atributos

	-- Identificador unico autoincremental.
	-- MySQL utiliza AUTO_INCREMENT en lugar de GENERATED ALWAYS AS IDENTITY de PostgreSQL.
	ID_DEPORTE INTEGER AUTO_INCREMENT,
	
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
    -- MySQL utiliza CHAR(36) en lugar del tipo UUID nativo de PostgreSQL.
    -- UUID() genera el identificador si no se proporciona uno.
    ID_GRUPO CHAR(36) DEFAULT (UUID()),

    -- Cedula del estudiante que creo el grupo.
    CEDULA_CREADOR VARCHAR(12) NOT NULL,

    -- Nombre del grupo, obligatorio.
    NOMBRE_GRUPO VARCHAR(50) NOT NULL,

    -- Descripcion opcional del proposito del grupo.
    DESCRIPCION VARCHAR(200),

    -- Fecha de creacion, por defecto la fecha actual.
    FECHA_CREACION DATE NOT NULL DEFAULT (CURRENT_DATE()),

    -- Indica la privacidad del grupo: 1 = privado, 0 = publico.
    -- En MySQL BOOLEAN equivale a TINYINT(1), por lo que se
    -- utiliza CHECK para restringir los valores permitidos.
    PRIVACIDAD TINYINT(1) NOT NULL,

-- Definicion de reglas

    -- Clave primaria que identifica cada grupo.
    CONSTRAINT PK_GRUPO PRIMARY KEY (ID_GRUPO),

    -- Clave foranea hacia el estudiante creador.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE RESTRICT impide eliminar al estudiante
    -- mientras tenga grupos creados.
    CONSTRAINT FK_CEDULA_CREADORGRUPO FOREIGN KEY (CEDULA_CREADOR) REFERENCES ESTUDIANTE (CEDULA)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    -- Permite unicamente los valores 0 y 1 para la privacidad.
    CONSTRAINT CK_GRUPO_PRIVACIDAD CHECK (PRIVACIDAD IN (0, 1))
);


-- Se crea la tabla ingreso_grupo para registrar los estudiantes
-- que pertenecen a cada grupo y el rol que desempeñan.
CREATE TABLE INGRESO_GRUPO (
-- Definicion de atributos

    -- Cedula del estudiante que ingresa al grupo.
    CEDULA VARCHAR(12) NOT NULL,

    -- Identificador del grupo existente al que pertenece el estudiante.
    -- Se utiliza CHAR(36) para coincidir con la PK de la tabla grupo.
    -- No se genera un UUID nuevo, ya que referencia un grupo existente.
    ID_GRUPO CHAR(36) NOT NULL,

    -- Fecha de ingreso, por defecto la fecha actual.
    FECHA_INGRESO DATE NOT NULL DEFAULT (CURRENT_DATE()),

    -- Rol del estudiante dentro del grupo, obligatorio.
    ROL VARCHAR(25) NOT NULL,

-- Definicion de reglas

    -- Clave primaria compuesta que impide registrar
    -- dos veces al mismo estudiante en el mismo grupo.
    CONSTRAINT PK_COMP_CEDULA_IDGRUPO PRIMARY KEY (CEDULA, ID_GRUPO),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus membresias si el estudiante es eliminado.
    CONSTRAINT FK1_ESTUDIANTEINGRUPO FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia grupo.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    -- ON DELETE CASCADE elimina las membresias cuando se elimina el grupo.
    CONSTRAINT FK2_IDGRUPOINGRUPO FOREIGN KEY (ID_GRUPO) REFERENCES GRUPO (ID_GRUPO)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


-- Se crea la tabla evento para registrar las actividades
-- academicas, deportivas o sociales de los estudiantes.
CREATE TABLE EVENTO (

-- Definicion de atributos

    -- Identificador unico del evento, generado automaticamente.
    -- MySQL utiliza CHAR(36) para almacenar el UUID como texto.
    ID_EVENTO CHAR(36) DEFAULT (UUID()),

    -- Cedula del estudiante que crea el evento.
    CEDULA_CREADOR VARCHAR(12) NOT NULL,

    -- Nombre del evento, obligatorio.
    NOMBRE_EVENTO VARCHAR(50) NOT NULL,

    -- Descripcion opcional de la actividad.
    DESCRIPCION VARCHAR(200),

    -- Fecha y hora programadas para el evento.
    -- DATETIME permite almacenar fechas futuras sin el limite
    -- de 2038 que tiene TIMESTAMP en MySQL.
    FECHA_HORA_EVENTO DATETIME NOT NULL,

    -- Lugar donde se realizara el evento, obligatorio.
    LUGAR_EVENTO VARCHAR(100) NOT NULL,

    -- Datos opcionales de geolocalizacion obtenidos mediante GPS.
    -- JSON almacena informacion semiestructurada de sensores,
    -- como latitud, longitud y precision de la ubicacion.
    UBICACION_GPS JSON,

-- Definicion de reglas

    -- Clave primaria que identifica cada evento.
    CONSTRAINT PK_EVENTO PRIMARY KEY (ID_EVENTO),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE RESTRICT impide eliminar al estudiante
    -- mientras tenga eventos creados.
    CONSTRAINT FK_ESTUDIANTECREADOR FOREIGN KEY (CEDULA_CREADOR) REFERENCES ESTUDIANTE (CEDULA)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


-- Se crea la tabla conexion para registrar las relaciones
-- de seguimiento entre estudiantes de la red social.
CREATE TABLE conexion (
-- Definicion de atributos

    -- Cedula del estudiante que realiza el seguimiento.
    cedula_seguidor VARCHAR(12) NOT NULL,

    -- Cedula del estudiante que es seguido.
    cedula_seguido VARCHAR(12) NOT NULL,

    -- Fecha de conexion obligatoria; por defecto, la fecha actual.
    fecha_conexion DATE NOT NULL DEFAULT (CURRENT_DATE()),

-- Definicion de reglas

    -- Clave primaria compuesta que evita conexiones duplicadas.
    CONSTRAINT pk_comp_seguidor_seguido PRIMARY KEY (cedula_seguidor, cedula_seguido),

    -- Clave foranea hacia el estudiante seguidor.
    -- CASCADE actualiza la cedula y elimina sus conexiones
    -- si el estudiante es eliminado.
    CONSTRAINT fk1_seguidorconexion FOREIGN KEY (cedula_seguidor) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia el estudiante seguido.
    -- CASCADE actualiza la cedula y elimina sus conexiones
    -- si el estudiante es eliminado.
    CONSTRAINT fk2_seguidoconexion FOREIGN KEY (cedula_seguido) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE

    -- Diferencia con PostgreSQL:
    -- MySQL genera el error 3823 cuando un CHECK utiliza columnas
    -- que participan en claves foraneas con acciones referenciales CASCADE.
    -- Por esta razon se omite CHECK (cedula_seguidor <> cedula_seguido).
    -- La regla que impide el autoseguimiento se implementara posteriormente
    -- mediante triggers y SIGNAL SQLSTATE.
);

-- Esta parte del codigo se usa al final de la creacion de todas las tablas
-- o como en mi caso la use apenas cree la tabla conexion para no olvidarme despues

-- Solucion al error 3823 de MySQL.
-- No permite utilizar CHECK sobre columnas que participan
-- en claves foraneas con acciones referenciales CASCADE.
-- Se implementan triggers para impedir el autoseguimiento.

-- Se cambia temporalmente el delimitador para definir
-- los triggers sin interrumpir las instrucciones internas.
DELIMITER $$

-- Trigger 1: valida una nueva conexion antes de insertarla.
CREATE TRIGGER trg_conexion_insert BEFORE INSERT ON conexion FOR EACH ROW
BEGIN
    -- NEW representa los valores del nuevo registro.
    -- Si ambas cedulas son iguales, SIGNAL rechaza la insercion.
    IF NEW.cedula_seguidor = NEW.cedula_seguido THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un estudiante no puede seguirse a si mismo';
    END IF;
END$$

-- Trigger 2: valida los cambios de una conexion existente.
CREATE TRIGGER trg_conexion_update BEFORE UPDATE ON conexion FOR EACH ROW
BEGIN
    -- Impide modificar una conexion para que un estudiante
    -- termine siguiendose a si mismo.
    IF NEW.cedula_seguidor = NEW.cedula_seguido THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un estudiante no puede seguirse a si mismo';
    END IF;
END$$

-- Se restaura el delimitador habitual de MySQL.
DELIMITER ;


-- Se crea la tabla mentoria para registrar las relaciones
-- de orientacion academica entre estudiantes.
CREATE TABLE mentoria (

-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    id_mentoria INTEGER AUTO_INCREMENT,

    -- Cedula del estudiante que ofrece la mentoria.
    cedula_mentor VARCHAR(12) NOT NULL,

    -- Cedula del estudiante que recibe la mentoria.
    cedula_aprendiz VARCHAR(12) NOT NULL,

    -- Fecha de inicio, por defecto la fecha actual.
    fecha_inicio_mentoria DATE NOT NULL DEFAULT (CURRENT_DATE()),

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

    -- Diferencia con PostgreSQL:
    -- Se omite CHECK (cedula_mentor <> cedula_aprendiz) debido
    -- al error 3823 de MySQL con claves foraneas y CASCADE.
    -- La regla se implementara mediante triggers y SIGNAL.

    -- Impide que la fecha de finalizacion sea anterior al inicio.
    -- Permite NULL cuando la mentoria sigue activa.
    CONSTRAINT ck_fechas_mentoria CHECK (
        fecha_fin_mentoria IS NULL
        OR fecha_fin_mentoria >= fecha_inicio_mentoria
    )
);

-- Esta parte del codigo se usa al final de la creacion de todas las tablas
-- o como en mi caso la use apenas cree la tabla mentoria para no olvidarme despues

-- Solucion al error 3823 de MySQL.
-- No permite utilizar CHECK sobre columnas que participan
-- en claves foraneas con acciones referenciales CASCADE.
-- Se implementan triggers para impedir el autoseguimiento.

-- Se cambia temporalmente el delimitador para definir
-- los triggers sin interrumpir las instrucciones internas.
DELIMITER $$

-- Trigger 1: valida una nueva mentoria antes de insertarla.
CREATE TRIGGER trg_mentoria_insert BEFORE INSERT ON mentoria FOR EACH ROW
BEGIN
    -- NEW representa los valores del nuevo registro.
    -- Si mentor y aprendiz son iguales, se rechaza la insercion.
    IF NEW.cedula_aprendiz = NEW.cedula_mentor THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un estudiante no puede ser mentor de si mismo en una mentoria';
    END IF;
END$$

-- Trigger 2: valida los cambios de una mentoria existente.
CREATE TRIGGER trg_mentoria_update BEFORE UPDATE ON mentoria FOR EACH ROW
BEGIN
    -- Impide modificar una mentoria para que un estudiante
    -- termine siendo su propio mentor.
    IF NEW.cedula_aprendiz = NEW.cedula_mentor THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un estudiante no puede ser mentor de si mismo en una mentoria';
    END IF;
END$$

-- Se restaura el delimitador habitual de MySQL.
DELIMITER ;


-- Se crea la tabla asistencia para registrar la participacion
-- de los estudiantes en los eventos de la red social.
CREATE TABLE asistencia (

-- Definicion de atributos

    -- Cedula del estudiante que responde al evento.
    cedula VARCHAR(12),

    -- Identificador UUID del evento correspondiente.
    id_evento CHAR(36),

    -- Confirmacion de asistencia: TRUE = si, FALSE = no.
    respuesta TINYINT(1) NOT NULL,

    -- Fecha y hora en que el estudiante registra su respuesta.
    fecha_respuesta DATETIME NOT NULL,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces al mismo estudiante en el mismo evento.
    CONSTRAINT pk_asistencia PRIMARY KEY (cedula, id_evento),

    -- Clave foranea hacia estudiante.
    -- CASCADE actualiza su cedula y elimina sus asistencias
    -- cuando el estudiante es eliminado.
    CONSTRAINT fk1_cedulaasistente FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Clave foranea hacia evento.
    -- CASCADE actualiza el identificador y elimina las asistencias
    -- si el evento es eliminado.
    CONSTRAINT fk2_eventoasist FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- MySQL utiliza TINYINT(1) para representar valores booleanos.
    -- Se permite unicamente 1 (asiste) o 0 (no asiste).
    CONSTRAINT ck_asistencia_respuesta CHECK (respuesta IN (0, 1))
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
    CONSTRAINT fk1_estudianteafisica FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia deporte.
    -- CASCADE actualiza el identificador y elimina las asociaciones
    -- correspondientes si se elimina el deporte.
    CONSTRAINT fk2_deporteafisica FOREIGN KEY (id_deporte) REFERENCES deporte(id_deporte)
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
    CONSTRAINT fk1_estudianteehab FOREIGN KEY (cedula) REFERENCES estudiante(cedula)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia habilidad.
    -- CASCADE actualiza el identificador y elimina las asociaciones
    -- correspondientes cuando se elimina una habilidad.
    CONSTRAINT fk2_habilidadehab FOREIGN KEY (id_habilidad) REFERENCES habilidad(id_habilidad)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- PARA PROBAR EL FUNCIONAMIENTO DEL JSON VAMOS A AGREGAR UN STUDIANTE DE PRUEBA
-- Estudiante de prueba para validar la base de datos.
INSERT INTO estudiante (
    cedula,
    nombre,
    apellidos,
    correo_institucional,
    carrera,
    semestre
)
VALUES (
    '9999999999',
    'Estudiante',
    'Prueba',
    'prueba@ejemplo.com',
    'Desarrollo de Software',
    3
);

--LUEGO CREAMOS UN EVENTO Y LE INYECTAMOS LOS DATOS AL JSON

-- Insercion de un evento con datos de geolocalizacion JSON.
INSERT INTO evento (
    cedula_creador,
    nombre_evento,
    fecha_hora_evento,
    lugar_evento,
    ubicacion_gps
)
VALUES (
    'TU_CEDULA',
    'Encuentro estudiantil',
    '2026-11-20 09:00:00',
    'Pascual Bravo',
    JSON_OBJECT(
        'latitud', 6.2442,
        'longitud', -75.5812,
        'precision_metros', 10,
        'fuente', 'GPS'
    )
);

--Y con el siguiente comando consultamos si se guardo o si tuvo efecto

SELECT nombre_evento, ubicacion_gps
FROM evento;