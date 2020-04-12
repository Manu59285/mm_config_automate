# mm_config_automate
Exemple d'automatisation de la maintenance de mon installation de MagicMirror.

Ce dépôt a pour but de montrer la possibilité d'automatiser la maintenance d'une installation d'un MagicMirror.

## Préambule
Le présent dépôt s'appelle _mm_config_automate_. Son existence n'est que pédagogique. Il n'est en aucun cas un module de MagicMirror.

De plus, je ne suis pas responsable d'une altération de vos données. Il vous faudra tester et adapter chaque script pour correspondre à VOS attentes.

## Liste des scripts
L'ensemble des scripts sont en bash. Ils restent simples à comprendre et à prendre en main avec un peu de patience et de lecture.

Voici la liste des scripts :
  - first_install.sh
  - mm_reset.sh
  - mm_update.sh
  - update_files_config.sh
  - disk_usage.sh

## first_install.sh
Ce script permet d'installer l'ensemble des éléments de base pour qu'un MagicMirror puisse fonctionner. Il est à lancer sur une installation toute belle, toute neuve d'un Raspberry Pi.
Il prend en compte un Raspbian basé sur un Debian Buster (10) mis à disposition des utilisateurs en février 2020.

Il fera dans l'ordre :
  - _sudo apt update -y_ : Récupère la liste des mises à jour disponibles
  - _sudo apt upgrade -y_ : Installe quelques mises à jour, ne supprime pas les packages
  - _sudo apt autoremove -y_ : Supprime tous les anciens paquets qui ne sont plus nécessaires
  - _sudo apt clean -y_ : Cette commande de terminal libère de l'espace disque en nettoyant les fichiers .deb téléchargés du référentiel local.

Puis :
  - On active le son par le HDMI;
  - Forcer le HDMI;
  - Forcer l'affichage vertical de l'écran;
  - Enlever des programmes inutiles;
  - Installation de quelques packages;
  - Installation de Nodejs et NPM selon la méthode indiquée ici : https://github.com/audstanley/NodeJs-Raspberry-Pi
  - Ajouter les binaires de node dans le PATH;
  - Installation de PM2;
  - Enregistrer les variables d'environnement (le home de MagicMirror, ainsi que de PM2);
  - Création du fichier mm.sh dans /home/pi/;
  - Exécution du script d'installation du MagicMirror;
  - Sauvegarder les réglages de pm2 et lancement des scripts au démarrage;

Et enfin, on enregistre le contenu du fichier _crontab.txt_ dans le crontab de l'utilisateur en cours.

## mm_reset.sh
Ce script installe MagicMirror à partir du dépôt github dudit projet. Il s'appelle "mm_reset" au lieu de "mm_install" car il supprime le répertoire _/home/pi/MagicMirror/_ s'il existe. Donc, il faut faire attention à ce point si vous désirez garder une précédente installation.

A son tour, ce script va lancer une série de commandes:
  - Arrêt de MM grâce à _pm2 stop mm_;
  - Effacer le répertoire de MagicMirror si existant;
  - Récupération du dépôt de MagicMirror;
  - Passer sur la branche develop de MagicMirror;
  - Création des liens symboliques dans MM (custom.css et config.js);
  - Installation des dépendances de MM grâce à npm;
  - Lancement du script d'update des modules de MM (cf. _update_files_config.sh_);
  - Relancer MM sur pm2.

### Liens symboliques
Dans le script mm_reset.sh, il est présumé que le fichier "config.js" et le fichier de personnalisation de css vitaux à MagicMirror soient présents dans votre répertoire "/home/pi/mm_config_automate/". Un lien symbolique dans _/home/pi/MagicMirror/css/_ et _/home/pi/MagicMirror/config/_ sera fait pointant vers votre répertoire _mm_config_automate_.

MagicMirror n'y verra que du feu!

## mm_update.sh
Ce script est plus rapide. Dans ce dépôt d'exemple, il n'est pas utilisé dans le crontab. Il est à utiliser manuellement lorsque MM doit être mis à jour.

Il arrête MM par pm2, puis va dans le répertoire de MagicMirror. A partir de là, le dépôt git est mis à jour avec les derniers fichiers. Une installation et une mise à jour des packages npm sont lancées.

Cela fait, on relance MM sur pm2.

## update_files_config.sh
Ce script bash est le nerf de la guerre. Crontab appellera dans notre exemple le fichier update_files_config.sh tous les jours à 00h15. 

Ce script contient 2 fonctions clés :
  - import_module;
  - delete_modules.

Après l'utilisation de ces fonctions, une boucle est lancée pour vérifier l'existence du module MMM-AlarmClock. Ce dernier peut utiliser des fichiers mp3 comme sonnerie d'alarme. 

