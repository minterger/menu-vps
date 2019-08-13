#!/bin/bash
#
# Dropbear & OpenSSH
# ========================
#

mine_port () {
local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local NOREPEAT
local reQ
local Port
while read port; do
reQ=$(echo ${port}|awk '{print $1}')
Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
[[ $(echo -e $NOREPEAT|grep -w "$Port") ]] && continue
NOREPEAT+="$Port\n"
case ${reQ} in
squid|squid3)
[[ -z $SQD ]] && local SQD="\033[1;31mSQUID: \033[1;32m"
SQD+="$Port ";;
apache|apache2)
[[ -z $APC ]] && local APC="\033[1;31mAPACHE: \033[1;32m"
APC+="$Port ";;
ssh|sshd)
[[ -z $SSH ]] && local SSH="\033[1;31mSSH: \033[1;32m"
SSH+="$Port ";;
dropbear)
[[ -z $DPB ]] && local DPB="\033[1;31mDROPBEAR: \033[1;32m"
DPB+="$Port ";;
openvpn)
[[ -z $OVPN ]] && local OVPN="\033[1;31mOPENVPN: \033[1;32m"
OVPN+="$Port ";;
stunnel4|stunnel)
[[ -z $SSL ]] && local SSL="\033[1;31mSSL: \033[1;32m"
SSL+="$Port ";;
python|python3)
[[ -z $PY3 ]] && local PY3="\033[1;31mSOCKS: \033[1;32m"
PY3+="$Port ";;
esac
done <<< "${portasVAR}"
[[ ! -z $SQD ]] && echo -e $SQD
[[ ! -z $APC ]] && echo -e $APC
[[ ! -z $SSH ]] && echo -e $SSH
[[ ! -z $DPB ]] && echo -e $DPB
[[ ! -z $OVPN ]] && echo -e $OVPN
[[ ! -z $PY3 ]] && echo -e $PY3
[[ ! -z $SSL ]] && echo -e $SSL
}

  badvpn=`netstat -tunlp | grep badvpn | grep tcp | awk '{print $1}'`

  if [ "$badvpn" = "tcp" ]
  then
    startbad="on"
  else
    startbad="off"
  fi

clear
echo -e "\e[1;33m(Users)\e[1;32m"
echo "     __    __      _  ___     _  _______  ______  _____   ______  ______  _____   "
echo "    /  \  /  \    | ||   \   | ||__   __||  ____||  _  \ |  ____||  ____||  _  \  "
echo "   / /\ \/ /\ \   | || |\ \  | |   | |   | |____ | |_| | | |____ | |____ | |_| |  "
echo "  / /  \__/  \ \  | || | \ \ | |   | |   |  ____||  _  / |  __  ||  ____||  _  /  "
echo " / /          \ \ | || |  \ \| |   | |   | |____ | | \ \ | |__| || |____ | | \ \  "
echo "/_/            \_\|_||_|   \___|   |_|   |______||_|  \_\|______||______||_|  \_\ "
echo -e "\e[1;33mV= 0.1"
echo
echo -e "\e[1;32mPuertos abiertos:"
echo
mine_port
echo -e "\e[1;31mBADVPN:\e[1;32m $startbad "
echo
echo -e "\e[1;32mEstan conectados:\e[1;31m";
echo
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo -e "\e[1;32m=============================================="
echo -e "\e[1;31mUsuarios \e[1;32m[Dropbear]";
echo -e "\e[1;31m[x]\e[1;32m";

for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
        IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
        if [ $NUM1 -eq 1 ]; then
                echo -e "\e[1;32m[PID]:\e[1;33m $PID \e[1;32m- [Usuario]:\e[1;33m $USER";
                echo -e "\e[1;32m[TOTAL en Dropbear]:\e[1;33m $NUM1";
        fi
done
echo "---";

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);



echo -e "\e[1;31mUsuarios \e[1;32m[OpenSSH]";
echo -e "\e[1;31m[x]\e[1;32m";
for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM2=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM2 -eq 1 ]; then
          echo -e "\e[1;32m[PID]:\e[1;33m $PID \e[1;32m- [Usuario]:\e[1;33m $USER";
          echo -e "\e[1;32m[TOTAL en Dropbear]:\e[1;33m $NUM2";
        fi
done


echo ""
echo "=============================================="
echo -e "\e[1;33m------\e[1;31mMinterger Script\e[1;33m------\e[1;32m";
echo "=============================================="
echo
echo -e "\033[1;33mOpciones:\033[1;30m
1) Eliminar usuario
2) Eliminar y desconectar usuario
3) Desconectar usuario\033[0m"
read -p ": " option
 if [ $option -eq 1 ]; then
 read -p "Cual es el nombre del usuario: " name
 if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
 echo "Usuario no existe"
 exit
 fi
 userdel --force $name > /dev/null 2>/dev/null
 echo "El usuario $name fue eliminado"
 exit
 fi

 if [ $option -eq 2 ]; then
 read -p "Cual es el nombre del usuario: " name
 if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
 echo "Usuario no existe"
 exit
 fi
 pids=$(ps -u $name |awk {'print $1'})
 kill "$pids" >/dev/null 2>/dev/null
 userdel $name 1>/dev/null 2>/dev/null
 echo "El usuario $name fue desconectado y eliminado"
 exit
 fi

 if [ $option -eq 3 ]; then
 read -p "Cual es el nombre del ususario: " name
 if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
 echo "Usuario no existe"
 exit
 fi
 pids=$(ps -u $name |awk {'print $1'})
 kill "$pids" >/dev/null 2>/dev/null
 echo "El usuario $name fue desconectado"
 exit
 fi
exit 2
