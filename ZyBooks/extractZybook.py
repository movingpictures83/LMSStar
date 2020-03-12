# Usage: python extractZybook.py (filename) (column number)
# As of this LMSStar release, participation activities are column 6 and challenge are column 7
import sys
file = open(sys.argv[1], 'r')
column = int(sys.argv[2])

for line in file:
   entries = line.split(',')
   print entries[0], entries[1], entries[column]

