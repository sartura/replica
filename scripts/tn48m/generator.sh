#!/bin/sh
# SPDX-License-Identifier: MIT
#
# Copyright (c) 2021 Sartura Ltd.
#

set -e

WORKDIR=$1
INSTALLDIR="$WORKDIR/installer"

input_file=$2
sharch_body=$3
installer=$4
onie_config=$5
output_file=$6

echo -n "Creating $output_file: ."

mkdir -p $INSTALLDIR

cp $input_file $INSTALLDIR
cp $installer $INSTALLDIR
cp $onie_config $INSTALLDIR/replica.conf

# Repackage $INSTALLDIR into a self-extracting installer image
sharch="$WORKDIR/sharch.tar"
tar -C $WORKDIR -cf $sharch installer || {
    echo "Error: Problems creating $sharch archive"
    exit 1
}

[ -f "$sharch" ] || {
    echo "Error: $sharch not found"
    exit 1
}
echo -n "."

sha1=$(cat $sharch | sha1sum | awk '{print $1}')
echo -n "."

cp $sharch_body $output_file || {
    echo "Error: Problems copying sharch_body.sh"
    exit 1
}

# Replace variables in the sharch template
sed -i -e "s/%%IMAGE_SHA1%%/$sha1/" $output_file
echo -n "."
cat $sharch >> $output_file
rm -rf $tmp_dir
echo " Done."
