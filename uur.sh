#!/bin/bash

base_dir=$(dirname $(realpath $0))

if [ $# -ne 1 ]; then
	echo "Please specifiy urr file, e.q.: $0 gradio.uur"
	exit 0
fi

uur="$1"
if [ ! -f "$uur" ]; then
	# switch to directort with this script
	uur="${base_dir}/repo/${uur}.uur"
	if [ ! -f "$uur" ]; then
		echo "UUR file $uur not found! Please choose different one!"
		exit 0
	fi
fi
uurname="$(basename $uurname)"
uurname="${uur%.*}"

source ${base_dir}/.uur.sh

source $uur

download_file () {
	fileurl=$1
	filetarget=$2
	wget -O ${filetarget} ${fileurl}
}

untar_file() {
	archivefile=$1
	targetdir=$2
	tar -xf $archivefile -C $targetdir
	if [ $? -ne 0 ]; then
		echo "Untar failed!"
		exit 0
	fi
}
unzip_file() {
	archivefile=$1
	targetdir=$2

	unzip $archivefile -d $targetdir
	if [ $? -ne 0 ]; then
		echo "Unzip failed!"
		exit 0
	fi
}

srcdir="$(get_srcdir $uurname)"

if [ "$url" == "" ]; then
	echo "Missing URL!"
	exit 1
fi

if [ "$type" == "appimage" ]; then
	download_file $url $srcdir
elif [ "$type" == "tar" ]; then
	download_file $url $srcdir/$filename
	untar_file $srcdir
elif [ "$type" == "bin" ]; then
	:
elif [ "$type" == "deb" ]; then
	:
elif [ "$type" == "git" ]; then
	if [ -d "$srcdir" ]; then
		cd "$srcdir"
		git pull
		cd $base_dir
	else
		git clone $url $srcdir
	fi
fi

# install depends
echo "Installing ${#depends_apt[@]} depends"
if [ ${#depends_apt[@]} -gt 0 ]; then
	sudo apt install ${depends_apt[*]}
	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot install requierments!"
		exit 1
	fi
fi

srcinsidedir="$(get_insidedir $uurname $insidedir)"
# build
cd $srcinsidedir
do_build $srcinsidedir

# install
cd $srcinsidedir
do_install $srcinsidedir
