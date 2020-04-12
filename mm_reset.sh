#!/usr/bin/env bash
_MM_CFG_HOME=$MM_CFG_HOME
_MM_HOME=$MM_HOME
if [ -z ${_MM_CFG_HOME} ];
	then
    	_MM_CFG_HOME=/home/pi/mm_config_automate/
fi
if [ -z ${_MM_HOME} ];
	then
    	_MM_HOME=/home/pi/MagicMirror/
fi
echo ${_MM_CFG_HOME}
sleep 5s
cd $HOME
# On arrête MM sur pm2
echo "*******"
echo "**** Arrêt de MM"
pm2 stop mm
pm2 status

echo ""
echo "**** Effacer le répertoire de MagicMirror"
rm -rf MagicMirror

echo ""
echo "**** Récupération du dépôt de MagicMirror"
git clone --verbose https://github.com/MichMich/MagicMirror.git
cd ${_MM_HOME}

echo ""
echo "**** Passer sur la branche develop de MagicMirror"
git checkout develop

echo ""
echo "**** Création des liens symboliques dans MM"
cd ${_MM_HOME}
ln -s ${_MM_CFG_HOME}custom.css css/custom.css
ln -s ${_MM_CFG_HOME}config.js config/config.js

echo ""
echo "**** Installation des dépendances de MM"
npm install
npm audit fix
npm list --depth=0

echo ""
echo "**** Lancement du script d'update des modules de MM"
bash ${_MM_CFG_HOME}update_files_config.sh
cd ${_MM_HOME}
cd ../

echo ""
echo "**** Relancer MM sur pm2"
cd ${HOME}
pm2 start mm.sh
pm2 status

echo ""
echo "**** Et voilà! On est bon."
