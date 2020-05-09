-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2
-- PostgreSQL version: 12.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- object: jmlm | type: ROLE --
-- DROP ROLE IF EXISTS jmlm;
CREATE ROLE jmlm WITH 
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD '********';
-- ddl-end --


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: "P6_DB" | type: DATABASE --
-- -- DROP DATABASE IF EXISTS "P6_DB";
-- CREATE DATABASE "P6_DB"
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'fr_FR.UTF-8'
-- 	LC_CTYPE = 'fr_FR.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = jmlm;
-- -- ddl-end --
-- COMMENT ON DATABASE "P6_DB" IS E'Base de données P6-OC';
-- -- ddl-end --
-- 

-- object: public.client_profile | type: TYPE --
-- DROP TYPE IF EXISTS public.client_profile CASCADE;
CREATE TYPE public.client_profile AS
 ENUM ('Internet','Comptoir');
-- ddl-end --
ALTER TYPE public.client_profile OWNER TO jmlm;
-- ddl-end --

-- object: public.client | type: TABLE --
-- DROP TABLE IF EXISTS public.client CASCADE;
CREATE TABLE public.client (
	id_client serial NOT NULL,
	identifier varchar(20) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	password varchar(110) NOT NULL,
	email varchar(255),
	phone1 varchar(20) NOT NULL,
	phone2 varchar(20),
	profil public.client_profile NOT NULL,
	comment text,
	CONSTRAINT client_pk PRIMARY KEY (id_client),
	CONSTRAINT "U_client_identifier" UNIQUE (identifier)

);
-- ddl-end --
COMMENT ON COLUMN public.client.password IS E'110 char pour 1 psw de 30 char max avec : \nimport crypt\ncrypt.crypt(''123456789012345678901234567890'', crypt.METHOD_SHA512)';
-- ddl-end --
COMMENT ON COLUMN public.client.phone1 IS E'ex : +44 1143-256-861  16charpour un tel anglais\nex : +41 22 418 66 50    16 char num Suisse\nex : +33 6 24 35 53 12   17 char pour un tel francais';
-- ddl-end --
ALTER TABLE public.client OWNER TO jmlm;
-- ddl-end --

-- object: public.pizza_size | type: TYPE --
-- DROP TYPE IF EXISTS public.pizza_size CASCADE;
CREATE TYPE public.pizza_size AS
 ENUM ('Xtra Large','Large','Medium','Small','Xtra Small');
-- ddl-end --
ALTER TYPE public.pizza_size OWNER TO jmlm;
-- ddl-end --

-- object: public.pizza | type: TABLE --
-- DROP TABLE IF EXISTS public.pizza CASCADE;
CREATE TABLE public.pizza (
	id_pizza serial NOT NULL,
	name varchar(60) NOT NULL,
	description varchar(200),
	price decimal(5,2) NOT NULL,
	size public.pizza_size NOT NULL,
	enable bool NOT NULL DEFAULT 'TRUE',
	"id_vat_VAT" integer NOT NULL,
	CONSTRAINT pizza_pk PRIMARY KEY (id_pizza)

);
-- ddl-end --
ALTER TABLE public.pizza OWNER TO jmlm;
-- ddl-end --

-- object: public.additional_product | type: TABLE --
-- DROP TABLE IF EXISTS public.additional_product CASCADE;
CREATE TABLE public.additional_product (
	id_addproduct serial NOT NULL,
	name varchar(60) NOT NULL,
	price decimal(5,2) NOT NULL,
	enable boolean NOT NULL DEFAULT 'TRUE',
	"id_vat_VAT" integer NOT NULL,
	CONSTRAINT additional_product_pk PRIMARY KEY (id_addproduct)

);
-- ddl-end --
ALTER TABLE public.additional_product OWNER TO jmlm;
-- ddl-end --

-- object: "IU_pizza_name_size" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_pizza_name_size" CASCADE;
CREATE UNIQUE INDEX "IU_pizza_name_size" ON public.pizza
	USING btree
	(
	  name,
	  size
	);
-- ddl-end --

-- object: "IU_addproduct_name" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_addproduct_name" CASCADE;
CREATE INDEX  CONCURRENTLY "IU_addproduct_name" ON public.additional_product
	USING btree
	(
	  name
	);
-- ddl-end --

