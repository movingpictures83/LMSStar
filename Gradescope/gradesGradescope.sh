#Usage: ./gradesGradescope.sh (filename) (outputfile)
#Example: ./gradesGradescope.sh example/example1.csv testOutput.txt
#$1 = filename
#$2 = outputfile

if [ $# -lt 2 -o $# -gt 2 ]
    then
        echo "Usage: ./gradesGradescope.sh (filename) (outputfile)";
        exit 2;
fi

if (! test -e $1)
    then
        echo "FILE DOES NOT EXIST"
        exit 1
    else
        awk -F, '(NR > 1) {printf("%s \t %s \n", $1, $4);}' $1 >> $2
fi