#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 23 16:22:02 2020

@author: B
"""
import imageio
import skimage.color as color 
import matplotlib.pyplot as plt
import skimage.feature as feature
import skimage.filters as filters
import skimage.measure as measure
import skimage.transform as transform


path_list=['plantA_39.jpg','plantB_26.jpg','plantC_15.jpg',\
           'plantA_23.jpg','plantB_51.jpg','plantC_44.jpg']

for i in path_list:
    im = imageio.imread(i)
    img = color.rgb2gray(im)

    #grayscale
    plt.imshow(img, cmap=plt.cm.gray, interpolation='nearest')
    plt.axis('off')
    plt.savefig('(a)%s_grayscale.png'%i)
    
    #B&W
    threshold = filters.threshold_otsu(img)
    binary_img = img > threshold
    
    plt.imshow(binary_img, cmap=plt.cm.gray, interpolation='nearest')
    plt.axis('off')
    plt.savefig('(b)%s_b&w.png'%i)
    
    #edges
    edges = feature.canny(img, sigma=1)

    plt.imshow(edges, cmap=plt.cm.gray, interpolation='nearest')
    plt.axis('off')
    plt.savefig('(c)%s_edges.png'%i)
    
    #contours
    threshold = filters.threshold_otsu(img)
    contours = measure.find_contours(img, threshold)

    for n, contour in enumerate(contours):
        plt.plot(contour[:,1], contour[:,0], 'k-', linewidth=1)
    plt.axis('off')
    plt.savefig('(d)%s_contours.png'%i)  
    
    #green
    
    #straight line
    edges = feature.canny(img, sigma=1)
    lines = transform.probabilistic_hough_line(edges,threshold=30,\
                                               line_length=20,line_gap=3)
    fig,ax0 = plt.subplots(nrows=1, ncols=1,figsize=(8, 3),sharex=True,sharey=True)
    
    for line in lines:
        p0, p1 = line
        ax0.plot((p0[0], p1[0]),(p0[1], p1[1]))
    ax0.set_xlim((0,img.shape[1]))
    ax0.set_ylim((img.shape[0],0))
    plt.savefig('(f)%s_straight_line.png'%i)    