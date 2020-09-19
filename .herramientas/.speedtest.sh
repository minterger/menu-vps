#!/bin/bash

# log donde se guardan los datos de speedtest
log="speed.log"

clear;

speedtest () {

  if [ -f speed ]; then
    rm $log
    touch $log
  else
    touch $log
  fi

  aguarde () {
    comando[0]="$1"
    comando[1]="$2"
     (
    [[ -e $HOME/fim ]] && rm $HOME/fim
    [[ ! -d ~/.Menu ]] && rm -rf /bin/menu
    ${comando[0]} > /dev/null 2>&1
    ${comando[1]} > /dev/null 2>&1
    touch $HOME/fim
     ) > /dev/null 2>&1 &
     tput civis
    echo -ne "\033[1;33mESPERE \033[1;37m- \033[1;33m["
    while true; do
       for((i=0; i<18; i++)); do
       echo -ne "\033[1;31m#"
       sleep 0.1s
       done
       [[ -e $HOME/fim ]] && rm $HOME/fim && break
       echo -e "\033[1;33m]"
       sleep 1s
       tput cuu1
       tput dl1
       echo -ne "\033[1;33mESPERE \033[1;37m- \033[1;33m["
    done
    echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
  }
  fun_tst () {
    python speedtest.py > $log
  }
  echo ""
  echo -e "\e[1;32mEjecutando test de velocidad: \e[1;0m"
  echo ""
  aguarde 'fun_tst'
  echo ""
  png=$(cat $log | grep ms | awk -F ": " '{print $2}')
  down=$(cat $log | grep Download: | awk '{print $2 " " $3}')
  upl=$(cat $log | grep Upload: | awk '{print $2 " " $3}')
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\033[1;32mPING (LATENCIA): \033[1;37m$png"
  echo -e "\033[1;32mDOWNLOAD: \033[1;37m$down"
  echo -e "\033[1;32mUPLOAD: \033[1;37m$upl"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo
  echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
  read foo
  
  if [ -f $log ]; then
    rm $log
  fi 

}

if [ -f /usr/bin/python ]; then
  speedtest
else
  echo -e "\e[1;32mInstalando dependencias.....\e[1;32m"
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y python >/dev/null 2>/dev/null
  speedtest
fi
