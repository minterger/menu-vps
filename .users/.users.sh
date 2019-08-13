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
 read foo
 fi
 userdel --force $name > /dev/null 2>/dev/null
 echo "El usuario $name fue eliminado"
 read foo
 fi

 if [ $option -eq 2 ]; then
 read -p "Cual es el nombre del usuario: " name
 if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
 echo "Usuario no existe"
 read foo
 fi
 pids=$(ps -u $name |awk {'print $1'})
 kill "$pids" >/dev/null 2>/dev/null
 userdel $name 1>/dev/null 2>/dev/null
 echo "El usuario $name fue desconectado y eliminado"
 read foo
 fi

 if [ $option -eq 3 ]; then
 read -p "Cual es el nombre del ususario: " name
 if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
 echo "Usuario no existe"
 read foo
 fi
 pids=$(ps -u $name |awk {'print $1'})
 kill "$pids" >/dev/null 2>/dev/null
 echo "El usuario $name fue desconectado"
 read foo
 fi
exit 1;;
esac
