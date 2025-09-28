--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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

--
-- Name: enum_course_durationType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_course_durationType" AS ENUM (
    'MONTHS',
    'YEARS',
    'WEEK',
    'MONTH',
    'YEAR'
);


ALTER TYPE public."enum_course_durationType" OWNER TO postgres;

--
-- Name: enum_enrollment_enrollmentType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_enrollment_enrollmentType" AS ENUM (
    'MONTHLY',
    'ANNUAL'
);


ALTER TYPE public."enum_enrollment_enrollmentType" OWNER TO postgres;

--
-- Name: enum_enrollment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_enrollment_status AS ENUM (
    'ACTIVE',
    'COMPLETED',
    'DROPPED'
);


ALTER TYPE public.enum_enrollment_status OWNER TO postgres;

--
-- Name: enum_payment_paymentMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_payment_paymentMode" AS ENUM (
    'CASE',
    'ONLINE',
    'UPI'
);


ALTER TYPE public."enum_payment_paymentMode" OWNER TO postgres;

--
-- Name: enum_session_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_session_type AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public.enum_session_type OWNER TO postgres;

--
-- Name: enum_user_createdByType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_user_createdByType" AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public."enum_user_createdByType" OWNER TO postgres;

--
-- Name: enum_user_deleteByType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_user_deleteByType" AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public."enum_user_deleteByType" OWNER TO postgres;

--
-- Name: enum_user_loginOs; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_user_loginOs" AS ENUM (
    'ANDROID',
    'IOS'
);


ALTER TYPE public."enum_user_loginOs" OWNER TO postgres;

--
-- Name: enum_user_regOs; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_user_regOs" AS ENUM (
    'ANDROID',
    'IOS'
);


ALTER TYPE public."enum_user_regOs" OWNER TO postgres;

--
-- Name: enum_user_updatedByType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_user_updatedByType" AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public."enum_user_updatedByType" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    "adminId" bigint NOT NULL,
    "fullName" text,
    email character varying(60),
    "mobileNumber" character varying(15) DEFAULT NULL::character varying,
    "countryCode" character varying(5) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT NULL::character varying,
    otp character varying(150) DEFAULT NULL::character varying,
    block integer DEFAULT 0,
    "profilePicture" text,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    delete integer DEFAULT 0,
    "createdBy" integer DEFAULT 0,
    "updatedBy" integer DEFAULT 0,
    "deleteBy" integer DEFAULT 0
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_adminId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."admin_adminId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."admin_adminId_seq" OWNER TO postgres;

--
-- Name: admin_adminId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."admin_adminId_seq" OWNED BY public.admin."adminId";


--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    "courseId" bigint NOT NULL,
    "courseName" text,
    description text,
    fee character varying(20) DEFAULT NULL::character varying,
    duration character varying(20) DEFAULT NULL::character varying,
    "durationType" public."enum_course_durationType" DEFAULT 'MONTH'::public."enum_course_durationType",
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    delete integer DEFAULT 0,
    "createdBy" integer DEFAULT 0,
    "updatedBy" integer DEFAULT 0,
    "deleteBy" integer DEFAULT 0
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: course_courseId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."course_courseId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."course_courseId_seq" OWNER TO postgres;

--
-- Name: course_courseId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."course_courseId_seq" OWNED BY public.course."courseId";


