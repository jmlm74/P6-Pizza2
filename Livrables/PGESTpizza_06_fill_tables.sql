--
-- Triggers and functions
-- 
create function insert_price_quantity_pizza_order() returns trigger as $$
declare
	pizza_price decimal(5,2);
begin
	select into pizza_price price from pizza where id_pizza = new.id_pizza_pizza;
	update quantity_pizza_order set price = pizza_price where id_orderpizza_order_pizza = new.id_orderpizza_order_pizza
		and id_pizza_pizza = new.id_pizza_pizza;
	return null;
end;
$$
language 'plpgsql';
create trigger trigger_insert_price_quantity_pizza_order after insert 
	on quantity_pizza_order for each row execute procedure insert_price_quantity_pizza_order();


create function insert_price_quantity_addproduct_order() returns trigger as $$
declare
	ap_price decimal(5,2);
begin
	select into ap_price price from additional_product 
		where id_addproduct = new.id_addproduct_additional_product;
	update quantity_addproduct_order set price = ap_price where id_orderpizza_order_pizza = new.id_orderpizza_order_pizza
		and id_addproduct_additional_product = new.id_addproduct_additional_product;
	return null;
end;
$$
language 'plpgsql';

create trigger trigger_insert_price_quantity_addproduct_order after insert 
	on quantity_addproduct_order for each row execute procedure insert_price_quantity_addproduct_order();

--
-- Les vues
--

create view public.enumerates ("schema","nom","definition") 
as
 SELECT nspname , typname , string_agg(enumlabel::text, ', '::text) 
 AS definition FROM pg_enum JOIN pg_type ON enumtypid = pg_type.oid
	JOIN pg_namespace ON pg_type.typnamespace = pg_namespace.oid
	WHERE typcategory = 'E'
	GROUP BY nspname, typname
	ORDER BY 1,2;

--
-- Les tables
--

--
-- Table VAT
--
insert into public."VAT" (rate) values (0.055);
insert into public."VAT" (rate) values (0.10);
insert into public."VAT" (rate) values (0.20);

--
-- table additionnal product
--
insert into public.additional_product ("name","price" ,"enable", "id_vat_VAT" )
	values ('Coca_cola 33Cl',2.58,true,2);
insert into public.additional_product ("name","price" ,"enable", "id_vat_VAT" )
	values ('Coca_cola Zero 33Cl',2.65,true,2);
insert into public.additional_product ("name","price" ,"enable", "id_vat_VAT" )
	values ('Brownie Chocolat',3.58,true,1);
insert into public.additional_product ("name","price" ,"enable", "id_vat_VAT" )
	values ('Biere 33cl',3.40,true,3);

--
-- table client
--
insert into public.client ("identifier","first_name","last_name","password",
	"email","phone1","phone2","profil","comment" ) values 
	('client1','Prenom-client1','Nom-client1','pswclient1','nom1.prenom1@leplusbeaudomaine.com',
	'+33624355312','','Internet','no comment');
insert into public.client ("identifier","first_name","last_name","password",
	"email","phone1","phone2","profil","comment" ) values 
	('client2','Prenom-client2','Nom-client2','pswclient2','nom2.prenom2@autre-domaine.com',
	'+221 33 849 09 09','020 7606 3030','Comptoir','no comment');
insert into public.client ("identifier","first_name","last_name","password",
	"email","phone1","phone2","profil","comment" ) values 
	('client3','Prenom-client3','Nom-client3','pswclient3','nom3.prenom3@autre3-domaine.com',
	'+221 33 849 09 09','020 7606 3030','Comptoir','no comment');
--
-- table address
--
insert into public.address ("name","street1","street2","zipcode","city") values 
	('adr1','street_addr1','street_addr2','zipadr1','city adr11');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('adr2','street_addr2','street_addr2','zipadr2','city adr2');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('adr3','street_addr3','street_addr3','zipadr3','city adr3');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('adr4','street_addr4','','zipadr4','city adr4');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('resto1','street_resto1','street2_resto1','zipadr5','city adr5 resto1');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('resto2','street_resto2','','zipadr6','city adr6 resto2');
