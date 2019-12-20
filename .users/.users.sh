#!/bin/bash
#
# Dropbear & OpenSSH
# ========================
#
cd ..
bash .head.sh
cd .users
echo -e "\e[1;32mEstan conectados:\e[1;31m";
echo
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
DBR="0"
SSH="0"
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
                DBR=$(($DBR + 1))
        fi
done

echo
echo -e "\e[1;31mConectados DROPBEAR:\e[1;32m [$DBR] "
echo

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
          SSH=$(($SSH + 1))
        fi
done

echo
echo -e "\e[1;31mConectados SSH:\e[1;32m [$SSH] "
echo

echo ""
echo "=============================================="
echo -e "\e[1;33m------\e[1;31mMinterger Script\e[1;33m------\e[1;32m";
echo "=============================================="
echo
echo -e -n "Quiere desconectar un usuario S (si) o N (no): "
read opcion
case $opcion in
  S|s)
  bash .killusers.sh;;
  N|n)
  exit 1;;
  *)
  echo ;
  echo -e "\e[1;31mEs una opcion invalida:";
  exit 1;;
esac