-- object: public.restaurant | type: TABLE --
-- DROP TABLE IF EXISTS public.restaurant CASCADE;
CREATE TABLE public.restaurant (
	id_restaurant serial NOT NULL,
	name varchar(100) NOT NULL,
	phone varchar(20) NOT NULL,
	enable boolean NOT NULL DEFAULT 'TRUE',
	id_address_address integer NOT NULL,
	CONSTRAINT restaurant_pk PRIMARY KEY (id_restaurant)

);
-- ddl-end --
ALTER TABLE public.restaurant OWNER TO jmlm;
-- ddl-end --

-- object: "IU_retaurant_name" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_retaurant_name" CASCADE;
CREATE UNIQUE INDEX "IU_retaurant_name" ON public.restaurant
	USING btree
	(
	  name
	);
-- ddl-end --

-- object: public.users | type: TABLE --
-- DROP TABLE IF EXISTS public.users CASCADE;
CREATE TABLE public.users (
	id_user serial NOT NULL,
	identifier varchar(15) NOT NULL,
	password varchar(130) NOT NULL,
	firstname varchar(60) NOT NULL,
	lastname varchar(60) NOT NULL,
	enable boolean NOT NULL DEFAULT 'TRUE',
	id_restaurant_restaurant integer,
	id_role_user_role integer NOT NULL,
	CONSTRAINT user_pk PRIMARY KEY (id_user),
	CONSTRAINT "U_user_identifier" UNIQUE (identifier)

);
-- ddl-end --
ALTER TABLE public.users OWNER TO jmlm;
-- ddl-end --

-- object: public.order_pizza | type: TABLE --
-- DROP TABLE IF EXISTS public.order_pizza CASCADE;
CREATE TABLE public.order_pizza (
	id_orderpizza serial NOT NULL,
	date date NOT NULL,
	"time" time NOT NULL,
	paid boolean NOT NULL DEFAULT 'FALSE',
	token_braintree varchar(60),
	id_client_client integer NOT NULL,
	id_user_users integer,
	id_order_status_order_status integer NOT NULL,
	id_payment_mode_payment_mode integer NOT NULL,
	id_delivery_method_delivery_method integer NOT NULL,
	id_restaurant_restaurant integer NOT NULL,
	id_address_address integer,
	CONSTRAINT order_pizza_pk PRIMARY KEY (id_orderpizza)

);
-- ddl-end --
ALTER TABLE public.order_pizza OWNER TO jmlm;
-- ddl-end --

-- object: "I_order_date" | type: INDEX --
-- DROP INDEX IF EXISTS public."I_order_date" CASCADE;
CREATE INDEX "I_order_date" ON public.order_pizza
	USING btree
	(
	  date
	);
-- ddl-end --

-- object: public.address | type: TABLE --
-- DROP TABLE IF EXISTS public.address CASCADE;
CREATE TABLE public.address (
	id_address serial NOT NULL,
	name varchar(30),
	street1 varchar(150) NOT NULL,
	street2 varchar(150),
	zipcode varchar(10) NOT NULL,
	city varchar(100) NOT NULL,
	enable bool NOT NULL DEFAULT 'TRUE',
	id_client_client integer,
	CONSTRAINT address_pk PRIMARY KEY (id_address)

);
-- ddl-end --
ALTER TABLE public.address OWNER TO jmlm;
-- ddl-end --

-- object: client_fk | type: CONSTRAINT --
-- ALTER TABLE public.address DROP CONSTRAINT IF EXISTS client_fk CASCADE;
ALTER TABLE public.address ADD CONSTRAINT client_fk FOREIGN KEY (id_client_client)
REFERENCES public.client (id_client) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: restaurant_fk | type: CONSTRAINT --
-- ALTER TABLE public.users DROP CONSTRAINT IF EXISTS restaurant_fk CASCADE;
ALTER TABLE public.users ADD CONSTRAINT restaurant_fk FOREIGN KEY (id_restaurant_restaurant)
REFERENCES public.restaurant (id_restaurant) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: client_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS client_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT client_fk FOREIGN KEY (id_client_client)
REFERENCES public.client (id_client) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT users_fk FOREIGN KEY (id_user_users)
REFERENCES public.users (id_user) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.pizza_ingredient | type: TABLE --
-- DROP TABLE IF EXISTS public.pizza_ingredient CASCADE;
CREATE TABLE public.pizza_ingredient (
	quantity decimal(5,2) NOT NULL,
	id_pizza_pizza integer NOT NULL,
	id_ingredient_ingredient integer NOT NULL,
	CONSTRAINT pizza_ingredient_pk PRIMARY KEY (id_pizza_pizza,id_ingredient_ingredient)

);
-- ddl-end --
ALTER TABLE public.pizza_ingredient OWNER TO jmlm;
-- ddl-end --

