#!/bin/bash
instalar () {
  cd ~
  wget https://github.com/minterger/menu/archive/master.zip >/dev/null 2>/dev/null
  unzip master.zip >/dev/null 2>/dev/null
  rm -r master.zip
  mv menu-master .Menu
  cd .Menu >/dev/null 2>/dev/null
  mkdir .users/passwd
  mkdir .users/limite
  rm -r install.sh
  sudo mv limite /bin/limite >/dev/null 2>/dev/null
  sudo chmod +x /bin/limite >/dev/null 2>/dev/null
  sudo mv menu.sh /bin/menu >/dev/null 2>/dev/null
  sudo chmod +x /bin/menu >/dev/null 2>/dev/null

}

instalar2 () {
  echo -e "\033[1;32mInstalando Script\033[0m"
  echo
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

  echo
  echo -e "\033[1;32mScript instalado con exito"
  echo
  echo -e "\033[1;32mPara ejecutarlo use \033[1;33mmenu\033[0m"
  echo
  echo -e "\033[1;32mPresione una tecla para continuar\033[0m"
  read foo
}

if [ -f /bin/menu ]
then
  echo -e "\033[1;32mBorrando Version anterior\033[0m"
  rm -r /bin/menu
  rm -r ~/.Menu
  echo
  instalar2

else
  echo
  instalar2

fi
