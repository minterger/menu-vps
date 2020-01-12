#!/bin/bash

users () {
  clear
  bash .users.sh
  echo
  echo -e "\e[1;32mPresiona enter para continuar..."
  read foo
}

userkill () {
  clear
  bash .killusers.sh
  echo
  echo -e "\e[1;32mPresiona enter para continuar..."
  read foo
}

userkill2 () {
  clear
  bash .menunuevo.sh
  echo -e "\e[1;32mPresiona enter para continuar..."
  read foo
}

crearuser () {
  clear
  if [ $(id -u) -eq 0 ]
  then
    ip=$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')
  	echo -e -n "\033[1;32mNombre del nuevo usuario:\033[0;37m"; read -p " " name
  	echo -e -n "\033[1;32mContraseña para el usuario $name:\033[0;37m"; read -p " " pass
  	echo -e -n "\033[1;32mCuantos dias el usuario $name debe durar:\033[0;37m"; read -p " " daysrnf
  	echo -e -n "\033[1;32mLimite de logins simultaneos:\033[0;37m"; read -p " " limiteuser
    echo -e -n "\033[1;32mEscribe un puerto de conexion:\033[0;37m"; read -p " " portd
  	echo -e "\033[0m"
  	if cat /etc/passwd |grep $name: |grep -vi [a-z]$name |grep -v [0-9]$name > /dev/null
  	then
  		echo -e "\033[1;31mUsuario $name ya existe\033[0m"
  	else
  		valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
  		datexp=$(date "+%d/%m/%Y" -d "+ $daysrnf days")
  		useradd -M $name -e $valid
  		( echo "$pass";echo "$pass" ) | passwd $name 2> /dev/null
      echo -e "\033[1;36mIP: \033[0m$ip"
  		limite $name $limiteuser
  		echo -e "\033[1;36mUsuario: \033[0m$name"
  		echo -e "\033[1;36mContraseña: \033[0m$pass"
  		echo -e "\033[1;36mExpira:\033[0m $datexp"
      if [ "$portd" = "" ]
      then
        echo -e "\033[1;36mPara generar datos para HTTP custom escriba un puerto\033[0m"
      else
        echo -e "\033[1;36mDatos HTTP custom:\033[0m $ip:$portd@$name:$pass "
      fi
        echo "$pass" > ~/.Menu/.users/passwd/$name
        echo "$name $limiteuser" >> /root/usuarios.db
      echo
      echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
      read foo
  	fi
  else
  	if echo $(id) |grep sudo > /dev/null
  	then
  	echo "Su usuario no esta en el grupo sudo"
  	echo -e "Para ejecutar root escriba: \033[1;31msudo su\033[0m"
  	echo -e "O ejecute menu como sudo. \033[1;31msudo menu\033[0m"
  	else
  	echo -e "Vc no esta como usuario root, ni con sus derechos (sudo)\nPara ejecutar root escribe \033[1;31msu\033[0m y escribe su contraseña root"
  	fi
  fi
}

