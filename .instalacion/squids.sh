#!/bin/#!/usr/bin/env bash

squid_19 () {
#Instalador squid soporte a nuevos O.S

echo
echo "ESTE INSTALADOR CONFIGURA AUTOMATICAMNETE EL PUERTO SQUID EN LOS 2 UNICOS"
echo
echo "FUNCIONALES QUE ES EL 8080 Y EL 80 CON SOPORTE ALOS O.S"
echo
echo "DEBIAN 8,9               UBUNTU 14.04, 16.04, 18.04, 19.04"
sleep 2s
echo
echo "DETECTECTANDO SISTEMA OPERATIVO ESPERE......"
sleep 3s

echo

if cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 19.04"; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    cp squid.conf /etc/squid/squid.conf
echo -e "acl url1 dstdomain -i $ip" >> /etc/squid/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid

elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 18.04"; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    cp squid.conf /etc/squid/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid

elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 16.04"; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    cp squid.conf /etc/squid/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables-save
    service squid restart
    update-rc.d squid defaults

elif cat /etc/*release | grep DISTRIB_DESCRIPTION | grep "Ubuntu 14.04"; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    cp squid.conf /etc/squid3/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables-save
    service squid3 restart
    ln -s /etc/squid3 /etc/squid
    #update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid

elif cat /etc/os-release | grep PRETTY_NAME | grep "jessie"; then
    # OS = Debian 8 > /dev/null 2>&1
    /bin/rm -rf /etc/squid
    /usr/bin/apt update
    /usr/bin/apt -y install apache2-utils squid3
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    cp squid.conf /etc/squid3/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables-save
    service squid3 restart
    update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid

elif cat /etc/os-release | grep PRETTY_NAME | grep "stretch"; then
    # OS = Debian 9 > /dev/null 2>&1
    /bin/rm -rf /etc/squid
    /usr/bin/apt update
    /usr/bin/apt -y install apache2-utils squid
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    cp squid.conf /etc/squid/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
else
    echo "SISTEMA OPERATIVO NO SOPORTADO POR FAVOR PONGASE EN CONTACTO CON @minterger"
    exit 1;
fi
#/usr/bin/htpasswd -b -c /etc/squid/passwd USERNAME_HERE PASSWORD_HERE
}
