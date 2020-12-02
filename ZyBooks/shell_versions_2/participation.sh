#!/bin/bash

#USAGE: ./participation.sh (classtime file) (examtime file) (outputfile) (data column number) (total points possible)

USAGE="USAGE: ./participation.sh (classtime file) (examtime file) (outputfile csv) (data column number) (total points possible) [weight adjustment]"
outFile=$(echo $3 | cut -d '.' -f1) #converts possible bad file ext to csv
outFile=${outFile}.csv
partCol=$4
totalPoints=$5
#if number of arguments are not 5 or 6, error with input
if [ $# -lt 5 -o $# -gt 6 ]; then
	echo "ERROR: Wrong number of arguments given."
	echo $USAGE
	exit 1
fi
#set to default or custom weight adjustment
if [ $# -eq 5 ]; then
	adjWeight=0.75
elif [ $# -eq 6 ]; then
	adjWeight=$6
fi
# check if input files exist
if [ -e $1 ]; then
	classtimeFile=$1
else
	echo "Your classtime File does not exist"
	echo $USAGE
	exit 1
fi

if [ -e $2  ]; then
	examtimeFile=$2
else
	echo "Your examtime file does not exist"
	echo $USAGE
	exit 1
fi
#EXTRACT PARTICIPATION GRADES INTO STRING, EXCLUDE FIRST ROW
examtime=$(awk -F, -v var=${partCol} 'NR>1 { print $var }' $examtimeFile)
classtime=$(awk -F, -v var=${partCol} 'NR>1 { print $var }' $classtimeFile)
#replace spaces with commas, this solves parsing issues with spaces
examtimeSTR=$(echo $examtime | cut -d ' ' -f1- --output-delimiter ",")
classtimeSTR=$(echo $classtime | cut -d ' ' -f1- --output-delimiter ",")

#AWK script that creates the outfile & does calculation
awk -F, -v exam=${examtimeSTR} -v class=${classtimeSTR} -v adjWeight=${adjWeight} -v totPoints=${totalPoints} '
BEGIN { split(exam, examArr,","); split(class, classArr,","); i=1;x=0; printf "Last Name,First Name,SID,Adjusted Score,Percentage\n"; } 
NR>1 { printf "%s,%s,%s,", $1, $2, $5;
x=(classArr[i] + (classArr[i] - examArr[i])) * adjWeight;
if(x<0) x = x * -1;
printf "%.2f,%.2f\n", x, x/totPoints; 
i = i + 1; }' $classtimeFile > $outFile
exit 0