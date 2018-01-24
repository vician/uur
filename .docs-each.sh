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

docfilename="$(basename $(realpath $file))"
docfilename="${docfilename%.*}"

echo "docfilename: $docfilename"

source .uur.sh

source $file
if [ ! -f "$file" ]; then
	echo "file $file not found!"
	exit 1
fi

mkdir -p docs/packages/

doc="docs/packages/${docfilename}.md"
echo "doc: $doc"
touch $doc

srcdir="$(get_srcdir $docfilename)"
srcinsidedir="$(get_insidedir $docfilename $insidedir)"

echo "## Installation via UUR" >> $doc
echo '```bash' >> $doc
echo "./uur.sh $file" >> $doc
echo '```' >> $doc

echo "## Manual installation" >> $doc
echo "### Download" >> $doc
echo '```bash' >> $doc
if [ "$type" == "git" ]; then
	echo "git clone $url $srcdir" >> $doc
fi
echo '```' >> $doc

if [ ${#depends_apt[@]} -gt 0 ]; then
	echo "### Install requirements" >> $doc
	echo '```bash' >> $doc
	echo "sudo apt install ${depends_apt[*]}" >> $doc
	echo '```' >> $doc
fi
echo "### Build" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type do_build | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
echo "### Install" >> $doc
echo '```bash' >> $doc
echo "cd $srcdir" >> $doc
type do_install | tail -n +4 |sed \$d | sed 's/    //g' >> $doc
echo '```' >> $doc
