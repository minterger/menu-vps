#!/bin/bash
cd ~/.Menu
echo -e "\e[32mPara salir escriba exit\e[31m"
echo

banner=$(grep "banner /home/banner.net" /etc/ssh/ssh_config)

if [ "$banner" = "banner /home/banner.net" ]
  echo "" >/dev/null 2>/dev/null
else
  echo "banner /home/banner.net" >>/etc/ssh/sshd_config
  service sshd reload >/dev/null 2>/dev/null
fi

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
