# coding=UTF-8
from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.parse import quote
import re

file =  open("C:\\Users\\user\\Google Drive\\NTU\\Year 2\\OR\\FinalProject\\104-1-new.txt", "a", encoding = "UTF-8")
for pageNum in range(0,600):
	page = urlopen("http://ntusweety.herokuapp.com/search?m=0&m=1&m=2&m=3&m=4&m=5&m=6&m=7&m=8&m=9&m=10&m=A&m=B&m=C&m=D&t=0&t=1&t=2&t=3&t=4&t=5&t=6&t=7&t=8&t=9&t=10&t=A&t=B&t=C&t=D&w=0&w=1&w=2&w=3&w=4&w=5&w=6&w=7&w=8&w=9&w=10&w=A&w=B&w=C&w=D&h=0&h=1&h=2&h=3&h=4&h=5&h=6&h=7&h=8&h=9&h=10&h=A&h=B&h=C&h=D&f=0&f=1&f=2&f=3&f=4&f=5&f=6&f=7&f=8&f=9&f=10&f=A&f=B&f=C&f=D&s=0&s=1&s=2&s=3&s=4&s=5&s=6&s=7&s=8&s=9&s=10&s=A&s=B&s=C&s=D&sem=104-1&faculty=&depart=&name=&teacher=&page=" + str(pageNum))

	soup = BeautifulSoup(page,"html.parser")
	table = soup.find('table',{'class': 'table'})
	for row in table.findAll('tr'):		
		col = row.findAll('td')
		if len(col) >= 12:			
			classType = ''.join(col[3].getText())			
			className = ''.join(col[4].getText())
			classWeight = ''.join(col[5].getText())
			classID = ''.join(col[6].getText())
			classTime = ''.join(col[11].getText())
			while classTime.find('(') >= 0:	
				classTime = classTime[:classTime.find('(')] + classTime[classTime.find(')')+1:]		
			classTime = classTime.replace(',','.')
			classTime = classTime.replace(' ','')		
			file.write(classType + ',' + className + ',' + classWeight + ',' + classID + ',' + classTime )
			file.write('\n')
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