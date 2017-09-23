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

source $file

doc="docs/$name.md"
rm $doc
touch $doc

echo "## Download" >> $doc
echo '```' >> $doc
if [ "$ext" ]; then # release archive
	echo "wget -O $file $url" >> $doc
echo '```' >> $doc
else # git clone
	echo "git clone $url $dir" >> $doc
fi
echo '```' >> $doc

echo "## Build" >> $doc
echo '```' >> $doc
type build | tail -n +4 |sed \$d >> $doc
echo '```' >> $doc
echo "## Install" >> $doc
echo '```' >> $doc
type package | tail -n +4 |sed \$d >> $doc
echo '```' >> $doc
