#! /bin/bash
# USAGE: ./makeFolders.sh (root directory) (course) (exam) (n=number of sections) (section 1)...(section n) (dates, arbitrarily long)
USAGE="./makeFolders.sh (root directory) (course) (exam) (n=number of sections) (section 1)...(section n) (dates, arbitrarily long)"

# SAVE ARGUMENTS TO ARRAY, if ARGS=0, exit
if [ "$#" -eq 0 ]; then
    echo $USAGE
    exit 1
else
    CMD_ARGS=( "$@" )
fi
# echo ${CMD_ARGS[@]}

let NUM_SEC=${CMD_ARGS[3]} #NUMBER OF SECTIONS THAT SHOULD BE GIVEN

# GET SECTIONS INTO SEPARATE ARRAY
declare -a SECTIONS
if [ $NUM_SEC -ne 0 ]; then
    let i=4
    let STOP=3+$NUM_SEC
    let PLACE=0
    for (($i; $i<=$STOP; i++))
    do
        SECTIONS[$PLACE]=${CMD_ARGS[$i]}
        printf "DEBUG:::: WHAT IS SECTION NOW -- %s\n" ${SECTIONS[$PLACE]}
        let "PLACE+=1"
    done
else
    echo $USAGE
    exit
fi

# GET DATES INTO SEPARATE ARRAY
declare -a DATES
let "PLACE=0"
for (($i; $i<$#; i++))
do
    DATES[$PLACE]=${CMD_ARGS[$i]}
    let "PLACE+=1"
done

# MAKE FOLDERS
COURSE=${CMD_ARGS[0]}/${CMD_ARGS[1]}

if [ ! -d "$COURSE" ]; then
   mkdir ${COURSE}
fi
# mkdir for exam
if [ ! -d "${COURSE}/${CMD_ARGS[2]}" ]; then
    mkdir ${COURSE}/${CMD_ARGS[2]}
fi

for section in ${SECTIONS[@]}
do
    if [ ! -d "${COURSE}/${CMD_ARGS[2]}/$section" ]; then
        mkdir ${COURSE}/${CMD_ARGS[2]}/$section
    fi
    for date in ${DATES[@]}
    do
        if [ ! -d "${COURSE}/${CMD_ARGS[2]}/$section/$date" ]; then
            mkdir ${COURSE}/${CMD_ARGS[2]}/$section/$date
        fi
        mkdir ${COURSE}/${CMD_ARGS[2]}/$section/$date/classtime
        mkdir ${COURSE}/${CMD_ARGS[2]}/$section/$date/exam
    done
done
