#!/bin/bash

database="/root/usuarios.db"

echo $$ > /tmp/pids

touch /tmp/usersdbr;
basedbr () {
  data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
  for PID in "${data[@]}"
  do
          #echo "check $PID";
          NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
          USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
          IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
          if [ $NUM1 -eq 1 ]; then
                  echo "$PID $USER" >> /tmp/usersdbr;
          else
                  touch /tmp/usersdbr;
          fi
  done
}

basedbr

clear
echo -ne "Que usuario quieres desconectar?: "
read user

echo -ne "Cuantas veces quieres desconectarlo?: "
read f

datos="$(cat $database | grep $user | awk '{print $1}')"

touch /tmp/usr5
touch /tmp/usr6

if [ "$user" == "$datos" ]; then
  r=0
  w=0
  c=1
  while [ $c -le $f ]
  do
    cat /tmp/usersdbr | grep "'$user'" | grep -v grep | grep -v pts > /tmp/usr6
    ps x | grep [[:space:]]$user[[:space:]] | grep -v grep | grep -v pts > /tmp/usr5

    dbr="$(cat /tmp/usersdbr | grep "'$user'" | grep -v grep | grep -v pts | awk '{print $2}')"
    ssh="$(ps x | grep [[:space:]]$user[[:space:]] | grep -v grep | grep -v pts | awk '{print $6}')"

    if [ "$user" == "$dbr" ]; then
      while read line
      do
        tmp="$(echo $line | cut -d' ' -f1)"
        kill $tmp
      done < /tmp/usr6
      (( r++ ))
      echo
      echo "usuario $user desconectado de Dropbear $r de $f"
    else
      echo
      echo "usuario $user no conectado en Dropbear"
    fi

    if [ "$user" == "$ssh" ]; then
      while read line
      do
        tmp="$(echo $line | cut -d' ' -f1)"
        kill $tmp
      done < /tmp/usr5
      (( w++ ))
      echo
      echo "usuario $user desconectado de SSH $w de $f"
      echo
    else
      echo
      echo "usuario $user no conectado en SSH"
      echo
    fi

    sleep 3s
    basedbr
  	(( c++ ))
  done


else
  echo
  echo "usuario $user no existe en la base de datos"
  echo
fi

rm /tmp/usersdbr
rm /tmp/usr6
rm /tmp/usr5
