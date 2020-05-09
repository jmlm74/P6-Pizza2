<center><h1> P6 - Pizza2 </h1></center>

## P6 du parcours DA Python d'OpenClassRoom

## Concevez la solution technique d’un système de gestion de pizzeria
<br />
### Travail demandé
En tant qu’analyste-programmeur, votre travail consiste, à ce stade, à définir le domaine fonctionnel et à concevoir l’architecture technique de la solution répondant aux besoins du client, c’est-à-dire :

  * Modéliser les objets du domaine fonctionnel
  * Identifier les différents éléments composant le système à mettre en place et leurs interactions
 * Décrire le déploiement des différents composants que vous envisagez
 * Elaborer le schéma de la ou des bases de données que vous comptez créer

Votre travail sera validé par un des développeurs expérimentés de votre société (ce rôle est assuré par le mentor qui vous fera passer la soutenance du projet).

Vous utiliserez UML pour réaliser cette conception.  

### Livrables attendus
Un document (format PDF) de spécifications techniques comprenant :

* Une description du domaine fonctionnel
* Les différents composants du système et les composants externes utilisés par celui-ci et leur interaction
* La description de l’organisation physique de ces composants (déploiement)
* Le modèle physique de données (MPD) ou modèle relationnel de la base de données au format PDF ou image (PNG)
 * Base de données MySQL ou PostgreSQL avec un jeu de données de démo :
      * Un fichier ZIP contenant un dump de votre base de données
      * Un fichier ZIP contenant l’ensemble des scripts SQL de création de la base de données et du jeu de données de démo
      
### Descriptifs et explications
Ce projet est la suite du projet P4 que vous pouvez consulter [ici](https://github.com/jmlm74/P4-pizza1).  
__Les outils utilisés pour ce projet :__  
[Draw.io](https://drawio-app.com/) pour les diagrammes UML.  
[PosgreSQL](https://www.postgresql.org/) pour la base de données.  
[Pgmodler](https://pgmodeler.io/) pour le MPD et la génération de la base.  

#### Livrables :  
[PGESTpizza_01_Introduction.pdf](/Livrables/PGESTpizza_01_Introduction.pdf) - Slide d'introduction  
[PGESTpizza_02_spectechniques.pdf](/Livrables/PGESTpizza_02_spectechniques.pdf) - Specs Techniques  
[PGESTPizza_03_Modeledonnees.png](/Livrables/PGESTPizza_03_Modeledonnees.png) - Modèle Physique de Données  
[PGESTpizza_04_drop_tables.sql](/Livrables/PGESTpizza_04_drop_tables.sql) - Drop des tables base SQL  
[PGESTpizza_05_create_tables.sql](/Livrables/PGESTpizza_05_create_tables.sql) - Création des tables  
[PGESTpizza_06_fill_tables.sql](/Livrables/PGESTpizza_06_fill_tables.sql) - Remplissages des tables  
[PGESTpizza_07_tests.sql](/Livrables/PGESTpizza_07_tests.sql) - Ordres pour tester base do données  

#### Demo :  
Une version python de démo a été faite.  Ce script reprend tous les ordres SQL du fichier de test avec un menu et un resultat mis en tableau  
Version python :  >= 3.7  
__Requirements :__ 
entrypoints==0.3  
flake8==3.7.9  
mccabe==0.6.1  
prettytable==0.7.2  
prompt-toolkit==1.0.14  
psycopg2==2.8.5  
pycodestyle==2.5.0  
pyflakes==2.1.1  
Pygments==2.6.1  
regex==2020.4.4  
six==1.14.0  
__Pour  lancer la démo :__  
- Créer un virtualenv avec virtualenv - pyenv ou autre  
- Activer l'environnement virtuel  
- Se mettre dans le repertoire : Livrables/demo  
- Lancer pip install - r requirements.txt  
- Lancer le programme : python -m myapp.main  