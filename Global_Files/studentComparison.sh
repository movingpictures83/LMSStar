#!/bin/bash

#USAGE: ./studentComparison.sh (Canvas File) (Moodle File) [Gradescope file] [ZyBooks file]
#NEEDS AT LEAST ONE MAIN LMS FILE (CANVAS/MOODLE), AND A MINUMUM OF 2 FILES TO COMPARE
#FILES CAN BE IN ANY ORDER, AS LONG AS THE MAIN LMS FILES ARE GIVEN FIRST

USAGE="./studentComparison.sh (Canvas File) (Moodle File) [Gradescope file] [ZyBooks file]"

#USE getopt to decipher which file belongs to which platform???

while getopts "c:m:g:z:" option; do
    case $option in 
        c)
            CANVAS_FILE=${OPTARG}
            echo "CANVAS"
            echo $CANVAS_FILE
        ;;
        m)
            MOODLE_FILE=${OPTARG}
            echo "MOODLE"
            echo $MOODLE_FILE
        ;;
        g)
            echo "GRADESCOPE"
            GRADESCOPE_FILE=${OPTARG}
            echo $GRADESCOPE_FILE
        ;;
        z)
            ZYBOOKS_FILE=${OPTARG}
            echo "ZYBOOKS"
            echo $ZYBOOKS_FILE
        ;;
        *)
            echo "INVALID FLAG. ABORTING PROCESS"
            echo $USAGE
            exit 1
        ;;
    esac

done


#check student names: Gradescope&Canvas=one column, zybooks&moodle=two columns




#check student ID numbers



#check school email handle


exit 0
