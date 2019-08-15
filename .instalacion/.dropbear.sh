#!/bin/bash
if [ -f /usr/sbin/dropbear ]; then
echo -e "\033[1;32mDrobear ya esta instalado\033[0m"
echo
echo -n "Desea desinstalar S (si) o N (no): "
read opcion
case $opcion in
  s|S) clear;
  echo -e "Desinstalando Dropbear:\e[1;31m";
  echo ;
  apt-get remove -y dropbear >/dev/null 2>/dev/null;
  apt-get autoremove -y >/dev/null 2>/dev/null;
  sudo rm -r /usr/sbin/dropbear >/dev/null 2>/dev/null;
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
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y dropbear >/dev/null 2>/dev/null

  echo -e "\033[1;32m             Instalacion completada\033[0m"
  echo
  echo -e "\033[1;37mEjecutando en el puerto 80 y 443"
  echo

  rclocale='# disabled because OpenSSH is installed
  # change to NO_START=0 to enable Dropbear
  NO_START=0
  # the TCP port that Dropbear listens on
  DROPBEAR_PORT=443

  # any additional arguments for Dropbear
  DROPBEAR_EXTRA_ARGS="-p 80"

  # specify an optional banner file containing a message to be
  # sent to clients before they connect, such as "/etc/issue.net"
  DROPBEAR_BANNER=""

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

  service ssh stop
  service dropbear start

  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit 1
fi
