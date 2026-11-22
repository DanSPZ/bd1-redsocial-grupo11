--
-- PostgreSQL database dump
--

\restrict K9KVkgDZFtVaCfiQvCkPF2BxCzHa07cSeJSI9EluhTg1yVkMyle5wVSUSDFrlDU

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-21 20:21:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 17031)
-- Name: actividad_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad_fisica (
    cedula character varying(12) NOT NULL,
    id_deporte integer NOT NULL,
    frecuencia character varying(25)
);


ALTER TABLE public.actividad_fisica OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17012)
-- Name: asistencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asistencia (
    cedula character varying(12) NOT NULL,
    id_evento uuid NOT NULL,
    respuesta boolean NOT NULL,
    fecha_respuesta timestamp without time zone NOT NULL
);


ALTER TABLE public.asistencia OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16968)
-- Name: conexion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conexion (
    cedula_seguidor character varying(12) NOT NULL,
    cedula_seguido character varying(12) NOT NULL,
    fecha_conexion date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT ck_no_autoseguimiento CHECK (((cedula_seguidor)::text <> (cedula_seguido)::text))
);


ALTER TABLE public.conexion OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16907)
-- Name: deporte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deporte (
    id_deporte integer NOT NULL,
    nombre_deporte character varying(25) NOT NULL,
    tipo_deporte character varying(25) NOT NULL
);


ALTER TABLE public.deporte OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16906)
-- Name: deporte_id_deporte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.deporte ALTER COLUMN id_deporte ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.deporte_id_deporte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16841)
-- Name: estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante (
    cedula character varying(12) NOT NULL,
    nombre character varying(25) NOT NULL,
    apellidos character varying(25) NOT NULL,
    correo_institucional character varying(50) NOT NULL,
    carrera character varying(50) NOT NULL,
    semestre integer NOT NULL,
    numero_contacto character varying(15),
    CONSTRAINT ck_semestre CHECK (((semestre >= 1) AND (semestre <= 20)))
);


ALTER TABLE public.estudiante OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17048)
-- Name: estudiante_habilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante_habilidad (
    cedula character varying(12) NOT NULL,
    id_habilidad integer NOT NULL,
    nivel_habilidad character varying(20)
);


ALTER TABLE public.estudiante_habilidad OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16881)
-- Name: estudiante_interes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante_interes (
    cedula character varying(12) NOT NULL,
    id_interes integer NOT NULL
);


ALTER TABLE public.estudiante_interes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16952)
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evento (
    id_evento uuid DEFAULT gen_random_uuid() NOT NULL,
    cedula_creador character varying(12) NOT NULL,
    nombre_evento character varying(50) NOT NULL,
    descripcion character varying(200),
    fecha_hora_evento timestamp without time zone NOT NULL,
    lugar_evento character varying(100) NOT NULL,
    ubicacion_gps jsonb
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16915)
-- Name: grupo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grupo (
    id_grupo uuid DEFAULT gen_random_uuid() NOT NULL,
    cedula_creador character varying(12) NOT NULL,
    nombre_grupo character varying(50) NOT NULL,
    descripcion character varying(200),
    fecha_creacion date DEFAULT CURRENT_DATE NOT NULL,
    privacidad boolean NOT NULL
);


ALTER TABLE public.grupo OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16899)
-- Name: habilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.habilidad (
    id_habilidad integer NOT NULL,
    nombre_habilidad character varying(25) NOT NULL
);


ALTER TABLE public.habilidad OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16898)
-- Name: habilidad_id_habilidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.habilidad ALTER COLUMN id_habilidad ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.habilidad_id_habilidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 16932)
-- Name: ingreso_grupo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingreso_grupo (
    cedula character varying(12) NOT NULL,
    id_grupo uuid NOT NULL,
    fecha_ingreso date DEFAULT CURRENT_DATE NOT NULL,
    rol character varying(25) NOT NULL
);


ALTER TABLE public.ingreso_grupo OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16856)
-- Name: interes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interes (
    id_interes integer NOT NULL,
    nombre_interes character varying(20) NOT NULL
);


