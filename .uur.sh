#!/bin/bash
insidedir="."

uur_packages_sources="/opt/uur/src/"
uur_packages_bins="/opt/uur/bin/"

get_srcdir () {
	name=$1
	dir="${uur_packages_src}/${name}/"
	echo $dir
}

get_bindir () {
	name=$1
	dir="${uur_packages_bin}/${name}/"
	echo $dir
}

get_insidedir () {
	name=$1
	srcdir=$(get_srcdir $name)
	insidedir="$2"
	fulldir="${srcdir}/${insidedir}/"
	echo $fulldir
}

get_file () {
	dir=$1
	name=$2
	version=$3
	ext=$4
	file="${dir}${name}.${version}.${ext}"
	echo $file
}

# Default empty functions
build () {
	:
}

package () {
	:
}

uninstall () {
	:
}
