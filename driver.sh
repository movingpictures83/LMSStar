#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage Information"
    exit 1
fi

case $1 in
    --gradescopetocanvas | -g2c)
        exec ./Gradescope/gs_to_cvs.sh "$2" "$3" "$4"
        exit
        ;;
    --canvastomoodle | -c2m)
        exec ./Global_Files/canvasToMoodle.sh "$2" "$3"
        exit
        ;;
    --canvastogradescope | -c2g)
        exec ./Canvas/canvas_shell/canvasToGradescope.sh $2 $3 $4
        exit
        ;;
    --extractcanvas | -ec)
        ecargs=""
        for i in "${@:2}"; do
            ecargs+=" $i"
        done
        exec ./Canvas/canvas_shell/extractCanvas.sh $ecargs
        exit
        ;;
    --gradesgradescope | -gg)
        exec ./Gradescope/gradesGradescope.sh $2 $3
        exit
        ;;
    --moodleparser | -mp)
        exec ./Moodle/parser.sh $2 $3
        exit
        ;;
    --extractzybook | -ez)
        exec ./ZyBooks/shell_versions_2/extractZybook.sh $2 $3
        exit
        ;;
    --makefolderszybooks | -mfz)
        mfzargs=""
        for i in "${@:2}"; do
            mzfargs+=" $i"
        done
        exec ./ZyBooks/shell_versions_2/makeFolders.sh mfzargs
        exit
        ;;
    --participationzybooks | -pz)
        exec ./ZyBooks/shell_versions_2/participation.sh 
        exit
        ;;
esac