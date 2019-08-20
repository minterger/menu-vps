#!/bin/bash

desinstalar () {
  snap remove fast >/dev/null 2>/dev/null
}

desinstalar2 () {
  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/instmp ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/instmp
  echo -e "]" >&2
  ) &
  desinstala=$(desinstalar) && touch /tmp/instmp
  sleep 0.6s
}

instalar () {
  snap install fast >/dev/null 2>/dev/null
}

instalar2 () {
  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/instmp ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/instmp
  echo -e "]" >&2
  ) &
  install=$(instalar) && touch /tmp/instmp
  sleep 0.6s
}

if [ -f /snap/bin/fast ]; then
echo -e "\033[1;32mFast ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
  s|S) clear;
  echo -e "Desinstalando fast:\e[1;31m";
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
  echo -e "\033[1;31m           Instalador Fast\n\033[1;37mInstalando Fast...\033[0m"
  instalar2

  echo -e "\033[1;32mInstalacion completada\033[0m"

  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit 1
fi
