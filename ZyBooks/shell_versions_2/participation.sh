#!/bin/bash

#USAGE: ./participation.sh (classtime file) (examtime file) (outputfile) (data column number) (total points possible)

USAGE="./participation.sh (classtime file) (examtime file) (outputfile) (data co    lumn number) (total points possible)"

outFile=$3
partCol=$4
totalPoints=$5

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
#EXTRACT PARTICIPATION GRADES INTO ARRAY, EXCLUDE FIRST ROW
examtimeArr=($(awk -F, -v var=${partCol} 'NR>1 { print $var }' $examtimeFile))
classtimeArr=($(awk -F, -v var=${partCol} 'NR>1 { print $var }' $classtimeFile))
#create outfile with names & PIDs, append to the file later
awk -F, 'NR>1 { print $1,$2,$5 }' $classtimeFile > $outFile

exArrLen=${#examtimeArr[@]}
classArrLen=${#classtimeArr[@]}

#IF ARRAY LENGTHS DIFFER, THERE MUST BE AN ERROR > EXIT
if [ $exArrLen -ne $classArrLen ]; then
	echo "ERROR: Check that input files are for the same class"
	echo $USAGE
	exit 1
fi
index=0
lineNum=1
for i in "${examtimeArr[@]}"; do
	x=$(echo "(${classtimeArr[$index]} + (${i} * 0.75))" | bc)
	xPercent=$(echo "scale=2;${x}/${totalPoints}" | bc)
	sed -i "${lineNum} s/$/ ${x} ${xPercent}/" $outFile
	((index=index+1))
	((lineNum=lineNum+1))
done
exit 0
