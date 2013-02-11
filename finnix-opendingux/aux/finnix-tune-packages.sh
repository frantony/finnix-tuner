#!/bin/bash

# exit on any error
set -e

#echo "deb http://ftp.us.debian.org/debian testing main non-free contrib" > /etc/apt/sources.list
echo "deb http://ftp.ru.debian.org/debian testing main non-free contrib" > /etc/apt/sources.list
apt-get update
apt-get --assume-yes dist-upgrade

apt-get --assume-yes install dhcpdump isc-dhcp-server vsftpd
apt-get --assume-yes install vim ctags patch recode enca diffutils hexer
apt-get --assume-yes install git subversion
apt-get --assume-yes install gcc libc6-dev
apt-get --assume-yes install qemu
apt-get --assume-yes install make m4

apt-get --assume-yes autoremove

mkdir -p /opt
( cd /opt; tar vfx /media/opendingux-toolchain.2012-06-16.tar.bz2 )
( cd /opt; tar vfx /media/opendingux-gcw0-toolchain.2013-02-05.tar.bz2 )

cat > /etc/rc.local <<EOF;
#!/bin/sh

#set -x

FINNIXRC_LOCAL=finnixrc.local

for i in /media/*; do
	if [ -d \$i ]; then
		mount \$i
		if [ -x \$i/\$FINNIXRC_LOCAL ]; then
			echo "starting \$i/\$FINNIXRC_LOCAL"
			( cd \$i; ./\$FINNIXRC_LOCAL )

			exit 0
		fi
		umount \$i
	fi
done
exit 0
EOF
