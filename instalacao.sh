#!/bin/bash

	V='\033[01;31m'
	D='\033[01;32m'
	R='\033[0m'

echo -e "${D}Fazendo instalacao do VoxCast!${R}"
echo "Podera demorar varios minutos. Por favor, aguarde"

ptables -F

yum install iptables wget nano vixie-cron mailx sendmail nmap unzip -y

service iptables save

chkconfig iptables on

chkconfig crond on

ln -s /usr/bin/nano /usr/bin/pico

adduser streaming

chmod 777 /home/streaming

cd /home/streaming/
wget wget http://foxsolucoes.com/install/streaming.zip
unzip streaming.zip

mkdir -v configs logs playlists

rpm -Uvh rpmforge-release-0.5.2-2.el5.rf.i386.rpm
yum update -y

cd /home/streaming/
yum install vnstat pure-ftpd -y

chkconfig pure-ftpd on

rm -rfv /etc/pure-ftpd/pure-ftpd.conf /etc/pure-ftpd/pureftpd-mysql.conf
mv -v pure-ftpd.conf pureftpd-mysql.conf /etc/pure-ftpd/

service pure-ftpd restart

rm -rfv /etc/bashrc
mv -v bashrc /etc/bashrc
source /etc/bashrc

echo >> /root/.bash_profile
echo 'cd /home/streaming' >> /root/.bash_profile

mv monitor.txt /bin/monitor

chmod 777 /bin/monitor

rm -rf -v /var/spool/cron/root
mv -v cron.streaming.txt /var/spool/cron/root

service crond restart

vnstat -u -i eth0

vnstat -u -i venet0

vnstat -u --force

groupadd -g 2001 ftpgroup
useradd -u 2001 -s /bin/false -d /bin/null -c "pureftpd user" -g ftpgroup ftpuser

chkconfig --levels 235 pure-ftpd on
/etc/init.d/pure-ftpd start

modprobe ip_nat_ftp 

iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

passwd streaming

echo -e "${D}Instalado com sucesso!${R}"
echo -e "${D}Obrigado por instalar o VoxCast!${R}"

cd /etc/pure-ftpd
vi pureftpd-mysql.conf

