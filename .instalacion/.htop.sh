#!/bin/bash

desinstalar () {
  apt-get remove -y htop >/dev/null 2>/dev/null;
}

desinstalar2 () {
  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/instmp ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/instmp
  echo -ne "]" >&2
  echo
  ) &
  desinstala=$(desinstalar) && touch /tmp/instmp
  sleep 0.6s
}

instalar () {
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y htop >/dev/null 2>/dev/null
}

instalar2 () {
  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/instmp ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/instmp
  echo -ne "]" >&2
  echo
  ) &
  install=$(instalar) && touch /tmp/instmp
  sleep 0.6s
}

if [ -f /usr/bin/htop ]; then
echo -e "\033[1;32mHtop ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
s|S) clear;
echo -e "Desinstalando Htop:\e[1;31m";
echo ;
desinstalar2;
echo ;
echo -e "\e[1;32mDesinstalado\nPresiona una tecla para continuar...";
read foo;
exit 1;;
n|N) clear;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;
exit 1;;
esac
else
  echo -e "\033[1;31m           Instalador Htop\n\033[1;37mInstalando Htop...\033[0m"
  instalar2

  echo -e "\033[1;32mInstalacion completada\033[0m"

  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit 1

fi
