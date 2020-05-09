--
-- detail des clients avec  addresses
--
select c1.id_client as "id",c1.identifier as "ident",c1.first_name as "prenom",
c1.last_name as "nom", c1.phone1 as "tel1", c1.phone2 as "tel2", c1.profil as "profil",
a2."name" as "nom adre", a2.street1 as "rue1",a2.street2 as "rue2",a2.zipcode as "CP", 
a2.city as "Ville" from client as c1
	inner join address as a2
	on a2.id_client_client = c1.id_client 
order by "id";

--
-- '"les commandes en totalité"'
--
select op.id_orderpizza as "idcommande", op."date" as "date",cli.last_name as "Nom" ,
cli.first_name as "Prenom",re."name" as "Restaurant", os.status as "status"
from order_pizza as op 
	inner join restaurant as re
		on re.id_restaurant = op.id_restaurant_restaurant
	inner join client  as cli 
		on cli.id_client = op.id_client_client
	inner join order_status as os 
		on os.id_order_status = op.id_order_status_order_status 
	order by "date" desc;

--
-- Les commandes qui one des pizza en detail triees par commande
--
select op.id_orderpizza as "idcommande", piz."name" as "pizza",qpo.quantity as "quantité",
op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",os.status as "status",
r5."name"  as "Restaurant" from order_pizza as op 
	inner join quantity_pizza_order as qpo
		on qpo.id_orderpizza_order_pizza =op.id_orderpizza 
	inner join pizza as piz  
		on piz.id_pizza = qpo.id_pizza_pizza
	inner join client  as cli 
		on cli.id_client = op.id_client_client  
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status 
	inner join restaurant r5
		on r5.id_restaurant = op.id_restaurant_restaurant 
order by "idcommande";



--
--'Toutes les commandes du restaurant "resto1"'
-- 
select op.id_orderpizza as "Num Cde",re."name" as "restaurant", piz."name" as "produit",
qpo.quantity as "quantite", op."date" as "date",cli.last_name as "Nom",
cli.first_name as "Prenom",	os.status as "statut Cde" from order_pizza as op 
	inner  join quantity_pizza_order as qpo 
		on qpo.id_orderpizza_order_pizza =op.id_orderpizza 
	inner join pizza as piz 
		on piz.id_pizza = qpo.id_pizza_pizza
	inner join client  as cli 
		on cli.id_client = op.id_client_client
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status 
	inner join restaurant as re 
		on op.id_restaurant_restaurant = re.id_restaurant  
where re."name" = 'resto1' 
union 
select op.id_orderpizza as "Num Cde",re."name" as "restaurant", ap."name" as "produit",
qao.quantity as "quantite", op."date" as "date",cli.last_name as "Nom",
cli.first_name as "Prenom",	os.status as "statut Cde" from order_pizza as op 
	inner  join quantity_addproduct_order as qao 
		on qao.id_orderpizza_order_pizza =op.id_orderpizza 
	inner join additional_product as ap  
		on ap.id_addproduct = qao.id_addproduct_additional_product
	inner join client  as cli 
		on cli.id_client = op.id_client_client
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status 
	inner join restaurant as re 
		on op.id_restaurant_restaurant = re.id_restaurant
where re."name" = 'resto1' order by "Num Cde";

--
-- Les commandes en attente pour le restaurant 1
--
select op.id_orderpizza as "Num Cde",re."name" as "restaurant", 
op."date" as "date",cli.last_name as "Nom", cli.first_name as "Prenom",	
os.status as "statut Cde" from order_pizza as op 
	inner join client  as cli 
		on cli.id_client = op.id_client_client
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status 
	inner join restaurant as re 
		on op.id_restaurant_restaurant = re.id_restaurant 
where re."name" = 'resto1' and op.id_order_status_order_status between 1 and 7 
order by "Num Cde",op."date";

--
-- commandes --> Adresses de livraison y compris si retrait en restaurant 
-- --> cf left outer join
--
select C1.id_client as "Id", c1.identifier as "identifier",o2.id_orderpizza as "idCde",
a3."name" as "Addr", o2."date" as "Date" , o2.paid as "Reglée",os.status as "status"
from client as c1
	inner join order_pizza as o2
		on o2.id_client_client = c1.id_client 
	left outer join address as a3 
		on a3.id_address = o2.id_address_address
	inner join order_status as os 
		on os.id_order_status = o2.id_order_status_order_status ;
	
--
-- commandes client 1 en non livrée (en attente)
--
select C1.id_client as "Id", c1.identifier as "identifier",o2.id_orderpizza as "idCde",
a3."name" as "Addr", o2."date" as "Date" , o2.paid as "Reglée",os.status as "status"
from client as c1
	inner join order_pizza as o2
		on o2.id_client_client = c1.id_client 
	left outer join address as a3 
		on a3.id_address = o2.id_address_address
	inner join order_status as os 
		on os.id_order_status = o2.id_order_status_order_status
where os.id_order_status < 8 and C1.id_client = 1 ;

	--
-- Detail complet (pizza et addproduct) d'une commande --> Attention modifier 2 X le N° de commande si besoin
-- 
select op.id_orderpizza as "idcommande", piz."name" as "pizza",qpo.quantity as "quantité",
op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",os.status as "status",
r5."name" as "Restaurant" from order_pizza as op 
	inner join quantity_pizza_order as qpo
		on qpo.id_orderpizza_order_pizza =op.id_orderpizza 
	inner join pizza as piz  
		on piz.id_pizza = qpo.id_pizza_pizza
	inner join client  as cli 
		on cli.id_client = op.id_client_client  
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status
	inner join restaurant r5
		on r5.id_restaurant = op.id_restaurant_restaurant 
