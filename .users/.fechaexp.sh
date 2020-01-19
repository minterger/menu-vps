#!/bin/bash

database="/root/fechaexp.db"

while true
do

	valid=$(date '+%C%y-%m-%d')
  clear
	tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-18s\n' "REMOVEDOR DE EXPIRADOS"
	tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Fecha Expiracion " ; echo "" ; tput sgr0
	while read usline
	do

		user="$(echo $usline | cut -d' ' -f1)"
		fecha=$(cat /root/fechaexp.db | grep $user | awk '{print $2}')
		tput setaf 3 ; tput bold ; printf '  %-30s%s\n' $user $fecha; tput sgr0

		todate=$(date -d $valid +"%Y%m%d")
		todate1=$(date -d $fecha +"%Y%m%d")

		if [ $todate -ge $todate1 ] ;then
			userdel --force $user > /dev/null 2>/dev/null
      sed -i "/$user /d " /root/fechaexp.db
      sed -i "/$user /d " /root/usuarios.db
			echo "   -=Usuario $user eliminado=-"
		fi

    echo ""
	done < "$database"

sleep 1h

done
