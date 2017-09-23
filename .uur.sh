#!/bin/bash
insidedir="."

get_dir () {
	name=$1
	dir="/tmp/uur/${name}/"
	echo $dir
}

get_srcdir () {
	name=$1
	insidedir="$2"
	fulldir="/tmp/uur/${name}/${insidedir}/"
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
