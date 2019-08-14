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
  echo
  if [ $(id -u) -eq 0 ]
  then
  	echo -e -n "\033[1;32mNombre del nuevo usuario:\033[0;37m"; read -p " " name
  	echo -e -n "\033[1;32mContraseña para el usuario $name:\033[0;37m"; read -p " " pass
  	echo -e -n "\033[1;32mCuantos dias el usuario $name debe durar:\033[0;37m"; read -p " " daysrnf
  	echo -e -n "\033[1;32mLimite de logins simultaneos:\033[0;37m"; read -p " " limiteuser
  	echo -e "\033[0m"
  	if cat /etc/passwd |grep $name: |grep -vi [a-z]$name |grep -v [0-9]$name > /dev/null
  	then
  		echo -e "\033[1;31mUsuario $name ya existe\033[0m"
  	else
  		valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
  		datexp=$(date "+%d/%m/%Y" -d "+ $daysrnf days")
  		useradd -M $name -e $valid
  		( echo "$pass";echo "$pass" ) | passwd $name 2> /dev/null
  		limite $name $limiteuser
  		echo -e "\033[1;36mUsuario: \033[0m$name"
  		echo -e "\033[1;36mContraseña: \033[0m$pass"
  		echo -e "\033[1;36mExpira:\033[0m $datexp"
  	    echo "$pass" > ~/.Menu/.users/passwd/$name
      echo "Presione una tecla para continuar"
      read foo
  	fi
  else
  	if echo $(id) |grep sudo > /dev/null
  	then
  	echo "Su usuario no esta en el grupo sudo"
  	echo -e "Para ejecutar root escriba: \033[1;31msudo su\033[0m"
  	echo -e "O ejecute menu como sudo. \033[1;31msudo menu\033[0m"
  	else
  	echo -e "Vc no esta como usuario root, ni con sus derechos (sudo)\nPara ejecutar root escribe \033[1;31msu\033[0m y escribe su contraseña root"
  	fi
  fi
}

userdelete () {
  clear
  read -p "Cual es el nombre del usuario: " name
  if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
    echo
    echo "Usuario $name no existe"
    read foo
  else
    userdel --force $name > /dev/null 2>/dev/null
    echo
    echo "El usuario $name fue eliminado"
    read foo
  fi
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
userdelete;;
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
