#!/bin/bash

## banner ##

touch /root/usuarios.db
touch /root/fechaexp.db

if [ -f /home/banner.net ]; then
  clear
else
  echo "Script by MINTERGER" > /home/banner.net
fi

## configurar banner para sshd ##
banner=$(grep "banner /home/banner.net" /etc/ssh/sshd_config)

if [ "$banner" = "banner /home/banner.net" ]; then
  clear
else
  echo "banner /home/banner.net" >>/etc/ssh/sshd_config
  service sshd reload >/dev/null 2>/dev/null
fi

#animacion de carga
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
#fin animacion de carga


#funcion para instalar
instalar () {

  #verificacion e intalacion de dependencias
  if [ -f /usr/bin/unzip ]; then
    echo "" >/dev/null 2>/dev/null
  else
    sudo apt-get update >/dev/null 2>/dev/null
    sudo apt-get install -y unzip >/dev/null 2>/dev/null
  fi
  if [ -f /usr/bin/lsof ]; then
    echo "" >/dev/null 2>/dev/null
  else
    sudo apt-get update >/dev/null 2>/dev/null
    sudo apt-get install -y lsof >/dev/null 2>/dev/null
  fi
  #fin de verificacion e intalacion

  cd ~
  wget https://github.com/minterger/menu-vps/archive/master.zip >/dev/null 2>/dev/null
  unzip master.zip >/dev/null 2>/dev/null
  rm -r master.zip
  mv menu-vps-master .Menu
  cd .Menu >/dev/null 2>/dev/null
  mkdir .users/passwd
  mkdir .users/limite
  version=$(cat version)
  echo "$version" > versionact
  rm -r install.sh
  sudo mv limite /bin/limite >/dev/null 2>/dev/null
  sudo chmod +x /bin/limite >/dev/null 2>/dev/null
  sudo mv menu.sh /bin/menu >/dev/null 2>/dev/null
  sudo chmod +x /bin/menu >/dev/null 2>/dev/null

}


#### animacion antigua #####
#instalar2 () {
#  echo -e "\033[1;32mInstalando Script\033[0m"
#  echo
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

#  echo
#  echo -e "\033[1;32mScript instalado con exito"
#  echo
#  echo -e "\033[1;32mPara ejecutarlo use \033[1;33mmenu\033[0m"
#  echo
#}

if [ -f /bin/menu ]
then
  #actualizar o reinstalar
  echo -e "\033[1;32mBorrando Version anterior\033[0m"
  rm -r /bin/menu
  rm -r ~/.Menu
  echo
  echo -e "\033[1;32mInstalando Script\033[0m"
  echo
  fun_bar instalar
  echo
  echo -e "\033[1;32mScript instalado con exito"
  echo
  echo -e "\033[1;32mPara ejecutarlo use \033[1;33mmenu\033[0m"
  echo
else
  #solo instalacion
  echo
  echo -e "\033[1;32mInstalando Script\033[0m"
  echo
  fun_bar instalar
  echo
  echo -e "\033[1;32mScript instalado con exito"
  echo
  echo -e "\033[1;32mPara ejecutarlo use \033[1;33mmenu\033[0m"
  echo
fi
