#!/bin/bash

#USAGE: canvasToMoodle.sh (canvas infile) (Moodle outfile) (institution) (Department)
USAGE="canvasToMoodle.sh (canvas infile) (Moodle outfile) (institution) (Department)"

# awk -F, '{ $3="" }' $1 > $2
if [ $# -ne 4 ]; then
    echo $USAGE
    exit 1
fi

cp $1 $2 #copy canvas file as designated moodle file

sed -i 's/[^,]*,//2' $2 #deletes unneeded id
sed -i "1 s/Student/First name,Surname/" $2 #separate full name TITLE to first and last name
sed -i "1 s/SIS User ID/ID number/" $2
sed -i "1 s/SIS Login ID/Email address/" $2
sed -i "3,$ s/ /,/1" $2 #places comma in between 1st and last name
sed -i "3,$ s/,[0-9A-Za-z]*/$3/5" $2 #TODO: replace any text here with $3
sed -i "1 s/Section/Institution,Department/" $2
#TODO: add $4 to DEPARTMENT col
sed -i "2 s/[^,].,/,,,/1" $2 #move points possible to the right
sed -i "3,$ s/[^,].,/,,/5" $2 #move rest of cols to the right
exit 0