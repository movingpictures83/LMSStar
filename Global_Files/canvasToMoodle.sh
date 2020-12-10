#!/bin/bash

#### Script is used to convert Canvas data to Moodle data or vice versa ####

#USAGE: ./canvasToMoodle (Canvas infile) (Moodle outfile)
USAGE="USAGE: ./canvasToMoodle (Canvas infile) (Moodle outfile)"

if [ $# -ne 2 ]; then
    echo $USAGE
    exit 1
fi

inFile=$1
outFile=$2

if [ ! -e $inFile ]; then
    echo "ERROR! Your input file was not found."
    echo $USAGE
    exit 1
fi

#automatic conversion of a bad file to csv

fileExt=$(echo ${outFile} | cut -d "." -f2)

if [ "$fileExt" != "csv" ]; then
    echo "WARNING: outfile should be \".csv\" ... Changing extention."
    outFile2=$(echo ${outFile} | sed "s/.${fileExt}/.csv/")
    outFile=$outFile2
    unset outFile2
    echo $outFile
fi

if [ -e $outFile ]; then
    echo "ERROR! Your output file already exists. Choose another name or location."
    echo $USAGE
    exit 1
fi

firstNames=""
lastNames=""
emails=""
studentIDs=""
profCols=""
pointsPossCols=""
counter=0
OLDIFS=${IFS}
IFS=","
while read -a arr; do
    if [ $counter -eq 0 ]; then
        moodleTitleCols="First name,Surname,ID number,Institution,Department"
	profCols=$(echo ${arr[@]} | cut -d "," -f5-)
    fi
    if [ $counter -eq 1 ]; then
        pointsPossCols=$(echo ${arr[@]} | cut -d "," -f5-)
    fi
    if [ $counter -eq 2 ]; then
        emailURL=$(echo ${arr[4]} | cut -d "-" -f2 | awk '{ print tolower($0) }')
        emailURL=${emailURL:0:3}.edu
        department=$(echo ${arr[4]} | cut -d "-" -f3)
        # echo $emailURL
    fi
# '-' used here to avoid spaces when passing these strings to awk and using "split()" function
    firstNames+=-$(echo ${arr[0]} | cut -d " " -f1)
    lastNames+=-$(echo ${arr[0]} | cut -d " " -f2-)
    emails+=-${arr[3]}@${emailURL}
    studentIDs+=-${arr[2]}
    ((counter=counter+1))
done < $inFile

firstNames=${firstNames:10}
lastNames=${lastNames:10}
emails=${emails:17}
studentIDs=${studentIDs:14}

#echo $firstNames
#echo ${lastNames[@]}
#echo ${emails}
#echo ${studentIDs}
###TODO: write data to outFile (awk script)
IFS=${OLDIFS}
exit 0
