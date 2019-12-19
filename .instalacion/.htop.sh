#!/bin/bash

fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
[[ ! -d ~/.Menu ]] && rm -rf /bin/menu
${comando[0]} > /dev/null 2>&1
${comando[1]} > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "\033[1;33mESPERE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33mESPERE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

desinstalar () {
  apt-get remove -y htop >/dev/null 2>/dev/null;
}

#desinstalar2 () {
#  (
#  echo -ne "[" >&2
#  while [[ ! -e /tmp/instmp ]]; do
#  echo -ne "." >&2
#  sleep 0.8s
#  done
#  rm /tmp/instmp
#  echo -ne "]" >&2
#  echo
#  ) &
#  desinstala=$(desinstalar) && touch /tmp/instmp
#  sleep 0.6s
#}

instalar () {
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y htop >/dev/null 2>/dev/null
}

#instalar2 () {
#  (
#  echo -ne "[" >&2
#  while [[ ! -e /tmp/instmp ]]; do
#  echo -ne "." >&2
#  sleep 0.8s
#  done
#  rm /tmp/instmp
#  echo -ne "]" >&2
#  echo
#  ) &
#  install=$(instalar) && touch /tmp/instmp
#  sleep 0.6s
#}

if [ -f /usr/bin/htop ]; then
echo -e "\033[1;32mHtop ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
s|S) clear;
echo -e "Desinstalando Htop:\e[1;31m";
echo ;
fun_bar desinstalar;
echo ;
echo -e "\e[1;32mDesinstalado\nPresiona enter para continuar...";
read foo;
exit 1;;
n|N) clear;
echo -e "\e[1;32mPresiona enter para continuar...";
read foo;
exit 1;;
esac
else
  echo -e "\033[1;31m           Instalador Htop\n\033[1;37mInstalando Htop...\033[0m"
  fun_bar instalar

  echo -e "\033[1;32mInstalacion completada\033[0m"

  echo
  echo -e "\e[1;32mPresiona enter para continuar..."
  read foo
  exit 1

fi
