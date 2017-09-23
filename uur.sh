#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Please specifiy urr file, e.q.: $0 gradio.uur"
	exit 0
fi

uur="$1"
if [ ! -f "$uur" ]; then
	echo "UUR file $uur not found! Please choose different one!"
	exit 0
fi

source .uur.sh

source $uur

### Requiered ###
# - name
# - url
# - depends
# - releases archive:
# 	- ext
# 	- version
### Created ###
# - dir
# - releases archive:
# 	- file

dir="$(get_dir $name)"

if [ "$ext" ]; then # Downloading release
	mkdir -p $dir
	# constants
	file="$(get_file $dir $name $version $ext)"
	#file="${dir}$name.$version.$ext"

	# get the file
	if [ ! -f "$file" ]; then
		echo "Downloading file from $url"
		wget -O ${file} "$url"
		if [ $? -ne 0 ]; then
			echo "ERROR: Download release archive failed!"
			exit 1
		fi
	else
		echo "File already downloaded"
	fi
	# untar xz
	echo "untaring"
	tar -xf $file -C $dir
	if [ $? -ne 0 ]; then
		echo "ERROR Cannot untar release archive!"
		exit 1
	fi
else # Clonning git repository
	if [ ! -d "$dir" ]; then
		mkdir -p $dir
		git clone $url $dir
		if [ $? -ne 0 ]; then
			echo "ERROR: Cannot clone gir repository!"
			exit 1
		fi
	else
		cd $dir
		git pull
		if [ $? -ne 0 ]; then
			echo "ERROR: Cannot pull git repository!"
			exit 1
		fi
	fi
fi


# install depends
echo "Installing ${#depends[@]} depends"
sudo apt install ${depends[*]}
if [ $? -ne 0 ]; then
	echo "ERROR: Cannot install requierments!"
	exit 1
fi

srcdir="$(get_srcdir $name $insidedir)"
# build
cd $srcdir
build $dir

# install
cd $srcdir
package $dir
