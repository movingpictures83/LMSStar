#!/bin/bash
# USAGE: ./extractZybook.sh (filename) (column number)
USAGE="./extractZybook.sh (filename) (column number)"
file=$1
columns=$(echo $* | cut -d ' ' -f2-)
columnsArr=($columns)
echo $columns
OLDIFS=$IFS
IFS="(,|\ )"

if [ $# -lt 2 ]
then
	echo "Usage: ./extractZybook.sh (filename) (column number)"
	exit 2
fi

if [ ! -e ${file} ]; then
	echo "ERROR: Your given file does not exist"
	echo $USAGE
fi

 while read -a array; do
	printf "%s,%s" "${array[1]}" "${array[2]}"
	for col in ${columns[@]}; do
		printf ",%s" "${array[$col]}"
	done
	printf "\n"
 done < $file
 IFS=$OLDIFS