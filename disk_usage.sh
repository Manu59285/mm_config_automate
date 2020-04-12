#!/bin/bash
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD=90
current_date=$(date "+%Y-%m-%d")

# Si on dépasse 90% d'espace disque, on vide les logs pm2
if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    pm2 flush | tee -a /tmp/cron_log-${current_date}.txt
fi
# On relance le calcul de l'espace disque
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')

# Si on est toujours à plus de 90%, on envoie une alerte par email.
if [ "$CURRENT" -gt "$THRESHOLD" ] ;
	then
		echo "Your root partition remaining free space is critically low. Used: $CURRENT%" | tee -a /tmp/cron_log-${current_date}.txt
    	mail -s 'Magicpi : Disk Space Alert' your.email@gmail.com << EOF
Your root partition remaining free space is critically low. Used: $CURRENT%
EOF
	else
		echo "Disk usage is ok. Used: $CURRENT%" | tee -a /tmp/cron_log-${current_date}.txt
fi
