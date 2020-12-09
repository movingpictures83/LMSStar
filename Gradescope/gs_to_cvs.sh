#!/bin/bash

#Usage: ./gs_to_cvs.sh (input filename) (output filename) (exam name)
#Example: ./gs_to_cvs.sh example/example1.csv example/output.csv Exam3

#$1 = input filename
#$2 = output filename
#$3 = exam name

if [ "$#" -ne 3 ]; then
	echo "Usage: 3 arguments required. Inputfile, Outputfile name, and exam name"
	exit 2;
fi

if [  ! -f "$1" ]; then
	echo "Input file invalid";
	exit 2;
fi

awk -v var="$3" 'BEGIN{
	FS=",";
	OFS=",";
	fields[""]="";
}
function rmcol(col, i){
	for(i=col; i<NF; i++){
		$i = $(i+1);
	}
	NF--;
}
{
	#Converting column names to Canvas column names
	if(FNR == 1){
		$1 ="Student";
		$2 ="SIS User ID";
		$4 = var " Final Score";
	}else{
		$NF=$4;
		$4 = $NF;
	}

	
	while(NF>4){
		rmcol(NF);
	}
	print $0;
	
	
}' $1 > $2
