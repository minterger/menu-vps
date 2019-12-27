#!/bin/bash
##########################################################
##      Autor: Emanuel Malfatti
##      Contacto: ejmalfatti@outlook.com
##                https://www.twitter.com/sflibre
##      Licencia: GPL v2
##########################################################

cd ..
bash .head.sh
cd .herramientas

# Declaracion de Variables
NUM=$(cat /etc/passwd | cut -d: -f3) # > tmp/user
MIN="999"
MAX="2000"

echo -e "\e[1;32m..::Los usuarios en el sistema son::.."
echo
for ID in do $NUM; do
    if [ $ID -gt $MIN > /dev/null 2>&1 ] && [ $ID -lt $MAX > /dev/null 2>&1 ] ; then
                USER=$(cat /etc/passwd | cut -d: -f1-3 | grep $ID | cut -d: -f1)

                if [ -f ~/.Menu/.users/passwd/$USER ]; then
                  PASSWD=$(cat ~/.Menu/.users/passwd/$USER)
                else
                  PASSWD="null"
                fi

                if [ -f /root/usuarios.db ]; then
                  LIMITE=$(cat /root/usuarios.db | grep "$user " | awk '{print $2}')
                  if [ $LIMITE = "" ];then
                    LIMITE="null"
                  fi
                else
                  LIMITE="null"
                fi

                echo -e "\e[1;31m>\e[1;30mUsuario: $USER    contraseña: $PASSWD   limite_ssh: $LIMITE"
        fi
done
