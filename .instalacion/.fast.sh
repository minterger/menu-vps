#!/bin/bash
if [ -f /snap/bin/fast ]; then
echo -e "\033[1;32mFast ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
s) clear;
echo -e "Desinstalando fast:\e[1;31m";
echo ;
snap remove fast;
echo ;
echo -e "\e[1;32mDesinstalado\nPresiona una tecla para continuar...";
read foo;
exit 1;;
S) clear;
echo -e "Desinstalando fast:\e[1;31m";
echo ;
snap remove fast;
echo ;
echo -e "\e[1;32mDesinstalado\nPresiona una tecla para continuar...";
read foo;
exit 1;;
n) clear;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;
exit 1;;
N) clear;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;
exit 1;;
esac
else
clear
fi
if [ -f /snap/bin/fast ]; then
echo -e "\033[1;32mFast ya esta instalado\033[0m"
exit
else
clear
fi

echo -e "\033[1;31m           Instalador Fast\n\033[1;37mInstalando Fast...\033[0m"
snap install fast

echo -e "\033[1;32m             Instalacion completada\033[0m"
