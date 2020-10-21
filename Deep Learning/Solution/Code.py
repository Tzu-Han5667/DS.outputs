#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 17:39:21 2020

@author: B
"""
import numpy as np
s1=1
s2=9
s3=0
s4=5
s5=6
s6=6
s7=7
#Stest = np.array([s1,s2,s3,s4])
Stest=np.array([[s1, s2, s3, s4, s5, s6, s7],[s2, s3, s4, s5, s6, s7, s1],\
                [s3, s4, s5, s6, s7, s1, s2],[s4, s5, s6, s7, s1, s2, s3]])
Stest=Stest/np.array([2.3,4,1.5,4]).reshape(-1,1)
Xtest = Stest + np.array([4,2,1,0]).reshape(-1,1)


## k-Nearest-Neighbour Classifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_iris
iris=load_iris()
X = iris.data
y = iris.target
X_train, X_test, y_train, y_test = train_test_split(X, y,test_size=0.2, random_state=0)
Xtest_1=[Xtest[:, i] for i in range(7)]


# n_neighbors=3
iris_3 = KNeighborsClassifier(n_neighbors=3).fit(X_train, y_train)
print(iris_3.predict(Xtest_1))
# n_neighbors=7
iris_7 = KNeighborsClassifier(n_neighbors=7).fit(X_train, y_train)
print(iris_7.predict(Xtest_1))

'''
## Discriminant Functions
x = np.array([])
y = np.array([])
a = np.array([1, 0, 0])
b = np.array([s1, s2, s3, s4, s5, s6])
np.transpose(a)
np.transpose(b)
learning_rate = 0.1
#print(np.dot(a,b)
times = 0
#print(len(b))

for i in range(len(a)):
    a_new=[]
    if times < 12:
        for j in range(len(b))     


## Neural Networks_1
sida = -s3
w1 = -s4
w2 = s5
'''
## Neural Networks_2
l_rate = 0.1
#w
sida = -s3
w1 = -s4
w2 = s5
w3 = -s6
w4 = s7
w=np.array([-s3, -s4, s5, -s6, s7])

#t
t=[]
for i in iris.target:
    if i == 0:
        t.append(1)
    else:
        t.append(0)

t=np.array(t).reshape(150,1)        

#x
total_data=[]
for i in iris.data:
    data=[1]
    data.extend(i)
    data=np.array(data)
    total_data.append(data)

x=np.array(total_data) 

#y&w
a=np.array([1,1,1,1,1])
yt=[]
w0=[]
wt=[]
for i in range(len(x)):
    w0.append(w)
    H=np.dot(w, x[i])
    if H<0:
        y=0
    elif H>0:
        y=1
    else:
        y=0.5
    yt.append(y)
    w=w+l_rate*(t[i]-y)*x[i]
    wt.append(w)
   
    z=t[i]-y==0
    if z!=True:
        print(t[i]-y)
        print(w)
   
yt=np.array(yt).reshape(150,1)
w0=np.around(np.array(w0),decimals=6)
wt=np.around(np.array(wt),decimals=6) 

#order
k=np.arange(1,len(iris.data)+1)
k=k.tolist()

#Table
import pandas as pd
result={'w':w0.tolist(),'x':x.tolist(),'y':yt.tolist(),'t':t.tolist(),'w_new':wt.tolist()}
#print(result)
table = pd.DataFrame(data=result,index=k)
#print(table)
## Deep Discriminant Neural Networks
table.to_excel('table.xls')

## Neural Networks_3_Xtest

w=np.array([-2.57, 7.58, -5.28, 7.1])
y=[]
H=[]
for i in range(len(Xtest_1)):
    Ht=np.dot(w, Xtest_1[i])+0.5-(sida)
    if Ht-(-s3)<0:
        yt=0
    elif Ht>0:
        yt=1
    else:
        yt=0.5
    y.append(yt)
    H.append(Ht)
    #print("%s,%s"%(Ht,yt))

print(Xtest_1)
print(H)
print("%s, %s" %(Xtest_1,y))
'''   
c=[]
w_1=[-2.57, 7.58, -5.28, 7.1]
for i in range(7):
    y=np.dot(w,Xtest_1[i])
    print(y)
    if y-(-s3) > 0:
        c.append(1)
    else:
        c.append(0)
        print("%s, %s"%(y,c))
'''

    
    