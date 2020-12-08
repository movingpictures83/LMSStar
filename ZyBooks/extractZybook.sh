#! /bin/bash

#Usage: ./extractZybook.sh (filename) (column number)
#As of this LMSStar release, participation activities are column 7 and challenge are column 8
#Example ./extractZybook.sh example/CDA3102/UE3/U02/0302/classtime/FIUCDA3102CickovskiSpring2020_report_2020-03-02_1530.csv 7
#$1 = filename
#$2 = column number

case $# in
    0|1) echo "Usage: ./extractZybook.sh (filename) (column number)" 1>&2; exit 2 ;;
esac

if (! test -e $1)
    then
        echo "FILE DOES NOT EXIST"
        exit 1
    else
        awk -F, '(NR > 0) {print $1, $2, $'$2';}' $1
fi
