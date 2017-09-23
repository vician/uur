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

source $uur

### Requiered ###
# - name
# - version
# - ext
# - file
# - depends

if [ "$ext" ]; then # Downloading release
	# constants
	file="$name.$version.$ext"

	# get the file
	if [ ! -f "$file" ]; then
		echo "Downloading file from $url"
		wget -O $file "$url"
	else
		echo "File already downloaded"
	fi
	# untar xz
	echo "untaring"
	tar -xf $file
else # Clonning git repository
	if [ ! -d "$name" ]; then
		git clone $url
	else
		cd $name
		git pull
	fi
fi

# install depends
echo "Installing ${#depends[@]} depends"
sudo apt install ${depends[*]}

# build
build

# install
package
