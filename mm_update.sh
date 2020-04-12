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
sleep 10s
cd $HOME
pm2 stop mm | tee -a /tmp/mm_update_log.txt
cd ${_MM_HOME}
git checkout ./ | tee -a /tmp/mm_update_log.txt
git pull | tee -a /tmp/mm_update_log.txt
npm install | tee -a /tmp/mm_update_log.txt
npm audit fix | tee -a /tmp/mm_update_log.txt
npm update | tee -a /tmp/mm_update_log.txt
npm audit fix | tee -a /tmp/mm_update_log.txt
cd $HOME
pm2 restart mm | tee -a /tmp/mm_update_log.txt
