#!/bin/bash

mkdir -p /usr/local/ntripcaster/conf/ 

localIp=$(hostname -I)
localIp=`echo $localIp`
echo "Use local ip ${localIp}"

echo -n "User: "
read -er -i gps baseUser 

echo -n "Password: "
read -er -i gps basepassword

echo -n "Mountpoint: "
read -er -i ROVER basemountpoint

echo -n "Port: "
read -er -i 2108 baseport

echo "Stop services:"
echo -n "- ntripcaster."
systemctl stop ntripcaster.service
echo " done."
echo -n "- logrotate-ntripcaster"
systemctl stop logrotate-ntripcaster.timer
echo " done."
echo -n "- ntripserver"
systemctl stop ntripserver.service
echo " done."

echo "Install ntripcaster config file"
cp ntripcaster.conf /usr/local/ntripcaster/

cp ntripcaster.logrotate /usr/local/ntripcaster/
if [[ -f "sourcetable.dat.dist" ]]; then
  echo "Install sourcetable"
  cp sourcetable.dat.dist /usr/local/ntripcaster/conf/sourcetable.dat
  sed -i "s/BASEMOUNTPOINT/${basemountpoint}/g" /usr/local/ntripcaster/conf/sourcetable.dat
  sed -i "s/BASEUSER/${baseUser}/g" /usr/local/ntripcaster/conf/sourcetable.dat
  sed -i "s/BASEPASSWORD/${basepassword}/g" /usr/local/ntripcaster/conf/sourcetable.dat
  sed -i "s/BASELOCALIP/${localIp}/g" /usr/local/ntripcaster/conf/sourcetable.dat
  sed -i "s/BASEPORT/${baseport}/g" /usr/local/ntripcaster/conf/sourcetable.dat
fi

echo "Install services"
cp *.service *.timer /etc/systemd/system

sed -i "s/BASEMOUNTPOINT/${basemountpoint}/g" /etc/systemd/system/ntripserver.service /etc/systemd/system/ntripcaster.service /usr/local/ntripcaster/ntripcaster.conf
sed -i "s/BASEUSER/${baseUser}/g" /etc/systemd/system/ntripserver.service /etc/systemd/system/ntripcaster.service /usr/local/ntripcaster/ntripcaster.conf
sed -i "s/BASEPASSWORD/${basepassword}/g" /etc/systemd/system/ntripserver.service /etc/systemd/system/ntripcaster.service /usr/local/ntripcaster/ntripcaster.conf
sed -i "s/BASELOCALIP/${localIp}/g" /etc/systemd/system/ntripserver.service /etc/systemd/system/ntripcaster.service /usr/local/ntripcaster/ntripcaster.conf
sed -i "s/BASEPORT/${baseport}/g" /etc/systemd/system/ntripserver.service /etc/systemd/system/ntripcaster.service /usr/local/ntripcaster/ntripcaster.conf

echo "Reload services daemon"
systemctl daemon-reload

echo "Enable services:"

echo -n "- ntripcaster"
#systemctl enable ntripcaster.service
echo " done."
echo -n "- logrotate-ntripcaster"
systemctl enable logrotate-ntripcaster.timer
echo " done."
echo -n "- ntripserver"
#systemctl enable ntripserver.service
echo " done."

echo "Start services:"
echo -n "- ntripcaster."
systemctl start ntripcaster.service
echo " done."
echo -n "- logrotate-ntripcaster"
systemctl start logrotate-ntripcaster.timer
echo " done."
echo -n "- ntripserver"
systemctl start ntripserver.service
echo " done."

#systemctl enable ntripserver-remoteCaster.service
#systemctl try-restart str2str.service
#systemctl try-restart str2str-M8T.service
#systemctl try-restart str2str-injectrtcm1008.service
#systemctl try-restart str2str-remoteCaster.service

