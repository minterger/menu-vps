#!/bin/bash

users () {
  clear
  cd .users
  bash .users.sh
  echo
  cd ..
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
}

crearuser () {
  clear
  echo -e "Crear Usuario:\e[1;31m"
  echo
  echo -e -n "\e[1;32mPoner nombre de usuario: "
  read username
  echo -e "\e[1;31m"
  useradd $username
  passwd $username
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
}

userdel () {
  clear
  echo -e "Eliminar Usuario:\e[1;31m"
  echo
  echo -e -n "\e[1;32mPoner nombre de usuario: "
  read userdel
  echo -e "\e[1;31m"
  userdel $userdel
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
}

userlist () {
  clear
  cd .users
  bash .listusers.sh
  echo
  cd ..
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
}

herramientas () {
  clear
  echo -e "Herramientas: \e[1;31m"
  cd .herramientas
  bash .herramientas.sh
  cd ..
}

install () {
  clear
  echo -e "Instalación: \e[1;31m"
  cd .instalacion
  bash .instalar.sh
  cd ..
}

while :
do
bash .head.sh
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[1]\e[1;32m Usuario conectados"
echo -e "\e[1;31m[2]\e[1;32m Crear usuario"
echo -e "\e[1;31m[3]\e[1;32m Eliminar usuario"
echo -e "\e[1;31m[4]\e[1;32m Lista de usuarios"
echo -e "\e[1;31m[5]\e[1;32m Herramientas"
echo -e "\e[1;31m[6]\e[1;32m Menu de instalacion"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 6]: "
read opcion
case $opcion in
1)
users;;
2)
crearuser;;
3)
userdel;;
4)
userlist;;
5)
herramientas;;
6)
install;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