where op.id_orderpizza = 5
union 
select op.id_orderpizza as "idcommande", ap."name" as "pizza",qap.quantity as "quantité",
op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",os.status as "status",
r5."name" as "Restaurant" from order_pizza as op 
	inner join quantity_addproduct_order as qap
		on qap.id_orderpizza_order_pizza =op.id_orderpizza 
	inner join additional_product as ap   
		on ap.id_addproduct = qap.id_addproduct_additional_product
	inner join client  as cli 
		on cli.id_client = op.id_client_client  
	inner join order_status as os 
		on op.id_order_status_order_status = os.id_order_status
	inner join restaurant r5
		on r5.id_restaurant = op.id_restaurant_restaurant
where op.id_orderpizza = 5;


--
-- stock d'un restaurant en produit additionnel
-- 
select r2.id_restaurant as "id", r2."name"  as "Nom", 
sar.quantity as "Quantité",ap.name as "Libelle" from restaurant r2
	inner join stock_addproduct_restaurant as sar
		on r2.id_restaurant =sar.id_restaurant_restaurant 
	inner join additional_product as ap
		on ap.id_addproduct = sar.id_addproduct_additional_product 
where r2.id_restaurant = 1 order by "id";

--
-- Stock des ingrédients pour tous restaurants
-- 
select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité", 
i2."name" as "Libellé" from restaurant as r2
	inner join stock_ingredient_restaurant as sir 
		on sir.id_restaurant_restaurant = r2.id_restaurant 
	inner join ingredient as i2
		on i2.id_ingredient = sir.id_ingredient_ingredient order by "id";
	 

--
--
-- stock complet pour 1 restaurant (ingrédients + add products)
--
select r2.id_restaurant as "id", r2."name"  as "Nom", 
sar.quantity as "Quantité",ap.name as "Libelle",ap.id_addproduct as "idProduit" 
from restaurant r2
	inner join stock_addproduct_restaurant as sar
		on r2.id_restaurant =sar.id_restaurant_restaurant 
	inner join additional_product as ap
		on ap.id_addproduct = sar.id_addproduct_additional_product 
where r2.id_restaurant = 1 
union 
select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité", 
i2."name" as "Libellé", i2.id_ingredient as "idProduit" 
from restaurant as r2
	inner join stock_ingredient_restaurant as sir 
		on sir.id_restaurant_restaurant = r2.id_restaurant 
	inner join ingredient as i2
		on i2.id_ingredient = sir.id_ingredient_ingredient 
where r2.id_restaurant = 1 order by "id","idProduit";

--
-- Le même pour tous les restaurants !
--
select r2.id_restaurant as "id", r2."name"  as "Nom", 
sar.quantity as "Quantité",ap.name as "Libelle",ap.id_addproduct as "idProduit" 
from restaurant r2
	inner join stock_addproduct_restaurant as sar
		on r2.id_restaurant =sar.id_restaurant_restaurant 
	inner join additional_product as ap
		on ap.id_addproduct = sar.id_addproduct_additional_product  
union 
select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité", 
i2."name" as "Libellé", i2.id_ingredient as "idProduit" 
from restaurant as r2
	inner join stock_ingredient_restaurant as sir 
		on sir.id_restaurant_restaurant = r2.id_restaurant 
	inner join ingredient as i2
		on i2.id_ingredient = sir.id_ingredient_ingredient 
order by "id","idProduit";

--
-- Retrouver une pizza si ingredient OK pour restaurant 1
--
-- On supprime les anchois pour le restaurant 1 
update stock_ingredient_restaurant set quantity = 0 where id_ingredient_ingredient=10006 and id_restaurant_restaurant = 1;
-- Toutes les pizzas avec les ingredients (necesaires et stocks) --> Verifier 0 pour les anchois du resto1
select p1."name",i3.name as "ingredient",pi2.quantity as "quantite",sir4.quantity as "Stock" from pizza p1
	inner join pizza_ingredient pi2
		on p1.id_pizza =pi2.id_pizza_pizza
	inner join ingredient as i3
		on i3.id_ingredient = pi2.id_ingredient_ingredient
	inner join stock_ingredient_restaurant as sir4
		on sir4.id_ingredient_ingredient = i3.id_ingredient
where sir4.id_restaurant_restaurant = 1;
--
-- Sans la pizza qui pour laquelle il manque les anchois en stock --> non disponible
	inner join pizza_ingredient pi2
		on p1.id_pizza =pi2.id_pizza_pizza
	inner join ingredient as i3
		on i3.id_ingredient = pi2.id_ingredient_ingredient
	inner join stock_ingredient_restaurant as sir4
		on sir4.id_ingredient_ingredient = i3.id_ingredient
 where p1.name not in (
 	select p1."name" from pizza p1
		inner join pizza_ingredient pi2
			on p1.id_pizza =pi2.id_pizza_pizza
		inner join ingredient as i3
			on i3.id_ingredient = pi2.id_ingredient_ingredient
		inner join stock_ingredient_restaurant as sir4
			on sir4.id_ingredient_ingredient = i3.id_ingredient
	where sir4.id_restaurant_restaurant = 1 and pi2.quantity > sir4.quantity);
