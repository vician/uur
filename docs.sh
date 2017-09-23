#!/bin/bash

uurs=($(ls *.uur))

echo "Found ${#uurs[@]} uurs"

for uur in ${uurs[@]}; do
	echo "- parsing $uur"

	./.docs-each.sh $uur
done

ln -s index.md docs/index.md
