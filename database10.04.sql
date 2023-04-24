--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

-- Started on 2023-04-10 11:45:24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 212 (class 1255 OID 66018)
-- Name: after_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.after_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO tlog(tinfo) VALUES ('action INSERT!');
	RETURN NEW;
	
END;
$$;


ALTER FUNCTION public.after_insert() OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 66001)
-- Name: check_qprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_qprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.qprice <= 0 THEN 
		RAISE EXCEPTION 'Negative price : %',  NEW.qprice;
	ELSE 
		NEW.qprice = NEW.qprice + 1000000;
		RAISE NOTICE 'PRICE OK!';
	END IF;
	RETURN NEW;
	
END;
$$;


ALTER FUNCTION public.check_qprice() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 65905)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    cid integer NOT NULL,
    cname character varying(45)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 65910)
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    eqid integer NOT NULL,
    eqname character varying(45),
    vprice numeric(12,2),
    cprice numeric(12,2)
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 74143)
-- Name: managers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.managers (
    mgid integer NOT NULL,
    mgname character varying,
    mgprice integer
);


ALTER TABLE public.managers OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 65967)
-- Name: qitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qitem (
    qid integer NOT NULL,
    eqid integer NOT NULL,
    amnt integer,
    qprice numeric(12,2)
);


ALTER TABLE public.qitem OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 65900)
-- Name: quotation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotation (
    qid integer NOT NULL,
    qdate date,
    cid integer,
    mgid integer
);


ALTER TABLE public.quotation OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 66003)
-- Name: test_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    MAXVALUE 1000000
    CACHE 1;


ALTER TABLE public.test_seq OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 66007)
-- Name: tlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tlog (
    tkey integer NOT NULL,
    ttime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    tuser text DEFAULT CURRENT_USER,
    tinfo text
);


ALTER TABLE public.tlog OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 66005)
-- Name: tlog_tkey_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tlog_tkey_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tlog_tkey_seq OWNER TO postgres;

--
-- TOC entry 3055 (class 0 OID 0)
-- Dependencies: 208
-- Name: tlog_tkey_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tlog_tkey_seq OWNED BY public.tlog.tkey;


--
-- TOC entry 205 (class 1259 OID 65990)
-- Name: v1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v1 AS
 SELECT quotation.qid,
    quotation.qdate,
    qitem.eqid,
    qitem.amnt,
    qitem.qprice,
    ((qitem.amnt)::numeric * qitem.qprice) AS qtotal
   FROM (public.qitem
     JOIN public.quotation ON ((qitem.qid = quotation.qid)));


ALTER TABLE public.v1 OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 65986)
-- Name: v2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2 AS
 SELECT qitem.qid,
    qitem.eqid
   FROM public.qitem;


ALTER TABLE public.v2 OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 65994)
-- Name: v3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v3 AS
 SELECT v1.qid,
    v1.qdate,
    v1.eqid,
    v1.amnt,
    v1.qprice,
    v1.qtotal,
    equipment.eqname,
    equipment.cprice,
    (equipment.cprice * (v1.amnt)::numeric) AS ctotal
   FROM (public.v1
     JOIN public.equipment USING (eqid));


ALTER TABLE public.v3 OWNER TO postgres;

--
-- TOC entry 2888 (class 2604 OID 66010)
-- Name: tlog tkey; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tlog ALTER COLUMN tkey SET DEFAULT nextval('public.tlog_tkey_seq'::regclass);


--
-- TOC entry 3043 (class 0 OID 65905)
-- Dependencies: 201
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (100, 'UNN');
INSERT INTO public.customers VALUES (101, 'NNTU');
INSERT INTO public.customers VALUES (102, 'NSLU');
INSERT INTO public.customers VALUES (103, 'NNMA');


