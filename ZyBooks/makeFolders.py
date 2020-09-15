# Usage: Python makeFolders.py (root directory) (course) (exam) (n=number of sections) (section 1)...(section n) (dates, arbitrarily long)
import os
import sys

rootdir = sys.argv[1]
course = sys.argv[2]
exam = sys.argv[3]
sections = []
for i in range(1, int(sys.argv[4])+1):
   sections.append(sys.argv[4+i])

dates = []
for i in range(5, len(sys.argv)):
   dates.append(sys.argv[i])

course = rootdir+course
if not os.path.exists(course):
   os.mkdir(course)
os.mkdir(course+"/"+exam)

for section in sections:
   os.mkdir(course+"/"+exam+"/"+section)

   for date in dates:
      os.mkdir(course+"/"+exam+"/"+section+"/"+date)
      os.mkdir(course+"/"+exam+"/"+section+"/"+date+"/classtime")
      os.mkdir(course+"/"+exam+"/"+section+"/"+date+"/exam")
