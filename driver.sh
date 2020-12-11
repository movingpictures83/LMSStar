#!/bin/bash

#USAGE: ./driver.sh -g2c (input filename) (output filename) (exam name) #Example: ./driver.sh -g2c example/example1.csv example/output.csv Exam3

if [ $# -eq 0 ]; then
    echo "Usage Information contained in man page. Can be accessed with: -m flag"
    exit 1
fi

case $1 in
    --gradescopetocanvas | -g2c)
        exec ./Gradescope/gs_to_cvs.sh "$2" "$3" "$4"
        exit 2
        ;;
    --canvastomoodle | -c2m)
        exec ./Global_Files/canvasToMoodle.sh "$2" "$3"
        exit 2
        ;;
    --canvastogradescope | -c2g)
        exec ./Canvas/canvas_shell/canvasToGradescope.sh $2 $3 $4
        exit 2
        ;;
    --extractcanvas | -ec)
        ecargs=""
        for i in "${@:2}"; do
            ecargs+=" $i"
        done
        exec ./Canvas/canvas_shell/extractCanvas.sh $ecargs
        exit 2
        ;;
    --gradesgradescope | -gg)
        exec ./Gradescope/gradesGradescope.sh $2 $3
        exit 2
        ;;
    --moodleparser | -mp)
        exec ./Moodle/parser.sh $2 $3
        exit 2
        ;;
    --extractzybook | -ez)
        exec ./ZyBooks/shell_versions_2/extractZybook.sh $2 $3
        exit 2
        ;;
    --makefolderszybooks | -mfz)
        mfzargs=""
        for i in "${@:2}"; do
            mzfargs+=" $i"
        done
        exec ./ZyBooks/shell_versions_2/makeFolders.sh mfzargs
        exit 2
        ;;
    --participationzybooks | -pz)
        pzargs=""
        for i in "${@:2}"; do
            pzargs+=" $i"
        done
        exec ./ZyBooks/shell_versions_2/participation.sh pzargs
        exit 2
        ;;
    --manpage | -m)
        exec man -l man1/driver.1.gz
        exit 2
        ;;
esac

echo "Invalid flag"
exit 1