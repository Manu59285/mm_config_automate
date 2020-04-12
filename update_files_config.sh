#!/usr/bin/env bash
_MM_CFG_HOME=$MM_CFG_HOME
_MM_HOME=$MM_HOME
txt_bold=$(tput bold)
txt_normal=$(tput sgr0)
txt_red='\033[0;31m'
txt_green='\033[0;32m'
txt_nc='\033[0m' # No Color

if [ -z ${_MM_CFG_HOME} ];
	then
    	_MM_CFG_HOME=/home/pi/mm_config_automate/
fi
if [ -z ${_MM_HOME} ];
	then
    	_MM_HOME=/home/pi/MagicMirror/
fi

if [ ! -f ${_MM_HOME}config/config.js ];
	then
    	ln -s ${_MM_CFG_HOME}config.js ${_MM_HOME}config/config.js
fi

delete_modules () {
  # Stocker l'ensemble des répertoires présents /home/pi/MagicMirror/modules/
  modules_list=$(ls ${_MM_HOME}modules/)

  # Ne pas prendre en compte certains fichiers et répertoires propres à MagicMirror
  modules_list=${modules_list[@]//default/}
  modules_list=${modules_list[@]//README.md/}
  modules_list=${modules_list[@]//node_modules/}

  # lançons une boucle pour s'occuper de chaque module.
  for module in ${modules_list[@]}
  do
    # Si le module n'est pas utilisé dans config.js
    if grep -Fq "module: \"${module}\"" ${_MM_HOME}config/config.js
      then
        echo "${module} existe dans config.js"
      else
        echo "${module} n'existe pas dans config.js"
        rm -rf ${_MM_HOME}modules/${module}
    fi
  done
}

import_module () {
  if [[ ! -z ${1} ]];
    then
      cd ${_MM_HOME}modules/
      repository=$(basename -s .git "$1")
      echo ""
      printf "${txt_green}${txt_bold}${repository}${txt_normal}${txt_nc}\n"
      if [[ -d ${_MM_HOME}modules/${repository} ]];
        then
          echo "** ${_MM_HOME}modules/${repository} existe déjà"
        else
          echo "** Récupération du répertoire ${1}"
          git clone ${1}
      fi
      cd ${_MM_HOME}modules/${repository}
      git checkout ./
      git pull
      if [[ -f $(ls | grep 'package.json') && ! -d $(ls | grep 'node_modules') ]];
        then
          echo "** Installation des modules npm de ${repository}"
          npm install
          npm audit fix
        else
          if [[ ! -f $(ls | grep 'package.json') ]];
            then
              echo "** Il n'y a pas de modules npm à installer pour ${txt_bold}${repository}${txt_normal}"
            else
              echo "** Les modules npm de ${txt_bold}${repository}${txt_normal} sont déjà installés"
          fi
      fi
      cd ${_MM_HOME}modules/
    else
      printf "\n${txt_red}Vous avez oublié d'indiquer un dépôt git en paramètre${txt_nc}\n"
  fi
}

import_module https://github.com/BenRoe/MMM-SystemStats.git
import_module https://github.com/edward-shen/MMM-page-indicator.git
import_module https://github.com/edward-shen/MMM-pages.git
import_module https://github.com/tataille/MMM-FreeBox-Monitor.git
import_module https://github.com/Ybbet/MMM-AlarmClock.git
import_module https://github.com/Ybbet/worldclock.git
import_module https://github.com/Jopyth/MMM-Remote-Control.git
import_module https://github.com/raywo/MMM-NowPlayingOnSpotify.git
import_module https://github.com/NolanKingdon/MMM-MoonPhase.git

delete_modules

#####
# Traitement supplémentaire après installation des modules.
#####

if [ -d ${_MM_HOME}modules/MMM-AlarmClock ];
	then
		#ls ${_MM_CFG_HOME}sounds/ | grep ".mp3"
		list_mp3=$(ls ${_MM_CFG_HOME}sounds/ | grep ".mp3")
		for mp3_file in $list_mp3;
		do
			if [[ -f ${_MM_HOME}modules/MMM-AlarmClock/sounds/$mp3_file ]];
				then
					echo "Le fichier ${txt_bold}$mp3_file${txt_normal} existe dans ${_MM_HOME}modules/MMM-AlarmClock/sounds";
				else
					echo "Le fichier ${txt_bold}$mp3_file${txt_normal} n'existe pas dans ${_MM_HOME}modules/MMM-AlarmClock/sounds. On crée le lien symbolique.";
					ln -s ${_MM_CFG_HOME}sounds/$mp3_file ${_MM_HOME}modules/MMM-AlarmClock/sounds/$mp3_file;
			fi
		done
fi
