#!/bin/bash

#USAGE: ./studentComparison.sh (Canvas File) (Moodle File) [Gradescope file] [ZyBooks file]
#NEEDS AT LEAST ONE MAIN LMS FILE (CANVAS/MOODLE), AND A MINUMUM OF 2 FILES TO COMPARE
#FILES CAN BE IN ANY ORDER, AS LONG AS THE MAIN LMS FILES ARE GIVEN FIRST

USAGE="./studentComparison.sh -c (Canvas File) -m (Moodle File) -g [Gradescope file] -z [ZyBooks file]"
NOFILE=" doesn't exist"
#USE getopt to decipher which file belongs to which platform???


#Make a loop that compares the strings of the ID's. If match, figure out what number that name has in the
#two different arrays. Then compare the Names's at those same spots.

#Create a method that checks that name only contains a-z
#ID only contains digits
#Email contains @

#check student names: Gradescope&Canvas=one column, zybooks&moodle=two columns
#check student ID numbers
#check school email handle

arrNamesCANV=()
arrIDsCANV=()
arrNamesMOOD=()
arrIDsMOOD=()
arrNamesZYB=()
arrIDsZYB=()
counter=0
totalErrors=0





#Doesnt work
echoArrays(){
  for value in "${s1[@]}"
  do
    echo $value
  done
}

getErrorCount(){
  if (( $totalErrors==0 )); then
    echo "All emails legitimate"
  fi
}

#Checks that email is legitimate
emailVerify(){

  counter=0
  regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
  if [[ $2 == "MOODLE" ]] ; then
    while IFS=","; read s1 s2 s3 s4 s5 s6 s7;
    do
      let "counter=counter+1"
      if (( $counter>1 )); then
        i="$s6"
        if [[ $i =~ $regex ]] ; then
            :
        else
            echo "$s1 $s2's email not OK ($s6)"
            let "totalErrors=totalErrors+1"
        fi
      fi
    done < $1
  elif [[ $2 == "ZYBOOKS" ]]; then
    while IFS=","; read s1 s2 s3 s4 s5 s6 s7;
    do
      let "counter=counter+1"
      if (( $counter>1 )); then
        i="$s3"
        if [[ $i =~ $regex ]] ; then
            :
        else
            echo "$s2 $s1's email not OK ($s3)"
            let "totalErrors=totalErrors+1"
        fi
      fi
    done < $1
  fi

    #statements
}

addNameID(){
  if [[ $2 == "CANVAS" ]] ; then
    echo "Canvas file"

    while IFS=","; read s1 s2 s3 s4;
    do
      let "counter=counter+1"
      if (( $counter>2 )); then
        arrNamesCANV+=($s1)
        arrIDsCANV+=($s3)
      fi
    done < $1
  elif [[ $2 == "MOODLE" ]]; then
    echo "Moodle file"

    counter=0
    while IFS=","; read s1 s2 s3 s4;
    do
      let "counter=counter+1"
      if (( $counter>1 )); then
        arrNamesMOOD+=($s1)
        arrIDsMOOD+=($s3)
      fi
    done < $1
  elif [[ $2 == "ZYBOOKS" ]]; then
    echo "ZYB file"

    fullName=""
    while IFS=","; read s1 s2 s3 s4 s5 s6;
    do
      let "counter=counter+1"
      if (( $counter>1 )); then
        fullName="$s2 $s1"
        arrNamesZYB+=($fullName)
        arrIDsZYB+=($s5)
      fi
    done < $1
  fi

}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

while getopts "c:m:g:z:" option; do

    case $option in
        c)
            CANVAS_FILE=${OPTARG}
            #echo "CANVAS"
            #echo $CANVAS_FILE
            addNameID $CANVAS_FILE CANVAS
            #addNameIDCanvas $CANVAS_FILE CANVAS

            #check that file exists
            if ! test -f "$CANVAS_FILE"; then
                echo $CANVAS_FILE $NOFILE
                exit 1
            fi
        ;;
        m)
            MOODLE_FILE=${OPTARG}
            #echo "MOODLE"
            #echo $MOODLE_FILE
            addNameID $MOODLE_FILE MOODLE
            emailVerify $MOODLE_FILE MOODLE
            if ! test -f "$MOODLE_FILE"; then
                echo $MOODLE_FILE $NOFILE
                exit 1
            fi
        ;;
        g)
            #echo "GRADESCOPE"
            GRADESCOPE_FILE=${OPTARG}
            #echo $GRADESCOPE_FILE
            if ! test -f "$GRADESCOPE_FILE="; then
                echo $GRADESCOPE_FILE $NOFILE
                exit 1
            fi
        ;;
        z)
            ZYBOOKS_FILE=${OPTARG}
            addNameID $ZYBOOKS_FILE ZYBOOKS
            emailVerify $ZYBOOKS_FILE ZYBOOKS
            #echo "ZYBOOKS"
            #echo $ZYBOOKS_FILE
            #if ! test -f "$ZYBOOKS_FILE="; then
            #    echo $ZYBOOKS_FILE $NOFILE
            #    exit 1
            #fi
        ;;
        *)
            echo "INVALID FLAG. ABORTING PROCESS"
            echo $USAGE
            exit 1
        ;;
    esac

done

getErrorCount


sortedIDsCANV=()
counterZYB=0
counterCAN=0

#ID and name comparison
for value in "${arrIDsZYB[@]}"
do

  ZybID=$value
  ZybName=${arrNamesZYB[counterZYB]}

  let "counterZYB=counterZYB+1"
  for value in "${arrIDsCANV[@]}"
  do
    #let "counterCAN=counterCAN+1"
    if [ "$ZybID" = "$value" ]; then
      echo "ID match between student $ZybName from Zybook record"

      sortedIDsCANV+=($value)

    fi
  done
done




##ECHO SORTED##
#for value in "${sortedIDsCANV[@]}"
#do
#  echo $value
#done

##ECHO ZYBOOK##
#for value in "${arrNamesZYB[@]}"
#do
#  echo $value
#done

#for value in "${arrIDsZYB[@]}"
#do
#  echo $value
#done

##ECHO MOODLE##

#for value in "${arrNamesMOOD[@]}"
#do
#  echo $value
#done

#for value in "${arrIDsMOOD[@]}"
#do
#  echo $value
#done


##ECHO CANVAS##
#for value in "${arrNamesCANV[@]}"
#do
#  echo $value
#done

#for value in "${arrIDsCANV[@]}"
#do
#  echo $value
#done

#addNameIDMoodle(){
#  counter=0
#  while IFS=","; read s1 s2 s3 s4;
#  do
#    let "counter=counter+1"
#    if (( $counter>1 )); then
#      arrNamesMOOD+=($s1)
#      arrIDsMOOD+=($s3)
#    fi
#  done < $1
#}

#addNameIDZYB(){
#  fullName=""
#  while IFS=","; read s1 s2 s3 s4 s5 s6;
#  do
#    let "counter=counter+1"
#    if (( $counter>1 )); then
#      fullName="$s2 $s1"
#      arrNamesZYB+=($fullName)
#      arrIDsZYB+=($s5)
#    fi
#  done < $1
#}


#echo "Script was called with $@"
exit 0
