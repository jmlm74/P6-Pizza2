
from myapp.tools.jmlmtools import clear, colorify, MyError,database_connect
from prettytable import PrettyTable

ligneSep = "--------------"
ligneQuitter = ligne1 = colorify("0 - ", ['lightgreen']) + \
                     colorify("Quitter", ['lightblue'])

sql_orders= [# 1
             'select c1.id_client as "idClt",c1.identifier as "ident",c1.first_name as "prenom",'
             'c1.last_name as "nom", c1.phone1 as "tel1", c1.phone2 as "tel2", c1.profil as "profil",'
             'a2."name" as "nom adre", a2.street1 as "rue1",a2.street2 as "rue2",a2.zipcode as "CP",'
             'a2.city as "Ville" '
             'from client as c1 '
             'inner join address as a2 on a2.id_client_client = c1.id_client order by "idClt";'
             # 2
             ,'select op.id_orderpizza as "idcommande", op."date" as "date",cli.last_name as "Nom" , '
              'cli.first_name as "Prenom",re."name" as "Restaurant", os.status as "status" '
              'from order_pizza as op '
              'inner join restaurant as re on re.id_restaurant = op.id_restaurant_restaurant '
              'inner join client  as cli on cli.id_client = op.id_client_client '
              'inner join order_status as os on os.id_order_status = op.id_order_status_order_status '
              '	order by "date" desc;',
             # 3
              'select op.id_orderpizza as "idcommande", piz."name" as "pizza",qpo.quantity as '
              '"quantité", op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",'
              'os.status as "status", r5."name"  as "Restaurant" '
              'from order_pizza as op '
              'inner join quantity_pizza_order as qpo on qpo.id_orderpizza_order_pizza =op.id_orderpizza '
              'inner join pizza as piz on piz.id_pizza = qpo.id_pizza_pizza '
              'inner join client  as cli on cli.id_client = op.id_client_client '
              'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
              'inner join restaurant r5 on r5.id_restaurant = op.id_restaurant_restaurant '
              'order by "idcommande";',
             # 4
              'select op.id_orderpizza as "Num Cde",re."name" as "restaurant", piz."name" as '
              '"produit",qpo.quantity as "quantite", op."date" as "date",cli.last_name as "Nom",'
              'cli.first_name as "Prenom",os.status as "statut Cde" '
              'from order_pizza as op '
              'inner  join quantity_pizza_order as qpo on qpo.id_orderpizza_order_pizza =op.id_orderpizza '
              'inner join pizza as piz on piz.id_pizza = qpo.id_pizza_pizza '
              'inner join client  as cli on cli.id_client = op.id_client_client '
              'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
              'inner join restaurant as re on op.id_restaurant_restaurant = re.id_restaurant '
              'where re."name" = \'resto1\' '
              'union '
              'select op.id_orderpizza as "Num Cde",re."name" as "restaurant", ap."name" as '
              '"produit", qao.quantity as "quantite", op."date" as "date",cli.last_name as "Nom",'
              'cli.first_name as "Prenom",	os.status as "statut Cde" '
              'from order_pizza as op '
              'inner  join quantity_addproduct_order as qao on qao.id_orderpizza_order_pizza =op.id_orderpizza '
              'inner join additional_product as ap on ap.id_addproduct = qao.id_addproduct_additional_product '
              'inner join client  as cli on cli.id_client = op.id_client_client '
              'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
              'inner join restaurant as re on op.id_restaurant_restaurant = re.id_restaurant '
              'where re."name" = \'resto1\' order by "Num Cde";',
              # 5
               'select op.id_orderpizza as "Num Cde",re."name" as "restaurant",op."date" as "date",'
               'cli.last_name as "Nom", cli.first_name as "Prenom",os.status as "statut Cde" '
               'from order_pizza as op '
               'inner join client  as cli on cli.id_client = op.id_client_client '
               'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
               'inner join restaurant as re on op.id_restaurant_restaurant = re.id_restaurant '
               'where re."name" = \'resto1\' and op.id_order_status_order_status between 1 and 7 '
               'order by "Num Cde",op."date";',
              # 6
                'select C1.id_client as "Id", c1.identifier as "identifier",o2.id_orderpizza as "idCde",'
                'a3."name" as "Addr", o2."date" as "Date" , o2.paid as "Reglée",os.status as "status" '
                'from client as c1 '
                'inner join order_pizza as o2 on o2.id_client_client = c1.id_client '
                'left outer join address as a3 on a3.id_address = o2.id_address_address '
                'inner join order_status as os on os.id_order_status = o2.id_order_status_order_status ;',
               # 7
                'select C1.id_client as "Id", c1.identifier as "identifier",o2.id_orderpizza as "idCde", '
                'a3."name" as "Addr", o2."date" as "Date" , o2.paid as "Reglée",os.status as "status" '
                'from client as c1 '
                'inner join order_pizza as o2 on o2.id_client_client = c1.id_client '
                'left outer join address as a3 on a3.id_address = o2.id_address_address '
                'inner join order_status as os on os.id_order_status = o2.id_order_status_order_status '
                'where os.id_order_status < 8 and C1.id_client = 1 ;',
               # 8
                'select op.id_orderpizza as "idcommande", piz."name" as "pizza",qpo.quantity as '
                '"quantité",op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",'
                'os.status as "status",r5."name" as "Restaurant" '
                'from order_pizza as op	'
                'inner join quantity_pizza_order as qpo on qpo.id_orderpizza_order_pizza =op.id_orderpizza '
                'inner join pizza as piz on piz.id_pizza = qpo.id_pizza_pizza '
                'inner join client  as cli on cli.id_client = op.id_client_client '
                'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
                'inner join restaurant r5 on r5.id_restaurant = op.id_restaurant_restaurant '
                'where op.id_orderpizza = 5 '
                'union '
                'select op.id_orderpizza as "idcommande", ap."name" as "pizza",qap.quantity as "quantité",'
                'op."date" as "date", cli.last_name as "nom",cli.first_name as "prenom",os.status as "status", '
                'r5."name" as "Restaurant" '
                'from order_pizza as op '
                'inner join quantity_addproduct_order as qap on qap.id_orderpizza_order_pizza =op.id_orderpizza '
                'inner join additional_product as ap on ap.id_addproduct = qap.id_addproduct_additional_product '
                'inner join client  as cli on cli.id_client = op.id_client_client '
                'inner join order_status as os on op.id_order_status_order_status = os.id_order_status '
                'inner join restaurant r5 on r5.id_restaurant = op.id_restaurant_restaurant '
                'where op.id_orderpizza = 5;',
               # 9
                'select r2.id_restaurant as "id", r2."name"  as "Nom", sar.quantity as "Quantité",ap.name as "Libelle" '
                'from restaurant r2 '
                'inner join stock_addproduct_restaurant as sar on r2.id_restaurant =sar.id_restaurant_restaurant '
                'inner join additional_product as ap on ap.id_addproduct = sar.id_addproduct_additional_product '
                'where r2.id_restaurant = 1 order by "id";',
               # 10
                'select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité",'
                'i2."name" as "Libellé" '
                'from restaurant as r2 '
                'inner join stock_ingredient_restaurant as sir on sir.id_restaurant_restaurant = r2.id_restaurant '
                'inner join ingredient as i2 on i2.id_ingredient = sir.id_ingredient_ingredient order by "id";',
               # 11
                'select r2.id_restaurant as "id", r2."name"  as "Nom",sar.quantity as "Quantité",ap.name as "Libelle",'
                'ap.id_addproduct as "idProduit"'
                'from restaurant r2 '
                'inner join stock_addproduct_restaurant as sar on r2.id_restaurant =sar.id_restaurant_restaurant '
                'inner join additional_product as ap on ap.id_addproduct = sar.id_addproduct_additional_product '
                'where r2.id_restaurant = 1 '
                'union '
                'select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité", '
                'i2."name" as "Libellé", i2.id_ingredient as "idProduit" '
                'from restaurant as r2 '
                'inner join stock_ingredient_restaurant as sir on sir.id_restaurant_restaurant = r2.id_restaurant '
                'inner join ingredient as i2 on i2.id_ingredient = sir.id_ingredient_ingredient '
                'where r2.id_restaurant = 1 order by "id","idProduit";',
               # 12
                'select r2.id_restaurant as "id", r2."name"  as "Nom",sar.quantity as "Quantité",ap.name as "Libelle",'
                'ap.id_addproduct as "idProduit" '
                'from restaurant r2 '
                'inner join stock_addproduct_restaurant as sar on r2.id_restaurant =sar.id_restaurant_restaurant '
                'inner join additional_product as ap on ap.id_addproduct = sar.id_addproduct_additional_product '
                'union '
                'select r2.id_restaurant as "id", r2."name" as "Nom", sir.quantity as "quantité", i2."name" as '
                '"Libellé", i2.id_ingredient as "idProduit" '
                'from restaurant as r2 '
                'inner join stock_ingredient_restaurant as sir on sir.id_restaurant_restaurant = r2.id_restaurant '
                'inner join ingredient as i2 on i2.id_ingredient = sir.id_ingredient_ingredient '
                'order by "id","idProduit";',
               # 13
                'update stock_ingredient_restaurant set quantity = 0 where id_ingredient_ingredient=10006 '
                'and id_restaurant_restaurant = 1;',
               # 14
                'select p1."name",i3.name as "ingredient",pi2.quantity as "quantite",sir4.quantity as "Stock" '
                'from pizza p1 '
                'inner join pizza_ingredient pi2 on p1.id_pizza =pi2.id_pizza_pizza '
                'inner join ingredient as i3 on i3.id_ingredient = pi2.id_ingredient_ingredient '
                'inner join stock_ingredient_restaurant as sir4 on sir4.id_ingredient_ingredient = i3.id_ingredient '
                'where sir4.id_restaurant_restaurant = 1;',
               # 15
                'select distinct(p1."name") '
                'from pizza p1 '
                'inner join pizza_ingredient pi2 on p1.id_pizza =pi2.id_pizza_pizza '
                'inner join ingredient as i3 on i3.id_ingredient = pi2.id_ingredient_ingredient '
                'inner join stock_ingredient_restaurant as sir4 on sir4.id_ingredient_ingredient = i3.id_ingredient '
                'where p1.name not in '
                '(select p1."name" '
                'from pizza p1 '
                'inner join pizza_ingredient pi2 on p1.id_pizza =pi2.id_pizza_pizza	'
                'inner join ingredient as i3 on i3.id_ingredient = pi2.id_ingredient_ingredient '
                'inner join stock_ingredient_restaurant as sir4 on sir4.id_ingredient_ingredient = i3.id_ingredient '
                'where sir4.id_restaurant_restaurant = 1 and pi2.quantity > sir4.quantity);'
                ,]





