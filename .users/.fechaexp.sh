#!/bin/bash

database="/root/fechaexp.db"

while true
do

	valid=$(date '+%C%y-%m-%d')
  clear
	tput setaf 7 ; tput setab 4 ; tput bold ; printf '%29s%s%-20s\n' "SSH Limiter"
	tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Fecha Expiracion " ; echo "" ; tput sgr0
	while read usline
	do

		user="$(echo $usline | cut -d' ' -f1)"
		fecha="$(echo $usline | cut -d' ' -f2)"
    fecha1=$(date -d $fecha +"%Y-%m-%d")
		tput setaf 3 ; tput bold ; printf '  %-35s%s\n' $user $fecha1; tput sgr0

		todate=$(date -d $valid +"%Y%m%d")
		todate1=$(date -d $fecha1 +"%Y%m%d")

		if [ $todate -ge $todate1 ] ;then
			userdel --force $name > /dev/null 2>/dev/null
			echo "usuario $name eliminado"
		fi

    echo ""
	done < "$database"

sleep 60

done
