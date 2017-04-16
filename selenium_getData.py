from selenium import webdriver
database = {"IM123":[0,1,3,5,5,5,5,2,3,10],"CALCULUS":[20,11,7,9,8,6,6,4,3,8]}
cid="70522200" #演算法課號
PR=0.48
lettergrade={0:"F",1:"C-",2:"C",3:"C+",4:"B-",5:"B",6:"B+",7:"A-",8:"A",9:"A+",}
def addData(courseid):
    a=webdriver.PhantomJS()
    row=[0,0,0,0,0,0,0,0,0,0]
    a.get("http://ntusweety.herokuapp.com/history?&id="+courseid[0:3]+"+"+courseid[3:])
    content=a.find_elements_by_class_name("item")
    for i in content:
        temp=i.text.split(" ")
        for j in range(2,12):
            row[j-2]+=int(temp[j])
    database[courseid]=row


def predictCourseScore(courseid,PR):
    if(courseid not in database):
        addData(courseid)
    person=database[courseid]
    PRRange=[0,0,0,0,0,0,0,0,0,0]
    for i in range(1,10):
        person[i]+=person[i-1]
    for i in range(1,10):
        PRRange[i]=person[i]/person[9]
    grade=0
    for i in range(9,-1,-1):
        if(PR<=PRRange[i]):
            grade=i
    return grade

print(lettergrade[predictCourseScore(cid,PR)])