-- object: public.ingredient | type: TABLE --
-- DROP TABLE IF EXISTS public.ingredient CASCADE;
CREATE TABLE public.ingredient (
	id_ingredient serial NOT NULL,
	name varchar(100),
	CONSTRAINT ingerdient_pk PRIMARY KEY (id_ingredient)

);
-- ddl-end --
ALTER TABLE public.ingredient OWNER TO jmlm;
-- ddl-end --

-- object: pizza_fk | type: CONSTRAINT --
-- ALTER TABLE public.pizza_ingredient DROP CONSTRAINT IF EXISTS pizza_fk CASCADE;
ALTER TABLE public.pizza_ingredient ADD CONSTRAINT pizza_fk FOREIGN KEY (id_pizza_pizza)
REFERENCES public.pizza (id_pizza) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: ingredient_fk | type: CONSTRAINT --
-- ALTER TABLE public.pizza_ingredient DROP CONSTRAINT IF EXISTS ingredient_fk CASCADE;
ALTER TABLE public.pizza_ingredient ADD CONSTRAINT ingredient_fk FOREIGN KEY (id_ingredient_ingredient)
REFERENCES public.ingredient (id_ingredient) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.stock_ingredient_restaurant | type: TABLE --
-- DROP TABLE IF EXISTS public.stock_ingredient_restaurant CASCADE;
CREATE TABLE public.stock_ingredient_restaurant (
	quantity integer NOT NULL,
	id_ingredient_ingredient integer NOT NULL,
	id_restaurant_restaurant integer
);
-- ddl-end --
ALTER TABLE public.stock_ingredient_restaurant OWNER TO jmlm;
-- ddl-end --

-- object: ingredient_fk | type: CONSTRAINT --
-- ALTER TABLE public.stock_ingredient_restaurant DROP CONSTRAINT IF EXISTS ingredient_fk CASCADE;
ALTER TABLE public.stock_ingredient_restaurant ADD CONSTRAINT ingredient_fk FOREIGN KEY (id_ingredient_ingredient)
REFERENCES public.ingredient (id_ingredient) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: restaurant_fk | type: CONSTRAINT --
-- ALTER TABLE public.stock_ingredient_restaurant DROP CONSTRAINT IF EXISTS restaurant_fk CASCADE;
ALTER TABLE public.stock_ingredient_restaurant ADD CONSTRAINT restaurant_fk FOREIGN KEY (id_restaurant_restaurant)
REFERENCES public.restaurant (id_restaurant) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.quantity_pizza_order | type: TABLE --
-- DROP TABLE IF EXISTS public.quantity_pizza_order CASCADE;
CREATE TABLE public.quantity_pizza_order (
	quantity smallint,
	price decimal(5,2),
	id_pizza_pizza integer NOT NULL,
	id_orderpizza_order_pizza integer NOT NULL,
	CONSTRAINT quantity_pizza_order_pk PRIMARY KEY (id_pizza_pizza,id_orderpizza_order_pizza)

);
-- ddl-end --
ALTER TABLE public.quantity_pizza_order OWNER TO jmlm;
-- ddl-end --

-- object: pizza_fk | type: CONSTRAINT --
-- ALTER TABLE public.quantity_pizza_order DROP CONSTRAINT IF EXISTS pizza_fk CASCADE;
ALTER TABLE public.quantity_pizza_order ADD CONSTRAINT pizza_fk FOREIGN KEY (id_pizza_pizza)
REFERENCES public.pizza (id_pizza) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: order_pizza_fk | type: CONSTRAINT --
-- ALTER TABLE public.quantity_pizza_order DROP CONSTRAINT IF EXISTS order_pizza_fk CASCADE;
ALTER TABLE public.quantity_pizza_order ADD CONSTRAINT order_pizza_fk FOREIGN KEY (id_orderpizza_order_pizza)
REFERENCES public.order_pizza (id_orderpizza) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.stock_addproduct_restaurant | type: TABLE --
-- DROP TABLE IF EXISTS public.stock_addproduct_restaurant CASCADE;
CREATE TABLE public.stock_addproduct_restaurant (
	quantity integer NOT NULL,
	id_restaurant_restaurant integer NOT NULL,
	id_addproduct_additional_product integer NOT NULL,
	CONSTRAINT stock_addproduct_restaurant_pk PRIMARY KEY (id_restaurant_restaurant,id_addproduct_additional_product)

);
-- ddl-end --
ALTER TABLE public.stock_addproduct_restaurant OWNER TO jmlm;
-- ddl-end --

