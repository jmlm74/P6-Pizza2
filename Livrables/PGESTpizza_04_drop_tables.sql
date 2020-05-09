--
-- triggers et fonctions 
--
drop trigger if exists trigger_insert_price_quantity_pizza_order on quantity_pizza_order;
drop function if exists insert_price_quantity_pizza_order() cascade;
drop trigger if exists trigger_insert_price_quantity_addproduct_order on quantity_pizza_order;
drop function if exists insert_price_quantity_addproduct_order() cascade;

--
-- Tables
--
drop table if exists public.quantity_addproduct_order ;
drop table if exists public.stock_addproduct_restaurant ;
drop table if exists public.additional_product; 
drop table if exists public.quantity_pizza_order;
drop table if exists public.pizza_ingredient  ;
drop table if exists public.pizza ;
drop table if exists public.stock_ingredient_restaurant;
drop table if exists public.ingredient;
drop table if exists public."VAT" ;
drop table if exists public.order_pizza  ;
drop table if exists public.order_status ;
drop table if exists public.payment_mode ;
drop table if exists public.delivery_method ;
drop table if exists public.users; 
drop table if exists public.user_role ;
drop table if exists public.restaurant ;
drop table if exists public.address ;
drop table if exists public.client ;
--
-- Types
--
drop type if exists public.client_profile cascade;
drop type if exists public.pizza_size cascade;

--
-- views
-- 
drop view if exists public.enumerates