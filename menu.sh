#!/bin/bash

cd ~/.Menu
echo -e "\e[1;37mChequeando actualizaciones\e[1;0m"
sudo rm -r version >/dev/null 2>/dev/null
wget https://raw.githubusercontent.com/minterger/menu/master/version >/dev/null 2>/dev/null

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
echo -e "\e[1;37m-----------------------------------------------------\e[1;0m"
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
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
