#!/bin/bash
# USAGE: ./extractZybook.sh (filename) (column number)
USAGE="./extractZybook.sh (filename) (column number)"
file=$1
column=$2
OLDIFS=$IFS
IFS="(,|\ )"

if [ $# -lt 2 -o $# -gt 2 ]
then
	echo "Usage: ./extractZybook.sh (filename) (column number)"
	exit 2
fi

if [ ! -e ${file} ]; then
	echo "ERROR: Your given file does not exist"
	echo $USAGE
fi

while read -a array
do
	printf "%s %s %s\n" "${array[1]}" "${array[2]}" "${array[$column]}"
done < $file
IFS=$OLDIFS
