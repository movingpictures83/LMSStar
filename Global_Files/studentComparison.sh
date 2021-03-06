#!/bin/bash

#USAGE: ./studentComparison.sh (Canvas File) (Moodle File) [Gradescope file] [ZyBooks file]
#NEEDS AT LEAST ONE MAIN LMS FILE (CANVAS/MOODLE), AND A MINUMUM OF 2 FILES TO COMPARE
#FILES CAN BE IN ANY ORDER, AS LONG AS THE MAIN LMS FILES ARE GIVEN FIRST

USAGE="./studentComparison.sh -c (Canvas File) -m (Moodle File) -g [Gradescope file] -z [ZyBooks file]"
NOFILE=" doesn't exist"


###Current functionality###
#Verifies that files exists
#Verifies that emails are legitimate
#Verifies that names only contains a-z
#Verifies that ID's match


###Things left###
#Manpage
#Include in main script


arrNamesCANV=()
arrIDsCANV=()
arrNamesMOOD=()
arrIDsMOOD=()
arrNamesZYB=()
arrIDsZYB=()
counter=0
emailErrors=0
nameErrors=0
idErrors=0
missingID=0
cFlag=0
zFlag=0
mFlag=0

#Gets and reports errors
getErrorCount(){

  if (( $emailErrors==0 )); then
    echo "Student's emails legitimate"
  else
    echo "Not all student's emails legitimate"
  fi
  if (( $missingID==0 )); then
    echo "Student's ID's matching"
  else
    echo "Not all student's ID's legitimate"
  fi
  if (( $nameErrors==0 )); then
    echo "Student's names's legitimate"
  else
    echo "Not all student's name's legitimate"
  fi
}

#Verifies that names only contains a-z/A-Z
nameVerify(){

    if [[ $mFlag == 1 ]] ; then
      for value in "${arrNamesMOOD[@]}"
      do

        if [[ $value =~ ^[a-zA-Z]+$ ]];then
          :
        else
          echo "Invalid student name: $value"
          let "nameErrors=nameErrors+1"
        fi
      done
    fi

    if [[ $cFlag == 1 ]]; then
      for value in "${arrNamesCANV[@]}"
      do
        if [[ $value =~ ^[" "a-zA-Z]+$ ]];then
          :
        else
          echo "Invalid student name: $value"
          let "nameErrors=nameErrors+1"
        fi
      done
    fi

    if [[ $zFlag == 1 ]]; then
      for value in "${arrNamesZYB[@]}"
      do
        if [[ $value =~ ^[" "a-zA-Z]+$ ]];then
          :
        else
          echo "Invalid student name: $value"
          let "nameErrors=nameErrors+1"
        fi
      done
    fi


}



#Verifies that emails are legitimate
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
            let "emailErrors=emailErrors+1"
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
            let "emailErrors=emailErrors+1"
        fi
      fi
    done < $1
  fi
}

#Adds students names and ID's to arrays
addNameID(){
  if [[ $2 == "CANVAS" ]] ; then
    counter=0
    while IFS=","; read s1 s2 s3 s4;
    do
      let "counter=counter+1"
      if (( $counter>2 )); then
        arrNamesCANV+=($s1)
        arrIDsCANV+=($s3)
      fi
    done < $1
  elif [[ $2 == "MOODLE" ]]; then
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
    counter=0
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
            addNameID $CANVAS_FILE CANVAS
            #check that file exists
            if ! test -f "$CANVAS_FILE"; then
                echo $CANVAS_FILE $NOFILE
                exit 1
            fi
            cFlag=1
            echo "Canvas file succesfully supplied"
        ;;
        m)
            MOODLE_FILE=${OPTARG}
            addNameID $MOODLE_FILE MOODLE
            emailVerify $MOODLE_FILE MOODLE
            #check that file exists
            if ! test -f "$MOODLE_FILE"; then
                echo $MOODLE_FILE $NOFILE
                exit 1
            fi
            mFlag=1
            echo "Moodle file succesfully supplied"
        ;;
        g)
            GRADESCOPE_FILE=${OPTARG}
            #check that file exists
            if ! test -f "$GRADESCOPE_FILE="; then
                echo $GRADESCOPE_FILE $NOFILE
                exit 1
            fi
            gFlag=1
            echo "Gradescope file succesfully file supplied"
        ;;
        z)
            ZYBOOKS_FILE=${OPTARG}
            addNameID $ZYBOOKS_FILE ZYBOOKS
            emailVerify $ZYBOOKS_FILE ZYBOOKS
            #check that file exists
            #if ! test -f "$ZYBOOKS_FILE="; then
            #    echo $ZYBOOKS_FILE $NOFILE
            #    exit 1
            #fi
            zFlag=1
            echo "Zybook file succesfully supplied"
        ;;
        *)
            echo "INVALID FLAG. ABORTING PROCESS"
            echo $USAGE
            exit 1
        ;;
    esac

done



length1=${#arrIDsZYB[@]}
length2=${#arrIDsCANV[@]}
sortedIDsCANV=()
counterZYB=0
counterCAN=0
#ID and name comparison between Zybook and Canvas (MOODLE don't have studentID)
if(( $cFlag>0 && $zFlag>0)); then
  for value in "${arrIDsZYB[@]}"
  do
    find=0
    ZybID=$value
    ZybName=${arrNamesZYB[counterZYB]}
    CanName=${arrNamesCANV[counterZYB]}
    let "counterZYB=counterZYB+1"
    for value in "${arrIDsCANV[@]}"
    do
      if [ "$ZybID" = "$value" ]; then
        #echo "ID match between student $CanName from Canvas and $ZybName from Zybook record"
        sortedIDsCANV+=($value)
        let "find=find+1"
      fi
    done

    #If array is of equal length but still not finding a match
    #Should be if there is a match on email but not matching ID
    if(( $length1==$length2 && $find==0)); then
      echo "Missing ID match of student $CanName"
      let "missingID=missingID+1"
    fi
  done

fi

nameVerify
getErrorCount
exit 0
