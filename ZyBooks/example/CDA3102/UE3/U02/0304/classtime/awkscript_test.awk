BEGIN{
	print "welcome";
	sum  = 0;
}

$* == "U02"{

	sum = sum + 1;
}
END{
	print "sum: ", sum
	print "bye"

}