--
-- TOC entry 3044 (class 0 OID 65910)
-- Dependencies: 202
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment VALUES (1000, 'HP', 100000.00, 200000.00);
INSERT INTO public.equipment VALUES (1001, 'IBM
', 120000.00, 150000.00);
INSERT INTO public.equipment VALUES (1002, 'LENOVO', 80000.00, 100000.00);
INSERT INTO public.equipment VALUES (1003, 'CISCO', 200000.00, 250000.00);


--
-- TOC entry 3049 (class 0 OID 74143)
-- Dependencies: 210
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.managers VALUES (100, 'Arisha Danilova', 50);
INSERT INTO public.managers VALUES (101, 'Kate Zotova', 30);
INSERT INTO public.managers VALUES (102, 'Stas Katkov', 15);
INSERT INTO public.managers VALUES (103, 'Kate Zotova', 30);


--
-- TOC entry 3045 (class 0 OID 65967)
-- Dependencies: 203
-- Data for Name: qitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.qitem VALUES (1, 1000, 1, 150000.00);
INSERT INTO public.qitem VALUES (1, 1001, 2, 140000.00);
INSERT INTO public.qitem VALUES (2, 1000, 2, 180000.00);
INSERT INTO public.qitem VALUES (2, 1001, 1, 140000.00);
INSERT INTO public.qitem VALUES (2, 1002, 4, 100000.00);
INSERT INTO public.qitem VALUES (3, 1001, 2, 130000.00);
INSERT INTO public.qitem VALUES (3, 1002, 5, 100000.00);
INSERT INTO public.qitem VALUES (4, 1002, 5, 90000.00);
INSERT INTO public.qitem VALUES (1, 1002, 1, 100000.00);
INSERT INTO public.qitem VALUES (1, 1003, 1, 100000.00);
INSERT INTO public.qitem VALUES (3, 1000, 5, 100000.00);


--
-- TOC entry 3042 (class 0 OID 65900)
-- Dependencies: 200
-- Data for Name: quotation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quotation VALUES (1, '2016-03-01', 100, 100);
INSERT INTO public.quotation VALUES (2, '2016-01-10', 101, 102);
INSERT INTO public.quotation VALUES (3, '2016-04-20', 101, 101);
INSERT INTO public.quotation VALUES (4, '2016-02-29', 102, 100);


--
-- TOC entry 3048 (class 0 OID 66007)
-- Dependencies: 209
-- Data for Name: tlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tlog VALUES (1, '2023-03-27 11:39:29.040133+03', 'postgres', 'PROSTO TAK!');
INSERT INTO public.tlog VALUES (2, '2023-03-27 11:40:33.86431+03', 'postgres', 'NE PROSTO TAK!');
INSERT INTO public.tlog VALUES (1327, '2023-03-27 11:58:32.18583+03', 'postgres', 'action INSERT!');
INSERT INTO public.tlog VALUES (1328, '2023-03-27 12:02:35.908372+03', 'postgres', 'action INSERT!');


--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 207
-- Name: test_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_seq', 81, true);


--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 208
-- Name: tlog_tkey_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tlog_tkey_seq', 1328, true);


--
-- TOC entry 2894 (class 2606 OID 65909)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (cid);


--
-- TOC entry 2896 (class 2606 OID 65914)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (eqid);


--
-- TOC entry 2902 (class 2606 OID 74150)
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (mgid);


--
-- TOC entry 2898 (class 2606 OID 65971)
-- Name: qitem qitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_pkey PRIMARY KEY (qid, eqid);


--
-- TOC entry 2892 (class 2606 OID 65904)
-- Name: quotation quotation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation
    ADD CONSTRAINT quotation_pkey PRIMARY KEY (qid);


--
-- TOC entry 2900 (class 2606 OID 66012)
-- Name: tlog tlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tlog
    ADD CONSTRAINT tlog_pkey PRIMARY KEY (tkey);


--
-- TOC entry 2908 (class 2620 OID 66020)
-- Name: qitem after_insert_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_price AFTER INSERT OR UPDATE ON public.qitem FOR EACH ROW EXECUTE FUNCTION public.after_insert();


--
-- TOC entry 2907 (class 2620 OID 66002)
-- Name: qitem check_qprice; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_qprice AFTER INSERT OR UPDATE ON public.qitem FOR EACH ROW EXECUTE FUNCTION public.check_qprice();


--
-- TOC entry 2904 (class 2606 OID 74151)
-- Name: quotation FK(mgid); Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation
    ADD CONSTRAINT "FK(mgid)" FOREIGN KEY (mgid) REFERENCES public.managers(mgid) NOT VALID;


--
-- TOC entry 2905 (class 2606 OID 65972)
-- Name: qitem qitem_eqid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_eqid_fkey FOREIGN KEY (eqid) REFERENCES public.equipment(eqid);


--
-- TOC entry 2906 (class 2606 OID 65977)
-- Name: qitem qitem_qid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qitem
    ADD CONSTRAINT qitem_qid_fkey FOREIGN KEY (qid) REFERENCES public.quotation(qid) NOT VALID;


--
-- TOC entry 2903 (class 2606 OID 65962)
-- Name: quotation quotation_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation
    ADD CONSTRAINT quotation_cid_fkey FOREIGN KEY (cid) REFERENCES public.customers(cid) NOT VALID;


-- Completed on 2023-04-10 11:45:25

--
-- PostgreSQL database dump complete
--

