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
  cd .users
  bash .listusers.sh
  echo
  cd ..
  echo -e "\e[1;32mPresiona una tecla para continuar...\e[1;0m"
  read foo
}

inf_system () {
  clear
  echo "DETALLES DEL SISTEMA"
  null="\033[1;31m"
  null2="\033[1;32m"
  echo
  if [ ! /proc/cpuinfo ]; then echo "Sistema No Soportado" && echo; return 1; fi
  if [ ! /etc/issue.net ]; then echo "Sistema No Soportado" && echo; return 1; fi
  if [ ! /proc/meminfo ]; then echo "Sistema No Soportado" && echo; return 1; fi
  totalram=$(free | grep Mem | awk '{print $2}')
  usedram=$(free | grep Mem | awk '{print $3}')
  freeram=$(free | grep Mem | awk '{print $4}')
  swapram=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
  system=$(cat /etc/issue.net)
  clock=$(lscpu | grep "CPU MHz:" | awk '{print $3}')
  based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
  processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
  cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
  [[ "$system" ]] && echo -e "${null2}Sistema: ${null}$system" || echo -e "${null2}Sistema: ${null}???"
  [[ "$based" ]] && echo -e "${null2}Basado en: ${null}$based" || echo -e "${null2}Baseado: ${null}???"
  [[ "$processor" ]] && echo -e "${null2}Processador: ${null}$processor x$cpus" || echo -e "${null2}Processador: ${null}???"
  [[ "$clock" ]] && echo -e "${null2}Frequecia de Operacao: ${null}$clock MHz" || echo -e "${null2}Frequecia de Operacao: ${null}???"
  echo -e "${null2}Uso del Processador: ${null}$(ps aux  | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}')"
  echo -e "${null2}Memoria Virtual Total: ${null}$(($totalram / 1024))"
  echo -e "${null2}Memoria Virtual En Uso: ${null}$(($usedram / 1024))"
  echo -e "${null2}Memoria Virtual Libre: ${null}$(($freeram / 1024))"
  echo -e "${null2}Memoria Virtual Swap: ${null}$(($swapram / 1024))MB"
  echo -e "${null2}Tiempo Online: ${null}$(uptime)"
  echo -e "${null2}Nombre De La Maquina: ${null}$(hostname)"
  echo -e "${null2}Direccion De La Maquina: ${null}$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')"
  echo -e "${null2}Version del Kernel: ${null}$(uname -r)"
  echo -e "${null2}Arquitectura: ${null}$(uname -m)"
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  return 0
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
echo -e "\e[1;31m[5]\e[1;32m Informacion del sistema"
echo -e "\e[1;31m[6]\e[1;32m Herramientas"
echo -e "\e[1;31m[7]\e[1;32m Menu de instalacion"
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
inf_system;;
6)
herramientas;;
7)
install;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
