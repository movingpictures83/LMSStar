import sys

filestuff = open(sys.argv[1], 'r')
outfile = open(sys.argv[2], 'w')

outfile.write("\"Full Name\",\"Score\"\n")
for line in filestuff:
   contents = line.split(',')
   outfile.write(contents[0]+"\t"+contents[3]+"\n")
outfile.close()
