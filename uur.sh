#!/bin/bash

base_dir=$(dirname $(realpath $0))

if [ $# -eq 0 ]; then
	echo "Please specifiy urr file, e.q.: $0 gradio.uur"
	exit 0
fi

if [ $# -gt 1 ]; then
	echo "Multiple uurs, separated to each"
	for param in $@; do
		$0 $param
		echo "======================================"
	done
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
	if [ $? -ne 0 ]; then
		echo "chmod +x $srcdir/$filename failed!!"
		exit 1
	fi
	echo "Running $srcdir/$filename for installation."
	$srcdir/$filename
}

deb_install() {
	srcdir=$1
	filename=$2

	which gdebi 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Needs to install gdebi"
		sudo apt install gdebi
		if [ $? -ne 0 ]; then
			echo "Gdebi installation failed!"
			exit 1
		fi
	fi

	echo "Gdebi installation of $srcdir/$filename"
	sudo gdebi $srcdir/$filename
	if [ $? -ne 0 ]; then
		echo "Installation failed!"
		exit 1
	fi
}

# for appimage, deb or bin
bin_uninstall() {
	srcdir=$1
	filename=$2

	rm $srcdir/$filename
	if [ $? -ne 0 ]; then
		echo "Removing $srcdir/$filename failed!!"
		exit 1
	fi
}

srcdir="$(get_srcdir $uurname)"

if [ "$type" != "nope" ] && [ $type != "nop" ]; then
	if [ "$url" == "" ]; then
		echo "Missing URL!"
		exit 1
	fi
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
	download_file $url $srcdir $filename
	sudo gdebi $srcdir/$filename
elif [ "$type" == "git" ]; then
	if [ -d "$srcdir/.git" ]; then
		cd "$srcdir"
		git pull
		cd $base_dir
	else
		git clone $url $srcdir
	fi
elif [ "$type" == "nop" ]; then
	:
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
