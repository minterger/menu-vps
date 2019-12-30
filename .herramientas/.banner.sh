#!/bin/bash

clear

cd ~/.Menu
echo -e "\e[32mPara salir escriba exit\e[31m"
echo

echo "Script by MINTERGER" > /home/banner.net

cuentas () {
  read linea
  echo "$linea" >>/home/banner.net
}

while [[ condition ]]; do

  if [ "$linea" = "exit" ]
  then

    sed -i '/exit/d' /home/banner.net

    service sshd reload >/dev/null 2>/dev/null
    service dropbear restart >/dev/null 2>/dev/null
    echo -e "\e[0m"
    exit
  else
    cuentas
  fi

done
