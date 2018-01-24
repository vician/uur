#!/bin/bash

# clean old files
rm -rf docs/packages/*
mkdir -p docs/packages/

uurs=($(ls repo/*.uur))

echo "Found ${#uurs[@]} uurs"

for uur in ${uurs[@]}; do
	echo "- parsing $uur"

	./.docs-each.sh $uur
done

cp index.md docs/index.md

cp README.md docs/development.md
