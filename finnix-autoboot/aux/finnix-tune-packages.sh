#!/bin/bash

# exit on any error
set -e

#echo "deb http://ftp.us.debian.org/debian testing main non-free contrib" > /etc/apt/sources.list
echo "deb http://ftp.ru.debian.org/debian testing main non-free contrib" > /etc/apt/sources.list
apt-get update
apt-get --assume-yes dist-upgrade
apt-get --assume-yes autoremove

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
