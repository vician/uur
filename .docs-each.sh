#!/bin/bash

if [ $# -ne 1 ]; then
	echo "ERROR: $0 wrong parameters!"
	exit 1
fi

file="$1"
if [ ! -f "$file" ]; then
	echo "ERROR: file $file not found!"
	exit 1
fi

source .uur.sh

source $file

mkdir -p docs

doc="docs/$name.md"
rm $doc
touch $doc

dir="$(get_dir $name)"
srcdir="$(get_srcdir $name $insidedir)"

echo "## Download" >> $doc
echo '```bash' >> $doc
if [ "$ext" ]; then # release archive
	file="$(get_file $dir $name $version $ext)"
	echo "wget -O $file $url" >> $doc
else # git clone
	echo "git clone $url $dir" >> $doc
fi
echo '```' >> $doc

echo "## Build" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type build | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
echo "## Install" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type package | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
