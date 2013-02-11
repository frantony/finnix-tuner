#!/bin/bash

set -x
set -e

DISK=/dev/sda

BUILD_DIR=/srv/finnix/build

# 1. Boot the Finnix CD.

# Already done!

# 2. Mount a disk to work within. For this guide, the mount point $BUILD_DIR is assumed. If you do not use $BUILD_DIR, you will need to edit the build scripts later in this guide.

mkdir -p $BUILD_DIR
#mke2fs -F $DISK
mount $DISK $BUILD_DIR

# 3. Create the necessary filesystem layout for this guide.
mkdir -p $BUILD_DIR/master
mkdir -p $BUILD_DIR/source/FINNIX
#cp $BUILD_DIR/finnix-tune-packages.sh $BUILD_DIR/source/FINNIX/finnix-tune-packages.sh
#chmod +x $BUILD_DIR/source/FINNIX/finnix-tune-packages.sh

# 4. Copy the contents of /cdrom to $BUILD_DIR/master.
cp -a /cdrom/* $BUILD_DIR/master/

# 5. Copy the contents of /FINNIX (which is a mounted squashfs filesystem) to $BUILD_DIR/source/FINNIX. Remember that POSIX filesystems are case sensitive, so /FINNIX and /finnix are two separate directories.
cp -a /FINNIX/* $BUILD_DIR/source/FINNIX/

# 6. (Optional) If you plan on upgrading the kernel, you must extract the initrd.

# Skipped!

mount -o rbind $BUILD_DIR/aux $BUILD_DIR/source/FINNIX/media

# 7. Chroot into the extracted Finnix filesystem. Setting FINNIXDEV=1 allows for some chroot-specific features to make, for example, dist-upgrading easier. In most cases, you do not need to mount /proc and /sys manually; the Finnix dev enironment should do it for you in many cases (during apt-get operations, for example).

echo "Jumping to chroot"
export FINNIXDEV=1
chroot $BUILD_DIR/source/FINNIX /bin/bash -l /media/finnix-tune-packages.sh

umount $BUILD_DIR/source/FINNIX/media

# 8. Now that you are chrooted, you can make your desired modifications. What you do now is up to you. For ideas, please see Modification Ideas below.

if [ -e $BUILD_DIR/aux/isolinux.cfg ]; then
	cp $BUILD_DIR/aux/isolinux.cfg $BUILD_DIR/master/syslinux.cfg
	cp $BUILD_DIR/aux/isolinux.cfg $BUILD_DIR/master/isolinux.cfg
fi

$BUILD_DIR/source/FINNIX/usr/sbin/finnix-build-stage1 && $BUILD_DIR/source/FINNIX/usr/sbin/finnix-build-stage2

ls -l $BUILD_DIR/finnix.iso
tar czf $BUILD_DIR/finnix-etc.tar.gz /etc

# shutdown initscripts will unmount all filesystems
#umount $BUILD_DIR
#mount $DISK -o ro,remount
#umount $DISK

halt
