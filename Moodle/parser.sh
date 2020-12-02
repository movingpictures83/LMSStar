#!/bin/bash

#Description retrieves the student's first and last name and the requested column number and prints all 3 columns
#Usage: ./parser.sh (input filename) (column number)
#Example: ./parser.sh 

#$1 = input filename
#$2 = column number

if [ "$#" -ne 3 ]; then
	echo "Usage: 2 arguments required. Inputfile, and colun number";
	exit 2;
fi

if [  ! -f "$1" ]; then
	echo "Input file invalid";
	exit 2;
fi

awk -F "\"*,\"*" '{print $1,""$2 " ",$col}' col="${2}" $1