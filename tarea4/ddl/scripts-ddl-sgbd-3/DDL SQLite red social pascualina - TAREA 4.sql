-- Tarea4. Comparar la implementación de un diccionario de datos físico en diferentes SGBD - SQLite
-- Grupo 11
-- Integrante: Daniel Steven Pineda Zafra

-- Se crea la tabla estudiante con todos sus atributos y restricciones
CREATE TABLE estudiante (
-- Definicion de atributos
	
	-- SQLite utiliza TEXT en lugar de VARCHAR(n).
	-- Las restricciones CHECK permiten conservar los limites
	-- de longitud establecidos en el modelo original.
	
	-- identificador unico para estudiante
	CEDULA TEXT NOT NULL CHECK (length(cedula) <= 12),
	
	-- Nombre del estudiante obligatorio
	NOMBRE TEXT NOT NULL,
	
	-- Apellidos del estudiante obligatorio (puede ser simple o compuesto con espacios incluidos)
	APELLIDOS TEXT NOT NULL,
	
	-- Correo institucional del estudiante obligatorio y unico, no se puede repetir en otro estudiante
	CORREO_INSTITUCIONAL TEXT NOT NULL,
	
	-- Carrera del estudiante obligatorio
	CARRERA TEXT NOT NULL,
	
	-- Semestre que cursa el estudiante obligatorio
	SEMESTRE INTEGER NOT NULL,
	
	-- Numero de contacto del estudiante opcional, contemplano un caracter como el +
	NUMERO_CONTACTO TEXT,

-- Definicion de reglas
	-- Se prefiere definir las restricciones acá abajo para una manipulacion mas limpia en un futuro, pensando en
	-- codificaión modular
	
	-- Definicion de la clave primaria de la tabla estudiante
	CONSTRAINT PK_ESTUDIANTE PRIMARY KEY (CEDULA),
	
	-- Definicion de la unicidad de correo para esta tabla, no pueden hablar dos correos iguales
	CONSTRAINT UQ_CORREO UNIQUE (CORREO_INSTITUCIONAL),
	
	-- Definicion de una regla que solo permita el ingreso de numeros entre el 1 y el 20,
	-- que es logico para la cantidad de semestres en el pascual
	CONSTRAINT CK_SEMESTRE CHECK (SEMESTRE BETWEEN 1 AND 20),
	
    -- SQLite no limita automaticamente la longitud de TEXT.
    -- Se conservan los limites definidos en PostgreSQL.
	CONSTRAINT CK_LONGITUDES_ESTUDIANTE CHECK (
    LENGTH(NOMBRE) <= 25
    AND LENGTH(APELLIDOS) <= 25
    AND LENGTH(CORREO_INSTITUCIONAL) <= 50
    AND LENGTH(CARRERA) <= 50
    AND (NUMERO_CONTACTO IS NULL OR LENGTH(NUMERO_CONTACTO) <= 15)
)
);


-- Se crea la tabla interes con sus atributos y restricciones.
CREATE TABLE INTERES (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT en lugar
    -- de GENERATED ALWAYS AS IDENTITY de PostgreSQL.
    -- La clave primaria garantiza la unicidad y AUTOINCREMENT
    -- evita reutilizar identificadores asignados anteriormente.
    ID_INTERES INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Nombre del interes, obligatorio.
    NOMBRE_INTERES TEXT NOT NULL,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_INTERES
    -- porque SQLite exige esta sintaxis para utilizar AUTOINCREMENT.

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 20 caracteres del modelo original.
    CONSTRAINT CK_LONGITUDES CHECK (
        LENGTH(NOMBRE_INTERES) <= 20
    )
);


