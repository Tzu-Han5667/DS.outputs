#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 23 13:20:26 2020

@author: B
"""

import csv
import numpy as np
import pandas as pd
from sklearn.pipeline import Pipeline
from nltk.tokenize import TweetTokenizer
from textblob import TextBlob, Word, Blobber
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import CountVectorizer

#Stopwords
stopword=[]
with open('english-stop-words-large.txt','r') as file:
    files=file.read()
file.close()
stopword=TextBlob(files)

#Book content handling (without stopwords)
tknzr = TweetTokenizer()
book_list=['puck-of-pooks-hill.txt','man-who-would-be-king.txt','kim.txt','just-so-stories.txt',\
           'jungle-book.txt','ginger-pickles.txt','jeremy-fisher.txt','squirrel-nutkin.txt',\
           'benjamin-bunny.txt','peter-rabbit.txt']
bk_list={}
for i in book_list:
    b_k=[]
    with open(i) as book:
        book=csv.reader(book)
        bk=list(book)
        for j in bk:
            for k in j:
                word=tknzr.tokenize(k.strip())
                for l in word:
                    if l not in stopword:
                        b_k.append(l)
    bk_list[i]=b_k


#Computinging statistics for each book
ploarity_dict={}
subjectivity_dict={}
word_ct_dict={}
freq_dict={}
normalised_dict={}
tf_dict={}

for i in book_list:
    with open(i,'r') as file:
        files=file.read()
    file.close()
    blob=TextBlob(files)
    #(a) ploar
    ploarity_dict[i]=round(blob.sentiment.polarity,5)
    #(b) subjectivity
    subjectivity_dict[i]=round(blob.sentiment.subjectivity,5)
    #(c) word count 
    word_ct_dict[i]=len(bk_list[i])
    #(d) most frequent term (word)
    #(e) normalised frequency of most frequent word
    #(f) term frequency
    TOP_MOST =1
    words = {}
    for w in blob.word_counts:
        if (w not in stopword and (w!= '‘') and (w != '”')):
            words[w] = blob.word_counts[w]
    sorted_words = sorted( words, key=words.__getitem__, reverse=True )
    for ( j, w ) in zip( range( TOP_MOST ), sorted_words ):
        freq_dict[i]=w
        normalised_dict[i]=round(blob.word_counts[w]/word_ct_dict[i],5)
        tf_dict[i]=round(blob.word_counts[w]/len(sorted_words),5)

#(g) inverse document frequency
#corpus
corpus=[]
for i in book_list:
    with open(i,'r') as file:
        files=file.read()
        corpus.append(files)
    file.close()

#vocabulary
vocabulary=[]
for i in freq_dict:
    vocabulary.append(freq_dict[i])
vocabulary=list(set(vocabulary))
pipe = Pipeline([('count', CountVectorizer(vocabulary=vocabulary)),('tfid', TfidfTransformer())]).fit(corpus)
idf=list(pipe['tfid'].idf_)
voc=pipe['count'].vocabulary

#idf_dictionary
sum_idf={}
for i in range(len(voc)):
    sum_idf[voc[i]]=idf[i]

#idf with files
idf_dict={}
for i in freq_dict:
    idf_dict[i]=round(sum_idf.get(freq_dict[i]),5)   
    
#(h) TF-IDF
tf_idf_dict={}
for i in tf_dict:
    tf_idf=tf_dict[i]*idf_dict[i]
    tf_idf_dict[i]=round(tf_idf,5)
    
#Table
table_data={}
for i in book_list:
    data=[ploarity_dict[i],subjectivity_dict[i],word_ct_dict[i],freq_dict[i],normalised_dict[i],tf_dict[i],idf_dict[i],tf_idf_dict[i]]
    table_data[i]=data
index_name=['Polarity','Subjectivity','Word Count','Most Frequent Word','Normalised Frequency','TF','IDF','TF-IDF']
df=pd.DataFrame(table_data,index=index_name)