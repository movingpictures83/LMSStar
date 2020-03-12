# Pass first file, second file, output file, participation column number
#firstfile = open(sys.argv[1], 'r')
#secondfile = open(sys.argv[2], 'r')
#outputfile = open(sys.argv[3], 'w')
#partcol = int(sys.argv[4])
import os
import sys

partcol = 7
examdir = sys.argv[1]

grades = dict()
students = dict()
studentids = set()


for targetdir in os.listdir(examdir):
 dates = os.listdir(examdir+"/"+targetdir)
 countsum = 0.0
 for date in dates:
   zybookfile = os.listdir(examdir+"/"+targetdir+"/"+date+"/classtime")[0]  # Needs to be only one file there
   firstfile = open(examdir+"/"+targetdir+"/"+date+"/classtime/"+zybookfile)
   zybookfile = os.listdir(examdir+"/"+targetdir+"/"+date+"/exam")[0]  # Needs to be only one file there
   secondfile = open(examdir+"/"+targetdir+"/"+date+"/exam/"+zybookfile)
   header = firstfile.readline().split(',')
   partheader = header[partcol]
   count = int(partheader[partheader.find('(')+1:partheader.find(')')])
   #outputfile.write(count+"\n")

   secondfile.readline()
   for line in firstfile:
     contents = line.split(',')
     lastname = contents[0]
     firstname = contents[1]
     studentid = contents[4]
     studentids.add(studentid)
     score = float(contents[partcol])
     contents2 = secondfile.readline().split(',')
     score2 = float(contents2[partcol])
     #overallscore = score + .75*(score2-score)
     if (not grades.has_key(studentid)):
        grades[studentid] = 0
        students[studentid] = lastname+","+firstname
     #print students[studentid], score, score2, count, date
     grades[studentid] += (score + .75*(score2-score))*count
     #outputfile.write(lastname+','+firstname+','+str(overallscore)+'\n')
   countsum += count


records = []
for currid in studentids:
   records.append((students[currid].upper(), grades[currid] / countsum))

records.sort()

for record in records:
   print record[0]+":", record[1]
