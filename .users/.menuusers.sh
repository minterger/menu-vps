#!/bin/bash

users () {
  clear
  bash .users.sh
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
}

crearuser () {
  clear
  if [ $(id -u) -eq 0 ]
  then
    ip=$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')
  	echo -e -n "\033[1;32mNombre del nuevo usuario:\033[0;37m"; read -p " " name
  	echo -e -n "\033[1;32mContraseña para el usuario $name:\033[0;37m"; read -p " " pass
  	echo -e -n "\033[1;32mCuantos dias el usuario $name debe durar:\033[0;37m"; read -p " " daysrnf
  	echo -e -n "\033[1;32mLimite de logins simultaneos:\033[0;37m"; read -p " " limiteuser
    echo -e -n "\033[1;32mEscribe un puerto de conexion:\033[0;37m"; read -p " " portd
  	echo -e "\033[0m"
  	if cat /etc/passwd |grep $name: |grep -vi [a-z]$name |grep -v [0-9]$name > /dev/null
  	then
  		echo -e "\033[1;31mUsuario $name ya existe\033[0m"
  	else
  		valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
  		datexp=$(date "+%d/%m/%Y" -d "+ $daysrnf days")
  		useradd -M $name -e $valid
  		( echo "$pass";echo "$pass" ) | passwd $name 2> /dev/null
      echo -e "\033[1;36mIP: \033[0m$ip"
  		limite $name $limiteuser
  		echo -e "\033[1;36mUsuario: \033[0m$name"
  		echo -e "\033[1;36mContraseña: \033[0m$pass"
  		echo -e "\033[1;36mExpira:\033[0m $datexp"
      if [ "$portd" = "" ]
      then
        echo -e "\033[1;36mPara generar datos para HTTP custom escriba un puerto\033[0m"
      else
        echo -e "\033[1;36mDatos HTTP custom:\033[0m $ip:$portd@$name:$pass "
      fi
        echo "$pass" > ~/.Menu/.users/passwd/$name
      echo
      echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
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

redefiniruser () {
    echo -e -n "\e[1;32mNombre del usuario:\e[1;0m "
    read name
  if cat /etc/passwd |grep $name: > /dev/null
  then
   echo " "
  clear
  echo -e "\033[1;33mOpciones a modificar ?\033[1;30m
  1) Numero de Conexiones
  2) Fecha de expiracion
  3) Cambiar contraseña del usuario"
  read -p "opcion: " option
  if [ $option -eq 1 ]; then
    read -p "Cual es el nuevo limite de logins: " liml
    limite $name $liml
    echo
    echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
    read foo
  fi

  if [ $option -eq 2 ]; then
    echo "Cual es la nueva fecha : formato AAAA/MM/DD"
    read -p ": " date
    chage -E $date $name 2> /dev/null
    echo -e "\033[1;31mEl usuario $name se desconectara el dia: $date\033[0m"
    echo
    echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
    read foo
  fi
  if [ $option -eq 3 ]
  then
    read -p "Cual es la nueva contraseña para el usuario $name: " pass
    (echo "$pass" ; echo "$pass" ) |passwd $name > /dev/null 2>/dev/null
    echo "$pass" > ~/.Menu/.users/passwd/$name
    echo "Nueva contraseña aplicada: $pass"
    echo
    echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
    read foo
  fi
else
 clear
 echo -e "\e[1;32mEl usuario \e[1;31m$name \e[1;32mno existe\e[1;0m"
 echo
 echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
 read foo
fi

}

killusers () {
  clear

  data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

  echo -e "Desconectando Usuarios"

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
          if [ $NUM1 -eq 1 ]; then
                  kill $PID;
          fi
  done

  data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM2=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
          if [ $NUM2 -eq 1 ]; then
            kill $PID;
          fi
  done
}

userdelete () {
  clear
  read -p "Cual es el nombre del usuario: " name
  if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
    echo
    echo -e "\e[1;32mUsuario \e[1;31m$name \e[1;32mno existe\e[1;0m"
    echo
    echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
    read foo
  else
    userdel --force $name > /dev/null 2>/dev/null
    echo
    echo -e "\e[1;32mEl usuario \e[1;31m$name \e[1;32mfue eliminado\e[1;0m"
    echo
    echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
    read foo
  fi
}

userlist () {
  clear
  bash .listusers.sh
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
  read foo
}


while :
do
cd ..
bash .head.sh
cd .users
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[1]\e[1;32m Usuario conectados"
echo -e "\e[1;31m[2]\e[1;32m Crear usuario"
echo -e "\e[1;31m[3]\e[1;32m Redefinir usuario"
echo -e "\e[1;31m[4]\e[1;32m Eliminar usuario"
echo -e "\e[1;31m[5]\e[1;32m Lista de usuarios"
echo -e "\e[1;31m[6]\e[1;32m Desconectar todos los usuarios"
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
redefiniruser;;
4)
userdelete;;
5)
userlist;;
6)
killusers;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
