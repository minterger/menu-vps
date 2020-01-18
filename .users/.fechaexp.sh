#!/bin/bash

database="/root/fechaexp.db"

while true
do

	valid=$(date '+%C%y-%m-%d')
  clear
	tput setaf 7 ; tput setab 4 ; tput bold ; printf '%29s%s%-26s\n' "REMOVEDOR DE EXPIRADOS"
	tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Fecha Expiracion " ; echo "" ; tput sgr0
	while read usline
	do

		user="$(echo $usline | cut -d' ' -f1)"
		fecha="$(echo $usline | cut -d' ' -f2)"
    fecha1=$(date -d $fecha +"%Y-%m-%d")
		tput setaf 3 ; tput bold ; printf '  %-30s%s\n' $user $fecha1; tput sgr0

		todate=$(date -d $valid +"%Y%m%d")
		todate1=$(date -d $fecha1 +"%Y%m%d")

		if [ $todate -ge $todate1 ] ;then
			userdel --force $user > /dev/null 2>/dev/null
      sed -i "/$name /d " /root/fechaexp.db
			echo "   -=Usuario $user eliminado=-"
		fi

    echo ""
	done < "$database"

sleep 60

done