ALTER TABLE public.interes OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16855)
-- Name: interes_id_interes_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.interes ALTER COLUMN id_interes ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.interes_id_interes_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 17131)
-- Name: lectura_sensor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lectura_sensor (
    id_lectura bigint NOT NULL,
    id_sensor bigint NOT NULL,
    fecha_lectura timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    datos jsonb NOT NULL
);


ALTER TABLE public.lectura_sensor OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17130)
-- Name: lectura_sensor_id_lectura_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lectura_sensor ALTER COLUMN id_lectura ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lectura_sensor_id_lectura_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 16989)
-- Name: mentoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentoria (
    id_mentoria integer NOT NULL,
    cedula_mentor character varying(12) NOT NULL,
    cedula_aprendiz character varying(12) NOT NULL,
    fecha_inicio_mentoria date DEFAULT CURRENT_DATE NOT NULL,
    fecha_fin_mentoria date,
    descripcion character varying(200) NOT NULL,
    CONSTRAINT ck_fechas_mentoria CHECK (((fecha_fin_mentoria IS NULL) OR (fecha_fin_mentoria >= fecha_inicio_mentoria))),
    CONSTRAINT ck_mentoria CHECK (((cedula_mentor)::text <> (cedula_aprendiz)::text))
);


ALTER TABLE public.mentoria OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16988)
-- Name: mentoria_id_mentoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.mentoria ALTER COLUMN id_mentoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.mentoria_id_mentoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16863)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion (
    id_publicacion uuid DEFAULT gen_random_uuid() NOT NULL,
    contenido character varying(20000) NOT NULL,
    cedula_autor character varying(12) NOT NULL,
    fecha_publicacion date DEFAULT CURRENT_DATE NOT NULL,
    multimedia jsonb
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17117)
-- Name: sensor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensor (
    id_sensor bigint NOT NULL,
    codigo_sensor character varying(30) NOT NULL,
    tipo_sensor character varying(50) NOT NULL,
    ubicacion character varying(150) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.sensor OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17116)
-- Name: sensor_id_sensor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sensor ALTER COLUMN id_sensor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sensor_id_sensor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 17111)
-- Name: vw_confirmaciones_eventos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_confirmaciones_eventos AS
SELECT
    NULL::character varying(50) AS "Evento",
    NULL::bigint AS "Confirmaciones";


ALTER VIEW public.vw_confirmaciones_eventos OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17107)
-- Name: vw_integrantes_grupos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_integrantes_grupos AS
SELECT
    NULL::character varying(50) AS "Grupo",
    NULL::bigint AS "Cantidad de Miembros";


ALTER VIEW public.vw_integrantes_grupos OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17098)
-- Name: vw_intereses_populares; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_intereses_populares AS
SELECT
    NULL::integer AS id_interes,
    NULL::character varying(20) AS "Interes",
    NULL::bigint AS "Numero de Estudiantes";


ALTER VIEW public.vw_intereses_populares OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17102)
-- Name: vw_resumen_publicaciones; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_resumen_publicaciones AS
SELECT
    NULL::character varying(25) AS "Nombre",
    NULL::character varying(25) AS "Apellidos",
    NULL::bigint AS "Numero de Publicaciones";


ALTER VIEW public.vw_resumen_publicaciones OWNER TO postgres;

--
-- TOC entry 4988 (class 2606 OID 17142)
-- Name: lectura_sensor lectura_sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura_sensor
    ADD CONSTRAINT lectura_sensor_pkey PRIMARY KEY (id_lectura);


--
-- TOC entry 4976 (class 2606 OID 17020)
-- Name: asistencia pk_asistencia; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT pk_asistencia PRIMARY KEY (cedula, id_evento);


--
-- TOC entry 4978 (class 2606 OID 17037)
-- Name: actividad_fisica pk_comp_actfisica; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_fisica
    ADD CONSTRAINT pk_comp_actfisica PRIMARY KEY (cedula, id_deporte);


--
-- TOC entry 4968 (class 2606 OID 16941)
-- Name: ingreso_grupo pk_comp_cedula_idgrupo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso_grupo
    ADD CONSTRAINT pk_comp_cedula_idgrupo PRIMARY KEY (cedula, id_grupo);


--
-- TOC entry 4972 (class 2606 OID 16977)
-- Name: conexion pk_comp_seguidor_seguido; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conexion
    ADD CONSTRAINT pk_comp_seguidor_seguido PRIMARY KEY (cedula_seguidor, cedula_seguido);


