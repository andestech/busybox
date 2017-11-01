#!/bin/bash

make nds32_defconfig

if [ "$1" == "-EB" ]; then
	echo "Building big endian busybox."
	perl -i -npe "m/EXTRA_CFLAGS_OPTIONS/ && ( s/-EL/-EB/ || s/=\"/=\"-EB/)" .config
	CROSS_COMPILE=nds32be-linux-
elif [ "$1" == "-EL" ]; then
	echo "Building little endian busybox."
	perl -i -npe "m/EXTRA_CFLAGS_OPTIONS/ && ( s/-EB/-EL/ || s/=\"/=\"-EL/)" .config
	CROSS_COMPILE=nds32le-linux-
else
	echo "Please specify either -EB or -EL. Stop building."
	exit
fi

which ${CROSS_COMPILE}gcc

if [ $? == 0 ]; then
	perl -i -npe "s/CROSS_COMPILER_PREFIX=.*/CROSS_COMPILER_PREFIX=\""${CROSS_COMPILE}"\"/" .config
else
	perl -i -npe "s/CROSS_COMPILER_PREFIX=.*/CROSS_COMPILER_PREFIX=\"nds32-elf-\"/" .config
fi

if [ "$2" == "-install" ]; then
	rm -f $3/bin/* 2>&1 | tee -a busybox1_build.log
	rm -f $3/sbin/* 2>&1 | tee -a busybox1_build.log
	rm -f $3/usr/bin/* 2>&1 | tee -a busybox1_build.log
	rm -f $3/usr/sbin/* 2>&1 | tee -a busybox1_build.log
	make CONFIG_PREFIX=$3 install 2>&1 | tee -a busybox1_build.log
	exit
fi

make clean 2>&1 | tee -a busybox1_build.log
make 2>&1 | tee -a busybox1_build.log
