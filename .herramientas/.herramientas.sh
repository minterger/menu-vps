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
    [[ "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && echo "Inciado" || echo "Fallo"
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
}

killusers () {
  data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
          USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
          IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
          if [ $NUM1 -eq 1 ]; then
                  kill $PID;
          fi
  done

  data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM2=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
          USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
          IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
          if [ $NUM2 -eq 1 ]; then
            kill $PID;
          fi
  done
}

restart () {
  echo ""
  echo "Eperando para reiniciar"
  killusers
  echo ""
  echo "Reiniciando"
  echo ""
  sudo shutdown -r now
}

while :
do
cd ..
bash .head.sh
cd .herramientas
echo -e "\e[1;32mEscoja una opcion "
echo
echo -e "\e[1;31m[1]\e[1;32m start/stop BADVPN \e[1;37m(habilitar llamadas udp)\e[1;0m"
echo -e "\e[1;31m[2]\e[1;32m TCP Speed \e[1;37m(mojorar conexion)\e[1;0m"
echo -e "\e[1;31m[3]\e[1;32m Htop \e[1;37m(ver el consumo de recursos)\e[1;0m"
echo -e "\e[1;31m[4]\e[1;32m Servicios \e[1;37m(ver los servicios funcionando)\e[1;0m"
echo -e "\e[1;31m[5]\e[1;32m Host extractor \e[1;37m(extraer host para payload)\e[1;0m"
echo -e "\e[1;31m[6]\e[1;32m Speedtest \e[1;37m(hacer un test total de velocidad)\e[1;0m"
echo -e "\e[1;31m[7]\e[1;32m Fast \e[1;37m(medir solo velocidad de descarga)\e[1;0m"
echo -e "\e[1;31m[8]\e[1;32m Reiniciar vps"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 8]: "
read opcion
case $opcion in
1)BadVPN;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
2) clear;
TCPspeed;
echo;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
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
cd .host
bash .real-host.sh.;
cd .herramientas.;;
6) clear;
bash .speedtest.sh;;
7) clear;
echo -e "Ejecutando test de velocidad:\e[1;31m";
echo ;
fast;
echo ;
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
8)
restart;;
0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona una tecla para continuar...";
read foo;;
esac
done