insert into public.address ("name","street1","street2","zipcode","city") values 
	('adrclt3','streetclt3','ctreetclt3','zipadr','city adr');

--
-- client has Zero or more addresses
--
update public.address set id_client_client=1 where id_address=1;
update public.address set id_client_client=1 where id_address=2;
update public.address set id_client_client=1 where id_address=3;
update public.address set id_client_client=2 where id_address=4;
update public.address set id_client_client=3 where id_address=7;

--
-- Restaurant (with address in insert)
--
insert into public.restaurant ("name","phone","enable","id_address_address") values
	('resto1','+33 123456789',true,5);
insert into public.restaurant ("name","phone","enable","id_address_address") values
	('resto2','+33 12345789',true,6);


--
-- user_role
--
insert into public.user_role ("role") values ('Staff');
insert into public.user_role ("role") values ('Pizzaiolo');
insert into public.user_role ("role") values ('Delivery');
insert into public.user_role ("role") values ('seller');

--
-- Users
--
insert into public.users ("identifier","password","firstname","lastname","enable",
	"id_role_user_role" ,"id_restaurant_restaurant" ) values 
	('Karim','karimpsw','Karim','Director',true,1,null);
insert into public.users ("identifier","password","firstname","lastname","enable",
	"id_role_user_role" ,"id_restaurant_restaurant" ) values 
	('Luigi','luigipsw','Luigi','Magnifico',true,2,1);
insert into public.users ("identifier","password","firstname","lastname","enable",
	"id_role_user_role" ,"id_restaurant_restaurant" ) values 
	('Antho','Anthopsw','Anthony','Speedandfast',true,3,1);
insert into public.users ("identifier","password","firstname","lastname","enable",
	"id_role_user_role" ,"id_restaurant_restaurant" ) values 
	('Nath','Nathpsw','Nathalie','Desk',true,4,1);

--
-- Delivery method
--
insert into public.delivery_method ("method") values('Livraison comptoir');
insert into public.delivery_method ("method") values('Livraison domicile');
	
--
-- ingredient
--
alter sequence ingredient_id_ingredient_seq restart with 10001;
-- Permet de commencer l'id à 10000 pour les tris dans les stocks !
insert into public.ingredient ("name") values('Tomates');
insert into public.ingredient ("name") values('olives');
insert into public.ingredient ("name") values('Champigons');
insert into public.ingredient ("name") values('Fromage');
insert into public.ingredient ("name") values('Oignons');
insert into public.ingredient ("name") values('Anchois');
insert into public.ingredient ("name") values('Lardons');
insert into public.ingredient ("name") values('Creme fraiche');
insert into public.ingredient ("name") values('Jambon');

--
-- Pizza
--
insert into public.pizza ("name","description","price","size","enable","id_vat_VAT" ) values 
	('piccolo','La classique',12.58,'Large',true,1);
insert into public.pizza ("name","description","price","size","enable","id_vat_VAT" ) values 
	('moderato','La maritime',16.00,'Large',true,1);
insert into public.pizza ("name","description","price","size","enable","id_vat_VAT" ) values 
	('piano','qui va sano',15.00,'Large',true,1);
insert into public.pizza ("name","description","price","size","enable","id_vat_VAT" ) values 
	('presto','desc presto',15.00,'Large',true,1);

--
-- pizza_ingredient
--
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(5,1,10001);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,1,10002); 
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(100,1,10004);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(5,2,10001);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(100,2,10004);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,2,10002);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,2,10005);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(10,2,10006);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(5,3,10001);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(100,3,10004);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,3,10002);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,3,10005);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(50,3,10007);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(50,3,10008);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(5,4,10001);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(100,4,10004);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(12,4,10002);
insert into public.pizza_ingredient ("quantity","id_pizza_pizza","id_ingredient_ingredient") values
	(50,4,10009);

