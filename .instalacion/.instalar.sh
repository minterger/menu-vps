#!/bin/bash
while :
do
  cd ..
  bash .head.sh
  cd .instalacion
  echo -e "\e[1;32mMenu de instalación "
  echo
  echo -e "\e[1;31m[1]\e[1;32m Instalar Fast"
  echo -e "\e[1;31m[2]\e[1;32m Instalar DropBear"
  echo -e "\e[1;31m[3]\e[1;32m Instalar Squid"
  #echo -e "\e[1;31m[4]\e[1;32m Autoinstalar Squid \e[1;33m(newbeta)"
  echo -e "\e[1;31m[4]\e[1;32m Instalar HTOP"
  echo -e "\e[1;31m[5]\e[1;32m Proxy SOCKS"
  echo -e "\e[1;31m[0]\e[1;32m Volver"
  echo
  echo -n "Seleccione una opcion [1 - 5]: "
  read opcion
  case $opcion in
    1) clear;
    echo -e "Instalando Fast:\e[1;31m";
    echo ;
    bash .fast.sh;
    echo ;;
    2) clear;
    echo -e "Instalando DropBear:\e[1;31m";
    echo ;
    bash .dropbear.sh;
    echo ;;
    3) clear;
    echo -e "Instalando Squid:\e[1;31m";
    echo ;
    bash .squid.sh;
    echo ;;
    #4) clear;
    #echo -e "Instalando Squid:\e[1;31m";
    #echo ;
    #bash .squids.sh;
    #echo ;;
    4) clear;
    echo -e "Instalando HTOP:\e[1;31m";
    echo ;
    bash .htop.sh;
    echo ;;
    5) clear;
    echo -e "Administrar SOCKS:\e[1;31m";
    echo ;
    bash .socks.sh;
    echo ;;
    0) clear;
    exit 1;;
    *) clear;
    echo -e "\e[1;31mEs una opcion invalida:";
    echo -e "\e[1;32mPresiona enter para continuar...";
    read foo;;
  esac
done
