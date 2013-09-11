#! /bin/sh
# mksdcard.sh for odroid u2 
# heavily based on
# mkCubieCard.sh v0.1:
# 2013, Carlo Caione <carlo.caione@gmail.com>
# heavely based on :
# mkA10card.sh v0.1
# 2012, Jason Plum <jplum@archlinuxarm.org>
# loosely based on :
# mkcard.sh v0.5
# (c) Copyright 2009 Graeme Gregory <dp@xora.org.uk>
# Licensed under terms of GPLv2
#
# Parts of the procudure base on the work of Denys Dmytriyenko
# http://wiki.omap.com/index.php/MMC_Boot_Format

IMAGES_DIR=$1
UBOOT_IMG=$IMAGES_DIR/u-boot.bin
UIMAGE=$IMAGES_DIR/zImage
ROOTFS=$IMAGES_DIR/rootfs.tar
SDFUSE=$IMAGES_DIR/sd_fuse
BOOT_CMD_H=$IMAGES_DIR/boot.scr
TMP_DIR=$(mktemp -d -p ${IMAGES_DIR})

export LC_ALL=C

if [ $# -ne 2 ]; then
	echo "Usage: $0 <images_dir> <drive>"
	exit 1;
fi

if [ $EUID -ne 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

if [ ! -f $UBOOT_IMG ] ||
   [ ! -f $UIMAGE ] ||
   [ ! -f $ROOTFS ] ||
   [ ! -d $SDFUSE ] ||
   [ ! -f $BOOT_CMD_H ]; then
	echo "File(s) missing."
	exit 1
fi

DRIVE=$2
P1=`mktemp -d`
P2=`mktemp -d`

dd if=/dev/zero of=$DRIVE bs=1M count=3

parted $DRIVE --script -- mklabel msdos
# Fusing uses the first 4095 sectors.
parted $DRIVE --script -- mkpart primary fat32 4096s 266239s
parted $DRIVE --script -- mkpart primary ext4 266240s 100%

partprobe $DRIVE

pushd . 
cd $SDFUSE
./sd_fusing.sh $DRIVE
popd

if [ -b ${DRIVE}1 ]; then
	D1=${DRIVE}1
	umount ${DRIVE}1
	mkfs.vfat -n "boot" ${DRIVE}1
else
	if [ -b ${DRIVE}p1 ]; then
		D1=${DRIVE}p1
		umount ${DRIVE}p1
		mkfs.vfat -n "boot" ${DRIVE}p1
	else
		echo "Cant find boot partition in /dev"
		exit 1
	fi
fi

if [ -b ${DRIVE}2 ]; then
	D2=${DRIVE}2
	umount ${DRIVE}2
	mkfs.ext4 -L "rfs" ${DRIVE}2
else
	if [ -b ${DRIVE}p2 ]; then
		D2=${DRIVE}p2
		umount ${DRIVE}p2
		mkfs.ext4 -L "rfs" ${DRIVE}p2
	else
		echo "Cant find rootfs partition in /dev"
		exit 1
	fi
fi

mount $D1 $P1
mount $D2 $P2

# write uImage
cp $UIMAGE $P1
# write u-boot script
cp $BOOT_CMD_H $P1
# write rootfs
tar -C $TMP_DIR -xvf $ROOTFS

rsync --progress -rap --delete $TMP_DIR/ $P2/

rm -rf $TMP_DIR

sync

umount $D1
umount $D2

rm -fr $P1
rm -fr $P2

