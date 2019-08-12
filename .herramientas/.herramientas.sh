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

while :
do
cd ..
bash .head.sh
cd .herramientas
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[1]\e[1;32m start/stop BADVPN"
echo -e "\e[1;31m[2]\e[1;32m Consumo de recursos Top"
echo -e "\e[1;31m[3]\e[1;32m Consumo de recursos Htop"
echo -e "\e[1;31m[4]\e[1;32m Servicios funcionando"
echo -e "\e[1;31m[5]\e[1;32m Host extractor"
echo -e "\e[1;31m[6]\e[1;32m Speedtest.net Online"
echo -e "\e[1;31m[7]\e[1;32m Speedtest.net"
echo -e "\e[1;31m[8]\e[1;32m Fast"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 8]: "
read opcion
case $opcion in
1)BadVPN;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
2) clear;
echo -e "Ejecutando top\e[1;31m";
echo ;
top;;
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
5) clear;
echo -e "Ejecutando Script: \e[1;31m";
echo ;
cd ..;
cd .Irparpaya-a;
bash .real-host.sh.;
cd .herramientas.;;
6) clear;
bash .speedtest.sh;;
7) clear;
echo -e "Ejecutando test de velocidad: \e[1;31m";
echo ;
speedtest;
echo ;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
8) clear;
echo -e "Ejecutando test de velocidad:\e[1;31m";
echo ;
fast;
echo ;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
