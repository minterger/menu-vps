#!/bin/bash
speedtest () {
  echo -e "Ejecutando test de velocidad: \e[1;31m"
  echo
  ping=$(ping -c1 google.com |awk '{print $8 $9}' |grep -v loss |cut -d = -f2 |sed ':a;N;s/\n//g;ta')
  (
  echo -ne "[" >&2
  while [[ ! -e /tmp/pyend ]]; do
  echo -ne "." >&2
  sleep 0.8s
  done
  rm /tmp/pyend
  echo -e "]" >&2
  ) &
  starts_test=$(python speedtest.py) && touch /tmp/pyend
  sleep 0.6s
  down_load=$(echo "$starts_test" | grep "Download" | awk '{print $2,$3}')
  up_load=$(echo "$starts_test" | grep "Upload" | awk '{print $2,$3}')
  echo "Latencia: $ping"
  echo "Descarga: $down_load"
  echo "Subida: $up_load"
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
  exit
}

if [ -f /usr/bin/python ]; then
  speedtest
else
  apt-get update >/dev/null 2>/dev/null
  apt-get install -y python >/dev/null 2>/dev/null
  echo -e "Ejecutando test de velocidad: \e[1;31m"
  echo
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
  echo
  echo -e "\e[1;32mPresiona una tecla para continuar..."
  read foo
fi
