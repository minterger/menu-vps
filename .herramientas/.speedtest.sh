#!/bin/bash
if [ -f /usr/bin/python ]; then
  echo -e "Ejecutando test de velocidad: \e[1;31m"
  echo
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit
else
  clear
fi
if [ -f /usr/bin/python ]; then
  echo -e "Ejecutando test de velocidad: \e[1;31m"
  echo
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit
else
  clear
fi
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y python >/dev/null 2>/dev/null
  echo -e "Ejecutando test de velocidad: \e[1;31m"
  echo
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
