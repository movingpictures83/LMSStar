# /bin/bash

#USAGE: ./canvasToGradescope.sh (Canvas exam column) (Canvas .csv file) (gradescope .csv file)
USAGE="./canvasToGradescope.sh (Canvas exam column) (Canvas .csv file) (chosen Gradescope file name"
CANVAS_TEMP_PATH="/tmp/canvasToGradescope_sortedData_FROM_CANVAS.txt"
examColNum=$1
GS_FILE=$3
validEntry=0
#CHECK IF FILES EXIST
if [ ! -e $2 ]; then
    echo "ERROR: Your Canvas input file could not be found."
    echo $USAGE
    exit 1
else
    canvasInFile=$2
fi
checkForExistingFile() {
if [ -e $GS_FILE ]; then
    printf "ERROR: Your output file: \"%s\" already exists, would you like to overwrite ('O' or 'o'), enter a new name ('N' or 'n'), or quit ('Q' or 'q')?" "${canvasInFile}"
        read; echo $REPLY
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
checkFileExt() {
    GS_FILE_LEN=${#1}
    GS_NUM=$(($GS_FILE_LEN - 4)) #get position of file extension in string
    GS_FILE_EXT="${GS_FILE:GS_NUM:4}" #extract substring
    
    if [[ ! ${GS_FILE_EXT} =~ '.csv' ]]; then
        printf "WARNING: you entered \"%s\", not \".csv\" file extension.\nCreating a .csv file of the same name.\n" "${1}"
        GS_FILE=${GS_FILE/$GS_FILE_EXT/.csv}
        echo "DEBUG:::: " $GS_FILE
    fi
}
#Check & correct a wrong file extension
checkFileExt ${GS_FILE}
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
