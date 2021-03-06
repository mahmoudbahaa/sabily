#!/bin/bash

# To run this script you should call it with two parameters:
# ISO_IMAGE -> full path to the ubuntu iso file
# ISO_NAME -> name of the final ISO file
#
# For example:
# sudo ./1.clean.sh "fullPathToISO" "sabily-vX.XX-desktop-i386.iso"

REMASTER_HOME=`pwd`
ISO_IMAGE=$1
ISO_NAME=$2
CUSTOMIZE_DIR="$REMASTER_HOME/customization-scripts"

##################
# some functions #
##################

function check_exit_code()
{
	RESULT=$?
	if [ "$RESULT" -ne 0 ]; then
		exit "$RESULT"
	fi
}

function check_if_user_is_root()
{
	if [ `id -un` != "root" ]; then
		echo "You need root privileges"
		exit 2
	fi
}

########
# main #
########

check_if_user_is_root

if [ -e libraries/remaster-live-cd.sh ]; then
	SCRIPTS_DIR=`dirname "$0"`
else
	SCRIPTS_DIR=/usr/bin
fi

echo "Starting CD remastering on " `date`
echo "Customization dir=$CUSTOMIZE_DIR"

CUSTOMIZE_ROOTFS="no"
CUSTOMIZE_INITRD="no"
CUSTOMIZE_ISO="no"
REMOVE_WIN32_FILES=`cat "$CUSTOMIZE_DIR/remove_win32_files"`
CLEAN_DESKTOP_MANIFEST="no"

if [ -e "$CUSTOMIZE_DIR/customize" ]; then
	CUSTOMIZE_ROOTFS="yes"
fi

if [ -e "$CUSTOMIZE_DIR/customize_initrd" ]; then
	CUSTOMIZE_INITRD="yes"
fi

if [ -e "$CUSTOMIZE_DIR/customize_iso" ]; then
	CUSTOMIZE_ISO="yes"
fi

if [ -e "$CUSTOMIZE_DIR/clean_desktop_manifest" ]; then
	CLEAN_DESKTOP_MANIFEST="yes"
fi

#$SCRIPTS_DIR/uck-remaster-clean "$REMASTER_HOME"
#check_exit_code

#############
# unpacking #
#############

if [ "$CUSTOMIZE_ISO" = "yes" ] ; then
	echo unpack iso
	$SCRIPTS_DIR/uck-remaster-unpack-iso "$ISO_IMAGE" "$REMASTER_HOME"
	check_exit_code
fi

if [ "$CUSTOMIZE_INITRD" = "yes" ] ; then
	echo unpack initrd
	$SCRIPTS_DIR/uck-remaster-unpack-initrd "$REMASTER_HOME"
	check_exit_code
fi

if [ "$CUSTOMIZE_ISO" = "yes" ] && [ "$CUSTOMIZE_ROOTFS" = "yes" ] ; then
	echo unpack rootfs
	$SCRIPTS_DIR/uck-remaster-unpack-rootfs "$REMASTER_HOME"
	check_exit_code
fi


exit 0