--
-- stock_ingredient_restaurant
--
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (120,10001,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (100,10002,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (100,10003,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (4000,10004,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (120,10005,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (150,10006,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (1500,10007,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (2500,10008,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (1500,10009,1);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (120,10001,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (100,10002,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (100,10003,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (4000,10004,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (120,10005,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (150,10006,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (1500,10007,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (2500,10008,2);
insert into public.stock_ingredient_restaurant ("quantity","id_ingredient_ingredient",
	"id_restaurant_restaurant") values (1500,10009,2);

--
-- payment mode
--
insert into public.payment_mode ("mode") values ('CB Internet');
insert into public.payment_mode ("mode") values ('Cash Comptoir');
insert into public.payment_mode ("mode") values ('CB Comptoir');
insert into public.payment_mode ("mode") values ('Cheque Comptoir');
insert into public.payment_mode ("mode") values ('Ticket restaurant Comptoir');
insert into public.payment_mode ("mode") values ('CB Livraison');

--
-- order_status
--
insert into public.order_status ("status") values ('En attente');
insert into public.order_status ("status") values ('En livraison');
insert into public.order_status ("status") values ('En preparation');
insert into public.order_status ("status") values ('Fin preparation');
insert into public.order_status ("status") values ('Attente client');
insert into public.order_status ("status") values ('Attente Livraison');
insert into public.order_status ("status") values ('En Livraison');
insert into public.order_status ("status") values ('Livrée');
insert into public.order_status ("status") values ('Annulée');


--
-- stock add_product
--
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (100,1,1);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (100,2,1);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (50,3,1);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (75,4,1);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (100,1,2);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (100,2,2);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (50,3,2);
insert into public.stock_addproduct_restaurant ("quantity","id_addproduct_additional_product",
	"id_restaurant_restaurant") values (75,4,2);

--
-- order pizza
--
insert into public.order_pizza ("date","time","paid","token_braintree","id_client_client",
	"id_user_users","id_order_status_order_status","id_payment_mode_payment_mode",
	"id_delivery_method_delivery_method","id_address_address","id_restaurant_restaurant") values 
	(CURRENT_DATE,CURRENT_TIME,false,'1234567890',1,null,1,2,1,1,1);
insert into public.order_pizza ("date","time","paid","token_braintree","id_client_client",
	"id_user_users","id_order_status_order_status","id_payment_mode_payment_mode",
	"id_delivery_method_delivery_method","id_address_address","id_restaurant_restaurant") values 
	(CURRENT_DATE,CURRENT_TIME,false,'1234567890',1,null,5,2,1,6,2);
insert into public.order_pizza ("date","time","paid","token_braintree","id_client_client",
	"id_user_users","id_order_status_order_status","id_payment_mode_payment_mode",
	"id_delivery_method_delivery_method","id_address_address","id_restaurant_restaurant") values 
	(CURRENT_DATE-1,CURRENT_TIME,false,'1234567890',1,null,8,2,2,1,1);
insert into public.order_pizza ("date","time","paid","token_braintree","id_client_client",
	"id_user_users","id_order_status_order_status","id_payment_mode_payment_mode",
	"id_delivery_method_delivery_method","id_address_address","id_restaurant_restaurant") values 
	(CURRENT_DATE-2,CURRENT_TIME,True,'1234567890',3,null,3,4,1,7,1);
insert into public.order_pizza ("date","time","paid","token_braintree","id_client_client",
	"id_user_users","id_order_status_order_status","id_payment_mode_payment_mode",
	"id_delivery_method_delivery_method","id_address_address","id_restaurant_restaurant") values 
	(CURRENT_DATE-2,CURRENT_TIME,True,'1234567890',2,4,8,2,1,5,1);

--
-- quantity addproduct_order
--
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,1,1);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,4,1);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,1,2);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,3,2);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,2,3);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (2,2,4);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (2,4,4);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (1,3,5);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (2,2,5);
insert into public.quantity_addproduct_order (quantity,id_addproduct_additional_product ,
	id_orderpizza_order_pizza ) values (2,4,5);


--
-- quantity add_pizza_order
--
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,2,1);
insert into public.quantity_pizza_order (quantity,id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,3,1);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (2,1,2);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,4,3);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (2,4,4);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (2,3,4);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,1,4);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,2,4);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (2,4,5);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (2,3,5);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,1,5);
insert into public.quantity_pizza_order (quantity, id_pizza_pizza ,id_orderpizza_order_pizza )
	values (1,2,5);

	