#!/bin/bash

#USAGE: ./studentComparison.sh (Canvas File) (Moodle File) [Gradescope file] [ZyBooks file]
#NEEDS AT LEAST ONE MAIN LMS FILE (CANVAS/MOODLE), AND A MINUMUM OF 2 FILES TO COMPARE
#FILES CAN BE IN ANY ORDER, AS LONG AS THE MAIN LMS FILES ARE GIVEN FIRST

USAGE="./studentComparison.sh -c (Canvas File) -m (Moodle File) -g [Gradescope file] -z [ZyBooks file]"
NOFILE=" doesn't exist"
#USE getopt to decipher which file belongs to which platform???



if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

while getopts "c:m:g:z:" option; do

    case $option in
        c)
            CANVAS_FILE=${OPTARG}
            echo "CANVAS"
            echo $CANVAS_FILE
            #check that file exists
            if ! test -f "$CANVAS_FILE"; then
                echo $CANVAS_FILE $NOFILE
                exit 1
            fi
        ;;
        m)
            MOODLE_FILE=${OPTARG}
            echo "MOODLE"
            echo $MOODLE_FILE
            if ! test -f "$MOODLE_FILE"; then
                echo $MOODLE_FILE $NOFILE
                exit 1
            fi
        ;;
        g)
            echo "GRADESCOPE"
            GRADESCOPE_FILE=${OPTARG}
            echo $GRADESCOPE_FILE
            if ! test -f "$GRADESCOPE_FILE="; then
                echo $GRADESCOPE_FILE $NOFILE
                exit 1
            fi
        ;;
        z)
            ZYBOOKS_FILE=${OPTARG}
            echo "ZYBOOKS"
            echo $ZYBOOKS_FILE
            if ! test -f "$ZYBOOKS_FILE="; then
                echo $ZYBOOKS_FILE $NOFILE
                exit 1
            fi
        ;;
        *)
            echo "INVALID FLAG. ABORTING PROCESS"
            echo $USAGE
            exit 1
        ;;
    esac

done

echo "Down here"
if test -f "$CANVAS_FILE"; then
    echo "$CANVAS_FILE exists."
fi

#check student names: Gradescope&Canvas=one column, zybooks&moodle=two columns




#check student ID numbers



#check school email handle


exit 0
