#! /bin/bash

#echo "WELCOME TO INPUT LOOP"
#QUIT="q"
#i=0
#declare -a arr
#while read input; do
   # arr+=($input)
    #echo "NEED MORE?"
    #if [[ $input =~ q|Q ]]; then
   #     break
  #  fi
  #  echo ${arr[@]}
#done < /dev/tty
#arrToString=`echo ${arr[@]}`
#echo "TEST::::"
#echo $arrToString
string="ROBERTHELLO"
echo $string
name="LILI"
string=${string/ROBERT/$name}
echo $string
combine=$string,$name
echo $combine