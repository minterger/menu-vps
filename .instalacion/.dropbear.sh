#!/bin/bash

agregarpuerto () {
  ports1=$(netstat -tunlp | awk '{print $4}' | awk -F : '{print $2}')
  echo
  echo -n -e "\033[1;32mEscribe el puerto\033[1;0m"
  while read ports; do
    if [ "$ports" = "$ports1" ]
    then
      echo -e "\033[1;32mEl puerto \033[1;31m$ports esta ocupado\033[1;0m"
    else
      replace=$(echo "\'/DROPBEAR_EXTRA_ARGS=/c DROPBEAR_EXTRA_ARGS=\"-p $ports\".\'")
      sed $replace /etc/default/dropbear
      echo -e "\033[1;32mEl puerto 444 fue remplazado por \033[1;31m$ports\033[1;0m"
    fi
  done
}

desinstalar () {
  service dropbear stop > /dev/null 2>&1
  apt-get remove -y dropbear >/dev/null 2>/dev/null
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
  apt-get install -y dropbear >/dev/null 2>/dev/null
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

if [ -f /usr/sbin/dropbear ]; then
echo -e "\033[1;32mDrobear ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
  s|S) clear;
  echo -e "Desinstalando Dropbear:\e[1;31m";
  echo ;
  desinstalar2;
  echo ;
  echo -e "\e[1;32mDesinstalado. Reinicia para que surga efecto\n\nPresiona una tecla para continuar...";
  read foo;
  exit 1;;
  n|N) clear;
  echo -e "\e[1;32mPresiona una tecla para continuar...";
  read foo;
  exit 1;;
esac
else
  echo -e "\033[1;31m           Instalador Dropbear\n\033[1;37mInstalando Dropbear...\033[0m"
  instalar2

  echo -e "\033[1;32mInstalacion completada\033[0m"
  echo
  echo -e "\033[1;37mEjecutando en el puerto 443 y 444"
  echo

  rclocale='# disabled because OpenSSH is installed
  # change to NO_START=0 to enable Dropbear
  NO_START=0
  # the TCP port that Dropbear listens on
  DROPBEAR_PORT=443

  # any additional arguments for Dropbear
  DROPBEAR_EXTRA_ARGS="-p 444"

  # specify an optional banner file containing a message to be
  # sent to clients before they connect, such as "/etc/issue.net"
  DROPBEAR_BANNER="/etc/issue.net"

  # RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
  #DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"

  # DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
  #DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"

  # ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
  #DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"

  # Receive window size - this is a tradeoff between memory and
  # network performance
  DROPBEAR_RECEIVE_WINDOW=65536
  '
  echo "$rclocale" > /etc/default/dropbear

  echo -e -n "\033[1;32mDesea remplazar el puerto secundario \033[1;31m444 \033[1;32mpor otro \"S\" o \"N\"?\033[1;0m"
  read siono

  case $siono in
    s|S)
      agregarpuerto;;
    n|N)echo;;
  esac

  service ssh stop
  service dropbear start
  service ssh start

  echo -e "\e[1;32mPresiona una tecla para continuar...\033[1;0m"
  read foo
  exit 1
fi
