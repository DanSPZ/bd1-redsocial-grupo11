-- TAREA 6 - RED SOCIAL PASCUALINA
-- Agregar informacion multimedia a las publicaciones, modificamos la tabla publicación que ya existe

ALTER TABLE publicacion
ADD COLUMN IF NOT EXISTS multimedia JSONB;

-- Creación de tabla para registrar sensores IoT

CREATE TABLE sensor (
    id_sensor BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_sensor VARCHAR(30) NOT NULL UNIQUE,
    tipo_sensor VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(150) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- Creación de tabla para almacenar lecturas IoT

CREATE TABLE lectura_sensor (
    id_lectura BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_sensor BIGINT NOT NULL,
    fecha_lectura TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos JSONB NOT NULL,

    CONSTRAINT fk_lectura_sensor FOREIGN KEY (id_sensor)
        REFERENCES sensor(id_sensor)
);

-- Insertando sensores IoT de prueba

INSERT INTO sensor (codigo_sensor, tipo_sensor, ubicacion)
VALUES
('S001', 'ocupacion', 'Aula 101'),
('S002', 'temperatura', 'Laboratorio de sistemas'),
('S003', 'ocupacion', 'Aula 202');


-- Insertando mediciones de sensores IoT usando JSONB, lecturas ficticias

INSERT INTO lectura_sensor (id_sensor, datos)
VALUES
(
    (SELECT id_sensor FROM sensor WHERE codigo_sensor = 'S001'),
    '{"personas": 25, "estado": "normal"}'::jsonb
),
(
    (SELECT id_sensor FROM sensor WHERE codigo_sensor = 'S002'),
    '{"temperatura": 24.5, "humedad": 60}'::jsonb
),
(
    (SELECT id_sensor FROM sensor WHERE codigo_sensor = 'S003'),
    '{"personas": 18, "bateria": 95}'::jsonb
);

-- Insertando publicacion con informacion multimedia JSONB

INSERT INTO publicacion
(id_publicacion, contenido, cedula_autor, fecha_publicacion, multimedia)

SELECT
    gen_random_uuid(),'Compartiendo fotos del encuentro de robotica',
    cedula,
    CURRENT_DATE,
    '{
        "tipo": "imagen",
        "archivo": "robotica.jpg",
        "formato": "jpg",
        "etiquetas": ["robotica", "universidad"]
    }'::jsonb
FROM estudiante
ORDER BY cedula
LIMIT 1

RETURNING contenido, multimedia;

-- CONSULTAS

-- Consulta de eventos con informacion GPS almacenada en JSONB

SELECT
    nombre_evento,
    ubicacion_gps ->> 'fuente' AS fuente,
    ubicacion_gps ->> 'latitud' AS latitud,
    ubicacion_gps ->> 'longitud' AS longitud
FROM evento
WHERE ubicacion_gps IS NOT NULL;

-- Consulta de publicaciones multimedia con JOIN y JSONB

SELECT
    e.nombre,
    e.apellidos,
    p.contenido,
    p.multimedia ->> 'tipo' AS tipo_archivo,
    p.multimedia ->> 'archivo' AS nombre_archivo
FROM publicacion p
INNER JOIN estudiante e
    ON p.cedula_autor = e.cedula
WHERE p.multimedia IS NOT NULL;


-- Consulta de ocupacion de aulas con funciones agregadas

SELECT
    s.codigo_sensor,
    s.ubicacion,
    COUNT(l.id_lectura) AS total_lecturas,
    SUM((l.datos ->> 'personas')::INTEGER) AS total_personas
FROM sensor s
INNER JOIN lectura_sensor l
    ON s.id_sensor = l.id_sensor
WHERE s.tipo_sensor = 'ocupacion'
GROUP BY s.codigo_sensor, s.ubicacion;


-- CONSULTA INDICES

-- Buscar sensores con estado normal usando JSONB y el operador @>

SELECT
    s.codigo_sensor,
    s.ubicacion,
    l.datos
FROM lectura_sensor l
INNER JOIN sensor s
    ON l.id_sensor = s.id_sensor
WHERE l.datos @> '{"estado": "normal"}'::jsonb;

-- INDICES

CREATE INDEX IF NOT EXISTS idx_lectura_sensor_jsonb
ON lectura_sensor
USING GIN (datos);

-- Indice para optimizar consultas IoT por sensor y fecha

CREATE INDEX IF NOT EXISTS idx_sensor_fecha
ON lectura_sensor (id_sensor, fecha_lectura DESC);