-- Se crea la tabla publicacion con sus atributos y restricciones.
CREATE TABLE PUBLICACION (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite no cuenta con una funcion UUID nativa.
    -- Se utiliza INTEGER PRIMARY KEY AUTOINCREMENT como alternativa.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_PUBLICACION INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Contenido obligatorio de la publicacion.
    -- SQLite utiliza TEXT para almacenar textos extensos.
    -- Su longitud se limita a 20000 caracteres mediante CHECK.
    CONTENIDO TEXT NOT NULL,

    -- Cedula del autor, clave foranea hacia estudiante.
    -- TEXT coincide con el tipo de dato de la tabla estudiante.
    CEDULA_AUTOR TEXT NOT NULL,

    -- Fecha de la publicacion, por defecto la fecha actual.
    -- SQLite almacena la fecha como TEXT en formato YYYY-MM-DD.
    FECHA_PUBLICACION TEXT NOT NULL DEFAULT CURRENT_DATE,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_PUBLICACION,
    -- ya que SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- Definicion de la clave foranea.
    -- ON DELETE CASCADE elimina las publicaciones del estudiante eliminado.
    -- ON UPDATE CASCADE actualiza las FK si cambia la cedula del estudiante.
    CONSTRAINT FK_PUBLICACION
        FOREIGN KEY (CEDULA_AUTOR) REFERENCES ESTUDIANTE (CEDULA)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- SQLite utiliza LENGTH() para validar la longitud de TEXT.
    -- Conserva el limite de 20000 caracteres del modelo original.
    CONSTRAINT CK_CONTENIDO CHECK (LENGTH(CONTENIDO) <= 20000)
);


-- Se crea la tabla grupo para almacenar los grupos
-- academicos, sociales o de intereses de los estudiantes.
CREATE TABLE GRUPO (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT en lugar de UUID.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_GRUPO INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Cedula del estudiante que creo el grupo.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA_CREADOR TEXT NOT NULL,

    -- Nombre del grupo, obligatorio.
    NOMBRE_GRUPO TEXT NOT NULL,

    -- Descripcion opcional del proposito del grupo.
    DESCRIPCION TEXT,

    -- Fecha de creacion, por defecto la fecha actual.
    -- SQLite almacena las fechas como TEXT en formato YYYY-MM-DD.
    FECHA_CREACION TEXT NOT NULL DEFAULT CURRENT_DATE,

    -- Indica la privacidad del grupo: 1 = privado, 0 = publico.
    -- SQLite representa los booleanos mediante enteros.
    -- Se utiliza CHECK para permitir unicamente 0 y 1.
    PRIVACIDAD INTEGER NOT NULL,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_GRUPO
    -- porque SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- Clave foranea hacia el estudiante creador.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE RESTRICT impide eliminar al estudiante
    -- mientras tenga grupos creados.
    CONSTRAINT FK_CEDULA_CREADORGRUPO
        FOREIGN KEY (CEDULA_CREADOR) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva los limites de 50 y 200 caracteres.
    -- DESCRIPCION puede permanecer NULL porque es opcional.
    CONSTRAINT CK_LONGITUDESGRUPO CHECK (
        LENGTH(NOMBRE_GRUPO) <= 50
        AND (DESCRIPCION IS NULL OR LENGTH(DESCRIPCION) <= 200)
    ),

    -- Permite unicamente 0 (publico) o 1 (privado).
    CONSTRAINT CK_GRUPO_PRIVACIDAD CHECK (PRIVACIDAD IN (0, 1))
);