sql_libels = ['detail des clients - addresses',
              'les commandes en totalité',
              'Les commandes de pizza en detail triees par commande',
              'Toutes les commandes du restaurant "resto1"',
              'Les commandes en attente pour le restaurant 1',
              'Les Commandes (address - null si pas d adresse --> retrait en restaurant)',
              'commandes client 1 en non livrée (en attente)',
              'Detail d une commande --> Attention modifier 2 X le N° de commande !',
              'stock d un restaurant en produits additionnels',
              'Stock des ingrédients pour tous restaurants',
              'stock complet pour 1 restaurant (ingrédients + add products)',
              'stock complet pour tous les restaurants',
              'mise a 0 des anchois pour le resto1',
              'Toutes les pizzas et les ingredients nécessaires',
              'Sans la pizza qui pour laquelle il manque les anchois en stock !'
              ]

def affiche_result(cols,rows):
    x= PrettyTable()
    # print(cols)
    x.field_names = cols[:]
    list_row=[]
    for row in rows:
        list_row = list(row)
        x.add_row(list_row)
    print(x.get_string())
    pass

def choix(num_ordr):
    dbconn = None
    try:
        dbconn = database_connect()
        with dbconn as cursor:
            if cursor != 0:
                ordr_sql = sql_orders[num_ordr]
                cursor.execute(ordr_sql)
                if sql_orders[num_ordr][:6].lower() == 'select':
                    rows = cursor.fetchall()
                    cols = []
                    [cols.append(desc[0]) for desc in cursor.description]
                    print("")
                    print("Ordre SQL : %s" % ordr_sql)
                    print("")
                    affiche_result(cols,rows)
                else:
                    dbconn.commit()
    except(MyError) as error:
        print("Error SQL : %s" % error)
    finally:
        if dbconn is not None:
            dbconn.disconnect_db()
    input("Appuyez sur entree pour continuer : ")



