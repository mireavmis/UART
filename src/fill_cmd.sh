#!/bin/bash
CMD="cmd"
truncate -s 0 "$CMD"

for file in $(find ./ -name "*.v")
do
    echo "$file" >> "$CMD"
done
