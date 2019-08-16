#!/bin/bash
instalar () {
  cd ~
  wget https://github.com/minterger/menu/archive/master.zip
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
  echo
  echo -e "\033[1;32mPara ejecutarlo use menu\033[0m"
}

if [ -f /bin/menu ]
then
  echo -e "\033[1;32mBorrando Version anterior\033[0m"
  rm -r /bin/menu
  rm -r ~/.Menu
  echo
  echo -e "\033[1;32mInstalando Script\033[0m"

  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/pyend ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/pyend
  echo -e "]" >&2
  ) &
  install=$(instalar) && touch /tmp/pyend
  sleep 0.6s

  echo -e "\033[1;32mScript instalado con exito"
  echo
  echo -e "\033[1;32mPara ejecutarlo use menu\033[0m"
else
  echo
  echo -e "\033[1;32mInstalando Script\033[0m"

  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/pyend ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/pyend
  echo -e "]" >&2
  ) &
  install=$(instalar) && touch /tmp/pyend
  sleep 0.6s

  echo -e "\033[1;32mScript instalado con exito"
  echo
  echo -e "\033[1;32mPara ejecutarlo use menu\033[0m"
fi
