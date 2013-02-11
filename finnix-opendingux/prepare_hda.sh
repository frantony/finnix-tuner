#!/bin/sh

set -e

FINNIX_PROFILE=$1
MNT_DIR=$2

if [ ! -d $FINNIX_PROFILE ]; then
	echo "no $FINNIX_PROFILE directory"
	exit 1
fi

if [ ! -d $MNT_DIR ]; then
	echo "no $MNT_DIR directory"
	exit 1
fi

rm -rf $MNT_DIR/aux
mkdir -p $MNT_DIR/aux
cp -a $FINNIX_PROFILE/aux $MNT_DIR/

if [ ! -d $FINNIX_PROFILE/opt ]; then
	mkdir -p $FINNIX_PROFILE/opt
fi

OD_TOOLCHAIN=opendingux-gcw0-toolchain.2013-02-05.tar.bz2
OD_TOOLCHAIN_FILE=$FINNIX_PROFILE/opt/$OD_TOOLCHAIN
if [ ! -e $OD_TOOLCHAIN_FILE ]; then
	curl http://www.gcw-zero.com/files/$OD_TOOLCHAIN > $OD_TOOLCHAIN_FILE
fi
cp $OD_TOOLCHAIN_FILE $MNT_DIR/aux/

OD_TOOLCHAIN=opendingux-toolchain.2012-06-16.tar.bz2
OD_TOOLCHAIN_FILE=$FINNIX_PROFILE/opt/$OD_TOOLCHAIN
if [ ! -e $OD_TOOLCHAIN_FILE ]; then
	curl http://www.treewalker.org/opendingux/$OD_TOOLCHAIN > $OD_TOOLCHAIN_FILE
fi
cp $OD_TOOLCHAIN_FILE $MNT_DIR/aux/

cat > $MNT_DIR/finnixrc.local <<EOF;
#!/bin/sh -e

/media/sda/aux/rebuild-finnix.sh

exit 0
EOF
chmod +x $MNT_DIR/finnixrc.local
