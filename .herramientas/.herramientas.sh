#!/bin/bash

BadVPN () {
pid_badvpn=$(ps x | grep badvpn | grep -v grep | awk '{print $1}')
  if [ "$pid_badvpn" = "" ]; then
    echo
    echo "Iniciando Badvpn"
    echo
    if [[ ! -e /bin/badvpn-udpgw ]]; then
    wget -O /bin/badvpn-udpgw https://www.dropbox.com/s/nxf5s1lffmbikwq/badvpn-udpgw &>/dev/null
    chmod 777 /bin/badvpn-udpgw
    fi
    screen -dmS screen /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
    [[ "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && echo "inciado" || echo "fallo"
    echo
  else
    echo
    echo "Parando Badvpn"
    kill -9 $(ps x | grep badvpn | grep -v grep | awk '{print $1'}) > /dev/null 2>&1
    killall badvpn-udpgw > /dev/null 2>&1
    [[ ! "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && echo -e "${cor[4]} ${txt[125]}"
    unset pid_badvpn
    fi
unset pid_badvpn
}

TCPspeed () {
  if [[ `grep -c "^#ADM" /etc/sysctl.conf` -eq 0 ]]; then
    #INSTALA
    echo "TCP Speed No esta Activado, Desea Activar Ahora?"
    echo
    while [[ ${resposta} != @(s|S|n|N|y|Y) ]]; do
      read -p " [S/N]: " -e -i s resposta
      tput cuu1 && tput dl1
    done
    [[ "$resposta" = @(s|S|y|Y) ]] && {
    echo "#ADM" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_window_scaling = 1
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.ipv4.tcp_rmem = 4096 87380 16777216
    net.ipv4.tcp_wmem = 4096 16384 16777216
    net.ipv4.tcp_low_latency = 1
    net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf > /dev/null 2>&1
    echo "TCP Activado Con Exito!"
  } || echo "Cancelado!"
  else
    #REMOVE
    echo "TCP Speed ya esta Activado, Desea Parar Ahora?"
    echo
    while [[ ${resposta} != @(s|S|n|N|y|Y) ]]; do
      read -p " [S/N]: " -e -i s resposta
      tput cuu1 && tput dl1
    done
    [[ "$resposta" = @(s|S|y|Y) ]] && {
    grep -v "^#ADM
    net.ipv4.tcp_window_scaling = 1
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.ipv4.tcp_rmem = 4096 87380 16777216
    net.ipv4.tcp_wmem = 4096 16384 16777216
    net.ipv4.tcp_low_latency = 1
    net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv -f /tmp/syscl /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf > /dev/null 2>&1
    echo "TCP Parado Con Exito!"
  } || echo "Cancelado!"
  fi
  echo;
  echo -e "\e[1;32mPresiona una tecla para continuar...";
  read foo;;
}


update () {
  echo -e "\e[1;0m"
  echo -e "\033[1;32mDescargando"
  echo
  cd ~
  wget https://raw.githubusercontent.com/minterger/menu/master/install.sh >/dev/null 2>/dev/null
  bash install.sh
  sudo rm -r install.sh >/dev/null 2>/dev/null
  exit 5
}

restart () {
  echo ""
  echo "Reiniciando"
  sudo shutdown -r now
}

while :
do
cd ..
bash .head.sh
cd .herramientas
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[1]\e[1;32m start/stop BADVPN"
echo -e "\e[1;31m[2]\e[1;32m TCP Speed"
echo -e "\e[1;31m[3]\e[1;32m Consumo de recursos Htop"
echo -e "\e[1;31m[4]\e[1;32m Servicios funcionando"
echo -e "\e[1;31m[5]\e[1;32m Update Script"
echo -e "\e[1;31m[6]\e[1;32m Host extractor"
echo -e "\e[1;31m[7]\e[1;32m Speedtest.net Online"
echo -e "\e[1;31m[8]\e[1;32m Fast"
echo -e "\e[1;31m[9]\e[1;32m Reiniciar vps"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 9]: "
read opcion
case $opcion in
1)BadVPN;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
2) clear;
TCPspeed;;
3) clear;
echo -e "Ejecutando htop\e[1;31m";
echo ;
htop;;
4) clear;
echo -e "Servicios funcionando: \e[1;31m";
echo ;
lsof -n -i -P | grep '*';
echo ;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
5)
update;;
6) clear;
echo -e "Ejecutando Script: \e[1;31m";
echo ;
cd ..;
cd .host
bash .real-host.sh.;
cd .herramientas.;;
7) clear;
bash .speedtest.sh;;
8) clear;
echo -e "Ejecutando test de velocidad:\e[1;31m";
echo ;
fast;
echo ;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
9)
restart;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
