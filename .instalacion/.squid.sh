#!/bin/bash

#agregarpuerto () {
#  echo
#  echo -n -e "\033[1;32mEscribe el puerto: \033[1;0m"
#  read ports
#  ports1=$(netstat -tunlp| grep $ports | awk '{print $4}' | awk -F : '{print $2}')
#  if [ "$ports" = "$ports1" ]
#  then
#    echo
#    echo -e "\033[1;32mEl puerto \033[1;31m$ports \033[1;32mesta ocupado\033[1;0m"
#    echo
#    echo -n -e "\033[1;32mQuieres intentar otra vez \"S\" o \"N\"?: \033[1;0m"
#    read options
#    case $options in
#      s|S)
#      agregarpuerto;;
#      n|N)
#      echo;
#      echo "http_port 80" >> /etc/squid/squid.conf;
#      echo "http_port 3128" >> /etc/squid/squid.conf;
#      echo "http_port 8080" >> /etc/squid/squid.conf;;
#      echo -e "\033[1;32mEjecutando en el puerto 443 y 444";
#      echo;;
#    esac
#  else
#    echo
#    echo "DROPBEAR_EXTRA_ARGS=\"-p $ports\"" >>/etc/default/dropbear
#    echo -e "\033[1;32mEl puerto \033[1;31m444 \033[1;32mfue remplazado por \033[1;31m$ports\033[1;0m"
#    echo
#  fi
#}

desinstalar () {
  service squid stop > /dev/null 2>&1
  apt-get remove -y squid >/dev/null 2>/dev/null
  apt-get autoremove -y >/dev/null 2>/dev/null
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
  apt-get install -y apache2 >/dev/null 2>/dev/null
  apt-get install -y squid >/dev/null 2>/dev/null
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

if [ -f /usr/sbin/squid ]; then
echo -e "\033[1;32mSquid ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
  s|S) clear;
  echo -e "Desinstalando Squid:\e[1;31m";
  echo ;
  desinstalar2;
  echo ;
  echo -e "\e[1;32mDesinstalado.\n\nPresiona una tecla para continuar...";
  read foo;
  exit 1;;
  n|N) clear;
  echo -e "\e[1;32mPresiona una tecla para continuar...";
  read foo;
  exit 1;;
esac
else
  echo -e "\033[1;31m           Instalador Squid\n\033[1;37mInstalando Squid...\033[0m"
  instalar2

  echo -e "\033[1;32mInstalacion completada\033[0m"
  echo
  echo -e "\033[1;37mEjecutando en el puerto \e[1;31m80,3128 \e[1;37my\e[1;31m 8080\e[1;0m"
  echo

ip=$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')

  echo "cl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $ip
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
" > /etc/squid/squid.conf

# echo -n -e "\033[1;32mDesea remplazar los puertos por defecto por otro \"S\" o \"N\"?: \033[1;0m"
# read siono

# case $siono in
#   s|S)
#     agregarpuerto;;
#   n|N)echo;
#   echo "http_port 80" >> /etc/squid/squid.conf;
#   echo "http_port 3128" >> /etc/squid/squid.conf;
#   echo "http_port 8080" >> /etc/squid/squid.conf;;
# esac

  #echo "http_port 80" >> /etc/squid/squid.conf
  echo "http_port 3128" >> /etc/squid/squid.conf
  echo "http_port 8080" >> /etc/squid/squid.conf

  echo "
coredump_dir /var/spool/squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
visible_hostname proxy.mastahit.com
" >> /etc/squid/squid.conf

  echo -e "\033[1;32mReiniciando Squid\033[1;0m"

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
desinstala=$(service squid restart) && touch /tmp/instmp
sleep 0.6s

  echo
  echo -e "\e[1;32mPresiona una tecla para continuar...\033[1;0m"
  read foo
  exit 1
fi
