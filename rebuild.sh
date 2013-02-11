#!/bin/sh -e

FINNIX_PROFILE=$1

if [ ! -e "$FINNIX_PROFILE/config" ]; then
	echo "no file $FINNIX_PROFILE/config"
	exit 1
fi

export TOPDIR=$(pwd)

. $FINNIX_PROFILE/config

set -x

dd if=/dev/zero of=$DISK_SDA bs=1M count=$DISK_SDA_SIZE
mke2fs -F $DISK_SDA

MNT_DIR=$TOPDIR/mnt
mkdir -p $MNT_DIR
mount $DISK_SDA $MNT_DIR -o loop,sync

$FINNIX_PROFILE/prepare_hda.sh $TOPDIR/$FINNIX_PROFILE $MNT_DIR

ls $MNT_DIR
lsof $MNT_DIR || true

umount $MNT_DIR

$KVM -smp 2 -m 512 -cdrom $FINNIX_ISO -hda $DISK_SDA $KVM_OUTPUT

if [ "$SET_TIMESTAMP" = "yes" ]; then
	DATE=-$(date +%Y%m%d%H%M%S)
else
	DATE=""
fi

mount $DISK_SDA $MNT_DIR -o loop
cp $MNT_DIR/finnix.iso finnix$SUFFIX$DATE.iso
cp $MNT_DIR/finnix-etc.tar.gz finnix-etc$SUFFIX$DATE.tar.gz
umount $MNT_DIR
