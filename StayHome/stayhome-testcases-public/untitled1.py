#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 15 23:16:01 2020

@author: georgiosthemelis
"""

from collections import deque
import sys
#-----------------------------------------------------BASIC IDEA-------------------------------------------------------#
# get index of Sotiris and virus and place each (x,y) tuple to a queue(Sotiris queue and virus queue). Then do a while 
# loop until S replaced T or W replaced T. In each iteration we move Sotiris to every possible position(U,D,L,R). Every
# two times Sotiris is moved, virus is also moved. If virus gets into one Airport, after 5 sec, the virus is spread to
# every airport. Virus moves one block every 2 sec. Each time Sotiris/Virus moves to every possible direction, we 
# store the (x,y) coordinates to its queue(Sotiris queue and Virus queue). To make a next move we always get the (x,y)
# coordinates from the queue. We also update previous array, which at the end have the answer.
# rounds array has in (x,y) pos the number of round that particular block was changed.
#---------------------------------------------------END BASIC IDEA-----------------------------------------------------#

#----------------READ INPUT FILE----------------#
inputfile = open('stayhome.in1')
getInput = inputfile.read().split('\n')[:-1]
#----------------END READ INPUT-----------------#

#-------------------INIT N,M,TABLES--------------------#
N = len(getInput)
M = len(getInput[0])
t = 0
reached = False
activated = 0
airports_deque = deque()
s_deque = deque()
virus_deque = deque()
globe = [[0 for j in range(M)] for i in range(N)]
previous = [[0 for j in range(M)] for i in range(N)]
rounds = [[0 for j in range(M)] for i in range(N)]

#----------------------END INIT------------------------#

def validMove(x,y,idx,move):
    print("ayta einai ta x y",x,y,idx,move)
    if ((x < 0) or (x >= N) or (y < 0) or (y >= M)):
        return
    if(globe[x][y] == 'X'):
        return

    if(idx == 'S' or idx == 'Z'):
        if(globe[x][y] == 'T'):
            previous[x][y]=move
            rounds[x][y] = t
            global reached
            reached = True
        elif(globe[x][y] == '.'):
            globe[x][y] = 'S'
            rounds[x][y] = t
            previous[x][y] = move
            s_deque.append((x,y))
        elif(globe[x][y] == 'A'):
            globe[x][y] = 'Z'
            rounds[x][y] = t
            previous[x][y] = move
            s_deque.append((x,y)) 
        elif((globe[x][y] == 'S' or globe[x][y] == 'Z') and rounds[x][y]==t):
            previous[x][y] = move 
        return   
    
    if(idx == 'W'):
        if(globe[x][y] == 'T'):
            print('IMPOSSIBLE')
            sys.exit()
        elif(globe[x][y] == 'S' or globe[x][y] == '.'):
            globe[x][y] = 'W'
            virus_deque.append((x,y))
        elif(globe[x][y] == 'Z' or globe[x][y] == 'A'):
            globe[x][y] = 'W'
            airports_deque.remove((x,y))
            virus_deque.append((x,y))
            global activated
            activated = 1
        return

    if(idx == 'I'):
        if(globe[x][y] == 'T'):
            print('IMPOSSIBLE')
            sys.exit()
        elif(globe[x][y] == 'S' or globe[x][y] == '.'):
            globe[x][y]='I'
            airports_deque.append((x,y))
        return

def spread(x,y):
    #print("spread me x,y ",x,y)
    #print('x,y',x,y)
    validMove(x+1,y,globe[x][y],'D')
    validMove(x,y-1,globe[x][y],'L')
    validMove(x,y+1,globe[x][y],'R')
    validMove(x-1,y,globe[x][y],'U')
    
    

for i in range(N):
    for j in range(M):
        if(getInput[i][j] == 'A'):
            airports_deque.append((i,j))
        if(getInput[i][j] == 'S'):
            s_deque.append((i,j))
        if(getInput[i][j] == 'W'):
            virus_deque.append((i,j))
        globe[i][j] = getInput[i][j]

#reached = False

while(not reached):
    #print("reached einai:",reached)
    if(t % 2 == 1):
        for k in range (len(virus_deque)):
            x,y = virus_deque.popleft()
            spread(x,y)

    if((activated >= 6) and (activated % 2 == 0)):
        print("len of Is",len(airports_deque))
        length_airport = len(airports_deque)
        for k in range (length_airport):
            x,y = airports_deque.popleft()
            if(globe[x][y]=='A' or globe[x][y]=='Z' or globe[x][y]=='S'):
                globe[x][y]='I'
                airports_deque.append((x,y))
            else:
                #print("stelno stin spread ta x,y:",x,y)
                spread(x,y)


    for k in range (len(s_deque)):
        x,y = s_deque.popleft()
        spread(x,y)
    
    if(activated > 0):
        activated+=1

    t+=1
    print(t-1)
    print("lista me aerodromia",airports_deque)
    for l in range(N):
        print(globe[l])
    print("\n")
    

#print(globe)