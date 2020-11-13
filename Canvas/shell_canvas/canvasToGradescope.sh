# /bin/bash

#USAGE: ./canvasToGradescope.sh (Canvas exam column) (Canvas .csv file) (gradescope .csv file)
USAGE="./canvasToGradescope.sh (Canvas exam column) (Canvas .csv file) (chosen Gradescope file name)"
CANVAS_TEMP_PATH="/tmp/canvasToGradescope_sortedData_FROM_CANVAS.txt"
examColNum=$1
GS_FILE=$3
validEntry=0
#CHECK IF INPUT(CANVAS) FILE EXISTS
if [ ! -e $2 ]; then
    echo "ERROR: Your Canvas input file could not be found."
    echo $USAGE
    exit 1
else
    canvasInFile=$2
fi
#
# Makes us able to check for output(gradescope) file names multiple times
# usage: checkForExistingFile() $[filename]
#
checkForExistingFile() {
if [ -e $GS_FILE ]; then
    printf "ERROR: Your output file: \"%s\" already exists, would you like to overwrite ('O' or 'o'), enter a new name ('N' or 'n'), or quit ('Q' or 'q')? " "${GS_FILE}"
        read
        case $REPLY in
        O|o) 
                validEntry=$((validEntry+1));
        ;;

        N|n) 
                unset GS_FILE;
                read -p "Enter a new file name (.csv extension) " GS_FILE;
                checkFileExt ${GS_FILE}; #Check for correct extension of new file
            ;;

            Q|q) 
                exit 1;
                validEntry=$((validEntry+1));
            ;;

            *) 
                printf "ERROR: Invalid input. Valid commands:\nO or o: overwrite the output file\nN or n: enter a new file name.\nQ or q: quit program to start over\nWhat would you like to do?\n";
            ;;
        esac
fi
}
#
# Checks file extension
#
checkFileExt() {
    newFILE=$(echo ${GS_FILE} | cut -d '.' -f1)
    unset GS_FILE
    GS_FILE=${newFILE}.csv
    echo $GS_FILE
    unset newFILE
}
#Check & correct a wrong file extension
echo "WHATWHATH"
checkFileExt ${GS_FILE}
#while loop is needed to check if a newly entered file also already exists
while [ $validEntry -eq 0 ]; do
    checkForExistingFile ${GS_FILE}
done
#Check if Gradescope output file exists
declare -a extraCreditCols
#DO INPUT LOOP TO GET EXTRA CREDIT COLUMNS
read -p "Do you have extra credit column(s) related to this exam? Enter \"Y\" or \"N\": " yesOrNo
if [[ ${yesOrNo} =~ Y|y ]]; then
    echo "Enter one or more column numbers where you have extra credit data for the exam:"
    echo "Press any non-numerical key + enter when done"
    #enter extra credit columns until user enters a non-number
    while read input; do
        echo ${extraCreditCols[@]}
        if [[ $input =~ Q|q ]]; then
            break
        else
            extraCreditCols+=($input)
        fi
    done < /dev/tty
fi
# if extraCreditColsArray is not empty, use them when making conversion

OLDIFS=${IFS}
IFS=','
rm $GS_FILE #allows to append to empty file
while read -a row; do
    newRow="${row[0]},${row[2]},${row[$examColNum]}" #name,SID,ExamGrade
    if [ ${#extraCreditCols[@]} -ne 0 ]; then
        for credCol in ${extraCreditCols[@]}; do
            newRow+=,${row[credCol]} #dynamically adds extra credit
        done
        newRow=${newRow///' '/,/}
        printf "%s\n" "${newRow}" >> ${GS_FILE}
    fi
done < $canvasInFile
IFS=${OLDIFS}
#do the same for EXAMS if 2nd arg is not 'n' or 'N'