--
-- TOC entry 4960 (class 2606 OID 16887)
-- Name: estudiante_interes pk_compuesta_estudiante_interes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_interes
    ADD CONSTRAINT pk_compuesta_estudiante_interes PRIMARY KEY (cedula, id_interes);


--
-- TOC entry 4964 (class 2606 OID 16914)
-- Name: deporte pk_deporte; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deporte
    ADD CONSTRAINT pk_deporte PRIMARY KEY (id_deporte);


--
-- TOC entry 4952 (class 2606 OID 16852)
-- Name: estudiante pk_estudiante; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT pk_estudiante PRIMARY KEY (cedula);


--
-- TOC entry 4980 (class 2606 OID 17054)
-- Name: estudiante_habilidad pk_estuhabilidad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_habilidad
    ADD CONSTRAINT pk_estuhabilidad PRIMARY KEY (cedula, id_habilidad);


--
-- TOC entry 4970 (class 2606 OID 16962)
-- Name: evento pk_evento; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT pk_evento PRIMARY KEY (id_evento);


--
-- TOC entry 4966 (class 2606 OID 16926)
-- Name: grupo pk_grupo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT pk_grupo PRIMARY KEY (id_grupo);


--
-- TOC entry 4962 (class 2606 OID 16905)
-- Name: habilidad pk_habilidad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.habilidad
    ADD CONSTRAINT pk_habilidad PRIMARY KEY (id_habilidad);


--
-- TOC entry 4956 (class 2606 OID 16862)
-- Name: interes pk_interes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interes
    ADD CONSTRAINT pk_interes PRIMARY KEY (id_interes);


--
-- TOC entry 4974 (class 2606 OID 17001)
-- Name: mentoria pk_mentoria; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoria
    ADD CONSTRAINT pk_mentoria PRIMARY KEY (id_mentoria);


--
-- TOC entry 4958 (class 2606 OID 16875)
-- Name: publicacion pk_publicacion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion);


--
-- TOC entry 4982 (class 2606 OID 17129)
-- Name: sensor sensor_codigo_sensor_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_codigo_sensor_key UNIQUE (codigo_sensor);


--
-- TOC entry 4984 (class 2606 OID 17127)
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id_sensor);


--
-- TOC entry 4954 (class 2606 OID 16854)
-- Name: estudiante uq_correo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT uq_correo UNIQUE (correo_institucional);


--
-- TOC entry 4985 (class 1259 OID 17148)
-- Name: idx_lectura_sensor_jsonb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lectura_sensor_jsonb ON public.lectura_sensor USING gin (datos);


--
-- TOC entry 4986 (class 1259 OID 17149)
-- Name: idx_sensor_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sensor_fecha ON public.lectura_sensor USING btree (id_sensor, fecha_lectura DESC);


--
-- TOC entry 5157 (class 2618 OID 17114)
-- Name: vw_confirmaciones_eventos _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_confirmaciones_eventos AS
 SELECT e.nombre_evento AS "Evento",
    count(a.cedula) AS "Confirmaciones"
   FROM (public.evento e
     LEFT JOIN public.asistencia a ON (((e.id_evento = a.id_evento) AND (a.respuesta = true))))
  GROUP BY e.id_evento;


--
-- TOC entry 5156 (class 2618 OID 17110)
-- Name: vw_integrantes_grupos _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_integrantes_grupos AS
 SELECT g.nombre_grupo AS "Grupo",
    count(ig.cedula) AS "Cantidad de Miembros"
   FROM (public.grupo g
     LEFT JOIN public.ingreso_grupo ig ON ((g.id_grupo = ig.id_grupo)))
  GROUP BY g.id_grupo;


--
-- TOC entry 5154 (class 2618 OID 17101)
-- Name: vw_intereses_populares _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_intereses_populares AS
 SELECT i.id_interes,
    i.nombre_interes AS "Interes",
    count(ei.cedula) AS "Numero de Estudiantes"
   FROM (public.interes i
     LEFT JOIN public.estudiante_interes ei ON ((i.id_interes = ei.id_interes)))
  GROUP BY i.id_interes;