--
-- Name: enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollment (
    "enrollmentId" bigint NOT NULL,
    "courseId" integer DEFAULT 0,
    "enrollmentDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status public.enum_enrollment_status DEFAULT 'ACTIVE'::public.enum_enrollment_status,
    "enrollmentType" public."enum_enrollment_enrollmentType" DEFAULT 'MONTHLY'::public."enum_enrollment_enrollmentType",
    amount character varying(20) DEFAULT NULL::character varying,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    delete integer DEFAULT 0,
    "createdBy" integer DEFAULT 0,
    "updatedBy" integer DEFAULT 0,
    "deleteBy" integer DEFAULT 0,
    "userId" integer DEFAULT 0
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- Name: enrollment_enrollmentId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."enrollment_enrollmentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."enrollment_enrollmentId_seq" OWNER TO postgres;

--
-- Name: enrollment_enrollmentId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."enrollment_enrollmentId_seq" OWNED BY public.enrollment."enrollmentId";


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    "paymentId" bigint NOT NULL,
    "enrollmentId" integer DEFAULT 0,
    amount character varying(20) DEFAULT NULL::character varying,
    "paymentMode" public."enum_payment_paymentMode" DEFAULT 'CASE'::public."enum_payment_paymentMode",
    note text,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    delete integer DEFAULT 0,
    "createdBy" integer DEFAULT 0,
    "updatedBy" integer DEFAULT 0,
    "deleteBy" integer DEFAULT 0,
    "startDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "endDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "userId" integer DEFAULT 0,
    "paidAmount" character varying(20) DEFAULT NULL::character varying
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_paymentId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."payment_paymentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."payment_paymentId_seq" OWNER TO postgres;

--
-- Name: payment_paymentId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."payment_paymentId_seq" OWNED BY public.payment."paymentId";


--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    "sessionId" bigint NOT NULL,
    type public.enum_session_type DEFAULT 'ADMIN'::public.enum_session_type,
    "userId" bigint DEFAULT 0,
    token character varying(150) DEFAULT NULL::character varying,
    "expireTime" timestamp with time zone,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: session_sessionId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."session_sessionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."session_sessionId_seq" OWNER TO postgres;

--
-- Name: session_sessionId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."session_sessionId_seq" OWNED BY public.session."sessionId";


--
-- Name: systemsetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.systemsetting (
    "systemsettingId" bigint NOT NULL,
    key character varying(150) DEFAULT NULL::character varying,
    value text,
    delete integer DEFAULT 0,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" integer DEFAULT 0 NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedBy" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.systemsetting OWNER TO postgres;

--
-- Name: systemsetting_systemsettingId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."systemsetting_systemsettingId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."systemsetting_systemsettingId_seq" OWNER TO postgres;

--
-- Name: systemsetting_systemsettingId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."systemsetting_systemsettingId_seq" OWNED BY public.systemsetting."systemsettingId";


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    "userId" bigint NOT NULL,
    "fullName" text,
    email character varying(60) DEFAULT NULL::character varying,
    "mobileNumber" character varying(15) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT NULL::character varying,
    otp character varying(150) DEFAULT NULL::character varying,
    block integer DEFAULT 0,
    delete integer DEFAULT 0,
    "profilePicture" text,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "createdBy" integer DEFAULT 0,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedBy" integer DEFAULT 0,
    "deleteBy" integer DEFAULT 0,
    address text,
    "joiningDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_userId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."user_userId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."user_userId_seq" OWNER TO postgres;

--
-- Name: user_userId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."user_userId_seq" OWNED BY public."user"."userId";


--
-- Name: admin adminId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN "adminId" SET DEFAULT nextval('public."admin_adminId_seq"'::regclass);


--
-- Name: course courseId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course ALTER COLUMN "courseId" SET DEFAULT nextval('public."course_courseId_seq"'::regclass);


--
-- Name: enrollment enrollmentId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment ALTER COLUMN "enrollmentId" SET DEFAULT nextval('public."enrollment_enrollmentId_seq"'::regclass);


--
-- Name: payment paymentId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN "paymentId" SET DEFAULT nextval('public."payment_paymentId_seq"'::regclass);


--
-- Name: session sessionId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session ALTER COLUMN "sessionId" SET DEFAULT nextval('public."session_sessionId_seq"'::regclass);


--
-- Name: systemsetting systemsettingId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systemsetting ALTER COLUMN "systemsettingId" SET DEFAULT nextval('public."systemsetting_systemsettingId_seq"'::regclass);


--
-- Name: user userId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN "userId" SET DEFAULT nextval('public."user_userId_seq"'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admin ("adminId", "fullName", email, "mobileNumber", "countryCode", password, otp, block, "profilePicture", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (1, 'admin', 'admin@gmail.com', '9929988288', NULL, '$2b$10$yxtnyka9MGZ6hUfNe1D4JOTK2hG/haVxLz2Vc36.7F01BwapRGqSC', NULL, 0, NULL, '2025-09-21 18:08:44.54578+05:30', '2025-09-21 18:08:44.54578+05:30', 0, 0, 1, 0);


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (1, 'Course 1', 'Description for Course 1', '1001', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (2, 'Course 2', 'Description for Course 2', '1002', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (3, 'Course 3', 'Description for Course 3', '1003', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (4, 'Course 4', 'Description for Course 4', '1004', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (5, 'Course 5', 'Description for Course 5', '1005', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (6, 'Course 6', 'Description for Course 6', '1006', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (7, 'Course 7', 'Description for Course 7', '1007', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (8, 'Course 8', 'Description for Course 8', '1008', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (9, 'Course 9', 'Description for Course 9', '1009', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (10, 'Course 10', 'Description for Course 10', '1010', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (11, 'Course 11', 'Description for Course 11', '1011', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (12, 'Course 12', 'Description for Course 12', '1012', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (13, 'Course 13', 'Description for Course 13', '1013', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (14, 'Course 14', 'Description for Course 14', '1014', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (15, 'Course 15', 'Description for Course 15', '1015', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (16, 'Course 16', 'Description for Course 16', '1016', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (17, 'Course 17', 'Description for Course 17', '1017', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (18, 'Course 18', 'Description for Course 18', '1018', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (19, 'Course 19', 'Description for Course 19', '1019', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (20, 'Course 20', 'Description for Course 20', '1020', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (21, 'Course 21', 'Description for Course 21', '1021', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (22, 'Course 22', 'Description for Course 22', '1022', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (23, 'Course 23', 'Description for Course 23', '1023', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (24, 'Course 24', 'Description for Course 24', '1024', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (25, 'Course 25', 'Description for Course 25', '1025', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (26, 'Course 26', 'Description for Course 26', '1026', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (27, 'Course 27', 'Description for Course 27', '1027', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (28, 'Course 28', 'Description for Course 28', '1028', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (29, 'Course 29', 'Description for Course 29', '1029', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (30, 'Course 30', 'Description for Course 30', '1030', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (31, 'Course 31', 'Description for Course 31', '1031', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (32, 'Course 32', 'Description for Course 32', '1032', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (33, 'Course 33', 'Description for Course 33', '1033', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (34, 'Course 34', 'Description for Course 34', '1034', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (35, 'Course 35', 'Description for Course 35', '1035', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (36, 'Course 36', 'Description for Course 36', '1036', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (37, 'Course 37', 'Description for Course 37', '1037', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (38, 'Course 38', 'Description for Course 38', '1038', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (39, 'Course 39', 'Description for Course 39', '1039', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (40, 'Course 40', 'Description for Course 40', '1040', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (41, 'Course 41', 'Description for Course 41', '1041', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (42, 'Course 42', 'Description for Course 42', '1042', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (43, 'Course 43', 'Description for Course 43', '1043', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (44, 'Course 44', 'Description for Course 44', '1044', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (45, 'Course 45', 'Description for Course 45', '1045', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (46, 'Course 46', 'Description for Course 46', '1046', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (47, 'Course 47', 'Description for Course 47', '1047', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (48, 'Course 48', 'Description for Course 48', '1048', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (49, 'Course 49', 'Description for Course 49', '1049', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (50, 'Course 50', 'Description for Course 50', '1050', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (51, 'Course 51', 'Description for Course 51', '1051', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (52, 'Course 52', 'Description for Course 52', '1052', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (53, 'Course 53', 'Description for Course 53', '1053', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (54, 'Course 54', 'Description for Course 54', '1054', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (55, 'Course 55', 'Description for Course 55', '1055', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (56, 'Course 56', 'Description for Course 56', '1056', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (57, 'Course 57', 'Description for Course 57', '1057', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (58, 'Course 58', 'Description for Course 58', '1058', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (59, 'Course 59', 'Description for Course 59', '1059', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (60, 'Course 60', 'Description for Course 60', '1060', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (61, 'Course 61', 'Description for Course 61', '1061', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (62, 'Course 62', 'Description for Course 62', '1062', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (63, 'Course 63', 'Description for Course 63', '1063', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (64, 'Course 64', 'Description for Course 64', '1064', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (65, 'Course 65', 'Description for Course 65', '1065', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (66, 'Course 66', 'Description for Course 66', '1066', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (67, 'Course 67', 'Description for Course 67', '1067', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (68, 'Course 68', 'Description for Course 68', '1068', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (69, 'Course 69', 'Description for Course 69', '1069', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (70, 'Course 70', 'Description for Course 70', '1070', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (71, 'Course 71', 'Description for Course 71', '1071', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (72, 'Course 72', 'Description for Course 72', '1072', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (73, 'Course 73', 'Description for Course 73', '1073', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (74, 'Course 74', 'Description for Course 74', '1074', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (75, 'Course 75', 'Description for Course 75', '1075', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (76, 'Course 76', 'Description for Course 76', '1076', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (77, 'Course 77', 'Description for Course 77', '1077', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (78, 'Course 78', 'Description for Course 78', '1078', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (79, 'Course 79', 'Description for Course 79', '1079', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (80, 'Course 80', 'Description for Course 80', '1080', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (81, 'Course 81', 'Description for Course 81', '1081', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (82, 'Course 82', 'Description for Course 82', '1082', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (83, 'Course 83', 'Description for Course 83', '1083', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (84, 'Course 84', 'Description for Course 84', '1084', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (85, 'Course 85', 'Description for Course 85', '1085', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (86, 'Course 86', 'Description for Course 86', '1086', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (87, 'Course 87', 'Description for Course 87', '1087', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (88, 'Course 88', 'Description for Course 88', '1088', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (89, 'Course 89', 'Description for Course 89', '1089', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (90, 'Course 90', 'Description for Course 90', '1090', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (91, 'Course 91', 'Description for Course 91', '1091', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (92, 'Course 92', 'Description for Course 92', '1092', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (93, 'Course 93', 'Description for Course 93', '1093', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (94, 'Course 94', 'Description for Course 94', '1094', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (95, 'Course 95', 'Description for Course 95', '1095', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (96, 'Course 96', 'Description for Course 96', '1096', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (97, 'Course 97', 'Description for Course 97', '1097', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (98, 'Course 98', 'Description for Course 98', '1098', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (99, 'Course 99', 'Description for Course 99', '1099', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (100, 'Course 100', 'Description for Course 100', '1100', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (101, 'Course 101', 'Description for Course 101', '1101', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (102, 'Course 102', 'Description for Course 102', '1102', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (103, 'Course 103', 'Description for Course 103', '1103', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (104, 'Course 104', 'Description for Course 104', '1104', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (105, 'Course 105', 'Description for Course 105', '1105', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (106, 'Course 106', 'Description for Course 106', '1106', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (107, 'Course 107', 'Description for Course 107', '1107', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (108, 'Course 108', 'Description for Course 108', '1108', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (109, 'Course 109', 'Description for Course 109', '1109', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (110, 'Course 110', 'Description for Course 110', '1110', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (111, 'Course 111', 'Description for Course 111', '1111', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (112, 'Course 112', 'Description for Course 112', '1112', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (113, 'Course 113', 'Description for Course 113', '1113', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (114, 'Course 114', 'Description for Course 114', '1114', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (115, 'Course 115', 'Description for Course 115', '1115', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (116, 'Course 116', 'Description for Course 116', '1116', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (117, 'Course 117', 'Description for Course 117', '1117', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (118, 'Course 118', 'Description for Course 118', '1118', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (119, 'Course 119', 'Description for Course 119', '1119', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (120, 'Course 120', 'Description for Course 120', '1120', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (121, 'Course 121', 'Description for Course 121', '1121', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (122, 'Course 122', 'Description for Course 122', '1122', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (123, 'Course 123', 'Description for Course 123', '1123', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (124, 'Course 124', 'Description for Course 124', '1124', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (125, 'Course 125', 'Description for Course 125', '1125', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (126, 'Course 126', 'Description for Course 126', '1126', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (127, 'Course 127', 'Description for Course 127', '1127', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (128, 'Course 128', 'Description for Course 128', '1128', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (129, 'Course 129', 'Description for Course 129', '1129', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (130, 'Course 130', 'Description for Course 130', '1130', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (131, 'Course 131', 'Description for Course 131', '1131', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (132, 'Course 132', 'Description for Course 132', '1132', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (133, 'Course 133', 'Description for Course 133', '1133', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (134, 'Course 134', 'Description for Course 134', '1134', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (135, 'Course 135', 'Description for Course 135', '1135', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (136, 'Course 136', 'Description for Course 136', '1136', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (137, 'Course 137', 'Description for Course 137', '1137', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (138, 'Course 138', 'Description for Course 138', '1138', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (139, 'Course 139', 'Description for Course 139', '1139', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (140, 'Course 140', 'Description for Course 140', '1140', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (141, 'Course 141', 'Description for Course 141', '1141', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (142, 'Course 142', 'Description for Course 142', '1142', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (143, 'Course 143', 'Description for Course 143', '1143', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (144, 'Course 144', 'Description for Course 144', '1144', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (145, 'Course 145', 'Description for Course 145', '1145', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (146, 'Course 146', 'Description for Course 146', '1146', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (147, 'Course 147', 'Description for Course 147', '1147', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (148, 'Course 148', 'Description for Course 148', '1148', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (149, 'Course 149', 'Description for Course 149', '1149', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (150, 'Course 150', 'Description for Course 150', '1150', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (151, 'Course 151', 'Description for Course 151', '1151', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (152, 'Course 152', 'Description for Course 152', '1152', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (153, 'Course 153', 'Description for Course 153', '1153', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (154, 'Course 154', 'Description for Course 154', '1154', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (155, 'Course 155', 'Description for Course 155', '1155', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (156, 'Course 156', 'Description for Course 156', '1156', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (157, 'Course 157', 'Description for Course 157', '1157', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (158, 'Course 158', 'Description for Course 158', '1158', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (159, 'Course 159', 'Description for Course 159', '1159', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (160, 'Course 160', 'Description for Course 160', '1160', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (161, 'Course 161', 'Description for Course 161', '1161', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (162, 'Course 162', 'Description for Course 162', '1162', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (163, 'Course 163', 'Description for Course 163', '1163', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (164, 'Course 164', 'Description for Course 164', '1164', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (165, 'Course 165', 'Description for Course 165', '1165', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (166, 'Course 166', 'Description for Course 166', '1166', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (167, 'Course 167', 'Description for Course 167', '1167', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (168, 'Course 168', 'Description for Course 168', '1168', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (169, 'Course 169', 'Description for Course 169', '1169', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (170, 'Course 170', 'Description for Course 170', '1170', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (171, 'Course 171', 'Description for Course 171', '1171', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (172, 'Course 172', 'Description for Course 172', '1172', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (173, 'Course 173', 'Description for Course 173', '1173', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (174, 'Course 174', 'Description for Course 174', '1174', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (175, 'Course 175', 'Description for Course 175', '1175', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (176, 'Course 176', 'Description for Course 176', '1176', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (177, 'Course 177', 'Description for Course 177', '1177', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (178, 'Course 178', 'Description for Course 178', '1178', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (179, 'Course 179', 'Description for Course 179', '1179', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (180, 'Course 180', 'Description for Course 180', '1180', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (181, 'Course 181', 'Description for Course 181', '1181', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (182, 'Course 182', 'Description for Course 182', '1182', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (183, 'Course 183', 'Description for Course 183', '1183', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (184, 'Course 184', 'Description for Course 184', '1184', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (185, 'Course 185', 'Description for Course 185', '1185', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (186, 'Course 186', 'Description for Course 186', '1186', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (187, 'Course 187', 'Description for Course 187', '1187', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (188, 'Course 188', 'Description for Course 188', '1188', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (189, 'Course 189', 'Description for Course 189', '1189', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (190, 'Course 190', 'Description for Course 190', '1190', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (191, 'Course 191', 'Description for Course 191', '1191', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (192, 'Course 192', 'Description for Course 192', '1192', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (193, 'Course 193', 'Description for Course 193', '1193', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (194, 'Course 194', 'Description for Course 194', '1194', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (195, 'Course 195', 'Description for Course 195', '1195', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (196, 'Course 196', 'Description for Course 196', '1196', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (197, 'Course 197', 'Description for Course 197', '1197', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (198, 'Course 198', 'Description for Course 198', '1198', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (199, 'Course 199', 'Description for Course 199', '1199', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (200, 'Course 200', 'Description for Course 200', '1200', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (201, 'Course 201', 'Description for Course 201', '1201', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (202, 'Course 202', 'Description for Course 202', '1202', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (203, 'Course 203', 'Description for Course 203', '1203', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (204, 'Course 204', 'Description for Course 204', '1204', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (205, 'Course 205', 'Description for Course 205', '1205', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (206, 'Course 206', 'Description for Course 206', '1206', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (207, 'Course 207', 'Description for Course 207', '1207', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (208, 'Course 208', 'Description for Course 208', '1208', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (209, 'Course 209', 'Description for Course 209', '1209', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (210, 'Course 210', 'Description for Course 210', '1210', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (211, 'Course 211', 'Description for Course 211', '1211', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (212, 'Course 212', 'Description for Course 212', '1212', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (213, 'Course 213', 'Description for Course 213', '1213', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (214, 'Course 214', 'Description for Course 214', '1214', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (215, 'Course 215', 'Description for Course 215', '1215', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (216, 'Course 216', 'Description for Course 216', '1216', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (217, 'Course 217', 'Description for Course 217', '1217', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (218, 'Course 218', 'Description for Course 218', '1218', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (219, 'Course 219', 'Description for Course 219', '1219', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (220, 'Course 220', 'Description for Course 220', '1220', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (221, 'Course 221', 'Description for Course 221', '1221', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (222, 'Course 222', 'Description for Course 222', '1222', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (223, 'Course 223', 'Description for Course 223', '1223', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (224, 'Course 224', 'Description for Course 224', '1224', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (225, 'Course 225', 'Description for Course 225', '1225', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (226, 'Course 226', 'Description for Course 226', '1226', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (227, 'Course 227', 'Description for Course 227', '1227', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (228, 'Course 228', 'Description for Course 228', '1228', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (229, 'Course 229', 'Description for Course 229', '1229', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (230, 'Course 230', 'Description for Course 230', '1230', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (231, 'Course 231', 'Description for Course 231', '1231', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (232, 'Course 232', 'Description for Course 232', '1232', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (233, 'Course 233', 'Description for Course 233', '1233', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (234, 'Course 234', 'Description for Course 234', '1234', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (235, 'Course 235', 'Description for Course 235', '1235', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (236, 'Course 236', 'Description for Course 236', '1236', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (237, 'Course 237', 'Description for Course 237', '1237', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (238, 'Course 238', 'Description for Course 238', '1238', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (239, 'Course 239', 'Description for Course 239', '1239', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (240, 'Course 240', 'Description for Course 240', '1240', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (241, 'Course 241', 'Description for Course 241', '1241', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (242, 'Course 242', 'Description for Course 242', '1242', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (243, 'Course 243', 'Description for Course 243', '1243', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (244, 'Course 244', 'Description for Course 244', '1244', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (245, 'Course 245', 'Description for Course 245', '1245', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (246, 'Course 246', 'Description for Course 246', '1246', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (247, 'Course 247', 'Description for Course 247', '1247', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (248, 'Course 248', 'Description for Course 248', '1248', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (249, 'Course 249', 'Description for Course 249', '1249', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (250, 'Course 250', 'Description for Course 250', '1250', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (251, 'Course 251', 'Description for Course 251', '1251', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (252, 'Course 252', 'Description for Course 252', '1252', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (253, 'Course 253', 'Description for Course 253', '1253', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (254, 'Course 254', 'Description for Course 254', '1254', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (255, 'Course 255', 'Description for Course 255', '1255', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (256, 'Course 256', 'Description for Course 256', '1256', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (257, 'Course 257', 'Description for Course 257', '1257', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (258, 'Course 258', 'Description for Course 258', '1258', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (259, 'Course 259', 'Description for Course 259', '1259', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (260, 'Course 260', 'Description for Course 260', '1260', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (261, 'Course 261', 'Description for Course 261', '1261', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (262, 'Course 262', 'Description for Course 262', '1262', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (263, 'Course 263', 'Description for Course 263', '1263', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (264, 'Course 264', 'Description for Course 264', '1264', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (265, 'Course 265', 'Description for Course 265', '1265', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (266, 'Course 266', 'Description for Course 266', '1266', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (267, 'Course 267', 'Description for Course 267', '1267', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (268, 'Course 268', 'Description for Course 268', '1268', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (269, 'Course 269', 'Description for Course 269', '1269', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (270, 'Course 270', 'Description for Course 270', '1270', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (271, 'Course 271', 'Description for Course 271', '1271', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (272, 'Course 272', 'Description for Course 272', '1272', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (273, 'Course 273', 'Description for Course 273', '1273', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (274, 'Course 274', 'Description for Course 274', '1274', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (275, 'Course 275', 'Description for Course 275', '1275', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (276, 'Course 276', 'Description for Course 276', '1276', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (277, 'Course 277', 'Description for Course 277', '1277', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (278, 'Course 278', 'Description for Course 278', '1278', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (279, 'Course 279', 'Description for Course 279', '1279', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (280, 'Course 280', 'Description for Course 280', '1280', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (281, 'Course 281', 'Description for Course 281', '1281', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (282, 'Course 282', 'Description for Course 282', '1282', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (283, 'Course 283', 'Description for Course 283', '1283', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (284, 'Course 284', 'Description for Course 284', '1284', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (285, 'Course 285', 'Description for Course 285', '1285', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (286, 'Course 286', 'Description for Course 286', '1286', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (287, 'Course 287', 'Description for Course 287', '1287', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (288, 'Course 288', 'Description for Course 288', '1288', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (289, 'Course 289', 'Description for Course 289', '1289', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (290, 'Course 290', 'Description for Course 290', '1290', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (291, 'Course 291', 'Description for Course 291', '1291', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (292, 'Course 292', 'Description for Course 292', '1292', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (293, 'Course 293', 'Description for Course 293', '1293', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (294, 'Course 294', 'Description for Course 294', '1294', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (295, 'Course 295', 'Description for Course 295', '1295', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (296, 'Course 296', 'Description for Course 296', '1296', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (297, 'Course 297', 'Description for Course 297', '1297', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (298, 'Course 298', 'Description for Course 298', '1298', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (299, 'Course 299', 'Description for Course 299', '1299', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (300, 'Course 300', 'Description for Course 300', '1300', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (301, 'Course 301', 'Description for Course 301', '1301', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (302, 'Course 302', 'Description for Course 302', '1302', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (303, 'Course 303', 'Description for Course 303', '1303', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (304, 'Course 304', 'Description for Course 304', '1304', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (305, 'Course 305', 'Description for Course 305', '1305', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (306, 'Course 306', 'Description for Course 306', '1306', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (307, 'Course 307', 'Description for Course 307', '1307', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (308, 'Course 308', 'Description for Course 308', '1308', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (309, 'Course 309', 'Description for Course 309', '1309', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (310, 'Course 310', 'Description for Course 310', '1310', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (311, 'Course 311', 'Description for Course 311', '1311', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (312, 'Course 312', 'Description for Course 312', '1312', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (313, 'Course 313', 'Description for Course 313', '1313', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (314, 'Course 314', 'Description for Course 314', '1314', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (315, 'Course 315', 'Description for Course 315', '1315', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (316, 'Course 316', 'Description for Course 316', '1316', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (317, 'Course 317', 'Description for Course 317', '1317', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (318, 'Course 318', 'Description for Course 318', '1318', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (319, 'Course 319', 'Description for Course 319', '1319', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (320, 'Course 320', 'Description for Course 320', '1320', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (321, 'Course 321', 'Description for Course 321', '1321', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (322, 'Course 322', 'Description for Course 322', '1322', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (323, 'Course 323', 'Description for Course 323', '1323', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (324, 'Course 324', 'Description for Course 324', '1324', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (325, 'Course 325', 'Description for Course 325', '1325', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (326, 'Course 326', 'Description for Course 326', '1326', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (327, 'Course 327', 'Description for Course 327', '1327', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (328, 'Course 328', 'Description for Course 328', '1328', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (329, 'Course 329', 'Description for Course 329', '1329', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (330, 'Course 330', 'Description for Course 330', '1330', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (331, 'Course 331', 'Description for Course 331', '1331', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (332, 'Course 332', 'Description for Course 332', '1332', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (333, 'Course 333', 'Description for Course 333', '1333', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (334, 'Course 334', 'Description for Course 334', '1334', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (335, 'Course 335', 'Description for Course 335', '1335', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (336, 'Course 336', 'Description for Course 336', '1336', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (337, 'Course 337', 'Description for Course 337', '1337', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (338, 'Course 338', 'Description for Course 338', '1338', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (339, 'Course 339', 'Description for Course 339', '1339', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (340, 'Course 340', 'Description for Course 340', '1340', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (341, 'Course 341', 'Description for Course 341', '1341', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (342, 'Course 342', 'Description for Course 342', '1342', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (343, 'Course 343', 'Description for Course 343', '1343', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (344, 'Course 344', 'Description for Course 344', '1344', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (345, 'Course 345', 'Description for Course 345', '1345', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (346, 'Course 346', 'Description for Course 346', '1346', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (347, 'Course 347', 'Description for Course 347', '1347', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (348, 'Course 348', 'Description for Course 348', '1348', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (349, 'Course 349', 'Description for Course 349', '1349', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (350, 'Course 350', 'Description for Course 350', '1350', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (351, 'Course 351', 'Description for Course 351', '1351', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (352, 'Course 352', 'Description for Course 352', '1352', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (353, 'Course 353', 'Description for Course 353', '1353', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (354, 'Course 354', 'Description for Course 354', '1354', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (355, 'Course 355', 'Description for Course 355', '1355', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (356, 'Course 356', 'Description for Course 356', '1356', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (357, 'Course 357', 'Description for Course 357', '1357', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (358, 'Course 358', 'Description for Course 358', '1358', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (359, 'Course 359', 'Description for Course 359', '1359', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (360, 'Course 360', 'Description for Course 360', '1360', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (361, 'Course 361', 'Description for Course 361', '1361', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (362, 'Course 362', 'Description for Course 362', '1362', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (363, 'Course 363', 'Description for Course 363', '1363', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (364, 'Course 364', 'Description for Course 364', '1364', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (365, 'Course 365', 'Description for Course 365', '1365', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (366, 'Course 366', 'Description for Course 366', '1366', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (367, 'Course 367', 'Description for Course 367', '1367', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (368, 'Course 368', 'Description for Course 368', '1368', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (369, 'Course 369', 'Description for Course 369', '1369', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (370, 'Course 370', 'Description for Course 370', '1370', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (371, 'Course 371', 'Description for Course 371', '1371', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (372, 'Course 372', 'Description for Course 372', '1372', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (373, 'Course 373', 'Description for Course 373', '1373', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (374, 'Course 374', 'Description for Course 374', '1374', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (375, 'Course 375', 'Description for Course 375', '1375', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (376, 'Course 376', 'Description for Course 376', '1376', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (377, 'Course 377', 'Description for Course 377', '1377', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (378, 'Course 378', 'Description for Course 378', '1378', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (379, 'Course 379', 'Description for Course 379', '1379', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (380, 'Course 380', 'Description for Course 380', '1380', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (381, 'Course 381', 'Description for Course 381', '1381', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (382, 'Course 382', 'Description for Course 382', '1382', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (383, 'Course 383', 'Description for Course 383', '1383', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (384, 'Course 384', 'Description for Course 384', '1384', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (385, 'Course 385', 'Description for Course 385', '1385', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (386, 'Course 386', 'Description for Course 386', '1386', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (387, 'Course 387', 'Description for Course 387', '1387', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (388, 'Course 388', 'Description for Course 388', '1388', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (389, 'Course 389', 'Description for Course 389', '1389', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (390, 'Course 390', 'Description for Course 390', '1390', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (391, 'Course 391', 'Description for Course 391', '1391', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (392, 'Course 392', 'Description for Course 392', '1392', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (393, 'Course 393', 'Description for Course 393', '1393', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (394, 'Course 394', 'Description for Course 394', '1394', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (395, 'Course 395', 'Description for Course 395', '1395', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (396, 'Course 396', 'Description for Course 396', '1396', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (397, 'Course 397', 'Description for Course 397', '1397', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (398, 'Course 398', 'Description for Course 398', '1398', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (399, 'Course 399', 'Description for Course 399', '1399', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (400, 'Course 400', 'Description for Course 400', '1400', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (401, 'Course 401', 'Description for Course 401', '1401', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (402, 'Course 402', 'Description for Course 402', '1402', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (403, 'Course 403', 'Description for Course 403', '1403', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (404, 'Course 404', 'Description for Course 404', '1404', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (405, 'Course 405', 'Description for Course 405', '1405', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (406, 'Course 406', 'Description for Course 406', '1406', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (407, 'Course 407', 'Description for Course 407', '1407', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (408, 'Course 408', 'Description for Course 408', '1408', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (409, 'Course 409', 'Description for Course 409', '1409', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (410, 'Course 410', 'Description for Course 410', '1410', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (411, 'Course 411', 'Description for Course 411', '1411', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (412, 'Course 412', 'Description for Course 412', '1412', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (413, 'Course 413', 'Description for Course 413', '1413', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (414, 'Course 414', 'Description for Course 414', '1414', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (415, 'Course 415', 'Description for Course 415', '1415', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (416, 'Course 416', 'Description for Course 416', '1416', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (417, 'Course 417', 'Description for Course 417', '1417', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (418, 'Course 418', 'Description for Course 418', '1418', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (419, 'Course 419', 'Description for Course 419', '1419', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (420, 'Course 420', 'Description for Course 420', '1420', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (421, 'Course 421', 'Description for Course 421', '1421', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (422, 'Course 422', 'Description for Course 422', '1422', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (423, 'Course 423', 'Description for Course 423', '1423', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (424, 'Course 424', 'Description for Course 424', '1424', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (425, 'Course 425', 'Description for Course 425', '1425', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (426, 'Course 426', 'Description for Course 426', '1426', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (427, 'Course 427', 'Description for Course 427', '1427', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (428, 'Course 428', 'Description for Course 428', '1428', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (429, 'Course 429', 'Description for Course 429', '1429', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (430, 'Course 430', 'Description for Course 430', '1430', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (431, 'Course 431', 'Description for Course 431', '1431', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (432, 'Course 432', 'Description for Course 432', '1432', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (433, 'Course 433', 'Description for Course 433', '1433', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (434, 'Course 434', 'Description for Course 434', '1434', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (435, 'Course 435', 'Description for Course 435', '1435', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (436, 'Course 436', 'Description for Course 436', '1436', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (437, 'Course 437', 'Description for Course 437', '1437', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (438, 'Course 438', 'Description for Course 438', '1438', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (439, 'Course 439', 'Description for Course 439', '1439', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (440, 'Course 440', 'Description for Course 440', '1440', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (441, 'Course 441', 'Description for Course 441', '1441', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (442, 'Course 442', 'Description for Course 442', '1442', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (443, 'Course 443', 'Description for Course 443', '1443', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (444, 'Course 444', 'Description for Course 444', '1444', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (445, 'Course 445', 'Description for Course 445', '1445', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (446, 'Course 446', 'Description for Course 446', '1446', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (447, 'Course 447', 'Description for Course 447', '1447', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (448, 'Course 448', 'Description for Course 448', '1448', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (449, 'Course 449', 'Description for Course 449', '1449', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (450, 'Course 450', 'Description for Course 450', '1450', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (451, 'Course 451', 'Description for Course 451', '1451', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (452, 'Course 452', 'Description for Course 452', '1452', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (453, 'Course 453', 'Description for Course 453', '1453', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (454, 'Course 454', 'Description for Course 454', '1454', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (455, 'Course 455', 'Description for Course 455', '1455', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (456, 'Course 456', 'Description for Course 456', '1456', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (457, 'Course 457', 'Description for Course 457', '1457', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (458, 'Course 458', 'Description for Course 458', '1458', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (459, 'Course 459', 'Description for Course 459', '1459', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (460, 'Course 460', 'Description for Course 460', '1460', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (461, 'Course 461', 'Description for Course 461', '1461', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (462, 'Course 462', 'Description for Course 462', '1462', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (463, 'Course 463', 'Description for Course 463', '1463', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (464, 'Course 464', 'Description for Course 464', '1464', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (465, 'Course 465', 'Description for Course 465', '1465', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (466, 'Course 466', 'Description for Course 466', '1466', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (467, 'Course 467', 'Description for Course 467', '1467', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (468, 'Course 468', 'Description for Course 468', '1468', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (469, 'Course 469', 'Description for Course 469', '1469', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (470, 'Course 470', 'Description for Course 470', '1470', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (471, 'Course 471', 'Description for Course 471', '1471', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (472, 'Course 472', 'Description for Course 472', '1472', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (473, 'Course 473', 'Description for Course 473', '1473', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (474, 'Course 474', 'Description for Course 474', '1474', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (475, 'Course 475', 'Description for Course 475', '1475', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (476, 'Course 476', 'Description for Course 476', '1476', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (477, 'Course 477', 'Description for Course 477', '1477', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (478, 'Course 478', 'Description for Course 478', '1478', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (479, 'Course 479', 'Description for Course 479', '1479', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (480, 'Course 480', 'Description for Course 480', '1480', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (481, 'Course 481', 'Description for Course 481', '1481', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (482, 'Course 482', 'Description for Course 482', '1482', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (483, 'Course 483', 'Description for Course 483', '1483', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (484, 'Course 484', 'Description for Course 484', '1484', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (485, 'Course 485', 'Description for Course 485', '1485', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (486, 'Course 486', 'Description for Course 486', '1486', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (487, 'Course 487', 'Description for Course 487', '1487', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (488, 'Course 488', 'Description for Course 488', '1488', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (489, 'Course 489', 'Description for Course 489', '1489', '10', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (490, 'Course 490', 'Description for Course 490', '1490', '11', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (491, 'Course 491', 'Description for Course 491', '1491', '12', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (492, 'Course 492', 'Description for Course 492', '1492', '1', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (493, 'Course 493', 'Description for Course 493', '1493', '2', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (494, 'Course 494', 'Description for Course 494', '1494', '3', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (495, 'Course 495', 'Description for Course 495', '1495', '4', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (496, 'Course 496', 'Description for Course 496', '1496', '5', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (497, 'Course 497', 'Description for Course 497', '1497', '6', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (498, 'Course 498', 'Description for Course 498', '1498', '7', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (499, 'Course 499', 'Description for Course 499', '1499', '8', 'YEAR', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);
INSERT INTO public.course ("courseId", "courseName", description, fee, duration, "durationType", created, updated, delete, "createdBy", "updatedBy", "deleteBy") VALUES (500, 'Course 500', 'Description for Course 500', '1500', '9', 'MONTH', '2025-09-27 19:37:46.272329+05:30', '2025-09-27 19:37:46.272329+05:30', 0, 1, 1, 0);


--
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrollment ("enrollmentId", "courseId", "enrollmentDate", status, "enrollmentType", amount, created, updated, delete, "createdBy", "updatedBy", "deleteBy", "userId") VALUES (2, 101, '2025-09-27 00:00:00+05:30', 'ACTIVE', 'MONTHLY', '1500', '2025-09-27 20:01:05.673173+05:30', '2025-09-27 20:01:05.673173+05:30', 0, 1, 0, 0, 1);
INSERT INTO public.enrollment ("enrollmentId", "courseId", "enrollmentDate", status, "enrollmentType", amount, created, updated, delete, "createdBy", "updatedBy", "deleteBy", "userId") VALUES (3, 500, '2025-09-27 00:00:00+05:30', 'ACTIVE', 'MONTHLY', '1000', '2025-09-27 20:49:40.989773+05:30', '2025-09-27 20:49:40.989773+05:30', 0, 1, 1, 0, 2);
INSERT INTO public.enrollment ("enrollmentId", "courseId", "enrollmentDate", status, "enrollmentType", amount, created, updated, delete, "createdBy", "updatedBy", "deleteBy", "userId") VALUES (1, 101, '2025-09-27 00:00:00+05:30', 'ACTIVE', 'MONTHLY', '1500', '2025-09-27 20:01:03.528751+05:30', '2025-09-27 20:01:03.528751+05:30', 1, 1, 0, 0, 1);
INSERT INTO public.enrollment ("enrollmentId", "courseId", "enrollmentDate", status, "enrollmentType", amount, created, updated, delete, "createdBy", "updatedBy", "deleteBy", "userId") VALUES (4, 406, '2025-09-18 00:00:00+05:30', 'ACTIVE', 'MONTHLY', '2500', '2025-09-27 21:07:59.808513+05:30', '2025-09-27 21:07:59.808513+05:30', 0, 1, 0, 0, 1);
INSERT INTO public.enrollment ("enrollmentId", "courseId", "enrollmentDate", status, "enrollmentType", amount, created, updated, delete, "createdBy", "updatedBy", "deleteBy", "userId") VALUES (5, 465, '2025-09-28 00:00:00+05:30', 'ACTIVE', 'MONTHLY', NULL, '2025-09-28 12:04:39.514359+05:30', '2025-09-28 12:04:39.514359+05:30', 0, 1, 0, 0, 1);


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.session ("sessionId", type, "userId", token, "expireTime", created, updated) VALUES (2, 'ADMIN', 2, NULL, '2025-09-21 20:20:01.054866+05:30', '2025-09-21 18:19:34.014224+05:30', '2025-09-21 18:19:34.014224+05:30');
INSERT INTO public.session ("sessionId", type, "userId", token, "expireTime", created, updated) VALUES (1, 'ADMIN', 1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NTkwMzk3MDAsImV4cCI6MTc1OTA0MzMwMH0.pBk2dFYda4iieArO8BcOxB1K6V4GRn1p-v_-X2DPW_0', '2025-09-28 14:20:18.917035+05:30', '2025-09-21 18:18:06.018625+05:30', '2025-09-21 18:18:06.018625+05:30');


--
-- Data for Name: systemsetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.systemsetting ("systemsettingId", key, value, delete, created, "createdBy", updated, "updatedBy") VALUES (1, 'sessionTime', '120', 0, '2025-09-21 18:08:44.557888+05:30', 0, '2025-09-21 18:08:44.557888+05:30', 0);
INSERT INTO public.systemsetting ("systemsettingId", key, value, delete, created, "createdBy", updated, "updatedBy") VALUES (2, 'blockTime', '20', 0, '2025-09-21 18:08:44.557888+05:30', 0, '2025-09-21 18:08:44.557888+05:30', 0);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" ("userId", "fullName", email, "mobileNumber", password, otp, block, delete, "profilePicture", created, "createdBy", updated, "updatedBy", "deleteBy", address, "joiningDate") VALUES (1, 'Test', 'test@gmail.com', '9999999999', NULL, NULL, 0, 0, NULL, '2025-09-21 18:55:04.987826+05:30', 1, '2025-09-21 18:55:04.987826+05:30', 1, 0, 'test address', '2024-09-10 00:00:00+05:30');
INSERT INTO public."user" ("userId", "fullName", email, "mobileNumber", password, otp, block, delete, "profilePicture", created, "createdBy", updated, "updatedBy", "deleteBy", address, "joiningDate") VALUES (2, 'adfs', 'asdf@asdf.com', '987564987564', NULL, NULL, 0, 0, NULL, '2025-09-27 19:43:15.735138+05:30', 1, '2025-09-27 19:43:15.735138+05:30', 1, 0, 'skajfasdhkf`', '2025-09-04 00:00:00+05:30');


--
-- Name: admin_adminId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."admin_adminId_seq"', 2, true);


--
-- Name: course_courseId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."course_courseId_seq"', 500, true);


--
-- Name: enrollment_enrollmentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."enrollment_enrollmentId_seq"', 5, true);


--
-- Name: payment_paymentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."payment_paymentId_seq"', 1, false);


--
-- Name: session_sessionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."session_sessionId_seq"', 2, true);


--
-- Name: systemsetting_systemsettingId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."systemsetting_systemsettingId_seq"', 2, true);


--
-- Name: user_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."user_userId_seq"', 2, true);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY ("adminId");


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY ("courseId");


--
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY ("enrollmentId");


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY ("paymentId");


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY ("sessionId");


--
-- Name: systemsetting systemsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systemsetting
    ADD CONSTRAINT systemsetting_pkey PRIMARY KEY ("systemsettingId");


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY ("userId");


--
-- Name: systemsetting_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX systemsetting_key ON public.systemsetting USING btree (key);


--
-- PostgreSQL database dump complete
--

