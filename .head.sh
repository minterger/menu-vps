#!/bin/bash

# contador de usuarios beta
countusers () {
  data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
  NUM2="0"
  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
          if [ $NUM1 -eq 1 ]; then
                  NUM2=$(($NUM2 + 1))
          fi
  done
  echo -e "\e[1;31mCONECTADOS:\e[1;32m [$NUM2] "
}

# ver puertos abiertos
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

# ver is badvpn esta activo
badvpn () {
  badvpn=`netstat -tunlp | grep badvpn | grep tcp | awk '{print $1}'`

  if [ "$badvpn" = "tcp" ]
  then
    startbad="on"
  else
    startbad="off"
  fi

  echo -e "\e[1;31mBADVPN:\e[1;32m $startbad "
}

clear
echo -e "\e[1;33m(Main)\e[1;32m"
echo " ___    ___  _  ___     _  _______  ______  _____    ______  ______  _____  "
echo "|   \  /   || ||   \   | ||__   __||  ____||  _  \  |  ____||  ____||  _  \ "
echo "| |\ \/ /| || || |\ \  | |   | |   | |____ | |_|  } | |____ | |____ | |_|  } "
echo "| | \__/ | || || | \ \ | |   | |   |  ____||  _  /  |  __  ||  ____||  _  / "
echo "| |      | || || |  \ \| |   | |   | |____ | | \ \  | |__| || |____ | | \ \ "
echo "|_|      |_||_||_|   \___|   |_|   |______||_|  \_\ |______||______||_|  \_\ "
echo -e "\e[1;33mV= 0.1.27 ©"
echo -e "\e[1;37m-----------------------------------------------------\e[1;0m"
echo -e "\e[1;32mPuertos abiertos:"
echo -e "\e[1;37m-----------------------------------------------------\e[1;0m"
mine_port
badvpn
echo -e "\e[1;37m-----------------------------------------------------\e[1;0m"
