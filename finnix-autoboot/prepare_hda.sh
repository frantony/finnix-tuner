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
