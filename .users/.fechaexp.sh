#!/bin/bash

database="$(cat /root/fechaexp.db | awk '{print $1}')"

while true ; do

	valid=$(date '+%C%y-%m-%d')
	tput setaf 7 ; tput setab 4 ; tput bold ; printf '%29s%s%-20s\n' "SSH Limiter"
	tput setaf 7 ; tput setab 4 ; printf '  %-30s%s\n' "Usuário" "Fecha Expiracion " ; echo "" ; tput sgr0
	while read usline
	do

		user="$(echo $usline | cut -d' ' -f1)"
		fecha="$(echo $usline | cut -d' ' -f2)"

		tput setaf 3 ; tput bold ; printf '  %-35s%s\n' $user $fecha; tput sgr0

		todate=$(date -d $valid +"%Y%m%d")
		todate1=$(date -d $fecha +"%Y%m%d")

		if [ $todate1 -ge $todate ] ;then
			userdel --force $name > /dev/null 2>/dev/null
			echo "usuario $name eliminado"
		fi

    echo ""
	done < "$database"

sleep 60

done