--
-- TOC entry 5155 (class 2618 OID 17105)
-- Name: vw_resumen_publicaciones _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_resumen_publicaciones AS
 SELECT e.nombre AS "Nombre",
    e.apellidos AS "Apellidos",
    count(p.id_publicacion) AS "Numero de Publicaciones"
   FROM (public.estudiante e
     LEFT JOIN public.publicacion p ON (((e.cedula)::text = (p.cedula_autor)::text)))
  GROUP BY e.cedula;


--
-- TOC entry 5000 (class 2606 OID 17021)
-- Name: asistencia fk1_cedula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT fk1_cedula FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5002 (class 2606 OID 17038)
-- Name: actividad_fisica fk1_estudiante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_fisica
    ADD CONSTRAINT fk1_estudiante FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5004 (class 2606 OID 17055)
-- Name: estudiante_habilidad fk1_estudiante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_habilidad
    ADD CONSTRAINT fk1_estudiante FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4993 (class 2606 OID 16942)
-- Name: ingreso_grupo fk1_estudiante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso_grupo
    ADD CONSTRAINT fk1_estudiante FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4998 (class 2606 OID 17002)
-- Name: mentoria fk1_mentor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoria
    ADD CONSTRAINT fk1_mentor FOREIGN KEY (cedula_mentor) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4996 (class 2606 OID 16978)
-- Name: conexion fk1_seguidor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conexion
    ADD CONSTRAINT fk1_seguidor FOREIGN KEY (cedula_seguidor) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4999 (class 2606 OID 17007)
-- Name: mentoria fk2_aprendiz; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoria
    ADD CONSTRAINT fk2_aprendiz FOREIGN KEY (cedula_aprendiz) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5003 (class 2606 OID 17043)
-- Name: actividad_fisica fk2_deporte; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_fisica
    ADD CONSTRAINT fk2_deporte FOREIGN KEY (id_deporte) REFERENCES public.deporte(id_deporte) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5001 (class 2606 OID 17026)
-- Name: asistencia fk2_evento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT fk2_evento FOREIGN KEY (id_evento) REFERENCES public.evento(id_evento) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5005 (class 2606 OID 17060)
-- Name: estudiante_habilidad fk2_habilidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_habilidad
    ADD CONSTRAINT fk2_habilidad FOREIGN KEY (id_habilidad) REFERENCES public.habilidad(id_habilidad) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4994 (class 2606 OID 16947)
-- Name: ingreso_grupo fk2_idgrupo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso_grupo
    ADD CONSTRAINT fk2_idgrupo FOREIGN KEY (id_grupo) REFERENCES public.grupo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4997 (class 2606 OID 16983)
-- Name: conexion fk2_seguido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conexion
    ADD CONSTRAINT fk2_seguido FOREIGN KEY (cedula_seguido) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4990 (class 2606 OID 16888)
-- Name: estudiante_interes fk_1_estudiante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_interes
    ADD CONSTRAINT fk_1_estudiante FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4991 (class 2606 OID 16893)
-- Name: estudiante_interes fk_2_interes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_interes
    ADD CONSTRAINT fk_2_interes FOREIGN KEY (id_interes) REFERENCES public.interes(id_interes) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4992 (class 2606 OID 16927)
-- Name: grupo fk_cedula_creador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT fk_cedula_creador FOREIGN KEY (cedula_creador) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4995 (class 2606 OID 16963)
-- Name: evento fk_estudiante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT fk_estudiante FOREIGN KEY (cedula_creador) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5006 (class 2606 OID 17143)
-- Name: lectura_sensor fk_lectura_sensor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura_sensor
    ADD CONSTRAINT fk_lectura_sensor FOREIGN KEY (id_sensor) REFERENCES public.sensor(id_sensor);


--
-- TOC entry 4989 (class 2606 OID 16876)
-- Name: publicacion fk_publicacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT fk_publicacion FOREIGN KEY (cedula_autor) REFERENCES public.estudiante(cedula) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-11-21 20:21:28

--
-- PostgreSQL database dump complete
--

\unrestrict K9KVkgDZFtVaCfiQvCkPF2BxCzHa07cSeJSI9EluhTg1yVkMyle5wVSUSDFrlDU

