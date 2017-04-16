# coding=UTF-8
from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.parse import quote
import re

def findID(line):
	for i in range(0,3):
		pos = line.find(',')
		line = line[pos+1:]
	pos = line.find(',') 
	line = line[:pos]
	return line

file =  open("C:\\Users\\user\\Google Drive\\NTU\\Year 2\\OR\\FinalProject\\Outside-1.txt", "a", encoding = "UTF-8")

# main = open("C:\\Users\\user\\Google Drive\\NTU\\Year 2\\OR\\FinalProject\\104-1.txt", "a", encoding = "UTF-8")
count = 0

with open("C:\\Users\\user\\Google Drive\\NTU\\Year 2\\OR\\FinalProject\\104-1.txt", 'r',encoding = "UTF-8" ) as mainCourse:
	for course in mainCourse:
		count = count + 1
		cid = findID(course)
		# print (cid)
		for pageNum in range(1,7):
			with open("C:\\Users\\user\\Google Drive\\NTU\\Year 2\\OR\\FinalProject\\104-1-A" + str(pageNum) + ".txt", 'r',encoding = "UTF-8" ) as f:
				for line in f:
					child_id = findID(line)
					# print (line[:pos])
					if cid == child_id:
						print (cid)
			f.close()
	print (count)
	mainCourse.close()



file.close()

# open another page			
# courseurl = quote(col[16].a['href'], safe="%/:=&?~#+!$,;'@()*[]")		
# coursePage = urlopen(courseurl)
# soup2 = BeautifulSoup(coursePage, "html.parser")
# x = soup2.body.table.tbody.tr.td.findAll('table')
# count = 0
# for row in x[1].findAll('tr'):
# 	if(count == 10):				
# 		col = row.findAll('td')
# 		print (''.join(col[1].getText()))
# 		file.write(col[1].getText())
# 	count = count + 1
# cool constructure
# <table>
#	<td>
#		<table>
#			<td> 
#		<table>
# 		<table>
#           <td> 
#			<td>	
#		<table>
#	<td>
# <table>