-- object: restaurant_fk | type: CONSTRAINT --
-- ALTER TABLE public.stock_addproduct_restaurant DROP CONSTRAINT IF EXISTS restaurant_fk CASCADE;
ALTER TABLE public.stock_addproduct_restaurant ADD CONSTRAINT restaurant_fk FOREIGN KEY (id_restaurant_restaurant)
REFERENCES public.restaurant (id_restaurant) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: additional_product_fk | type: CONSTRAINT --
-- ALTER TABLE public.stock_addproduct_restaurant DROP CONSTRAINT IF EXISTS additional_product_fk CASCADE;
ALTER TABLE public.stock_addproduct_restaurant ADD CONSTRAINT additional_product_fk FOREIGN KEY (id_addproduct_additional_product)
REFERENCES public.additional_product (id_addproduct) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.quantity_addproduct_order | type: TABLE --
-- DROP TABLE IF EXISTS public.quantity_addproduct_order CASCADE;
CREATE TABLE public.quantity_addproduct_order (
	quantity smallint,
	price decimal(5,2),
	id_addproduct_additional_product integer NOT NULL,
	id_orderpizza_order_pizza integer NOT NULL,
	CONSTRAINT quantity_addproduct_order_pk PRIMARY KEY (id_addproduct_additional_product,id_orderpizza_order_pizza)

);
-- ddl-end --
ALTER TABLE public.quantity_addproduct_order OWNER TO jmlm;
-- ddl-end --

-- object: additional_product_fk | type: CONSTRAINT --
-- ALTER TABLE public.quantity_addproduct_order DROP CONSTRAINT IF EXISTS additional_product_fk CASCADE;
ALTER TABLE public.quantity_addproduct_order ADD CONSTRAINT additional_product_fk FOREIGN KEY (id_addproduct_additional_product)
REFERENCES public.additional_product (id_addproduct) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: order_pizza_fk | type: CONSTRAINT --
-- ALTER TABLE public.quantity_addproduct_order DROP CONSTRAINT IF EXISTS order_pizza_fk CASCADE;
ALTER TABLE public.quantity_addproduct_order ADD CONSTRAINT order_pizza_fk FOREIGN KEY (id_orderpizza_order_pizza)
REFERENCES public.order_pizza (id_orderpizza) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: address_fk | type: CONSTRAINT --
-- ALTER TABLE public.restaurant DROP CONSTRAINT IF EXISTS address_fk CASCADE;
ALTER TABLE public.restaurant ADD CONSTRAINT address_fk FOREIGN KEY (id_address_address)
REFERENCES public.address (id_address) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: restaurant_uq | type: CONSTRAINT --
-- ALTER TABLE public.restaurant DROP CONSTRAINT IF EXISTS restaurant_uq CASCADE;
ALTER TABLE public.restaurant ADD CONSTRAINT restaurant_uq UNIQUE (id_address_address);
-- ddl-end --

-- object: public.order_status | type: TABLE --
-- DROP TABLE IF EXISTS public.order_status CASCADE;
CREATE TABLE public.order_status (
	id_order_status serial NOT NULL,
	status varchar(30) NOT NULL,
	CONSTRAINT order_status_pk PRIMARY KEY (id_order_status)

);
-- ddl-end --
ALTER TABLE public.order_status OWNER TO jmlm;
-- ddl-end --

-- object: "IU_status" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_status" CASCADE;
CREATE UNIQUE INDEX "IU_status" ON public.order_status
	USING btree
	(
	  status
	);
-- ddl-end --

-- object: order_status_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS order_status_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT order_status_fk FOREIGN KEY (id_order_status_order_status)
REFERENCES public.order_status (id_order_status) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.payment_mode | type: TABLE --
-- DROP TABLE IF EXISTS public.payment_mode CASCADE;
CREATE TABLE public.payment_mode (
	id_payment_mode serial NOT NULL,
	mode varchar(30) NOT NULL,
	CONSTRAINT payment_mode_pk PRIMARY KEY (id_payment_mode)

);
-- ddl-end --
ALTER TABLE public.payment_mode OWNER TO jmlm;
-- ddl-end --

