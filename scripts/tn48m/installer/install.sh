#!/bin/sh
# SPDX-License-Identifier: MIT
#
# Copyright (c) 2021 Sartura Ltd.
#

set -e

cd $(dirname $0)

# Load configuration variables
. /etc/machine.conf
. replica.conf

echo "------------------------------------"
echo "        Replica OS installer"
echo " Architecture: $onie_arch"
echo " Machine:      $onie_machine"
echo
echo "------------------------------------"

echo "Partitioning disk..."
parted --script -a optimal $INSTALL_DISK \
	mklabel msdos \
	mkpart primary $INSTALL_FS 0% 100%

echo "Formatting disk..."
yes | mkfs.ext4 $INSTALL_PART

mkdir hdd-disk
mount -t ext4 $INSTALL_PART hdd-disk

echo "Extracting rootfs..."
tar -xpf $ROOTFS_ARCHIVE -C hdd-disk --numeric-owner

sync
umount hdd-disk

echo "Setting boot environment..."

fw_setenv -f replica_bootargs "root=$INSTALL_PART rw"
fw_setenv -f boot_replica "scsi scan; ext4load scsi 0:1 \${kernel_addr_r} $KERNEL; ext4load scsi 0:1 \${fdt_addr_r} $DTB; setenv bootargs \${replica_bootargs}; booti \${kernel_addr_r} - \${fdt_addr_r}"
fw_setenv -f nos_bootcmd 'run boot_replica'

sync

if [ -x /bin/onie-nos-mode ] ; then
    /bin/onie-nos-mode -s
fi

echo "Done, rebooting..."
