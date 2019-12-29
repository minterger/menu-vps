#!/bin/bash
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

killmultidbr
