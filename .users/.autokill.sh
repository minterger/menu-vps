#!/bin/bash

fun_bar () {
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

fun_socksoffssh () {
  for pidkillssh in  `screen -ls | grep ".killssh" | awk {'print $1'}`; do
    screen -r -S "$pidkillssh" -X quit
  done
  sleep 1
  screen -wipe > /dev/null
}

fun_inisocks () {
  screen -dmS killssh bash ~/.Menu/.users/.killssh.sh
}

autokill () {
  if ps x | grep .killssh.sh | grep -v grep 1>/dev/null 2>/dev/null; then
    clear

    echo -e "\033[1;32mDESACTIVANDO AUTOKILLSSH\033[1;33m"
    echo ""
    fun_bar 'fun_socksoffssh'
    echo ""
    echo -e "\033[1;32mAUTOKILLSSH DESACTIVADO CON EXITO!\033[1;33m"
    sleep 3
    clear
  else
    clear

    echo ""
    echo -e "\033[1;32mINICIANDO AUTOKILLSSH\033[1;33m"
    echo ""
    fun_bar 'fun_inisocks'
    echo ""
    echo -e "\033[1;32mAUTOKILLSSH ACTIVADO CON EXITO\033[1;33m"
    sleep 3
    clear
  fi
}

fun_socksoffdbr () {
  for pidkilldbr in  `screen -ls | grep ".killdbr" | awk {'print $1'}`; do
    screen -r -S "$pidkilldbr" -X quit
  done
  sleep 1
  screen -wipe > /dev/null
}

fun_inisocksdbr () {
  screen -dmS killdbr bash ~/.Menu/.users/.killdbr.sh
}

autokilldbr () {
  if ps x | grep .killdbr.sh | grep -v grep 1>/dev/null 2>/dev/null; then
    clear

    echo -e "\033[1;32mDESACTIVANDO AUTOKILLSSH\033[1;33m"
    echo ""
    fun_bar 'fun_socksoffdbr'
    echo ""
    echo -e "\033[1;32mAUTOKILLSSH DESACTIVADO CON EXITO!\033[1;33m"
    sleep 3
    clear
  else
    clear

    echo ""
    echo -e "\033[1;32mINICIANDO AUTOKILLSSH\033[1;33m"
    echo ""
    fun_bar 'fun_inisocksdbr'
    echo ""
    echo -e "\033[1;32mAUTOKILLSSH ACTIVADO CON EXITO\033[1;33m"
    sleep 3
    clear
  fi
}

onoff () {
  killdbr="$(ps x | grep .killdbr.sh | grep -v grep)"

  killssh="$(ps x | grep .killssh.sh | grep -v grep)"

  if [ "$killdbr" = "" ]; then
    asd="[off]"
  else
    asd="[on]"
  fi

  if [ "$killssh" = "" ]; then
    asd2="[off]"
  else
    asd2="[on]"
  fi
}

while :
do
cd ..
bash .head.sh
cd .users
echo -e "\e[1;32mEscoja una opcion "
echo
onoff
echo -e "\e[1;31m[1]\e[1;32m Autokill SSH $asd2"
echo -e "\e[1;31m[2]\e[1;32m Autokill Dropbear $asd"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 2]: "
read opcion
case $opcion in
1)
autokill;;
2)
autokilldbr;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona enter para continuar...";
read foo;;
esac
done
