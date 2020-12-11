#!/bin/bash

#converts from moodle format to canvas

#USAGE: ./moodleToCanvas (Moodle read-from file) (Canvas write-to file)

now=$(date +"%T")
INPUT=$1
studentName=()
ID=()

addValues(){
  counter=0
    while IFS=","; read s1 s2 s3 s4;
    do
      let "counter=counter+1"
      if (( $counter>1 )); then
        name=$s1" "$s2
        studentName+=($name)
        ID+=($s3)
      fi
    done < $INPUT
    IFS=$OLDIFS
}


if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi


addValues $MOODLE_FILE


printf "Student\tID\tSIS USER ID\tSIS Login ID\tSection\tAttendance\n" >> "moodleToCanvas$now.csv"
counter=0
for value in "${studentName[@]}"
do
    printf $value"\t${ID[$counter]}\n">>"moodleToCanvas$now.csv"
    let "counter=counter+1"
done
