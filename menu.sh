#!/bin/bash

#ingresar al directorio del script
cd ~/.Menu

#animacion de carga
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
#fin animacion de carga

########### check de actualizacion ############
check () {
  sudo rm -r version >/dev/null 2>/dev/null
  wget https://raw.githubusercontent.com/minterger/menu/master/version >/dev/null 2>/dev/nul
}

clear
echo -e "\e[1;37mChequeando actualizaciones\e[1;0m"
fun_bar check
######### fin check de actualizacion ##########

while :
do
cd ~/.Menu
version=$(cat versionact)
bash .menu.sh
clear
echo -e "\e[1;33m(Main)\e[1;32m"
echo " ___    ___  _  ___     _  _______  ______  _____   ______  ______  _____  "
echo "|   \  /   || ||   \   | ||__   __||  ____||  _  \ |  ____||  ____||  _  \ "
echo "| |\ \/ /| || || |\ \  | |   | |   | |____ | |_| | | |____ | |____ | |_| | "
echo "| | \__/ | || || | \ \ | |   | |   |  ____||  _  / |  __  ||  ____||  _  / "
echo "| |      | || || |  \ \| |   | |   | |____ | | \ \ | |__| || |____ | | \ \ "
echo "|_|      |_||_||_|   \___|   |_|   |______||_|  \_\|______||______||_|  \_\ "
echo -e "\e[1;33mV= $version ©"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[S]\e[1;32m Salir \e[1;31m[C]\e[1;32m Cancelar"
echo
echo -n "Seleccione una opcion [S o C]: "
read opcion
case $opcion in
c|C) clear;
echo -e "\e[1;31mMenu";
echo ;;
s|S) clear;
echo -e "\e[1;0m"
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo;
echo -e "\e[1;32mPresiona enter para continuar...";
read foo;;
esac
done
