#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 27 15:59:28 2020

@author: B
"""

##Classification

import numpy as np
import pandas as pd
table_0 = pd.read_csv("adult.csv")
table_0 = table_0.drop(columns='fnlwgt')

#1
print("1.")
#(i) number of instances
print("(i) number of instances: %s" %len(table_0))

#(ii) number of missing values
missing_val = 0
for i in table_0:
    for j in table_0[i]:
        if pd.isnull(j) == True:
            missing_val += 1
print("(ii) number of missing values: %s" %missing_val)

#(iii) fraction of missing values over all attribute values
print("(iii) fraction of missing values over all attributes: %.4f" %(missing_val/(len(table_0)*len(table_0.keys()))))

#(iv) number of instances with missing values
na_instances = 0
for i in range(len(table_0.index)) :
    if table_0.iloc[i].isnull().sum() != 0:
        na_instances += 1
print("(iv) number of instances with missing values: %s" %na_instances)

#(v) fraction of instances with missing values over all instances
print("(v) fraction of instances with missing values: %.4f"  %(na_instances/len(table_0)))

#2 (Scikit-LearnEncoder)
print("2.")
from sklearn import preprocessing
le = preprocessing.LabelEncoder()
table = table_0.dropna()
table_2 = pd.DataFrame()
for i in table.keys():
    table_2[i] = le.fit_transform(table[i].astype(str)) #transform to numbers
    
for i in table_2.keys():
    le.fit(table_2[i])
    print("Attribute: %s" %i)
    print("Possible values: %s" %set(le.classes_))

#3 (Decision Tree)
print("3.")
from sklearn import tree
from sklearn.model_selection import train_test_split
X = np.array(table_2.iloc[:,0:12])
y = np.array(table_2['class'])
train_X, test_X, train_y, test_y = train_test_split(X, y, test_size = 0.2)
clf = tree.DecisionTreeClassifier().fit(train_X, train_y)
pred_y = clf.predict(test_X)

score = 0
for i in range(len(test_y)):
    if test_y[i] == pred_y[i]:
        score += 1

error_rate = 1 - (1/len(test_y)) * score
print("Error rate: %.4f" % error_rate)

#4 (handling missing values)
print("4.")
# D' set
with_na = table_0[table_0.isna().any(axis=1)]
without_na = table.sample(n = len(with_na))
D = [with_na, without_na]
D = pd.concat(D)

# D1' 
D1 = pd.DataFrame()
for i in D:
    if any(D[i].isna()) == True:
        D1[i] = D[i].fillna('missing')
    else:
        D1[i] = D[i]
        
# D2' 
D2 = pd.DataFrame()
for i in D:
    if any(D[i].isna()) == True:
        pop_value = D[i].mode().item()
        D2[i] = D[i].fillna(value = pop_value)
    else:
        D2[i] = D[i]

# Two Decision tree of D1' & D2'
# D1' dtree error rate
for i in D1.keys():
    D1[i] = le.fit_transform(D1[i].astype(str))
X_1 = np.array(D1.iloc[:,0:12])
y_1 = np.array(D1['class'])
train_X1, test_X1, train_y1, test_y1 = train_test_split(X_1, y_1, test_size = 0.2)
clf1 = tree.DecisionTreeClassifier().fit(train_X1, train_y1)
pred_y1 = clf.predict(test_X1)

score_d1 = 0
for i in range(len(test_y1)):
    if test_y1[i] == pred_y1[i]:
        score_d1 += 1

error_rate_d1 = 1 - (1/len(test_y1)) * score_d1
print("Error rate of D1': %.4f" % error_rate_d1)

# D2' dtree error rate
for i in D2.keys():
    D2[i] = le.fit_transform(D2[i].astype(str))
X_2 = np.array(D1.iloc[:,0:12])
y_2 = np.array(D1['class'])
train_X2, test_X2, train_y2, test_y2 = train_test_split(X_2, y_2, test_size = 0.2)
clf2 = tree.DecisionTreeClassifier().fit(train_X2, train_y2)
pred_y2 = clf.predict(test_X2)

score_d2 = 0
for i in range(len(test_y2)):
    if test_y2[i] == pred_y2[i]:
        score_d2 += 1

error_rate_d2 = 1 - (1/len(test_y2)) * score_d2
print("Error rate of D2': %.4f" % error_rate_d2)

# Comment: According to error rates, D2 has lower error rate, so D2 has higher accuracy

##Clustering
import numpy as np
import pandas as pd
df = pd.read_csv("wholesale_customers.csv")
df = df.drop(columns=['Channel','Region'])

#1 Create table with mean, minimum and maximum
print("1.")
mean = []
i_range = []
attrb = []
for i in df: #i = attb names
    attrb.append(i)
    mean.append(df[i].mean())
    i_range.append([df[i].min(), df[i].max()])
data = {'Mean':mean, 'Range':i_range}
df_1 = pd.DataFrame(data, index=attrb)
print(df_1)


#2
print("2.") 
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from itertools import combinations, permutations

X = np.array(df)
kmeans = KMeans(n_clusters = 3).fit(X)
y_kmeans = kmeans.predict(X)

l = list(np.arange(6))
permutations(l,2)
l = list(combinations(l,2))

for i in l:
    plt.figure(figsize = (10,10))
    plt.scatter(X[:, i[0]], X[:, i[1]], c = y_kmeans, s = 50, cmap = 'viridis')
    plt.xlabel(attrb[i[0]])
    plt.ylabel(attrb[i[1]])
    plt.title('%s & %s' %(attrb[i[0]],attrb[i[1]]))
    plt.savefig('%s with %s .png' %(attrb[i[0]],attrb[i[1]]))
  
#3
print("3.")
from sklearn.cluster import KMeans
from itertools import combinations, permutations

X = np.array(df)
data = np.zeros((3,3), dtype = 'U10')

BC = []
WC = []
Score = []
for k in [3,5,10]:
    kmeans = KMeans(n_clusters = k).fit(X)
    c = kmeans.cluster_centers_
    # Within Cluster        
    for j in range(k): #k=3 or 5 or 10
        wc = 0
        for m in range(len(df)): 
            wc += (np.square(X[m,0]-c[j,0])+np.square(X[m,1]-c[j,1])+np.square(X[m,2]-c[j,2])+np.square(X[m,3]-c[j,3])+np.square(X[m,4]-c[j,4])+np.square(X[m,5]-c[j,5]))
    WC.append(wc)
    
    # Between Cluster
    l = list(np.arange(k))
    permutations(l,2)
    l = list(combinations(l,2))
    bc = 0
    for i in l:
        result = (np.square(c[i[0],0]-c[i[1],0])+np.square(c[i[0],1]-c[i[1],1]))
        bc += result        
    BC.append(bc)

for i in range(3):
    score = BC[i]/WC[i]
    Score.append(score)

data[0,:] = BC
data[1,:] = WC
data[2,:] = Score

df_3 = pd.DataFrame(data, index=['BC','WC','BC/WC'], columns=['k=3','k=5','k=10'])
print(df_3)
  