redefiniruser () {
    echo -e -n "\e[1;32mNombre del usuario:\e[1;0m "
    read name
  if cat /etc/passwd |grep $name: > /dev/null
  then
   echo " "
  clear
  echo -e "\e[100m \033[1;33mOpciones a modificar ?\033[1;30m \e[0m
  \e[36m1) \e[96mNumero de Conexiones
  \e[36m2) \e[96mFecha de expiracion
  \e[36m3) \e[96mCambiar contraseña del usuario
  \e[36m0) \e[96mVolver\e[32m"
  read -p " opcion: " option
  if [ $option -eq 1 ]; then
    read -p "Cual es el nuevo limite de logins: " liml
    echo
    limite $name $liml
    echo

    LIMITE=$(cat /root/usuarios.db | grep "$name " | awk '{print $2}')
    USER=$(cat /root/usuarios.db | grep "$name " | awk '{print $1}')

    if [ "$USER" == "$name" ];then
      sed -i "s/$USER $LIMITE/$name $liml/" /root/usuarios.db
    else
      echo "$name $liml" >> /root/usuarios.db
    fi

    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
  fi

  if [ $option -eq 2 ]; then
    echo "Cual es la nueva fecha : formato AAAA/MM/DD"
    read -p ": " date
    chage -E $date $name 2> /dev/null
    echo -e "\033[1;31mEl usuario $name se desconectara el dia: $date\033[0m"
    echo
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
  fi
  if [ $option -eq 3 ]
  then
    read -p "Cual es la nueva contraseña para el usuario $name: " pass
    (echo "$pass" ; echo "$pass" ) |passwd $name > /dev/null 2>/dev/null
    echo "$pass" > ~/.Menu/.users/passwd/$name
    echo "Nueva contraseña aplicada: $pass"
    echo
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
  fi
  else
   clear
   echo -e "\e[1;32mEl usuario \e[1;31m$name \e[1;32mno existe\e[1;0m"
   echo
   echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
   read foo
  fi

  if [ $option -eq 0 ]
  then
    clear
  fi

}

killusers () {
  clear

  data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

  echo -e "Desconectando Usuarios"

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
          if [ $NUM1 -eq 1 ]; then
                  kill $PID;
          fi
  done

  data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM2=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
          if [ $NUM2 -eq 1 ]; then
            kill $PID;
          fi
  done
}

userdelete () {
  clear
  read -p "Cual es el nombre del usuario: " name
  if [ $(cat /etc/passwd |grep "^$name:" |wc -l) -eq 0 ]; then
    echo
    echo -e "\e[1;32mUsuario \e[1;31m$name \e[1;32mno existe\e[1;0m"
    echo
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
  else
    userdel --force $name > /dev/null 2>/dev/null
    echo
    echo -e "\e[1;32mEl usuario \e[1;31m$name \e[1;32mfue eliminado\e[1;0m"
    echo
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    rm ~/.Menu/.users/passwd/$name*
    sed -i "/$name /d " /root/usuarios.db
    read foo
  fi
}

userlist () {
  clear
  bash .listusers.sh
  echo
  echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
  read foo
}

monitorssh () {
  clear
  database="/root/usuarios.db"
  echo $$ > /tmp/kids
  while true
  do
  tput setaf 7 ; tput setab 1 ; tput bold ; printf '%29s%s%-20s\n' "SSH Monitor"
  tput setaf 7 ; tput setab 1 ; printf '  %-15s%-16s%s\n' "Usuário" "contraseña" "Conexión / Límite " ; echo "" ; tput sgr0
  	while read usline
  	do
  		user="$(echo $usline | cut -d' ' -f1)"
  		s2ssh="$(echo $usline | cut -d' ' -f2)"
  		if [ -z "$user" ] ; then
  			echo "" > /dev/null
  		else
        if [ -f ~/.Menu/.users/passwd/$user ]; then
          passwd=$(cat ~/.Menu/.users/passwd/$user)
        else
          passwd="null"
        fi

  			ps x | grep [[:space:]]$user[[:space:]] | grep -v grep | grep -v pts > /tmp/tmp7
  			s1ssh="$(cat /tmp/tmp7 | wc -l)"
  			tput setaf 3 ; tput bold ; printf '  %-14s%-22s%s\n' $user $passwd $s1ssh/$s2ssh; tput sgr0
  		fi
  	done < "$database"
  	echo ""
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
    break
  done
}

killmulti () {
  clear
  database="/root/usuarios.db"
  echo $$ > /tmp/pids
  if [ ! -f "$database" ]
  then
  	echo "Archivo /root/usuarios.db no encontrado"
  	exit 1
  fi
  while true
  do
  tput setaf 7 ; tput setab 4 ; tput bold ; printf '%29s%s%-20s\n' "SSH Limiter"
  tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Conexión / Límite " ; echo "" ; tput sgr0
  	while read usline
  	do
  		user="$(echo $usline | cut -d' ' -f1)"
  		s2ssh="$(echo $usline | cut -d' ' -f2)"
  		if [ -z "$user" ] ; then
  			echo "" > /dev/null
  		else
  			ps x | grep [[:space:]]$user[[:space:]] | grep -v grep | grep -v pts > /tmp/tmp2
  			s1ssh="$(cat /tmp/tmp2 | wc -l)"
  			tput setaf 3 ; tput bold ; printf '  %-35s%s\n' $user $s1ssh/$s2ssh; tput sgr0
  			if [ "$s1ssh" -gt "$s2ssh" ]; then
  				tput setaf 7 ; tput setab 1 ; tput bold ; echo " Usuário desconectado por ultrapassar el limite!" ; tput sgr0
  				while read line
  				do
  					tmp="$(echo $line | cut -d' ' -f1)"
  					kill $tmp
  				done < /tmp/tmp2
  				rm /tmp/tmp2
  			fi
  		fi
  	done < "$database"
    echo ""
    echo -e "\e[1;32m Para salir precione Ctrl + C\e[1;0m"
  	sleep 5
  	clear
  done
}

killmultidbr () {
  touch /tmp/users;
  database="/root/usuarios.db"
  echo $$ > /tmp/pids
  if [ ! -f "$database" ]
  then
  	echo "Archivo /root/usuarios.db no encontrado"
  	exit 1
  fi

  while true
  do
    rm /tmp/users
    data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
    for PID in "${data[@]}"
    do
            #echo "check $PID";
            NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
            USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
            IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
            if [ $NUM1 -eq 1 ]; then
                    echo "$PID $USER" >> /tmp/users;
            else
                    touch /tmp/users;
            fi
    done

  clear
  tput setaf 7 ; tput setab 4 ; tput bold ; printf '%29s%s%-20s\n' "Dropbear Limiter"
  tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Conexión / Límite " ; echo "" ; tput sgr0

    while read usline
  	do
  		user="$(echo $usline | cut -d' ' -f1)"
  		s2ssh="$(echo $usline | cut -d' ' -f2)"
  		if [ -z "$user" ] ; then
  			echo "" > /dev/null
  		else
        cat /tmp/users | grep "'$user'" | grep -v grep | grep -v pts > /tmp/tmp2
        s1ssh="$(cat /tmp/tmp2 | wc -l)"
  			tput setaf 3 ; tput bold ; printf '  %-35s%s\n' $user $s1ssh/$s2ssh; tput sgr0
  			if [ "$s1ssh" -gt "$s2ssh" ]; then
  				tput setaf 7 ; tput setab 1 ; tput bold ; echo " Usuário desconectado por ultrapassar el limite!" ; tput sgr0
  				while read line
  				do
  					tmp="$(echo $line | cut -d' ' -f1)"
  					kill $tmp
  				done < /tmp/tmp2
  				rm /tmp/tmp2
  			fi
  		fi
  	done < "$database"
    echo ""
    echo -e "\e[1;32m Para salir precione Ctrl + C\e[1;0m"
  	sleep 5
  done
}

monitordropbear () {
  database="/root/usuarios.db"
  echo $$ > /tmp/kids
  while true
  do

    data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
    for PID in "${data[@]}"
    do
            #echo "check $PID";
            NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
            USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
            IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
            if [ $NUM1 -eq 1 ]; then
                    echo "$PID $USER" >> /tmp/users;
            else
                    touch /tmp/users;
            fi
    done
    clear

  tput setaf 7 ; tput setab 1 ; tput bold ; printf '%29s%s%-20s\n' "Dropbear Monitor"
  tput setaf 7 ; tput setab 1 ; printf '  %-15s%-16s%s\n' "Usuário" "contraseña" "Conexión / Límite " ; echo "" ; tput sgr0
  	while read usline
  	do
  		user="$(echo $usline | cut -d' ' -f1)"
  		s2ssh="$(echo $usline | cut -d' ' -f2)"
  		if [ -z "$user" ] ; then
  			echo "" > /dev/null
  		else
        if [ -f ~/.Menu/.users/passwd/$user ]; then
          passwd=$(cat ~/.Menu/.users/passwd/$user)
        else
          passwd="null"
        fi

  			cat /tmp/users | grep "'$user'" | grep -v grep | grep -v pts > /tmp/tmp8
  			s1ssh="$(cat /tmp/tmp8 | wc -l)"
  			tput setaf 3 ; tput bold ; printf '  %-14s%-22s%s\n' $user $passwd $s1ssh/$s2ssh; tput sgr0
  		fi
  	done < "$database"
  	echo ""
    rm /tmp/users
    echo -e "\e[1;32mPresiona enter para continuar...\e[1;0m"
    read foo
    break
    done
}

autokill () {
  clear
  echo -e "Autokill: \e[1;31m"
  bash .autokill.sh
}

while :
do
cd ..
bash .head.sh
cd .users
echo -e "\e[1;32mEscoja una opcion "
echo
#echo -e "\e[1;31m[1]\e[1;32m Usuarios conectados"
echo -e "\e[1;31m[1]\e[1;32m Crear usuario"
echo -e "\e[1;31m[2]\e[1;32m Redefinir usuario"
echo -e "\e[1;31m[3]\e[1;32m Eliminar usuario"
echo -e "\e[1;31m[4]\e[1;32m Monitor SSH"
echo -e "\e[1;31m[5]\e[1;32m Monitor Dropbear"
#echo -e "\e[1;31m[6]\e[1;32m Lista de usuarios"
echo -e "\e[1;31m[6]\e[1;32m Desconectar usarios de mas en SSH"
echo -e "\e[1;31m[7]\e[1;32m Desconectar usarios de mas en Dropbear"
echo -e "\e[1;31m[8]\e[1;32m Menu autodesconectar users"
echo -e "\e[1;31m[9]\e[1;32m Desconectar todos los usuarios"
echo -e "\e[1;31m[0]\e[1;32m Salir"
echo
echo -n "Seleccione una opcion [1 - 9]: "
read opcion
case $opcion in
#1)
#users;;
1)
crearuser;;
2)
redefiniruser;;
3)
userdelete;;
4)
monitorssh;;
5)
monitordropbear;;
#6)
#userlist;;
6)
killmulti;;
7)
killmultidbr;;
8)
autokill;;
9)
killusers;;

69)
userkill;;
70)
userkill2;;

0) clear;
exit 1;;
*) clear;
echo -e "\e[1;31mEs una opcion invalida:";
echo -e "\e[1;32mPresiona enter para continuar...";
read foo;;
esac
done
