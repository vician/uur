#!/bin/bash
insidedir="."

uur_packages_src="/opt/uur/"

if [ ! -d "$uur_packages_src" ]; then
	sudo mkdir -p "$uur_packages_src"
	sudo chown $USER:$USER "$uur_packages_src"
fi

get_srcdir () {
	name=$1
	dir="${uur_packages_src}/${name}/"
	if [ ! -d "$dir" ]; then
		mkdir "$dir"
	fi
	echo $dir
}

get_insidedir () {
	name=$1
	srcdir=$(get_srcdir $name)
	insidedir="$2"
	fulldir="${srcdir}/${insidedir}/"
	echo $fulldir
}

# Default empty functions
do_build () {
	:
}

do_install () {
	:
}

do_uninstall () {
	:
}
