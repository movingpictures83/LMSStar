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
function addcol(col,i){
	NF++
	for(i=NF; i>col+1; i--){
		$i = $(i-1);	
	}
	$col="ID";
}
{
	#Converting emails in gradescope to SIS Login ID
	if((x=index($3, "@")) > 0){
		$3=substr($3,1 ,x-1);
	}
	#Converting column names to Canvas column names
	if(FNR == 1){
		$1="Student";
		$2="SIS User ID";
		$3="SIS Login ID";
	}
	print $0;
	
	
}
END{print("done")}' $1
