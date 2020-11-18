awk 'BEGIN{
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
	#Converting emails in gradescope to SIS Login ID
	if((x=index($3, "@")) > 0){
		$3=substr($3,1 ,x-1);
	}
	#Converting column names to Canvas column names
	if(FNR == 1){
		$1 ="Student";
		$2 ="SIS User ID";
		$NF = "Final Score";
	}else{
		$NF=$4
	}
	rmcol(4);
	rmcol(4);
	print $0;
	
	
}' $1 > $2
