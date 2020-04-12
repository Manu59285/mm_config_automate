#!/bin/bash
txt_bold=$(tput bold)
txt_normal=$(tput sgr0)
txt_red='\033[0;31m'
txt_green='\033[0;32m'
txt_nc='\033[0m' # No Color
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

printf "\n\n${txt_green}${txt_bold} **** Installation et configuration du MagicPi${txt_normal}${txt_nc}\n"
printf "\n\n${txt_green}${txt_bold} **** Mise à jour des dépôts de Raspbian${txt_normal}${txt_nc}\n"
sudo apt-get update -y;
sudo apt-get upgrade -y;
sudo apt-get autoremove-y ;
sudo apt-get clean -y;

printf "\n\n${txt_green}${txt_bold} **** On active le son par le HDMI${txt_normal}${txt_nc}\n"
amixer cset numid=3 2

printf "\n\n${txt_green}${txt_bold} **** Forcer le HDMI${txt_normal}${txt_nc}\n"
sudo sed -i "s/#hdmi_drive=2/hdmi_drive=2/" /boot/config.txt

printf "\n\n${txt_green}${txt_bold} **** Forcer l'affichage vertical de l'écran${txt_normal}${txt_nc}\n"
if grep -q "# Rotate display vertically" /boot/config.txt;
  then
    printf "\n\n${txt_green}${txt_bold} **** L'affichage vertical a déjà été indiqué${txt_normal}${txt_nc}\n"
  else
echo "# Rotate display vertically
display_rotate=1
avoid_warnings=1
" >> /boot/config.txt
printf "\n\n${txt_green}${txt_bold} **** L'affichage a été modifié dans /boot/config.txt"
fi

printf "\n\n${txt_green}${txt_bold} **** Enlever des programmes inutiles${txt_normal}${txt_nc}\n"
sudo apt remove -y --purge idle3 java-common libreoffice minecraft-pi scratch python-minecraftpi python3-minecraftpi smartsim sonic-pi wolfram-engine

printf "\n\n${txt_green}${txt_bold} **** Installation de quelques packages${txt_normal}${txt_nc}\n"
packages=(git zip unzip curl wget)
for package in "${packages[@]}"
do
  printf "\n\n${txt_green}${txt_bold} **** Installation de ${package}${txt_normal}${txt_nc}\n"
  sudo apt install -y ${package}
  echo ""
done

printf "\n\n${txt_green}${txt_bold} **** Installation de Nodejs et NPM${txt_normal}${txt_nc}\n"
sudo apt remove -y node
# Plus d'infos ici : https://github.com/audstanley/NodeJs-Raspberry-Pi
wget -O - https://raw.githubusercontent.com/audstanley/NodeJs-Raspberry-Pi/master/Install-Node.sh | sudo bash
node -v
npm -v

printf "\n\n${txt_green}${txt_bold} **** Ajouter les binaires de node dans le PATH${txt_normal}${txt_nc}\n"
cat <<'EOF' >> $HOME/.profile

# set PATH so it includes node bin if exists
if [ -d \"/opt/nodejs/bin/\" ]; then
    PATH="/opt/nodejs/bin:$PATH\"
fi

EOF

printf "\n\n${txt_green}${txt_bold} **** Installation de PM2${txt_normal}${txt_nc}\n"
sudo npm install pm2 -g

printf "\n\n${txt_green}${txt_bold} **** Enregistrer les variables d'environnement${txt_normal}${txt_nc}\n"
if grep -q "mm_config_automate/" $HOME/.bashrc;
  then
    printf "\n\n${txt_green}${txt_bold} **** Les variables sont déjà présentes${txt_normal}${txt_nc}\n"
  else
echo "
export MM_CFG_HOME=${HOME}/mm_config_automate/
export MM_HOME=${HOME}/MagicMirror/
" >> $HOME/.bashrc
fi
PM2_HOME="$HOME/.pm2"
if grep -q "${PM2_HOME}" $HOME/.bashrc
  then
    printf "\n\n${txt_green}${txt_bold} **** Le HOME pour PM2 est déjà renseigné${txt_normal}${txt_nc}\n"
  else
echo "
export PM2_HOME=\"${PM2_HOME}\"
" >> $HOME/.bashrc
fi
source $HOME/.bashrc

printf "\n\n${txt_green}${txt_bold} **** Création du fichier mm.sh${txt_normal}${txt_nc}\n"
echo "#!/bin/bash
cd ~/MagicMirror
DISPLAY=:0 npm start" > ${HOME}/mm.sh
sudo chmod +x ${HOME}/mm.sh

printf "\n\n${txt_green}${txt_bold} **** Script d'installation du MagicMirror${txt_normal}${txt_nc}\n"
bash ${_MM_CFG_HOME}/mm_reset.sh

printf "\n\n${txt_green}${txt_bold} **** Sauvegarder les réglages de pm2 et lancement des scripts au démarrage."
pm2 save
pm2 startup
eval $(pm2 startup | tail -n1)

cat ${_MM_CFG_HOME}/crontab.txt | crontab -
