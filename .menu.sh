#!/bin/bash

updates () {
  version=$(cat versionact)
  updates1=$(cat version)

  if [ $updates1 = $version ]; then
    echo -e " \e[1;33m(no hay actualización)\e[1;0m"
  else
    echo -e " \e[1;33m(actualizacion disponible \e[1;31mV= $updates1 \e[1;33m)\e[1;0m"
  fi
}

update () {

  cd ~
  mkdir backup
  cp -r ~/.Menu/.users/passwd ~/backup/
  cp ~/.Menu/.instalacion/proxy.py ~/backup/

  echo -e "\e[1;0m"
  echo -e "\033[1;32mDescargando"
  echo
  wget https://raw.githubusercontent.com/minterger/menu-vps/master/install.sh >/dev/null 2>/dev/null
  bash install.sh
  sudo rm -r install.sh >/dev/null 2>/dev/null

  cp -r ~/backup/passwd ~/.Menu/.users/
  cp ~/backup/proxy.py ~/.Menu/.instalacion/
  rm -r ~/backup

  echo -e "\033[1;32mPara terminar la actualizacion salga del script y vuelva a entrar\033[0m"
  echo
  echo -e "\033[1;32mPresione enter para continuar\033[0m"
  read foo
  exit 1
}

menuusers () {
  clear
  echo -e "Usuarios: \e[1;31m"
  cd .users
  bash .menuusers.sh
  cd ..
}

inf_system () {
  clear
  echo "DETALLES DEL SISTEMA"
  null="\033[1;31m"
  null2="\033[1;32m"
  echo -e "\e[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[1;0m"
  if [ ! /proc/cpuinfo ]; then echo "Sistema No Soportado" && echo; return 1; fi
  if [ ! /etc/issue.net ]; then echo "Sistema No Soportado" && echo; return 1; fi
  if [ ! /proc/meminfo ]; then echo "Sistema No Soportado" && echo; return 1; fi

  mempor=`df -h | grep dev | grep sda | grep -v boot | awk '{print $5}'`
  mempor2=`df -h | grep dev | grep vda | grep -v boot | awk '{print $5}'`

  memto=`df -h | grep dev | grep sda | grep -v boot | awk '{print $2}'`
  memto2=`df -h | grep dev | grep vda | grep -v boot | awk '{print $2}'`

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
  [[ "$clock" ]] && echo -e "${null2}Frequecia de Operacion: ${null}$clock MHz" || echo -e "${null2}Frequecia de Operacion: ${null}???"
  echo -e "${null2}Uso del Processador: ${null}$(ps aux  | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}')"
  echo -e "${null2}Momoria usada ${null}$mempor$mempor2 ${null2}de ${null}$memto$memto2"
  echo -e "${null2}Memoria Virtual Total: ${null}$(($totalram / 1024))"
  echo -e "${null2}Memoria Virtual En Uso: ${null}$(($usedram / 1024))"
  echo -e "${null2}Memoria Virtual Libre: ${null}$(($freeram / 1024))"
  echo -e "${null2}Memoria Virtual Swap: ${null}$(($swapram / 1024))MB"
  echo -e "${null2}Tiempo Online: ${null}$(uptime | awk -F "," '{print $1}' | awk -F "up" '{print $2}')"
  echo -e "${null2}Nombre De La Maquina: ${null}$(hostname)"
  echo -e "${null2}Direccion IP De La Maquina: ${null}$(cat /home/ip)"
  echo -e "${null2}Version del Kernel: ${null}$(uname -r)"
  echo -e "${null2}Arquitectura: ${null}$(uname -m)"
  echo -e "\e[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[1;0m"
  echo -e "\e[1;32mPresiona enter para continuar..."
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
  echo -e "\e[1;31m[1]\e[1;32m Administrar usuarios"
  echo -e "\e[1;31m[2]\e[1;32m Informacion del sistema"
  echo -e "\e[1;31m[3]\e[1;32m Herramientas"
  echo -e "\e[1;31m[4]\e[1;32m Menu de instalacion"
  echo -n -e "\e[1;31m[5]\e[1;32m Update Script"
  updates
  echo -e "\e[1;31m[0]\e[1;32m Salir"
  echo
  echo -n "Seleccione una opcion [1 - 5]: "
  read opcion
  case $opcion in
    1)
    menuusers;;
    2)
    inf_system;;
    3)
    herramientas;;
    4)
    install;;
    5)
    update;;
    0) clear;
    exit 1;;
    *) clear;
    echo -e "\e[1;31mEs una opcion invalida:";
    echo -e "\e[1;32mPresiona enter para continuar...";
    read foo;;
  esac
done
