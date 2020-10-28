#!/bin/bash

#USAGE: ./extractCanvas.sh (input file) (column number)
USAGE="USAGE: ./extractCanvas.sh (input file) (column number)"

if [ -e $1 ]; then
	inFile=$1
else
	echo "ERROR: Input file doesn't exist"
	echo $USAGE
	exit 1
fi
awk -F, -v col=$2 '{ print $1,$col }' $inFile
exit 0
