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

<<<<<<< HEAD
		if [ $todate -ge $todate1 ] ;then
=======
		if [ $todate1 -ge $todate ] ;then
>>>>>>> 7d7ad493f94d23fd98f6c525b428cbb272536ac2
			userdel --force $name > /dev/null 2>/dev/null
			echo "usuario $name eliminado"
		fi

    echo ""
	done < "$database"

sleep 60

done
