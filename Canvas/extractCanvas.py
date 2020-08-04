import sys
file = open(sys.argv[1], 'r') # First argument, file
column = int(sys.argv[2])  # Second argument, column number

file.readline()
for line in file:
   entries = line.split(',')
   print entries[0], entries[column]

