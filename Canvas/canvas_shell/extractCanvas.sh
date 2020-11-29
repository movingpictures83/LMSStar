#!/bin/bash

#USAGE: ./extractCanvas.sh (input file) (column number) (column number) ... (column number)
USAGE="USAGE: ./extractCanvas.sh (input file) (column number)  (column number) ... (column number)"

case $# in
	0)
		echo "ERROR: No arguments given."
		echo $USAGE
		exit 2 ;;
	1) 
		echo "ERROR: Minimum of two arguments needed."
		echo $USAGE
		exit 2 ;;
	*) ;;
esac
#input file check
if [ -e $1 ]; then
	inFile=$1
else
	echo "ERROR: Input file doesn't exist"
	echo $USAGE
	exit 2
fi
#vars needed to dynamically print any number of columns
columnsLength=$(expr $# - 1)
columnsGiven=$(echo $@ | sed 's/ /,/g' | cut -d ',' -f 2-)

#begin extracting info
if [ ${columnsLength} -eq 1 ]; then
	awk -F, -v col=${columnsGiven} 'NR > 2 { printf "%s,%s,%s\n",$1,$3,col }' ${inFile}
else
	awk -F, -v cols=${columnsGiven} -v colsLen=${columnsLength} '
	BEGIN { split(cols, colsArr, ",") }

		NR > 2 { 
			printf "%s,%s", $1, $3
			for (i = 1; i <= colsLen; i++) {
				printf ",%s", $colsArr[i]
			}
			printf "\n"
		}
		' ${inFile}
fi
exit 0
