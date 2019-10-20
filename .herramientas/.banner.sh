#!/bin/bash

banner=$(grep "banner /home/banner.net" /etc/ssh/ssh_config)

if [ "$banner" = "banner /home/banner.net" ]
  clear
else
  echo "banner /home/banner.net" >>/etc/ssh/sshd_config
  service sshd reload >/dev/null 2>/dev/null
fi

cd ~/.Menu
echo -e "\e[32mPara salir escriba exit\e[31m"
echo

echo "Minterger" >/home/banner

cuentas () {
  read linea
  echo "$linea" >>/home/banner
}

while [[ condition ]]; do

  if [ "$linea" = "exit" ]
  then

    sed '/exit/d' /home/banner >/home/banner.net

    if [ -f /home/banner ]; then
      rm -r /home/banner
      clear
    else
      clear
    fi
    echo -e "\e[0m"
    exit
  else
    cuentas
  fi

done
