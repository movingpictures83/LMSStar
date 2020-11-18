#!/bin/bash

#USAGE: ./participation.sh (classtime file) (examtime file) (outputfile) (data column number) (total points possible)

USAGE="./participation.sh (classtime file) (examtime file) (outputfile csv) (data column number) (total points possible) [weight adjustment]"
outFile=$(echo $3 | cut -d '.' -f1) #converts possible bad file ext to csv
outFile=${outFile}.csv
partCol=$4
totalPoints=$5
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
#EXTRACT PARTICIPATION GRADES INTO ARRAY, EXCLUDE FIRST ROW
examtimeArr=($(awk -F, -v var=${partCol} 'NR>1 { print $var }' $examtimeFile))
classtimeArr=($(awk -F, -v var=${partCol} 'NR>1 { print $var }' $classtimeFile))
#create outfile with names & PIDs, append to the file later
awk -F, 'NR>1 { printf "%s,%s,%s\n", $1, $2, $5 }' $classtimeFile > $outFile

exArrLen=${#examtimeArr[@]}
classArrLen=${#classtimeArr[@]}
#IF ARRAY LENGTHS DIFFER, THERE MUST BE AN ERROR > EXIT
if [ $exArrLen -ne $classArrLen ]; then
	echo "ERROR: Check that input files are for the same class"
	echo $USAGE
	exit 1
fi
#CALCULATE SCORE & EXIT
index=0
lineNum=1
newGradePoints=""
newGradePerc=""
for i in "${examtimeArr[@]}"; do
	#x - adjusted points
	x=$(echo "${classtimeArr[$index]} + ((${classtimeArr[$index]} - ${i}) * ${adjWeight})" | bc | cut -d '-' -f2)
	xPercent=$(echo "scale=2;${x}/${totalPoints}" | bc | cut -d '-' -f2)
#	newGradePoints+=",$x"
#	newGradePerc+=",$xPercent"
	sed -i "${lineNum} s/$/,${x},${xPercent}/" $outFile
	((index=index+1))
	((lineNum=lineNum+1))
##	awk -F, -v newPoints=${newGradePoints} -v newPerc=${newGradePerc} -v line=${lineNum} '
#	BEGIN { split(newPoints,pointsArr,",")
#			split(newPerc,percArr,",")
#		 }
#		NR = line { print $1,$2,$5,$pointsArr[NR],$percArr[NR] }' $classtimeFile > $outFile
done
exit 0