Si vous désirez ajouter des fichiers mp3 à votre convenance, il vous suffira de les copier dans le répertoire _sounds_ de votre dépôt "mm_config_automate". Automatiquement, tous les soirs (selon le crontab mis en place), chaque fichier mp3 présent sera copié dans */home/pi/MagicMirror/modules/MMM-AlarmClock/sounds/*. Vous n'aurez plus à vous soucier d'autres choses que sa bonne utilisation dans votre fichier _config.js_


### import_module
Cette fonction bash attend un paramètre : l'url vers le dépôt git du module que vous désirez installer sur votre MagicMirror.

Par exemple, si vous désirez utiliser le module de page de MM, vous devez indiquer dans le fichier _update_files_config.sh_ la commande suivante :

    import_module https://github.com/edward-shen/MMM-pages.git


Elle ira dans le répertoire /home/pi/MagicMirror/modules/, vérifiera si le module existe déjà (en gros l'existance du répertoire "MMM-pages") ou pas. S'il n'existe pas, elle clonera le répertoire. Puis :

  - Accéder au répertoire du module;
  - Si un fichier package.json existe, l'installation des packages npm est lancée.

Il faudra utiliser cette fonction autant de fois que de modules désirés. 
Vous trouverez des exemples dans ledit fichier.

### delete_modules
Cette fonction se lance après l'ensemble des appels à import_module. Elle a pour but de supprimer les modules présents dans */home/pi/MagicMirror/modules/* devenus obsolètes.

Comme vous le savez, pour utiliser un module dans MagicMirror, nous devons l'avoir téléchargé d'une part dans */home/pi/MagicMirror/modules/* mais d'autre part l'avoir indiqué dans notre fichier _config.js_.

Si le répertoire */home/pi/MagicMirror/modules/nom_repertoire/* n'est pas indiqué dans ce fichier, le répertoire sera considéré comme obsolète. Donc, qu'il peut être supprimé. La présente fonction vérifiera chaque répertoire dans _modules/_ à l'exclusion de :
  - default/
  - node_modules/

Cela préservera l'espace disque de votre Raspberry Pi et évitera des erreurs dans votre MagicMirror.

## disk_usage.sh
Ce script permet de savoir le pourcentage d'utilisation d'espace disque. Dans le présent exemple, si le taux d'utilisation arrive à 90% de sa capacité, un email est envoyé (je vous laisse le soin de configurer le serveur d'envoi d'emails).

Il faut savoir que pm2 écrit beaucoup d'information dans les logs (cela dépend surtout des applications lancées sous pm2 mais c'est un autre sujet). En prenant cela en compte, si le taux d'utilisation excède les 90%, le script lance en premier lieu la commande _pm2 flush_ pour vider l'ensemble des fichiers logs de pm2. Puis vérifie à nouveau le taux de remplissage. Si la commande n'a pas changé la donne, l'email est envoyé.

# crontab.txt
Ce petit bout de fichier vous permet d'indiquer l'heure à laquelle vos routines doivent être mises en place.

Dans le présent exemple, voici les routines :
  - A 0h00: On vérifie d'abord l'espace disque
  - A 0h05: On met à jour les fichiers de mm_config_automate
  - A 0h10: On importe le contenu du fichier crontab.txt dans le crontab à 00h10
  - A 0h15: On peut maintenant lancer les scripts de routine (update_files_config.sh)
  - A 0h20: On relance MagicMirror pour prendre en compte la configuration à jour.
  - Tous les mois, on redémarre le Raspberry Pi

Si vous êtes parents et/ou assujetti à des périodes de vacances et un planning différents durant ces périodes, il est possible de mettre en place un fichier de config dédié à cette période.

Dans notre exemple, le contenu de _config.js_ et _config_vac.js_ sont identiques. Le but est d'illustrer l'existence des fichiers selon la période. En ayant en tête les dates de vacances qui vous intéressent, vous pouvez ajouter une ligne dédiée dans crontab pour que le lien symbolique de _/home/pi/MagicMirror/config/config.js_ pointe vers le fichier _/home/pi/mm_config_automate/config_vac.js_ au lieu de _/home/pi/mm_config_automate/config.js_. Le jour où vous devez revenir au travail (donc la fin de votre période de vacances) à 00h30, il suffira de remettre le lien symbolique vers _/home/pi/mm_config_automate/config.js_

Exemple pour les vacances de l'Ascension de la zone C :

    ###############
    # Vacances Ascension : 20 mai
    30 0 20 5 0 cd /home/pi/MagicMirror/config/; rm -rf config.js; ln -s /home/pi/mm_config_automate/config_vac.js config.js; pm2 restart mm
    # Rentrée : 25 mai
    30 0 25 5 * cd /home/pi/MagicMirror/config/; rm -rf config.js; ln -s /home/pi/mm_config_automate/config.js config.js; pm2 restart mm

Voilà. A vous de prendre en main ce projet en le copiant dans un dépôt personnel privé et de le faire vivre.