-- Se crea la tabla estudiante_interes con sus atributos y restricciones.
-- Resuelve la relacion muchos a muchos entre estudiante e interes.
CREATE TABLE ESTUDIANTE_INTERES (
-- Definicion de atributos

    -- Cedula del estudiante que tiene un interes.
    -- SQLite utiliza TEXT en lugar de VARCHAR(12).
    CEDULA TEXT NOT NULL,

    -- Identificador del interes existente.
    -- INTEGER coincide con el tipo de dato de la tabla padre.
    ID_INTERES INTEGER NOT NULL,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces el mismo interes para un estudiante.
    CONSTRAINT PK_COMPUESTA_ESTUDIANTE_INTERES PRIMARY KEY (CEDULA, ID_INTERES),

    -- Las claves foraneas requieren PRAGMA foreign_keys = ON
    -- para que SQLite valide las relaciones y acciones CASCADE.

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus asociaciones al borrar el estudiante.
    CONSTRAINT FK_ESTUDIANTE_INTERES_ESTUDIANTE FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia interes.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    -- ON DELETE CASCADE elimina las asociaciones al borrar el interes.
    CONSTRAINT FK_ESTUDIANTE_INTERES_INTERES FOREIGN KEY (ID_INTERES) REFERENCES INTERES (ID_INTERES)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Se crea la tabla habilidad con sus atributos y restricciones.
CREATE TABLE HABILIDAD (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT en lugar
    -- de GENERATED ALWAYS AS IDENTITY de PostgreSQL.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_HABILIDAD INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Nombre de la habilidad, obligatorio.
    NOMBRE_HABILIDAD TEXT NOT NULL,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_HABILIDAD
    -- porque SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 25 caracteres del modelo original.
    CONSTRAINT CK_LONGITUD_HABILIDAD CHECK (
        LENGTH(NOMBRE_HABILIDAD) <= 25
    )
);


-- Se crea la tabla deporte para almacenar los deportes
-- que pueden registrar los estudiantes de la red social.
CREATE TABLE DEPORTE (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT en lugar
    -- de GENERATED ALWAYS AS IDENTITY de PostgreSQL.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_DEPORTE INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Nombre del deporte, campo obligatorio.
    NOMBRE_DEPORTE TEXT NOT NULL,

    -- Clasificacion del deporte, por ejemplo:
    -- individual, de equipo, acuatico o de contacto.
    TIPO_DEPORTE TEXT NOT NULL,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_DEPORTE
    -- porque SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 25 caracteres para ambos atributos.
    CONSTRAINT CK_LONGITUD_DEPORTE CHECK (
        LENGTH(NOMBRE_DEPORTE) <= 25
        AND LENGTH(TIPO_DEPORTE) <= 25
    )
);


-- Se crea la tabla ingreso_grupo para registrar los estudiantes
-- que pertenecen a cada grupo y el rol que desempeñan.
CREATE TABLE INGRESO_GRUPO (
-- Definicion de atributos

    -- Cedula del estudiante que ingresa al grupo.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA TEXT NOT NULL,

    -- Identificador del grupo existente al que pertenece el estudiante.
    -- SQLite utiliza INTEGER en lugar del UUID de PostgreSQL y MySQL.
    -- No genera un ID nuevo, ya que referencia un grupo existente.
    ID_GRUPO INTEGER NOT NULL,

    -- Fecha de ingreso, por defecto la fecha actual.
    -- SQLite almacena las fechas como TEXT en formato YYYY-MM-DD.
    FECHA_INGRESO TEXT NOT NULL DEFAULT CURRENT_DATE,

    -- Rol del estudiante dentro del grupo, obligatorio.
    ROL TEXT NOT NULL,

-- Definicion de reglas

    -- Clave primaria compuesta que impide registrar
    -- dos veces al mismo estudiante en el mismo grupo.
    CONSTRAINT PK_COMP_CEDULA_IDGRUPO
        PRIMARY KEY (CEDULA, ID_GRUPO),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus membresias si el estudiante es eliminado.
    CONSTRAINT FK1_ESTUDIANTEINGRUPO
        FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia grupo.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    -- ON DELETE CASCADE elimina las membresias cuando se elimina el grupo.
    CONSTRAINT FK2_IDGRUPOINGRUPO
        FOREIGN KEY (ID_GRUPO) REFERENCES GRUPO (ID_GRUPO)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 25 caracteres para el rol.
    CONSTRAINT CK_LONGITUDROL CHECK (
        LENGTH(ROL) <= 25
    )
);


-- Se crea la tabla evento para registrar las actividades
-- academicas, deportivas o sociales de los estudiantes.
CREATE TABLE EVENTO (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT en lugar de UUID.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_EVENTO INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Cedula del estudiante que crea el evento.
    CEDULA_CREADOR TEXT NOT NULL,

    -- Nombre del evento, obligatorio.
    NOMBRE_EVENTO TEXT NOT NULL,

    -- Descripcion opcional de la actividad.
    DESCRIPCION TEXT,

    -- Fecha y hora programadas para el evento.
    -- SQLite almacena fechas y horas como TEXT.
    -- Se utilizara el formato YYYY-MM-DD HH:MM:SS.
    FECHA_HORA_EVENTO TEXT NOT NULL,

    -- Lugar donde se realizara el evento, obligatorio.
    LUGAR_EVENTO TEXT NOT NULL,

    -- Datos opcionales de geolocalizacion obtenidos mediante GPS.
    -- SQLite almacena los documentos JSON como TEXT.
    -- Se utiliza json_valid() para validar su formato.
    UBICACION_GPS TEXT,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_EVENTO
    -- porque SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- Clave foranea hacia el estudiante creador.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE RESTRICT impide eliminar al estudiante
    -- mientras tenga eventos creados.
    CONSTRAINT FK_ESTUDIANTECREADOR FOREIGN KEY (CEDULA_CREADOR) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva los limites del modelo original.
    -- DESCRIPCION puede permanecer NULL porque es opcional.
    CONSTRAINT CK_LONGITUDES_EVENTO CHECK (
        LENGTH(NOMBRE_EVENTO) <= 50
        AND (DESCRIPCION IS NULL OR LENGTH(DESCRIPCION) <= 200)
        AND LENGTH(LUGAR_EVENTO) <= 100
    ),

    -- Valida que los datos GPS tengan un formato JSON correcto.
    -- json_valid() devuelve 1 cuando el contenido es JSON valido.
    -- Se permite NULL porque la geolocalizacion es opcional.
    CONSTRAINT CK_EVENTO_JSON CHECK (UBICACION_GPS IS NULL OR json_valid(UBICACION_GPS)
    )
);


-- Se crea la tabla conexion para registrar las relaciones
-- de seguimiento entre estudiantes de la red social.
CREATE TABLE CONEXION (
-- Definicion de atributos

    -- Cedula del estudiante que realiza el seguimiento.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA_SEGUIDOR TEXT NOT NULL,

    -- Cedula del estudiante que es seguido.
    CEDULA_SEGUIDO TEXT NOT NULL,

    -- Fecha de conexion obligatoria; por defecto, la fecha actual.
    -- SQLite almacena las fechas como TEXT en formato YYYY-MM-DD.
    FECHA_CONEXION TEXT NOT NULL DEFAULT CURRENT_DATE,

-- Definicion de reglas

    -- Clave primaria compuesta que evita conexiones duplicadas.
    CONSTRAINT PK_COMP_SEGUIDOR_SEGUIDO
        PRIMARY KEY (CEDULA_SEGUIDOR, CEDULA_SEGUIDO),

    -- Clave foranea hacia el estudiante seguidor.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus conexiones al borrar el estudiante.
    CONSTRAINT FK1_SEGUIDORCONEXION FOREIGN KEY (CEDULA_SEGUIDOR) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia el estudiante seguido.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus conexiones al borrar el estudiante.
    CONSTRAINT FK2_SEGUIDOCONEXION FOREIGN KEY (CEDULA_SEGUIDO) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Impide que un estudiante se siga a si mismo.
    -- SQLite permite combinar CHECK con claves foraneas CASCADE.
    -- A diferencia de MySQL, no se requieren triggers para esta regla.
    CONSTRAINT CK_NO_AUTOSEGUIMIENTO CHECK (CEDULA_SEGUIDOR <> CEDULA_SEGUIDO)
);


-- Se crea la tabla mentoria para registrar las relaciones
-- de orientacion academica entre estudiantes.
CREATE TABLE MENTORIA (
-- Definicion de atributos

    -- Identificador unico generado automaticamente.
    -- SQLite utiliza INTEGER PRIMARY KEY AUTOINCREMENT.
    -- PRIMARY KEY garantiza la unicidad y AUTOINCREMENT evita
    -- reutilizar identificadores asignados anteriormente.
    ID_MENTORIA INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Cedula del estudiante que ofrece la mentoria.
    CEDULA_MENTOR TEXT NOT NULL,

    -- Cedula del estudiante que recibe la mentoria.
    CEDULA_APRENDIZ TEXT NOT NULL,

    -- Fecha de inicio, por defecto la fecha actual.
    -- SQLite almacena las fechas como TEXT en formato YYYY-MM-DD.
    FECHA_INICIO_MENTORIA TEXT NOT NULL DEFAULT CURRENT_DATE,

    -- Fecha de finalizacion opcional, puede permanecer NULL.
    FECHA_FIN_MENTORIA TEXT,

    -- Descripcion del objetivo de la mentoria, obligatoria.
    DESCRIPCION TEXT NOT NULL,

-- Definicion de reglas

    -- La clave primaria se define directamente en ID_MENTORIA
    -- porque SQLite requiere esta sintaxis para AUTOINCREMENT.

    -- Clave foranea hacia el estudiante mentor.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus mentorias al borrar el estudiante.
    CONSTRAINT FK1_MENTOR FOREIGN KEY (CEDULA_MENTOR) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia el estudiante aprendiz.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus mentorias al borrar el estudiante.
    CONSTRAINT FK2_APRENDIZ FOREIGN KEY (CEDULA_APRENDIZ) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Impide que un estudiante sea su propio mentor.
    -- SQLite permite CHECK con claves foraneas CASCADE.
    -- A diferencia de MySQL, no se requieren triggers.
    CONSTRAINT CK_MENTORIA CHECK (CEDULA_MENTOR <> CEDULA_APRENDIZ),

    -- Impide que la fecha de finalizacion sea anterior al inicio.
    -- Permite NULL cuando la mentoria sigue activa.
    -- La comparacion supone fechas almacenadas como YYYY-MM-DD.
    CONSTRAINT CK_FECHAS_MENTORIA CHECK (
        FECHA_FIN_MENTORIA IS NULL
        OR FECHA_FIN_MENTORIA >= FECHA_INICIO_MENTORIA
    ),

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 200 caracteres para la descripcion.
    CONSTRAINT CK_LONGITUD_MENTORIA CHECK (
        LENGTH(DESCRIPCION) <= 200
    )
);

-- Se crea la tabla asistencia para registrar la participacion
-- de los estudiantes en los eventos de la red social.
CREATE TABLE ASISTENCIA (
-- Definicion de atributos

    -- Cedula del estudiante que responde al evento.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA TEXT NOT NULL,

    -- Identificador del evento existente.
    -- SQLite utiliza INTEGER en lugar del UUID de PostgreSQL y MySQL.
    -- No genera un ID nuevo, ya que referencia un evento existente.
    ID_EVENTO INTEGER NOT NULL,

    -- Confirmacion de asistencia: 1 = si, 0 = no.
    -- SQLite representa los valores booleanos mediante INTEGER.
    -- Se utiliza CHECK para permitir unicamente 0 y 1.
    RESPUESTA INTEGER NOT NULL,

    -- Fecha y hora en que el estudiante registra su respuesta.
    -- SQLite utiliza TEXT en formato YYYY-MM-DD HH:MM:SS.
    -- Es obligatoria y debe proporcionarse al insertar el registro.
    FECHA_RESPUESTA TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces al mismo estudiante en el mismo evento.
    CONSTRAINT PK_ASISTENCIA PRIMARY KEY (CEDULA, ID_EVENTO),

    -- Clave foranea hacia estudiante.
    -- ON DELETE CASCADE elimina sus asistencias al borrar el estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    CONSTRAINT FK1_CEDULAASISTENTE FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Clave foranea hacia evento.
    -- ON DELETE CASCADE elimina las asistencias al borrar el evento.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    CONSTRAINT FK2_EVENTOASIST FOREIGN KEY (ID_EVENTO) REFERENCES EVENTO (ID_EVENTO)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- SQLite utiliza INTEGER para representar valores booleanos.
    -- CHECK permite unicamente 1 (asiste) o 0 (no asiste).
    CONSTRAINT CK_ASISTENCIA_RESPUESTA CHECK (
        RESPUESTA IN (0, 1)
    )
);


-- Se crea la tabla actividad_fisica para registrar los deportes
-- que practican los estudiantes y su frecuencia.
CREATE TABLE ACTIVIDAD_FISICA (
-- Definicion de atributos

    -- Cedula del estudiante que practica el deporte.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA TEXT NOT NULL,

    -- Identificador del deporte asociado al estudiante.
    -- INTEGER coincide con el tipo de la clave primaria de deporte.
    ID_DEPORTE INTEGER NOT NULL,

    -- Frecuencia con la que practica el deporte.
    -- Campo opcional que puede permanecer NULL.
    FRECUENCIA TEXT,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces el mismo deporte para un estudiante.
    CONSTRAINT PK_COMP_ACTFISICA PRIMARY KEY (CEDULA, ID_DEPORTE),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus asociaciones deportivas.
    CONSTRAINT FK1_ESTUDIANTEAFISICA FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- Clave foranea hacia deporte.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    -- ON DELETE CASCADE elimina las asociaciones del deporte eliminado.
    CONSTRAINT FK2_DEPORTEAFISICA FOREIGN KEY (ID_DEPORTE) REFERENCES DEPORTE (ID_DEPORTE)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 25 caracteres.
    -- Permite NULL porque la frecuencia es opcional.
    CONSTRAINT CK_LONGITUDFREC CHECK (FRECUENCIA IS NULL OR LENGTH(FRECUENCIA) <= 25    )
);

-- Se crea la tabla estudiante_habilidad para registrar las
-- habilidades de cada estudiante y su nivel de dominio.
CREATE TABLE ESTUDIANTE_HABILIDAD (
-- Definicion de atributos

    -- Cedula del estudiante que posee la habilidad.
    -- TEXT coincide con el tipo utilizado en estudiante.
    CEDULA TEXT NOT NULL,

    -- Identificador de la habilidad asociada.
    -- INTEGER coincide con el tipo de la clave primaria de habilidad.
    ID_HABILIDAD INTEGER NOT NULL,

    -- Nivel de dominio de la habilidad.
    -- Campo opcional que puede permanecer NULL.
    NIVEL_HABILIDAD TEXT,

-- Definicion de reglas

    -- Clave primaria compuesta que evita registrar
    -- dos veces la misma habilidad para un estudiante.
    CONSTRAINT PK_ESTUHABILIDAD PRIMARY KEY (CEDULA, ID_HABILIDAD),

    -- Clave foranea hacia estudiante.
    -- ON UPDATE CASCADE actualiza la cedula si cambia.
    -- ON DELETE CASCADE elimina sus asociaciones con habilidades.
    CONSTRAINT FK1_ESTUDIANTEEHAB FOREIGN KEY (CEDULA) REFERENCES ESTUDIANTE (CEDULA)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Clave foranea hacia habilidad.
    -- ON UPDATE CASCADE actualiza el identificador si cambia.
    -- ON DELETE CASCADE elimina las asociaciones de la habilidad eliminada.
    CONSTRAINT FK2_HABILIDADEHAB FOREIGN KEY (ID_HABILIDAD) REFERENCES HABILIDAD (ID_HABILIDAD)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- SQLite no limita automaticamente la longitud de TEXT.
    -- CHECK conserva el maximo de 20 caracteres del modelo original.
    -- Permite NULL porque el nivel de habilidad es opcional.
    CONSTRAINT CK_LONGNIVEL CHECK (
        NIVEL_HABILIDAD IS NULL OR LENGTH(NIVEL_HABILIDAD) <= 20
    )
);