-- object: "IU_mode" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_mode" CASCADE;
CREATE UNIQUE INDEX "IU_mode" ON public.payment_mode
	USING btree
	(
	  mode
	);
-- ddl-end --

-- object: payment_mode_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS payment_mode_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT payment_mode_fk FOREIGN KEY (id_payment_mode_payment_mode)
REFERENCES public.payment_mode (id_payment_mode) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.delivery_method | type: TABLE --
-- DROP TABLE IF EXISTS public.delivery_method CASCADE;
CREATE TABLE public.delivery_method (
	id_delivery_method serial NOT NULL,
	method varchar(30) NOT NULL,
	CONSTRAINT delivery_method_pk PRIMARY KEY (id_delivery_method)

);
-- ddl-end --
ALTER TABLE public.delivery_method OWNER TO jmlm;
-- ddl-end --

-- object: "IU_method" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_method" CASCADE;
CREATE UNIQUE INDEX "IU_method" ON public.delivery_method
	USING btree
	(
	  method
	);
-- ddl-end --

-- object: delivery_method_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS delivery_method_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT delivery_method_fk FOREIGN KEY (id_delivery_method_delivery_method)
REFERENCES public.delivery_method (id_delivery_method) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: address_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS address_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT address_fk FOREIGN KEY (id_address_address)
REFERENCES public.address (id_address) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."VAT" | type: TABLE --
-- DROP TABLE IF EXISTS public."VAT" CASCADE;
CREATE TABLE public."VAT" (
	id_vat serial NOT NULL,
	rate decimal(4,3) NOT NULL,
	CONSTRAINT "VAT_pk" PRIMARY KEY (id_vat)

);
-- ddl-end --
ALTER TABLE public."VAT" OWNER TO jmlm;
-- ddl-end --

-- object: "VAT_fk" | type: CONSTRAINT --
-- ALTER TABLE public.additional_product DROP CONSTRAINT IF EXISTS "VAT_fk" CASCADE;
ALTER TABLE public.additional_product ADD CONSTRAINT "VAT_fk" FOREIGN KEY ("id_vat_VAT")
REFERENCES public."VAT" (id_vat) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: "VAT_fk" | type: CONSTRAINT --
-- ALTER TABLE public.pizza DROP CONSTRAINT IF EXISTS "VAT_fk" CASCADE;
ALTER TABLE public.pizza ADD CONSTRAINT "VAT_fk" FOREIGN KEY ("id_vat_VAT")
REFERENCES public."VAT" (id_vat) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.user_role | type: TABLE --
-- DROP TABLE IF EXISTS public.user_role CASCADE;
CREATE TABLE public.user_role (
	id_role serial NOT NULL,
	role varchar(20) NOT NULL,
	CONSTRAINT user_role_pk PRIMARY KEY (id_role)

);
-- ddl-end --
ALTER TABLE public.user_role OWNER TO jmlm;
-- ddl-end --

-- object: "IU_role" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_role" CASCADE;
CREATE UNIQUE INDEX "IU_role" ON public.user_role
	USING btree
	(
	  role
	);
-- ddl-end --

-- object: user_role_fk | type: CONSTRAINT --
-- ALTER TABLE public.users DROP CONSTRAINT IF EXISTS user_role_fk CASCADE;
ALTER TABLE public.users ADD CONSTRAINT user_role_fk FOREIGN KEY (id_role_user_role)
REFERENCES public.user_role (id_role) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: restaurant_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_pizza DROP CONSTRAINT IF EXISTS restaurant_fk CASCADE;
ALTER TABLE public.order_pizza ADD CONSTRAINT restaurant_fk FOREIGN KEY (id_restaurant_restaurant)
REFERENCES public.restaurant (id_restaurant) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: "IU_address_idclient_name" | type: INDEX --
-- DROP INDEX IF EXISTS public."IU_address_idclient_name" CASCADE;
CREATE UNIQUE INDEX "IU_address_idclient_name" ON public.address
	USING btree
	(
	  id_client_client ASC NULLS LAST,
	  name
	);
-- ddl-end --


