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

filename="${file%.*}"

source .uur.sh

source $file

mkdir -p docs

doc="docs/${filename}.md"
rm $doc
touch $doc

dir="$(get_dir $filename)"
srcdir="$(get_srcdir $filename $insidedir)"

echo "## Installation via UUR" >> $doc
echo '```bash' >> $doc
echo "./uur.sh $file" >> $doc
echo '```' >> $doc

echo "## Manual installation" >> $doc
echo "### Download" >> $doc
echo '```bash' >> $doc
if [ "$ext" ]; then # release archive
	file="$(get_file $dir $filename $version $ext)"
	echo "wget -O $file $url" >> $doc
else # git clone
	echo "git clone $url $dir" >> $doc
fi
echo '```' >> $doc

echo "### Install requirements" >> $doc
echo '```bash' >> $doc
echo "sudo apt install ${depends[*]}" >> $doc
echo '```' >> $doc
echo "### Build" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type build | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
echo "### Install" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type package | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