def display_menu(erreur = False):
    clear()
    print("")
    if erreur == True:
        ligneErreur = colorify('Erreur - vous devez entrer un choix valide !', ['red'])
        print(ligneErreur)
    else:
        print("")
    choix_menu = 0
    titre = colorify("Menu", ['lightyellow'])

    if choix_menu == 999:
        ligneErreur = colorify('Erreur - vous devez entrer un choix valide !', ['red'])
        print(ligneErreur)
    else:

        print(ligneSep)
        print(titre)
        i=1
        for libel in sql_libels:
            ligne = colorify(str(i) +" - ", ['lightgreen']) + \
                     colorify(libel, ['lightblue'])
            i += 1
            print(ligne)
        print(ligneSep)
        print(ligneQuitter)
        try:
            msg = colorify("Entrez votre choix : ", ['lightyellow'])
            choix = int(input(msg))
            return choix
        except ValueError:
            return 999


def main():
    loop = True
    erreur = False
    while loop:
        choix_menu = display_menu(erreur)
        print(choix_menu)
        erreur = False
        if choix_menu == 0:
            loop = False
        elif choix_menu == 999:
            erreur = True;
#        elif choix_menu in [13]:
#            insert_sql(choix_menu - 1)
#            pass
        else:
            print("")
            print(sql_libels[choix_menu - 1])
            choix(choix_menu - 1)




if __name__ == "__main__":
    main()