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

uurname="$(basename $(realpath $uur))"
uurname="${uurname%.*}"

echo "uurname: $uurname"
echo "uurfile: $uur"

source ${base_dir}/.uur.sh

source $uur

download_file () {
	fileurl=$1
	targetdir=$2
	filename=$3

	if [ ! -d "$targetdir" ]; then
		mkdir "$targetdir"
	fi

	echo "Downloading $fileurl to $targetdir/$filename"
	wget -O ${targetdir}/$filename ${fileurl}
	if [ $? -ne 0 ]; then
		echo "Downloading failed!"
		exit 0
	fi
}

untar_file() {
	archivefile=$1
	targetdir=$2
	echo "Untaring $archivefile to $targetdir"
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

appimage_install() {
	srcdir=$1
	filename=$2

	chmod +x $srcdir/$filename
	echo "Running $srcdir/$filename for installation."
	$srcdir/$filename
}

appimage_uninstall() {
	srcdir=$1
	filename=$2

	rm $srcdir/$filename
}

srcdir="$(get_srcdir $uurname)"

if [ "$url" == "" ]; then
	echo "Missing URL!"
	exit 1
fi

if [ "$type" == "appimage" ] || [ "$type" == "AppImage" ]; then
	download_file $url $srcdir $filename
	appimage_install $srcdir $filename
elif [ "$type" == "tar" ]; then
	download_file $url $srcdir $filename
	untar_file $srcdir/$filename $srcdir
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
else
	echo "ERROR: Unknown type!"
	exit 1
fi

# install depends
echo "Installing ${#depends_apt[@]} depends: ${depends_apt[*]}"
if [ ${#depends_apt[@]} -gt 0 ]; then
	sudo apt install ${depends_apt[*]}
	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot install requierments!"
		exit 1
	fi
fi

srcinsidedir="$(get_insidedir $uurname $insidedir)"

if [ ! -d "$srcinsidedir" ]; then
	echo "ERROR: $srcinsidedir doesn't exist!"
	exit 1
fi

# build
cd $srcinsidedir
do_build $srcinsidedir

# install
cd $srcinsidedir
do_install $srcinsidedir
