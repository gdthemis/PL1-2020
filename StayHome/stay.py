"""
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
Created on Wed May 13 19:53:49 2020

@author: georgiosthemelis
"""
from collections import deque
import time

start_time = time.time()



def finish (goBack,final):
    x = final[0]
    y = final[1]
    final = []
    while goBack[x][y] != -1 :
        final.append(goBack[x][y])
        if goBack[x][y] == 'R' :
            y = y - 1
        elif goBack[x][y] == 'L' :
            y = y + 1
        elif goBack[x][y] == 'U' :
            x = x + 1
        elif goBack[x][y] == 'D' :
            x = x - 1
    final.reverse()
    return final

def nextSpot (spot): #The order is like that in order to traverse the graph and find the solution in the correct order
    nextspot = []
    if spot[0] + 1 < N and world[spot[0]+1][spot[1]] != 'X' :
        nextspot.append((spot[0]+1,spot[1]))
    
    if spot[1] > 0 and world[spot[0]][spot[1]-1] != 'X' :
        nextspot.append((spot[0],spot[1]-1))
    
    if spot[1] + 1 < M and world[spot[0]][spot[1] + 1] != 'X':
        nextspot.append((spot[0],spot[1]+1))
    
    if spot[0] > 0 and world[spot[0]-1][spot[1]] != 'X':
        nextspot.append((spot[0]-1,spot[1]))
        
    return nextspot

def positionLetter (spot1,spot2): #spot1 is the old spot2 is the next
    if spot1[0] == spot2[0] :
        if spot1[1] == spot2[1] + 1:
            return 'L'
        else: return 'R'
    if spot1[0] == spot2[0] + 1:
        return 'U'
    else: return 'D'
    
# =============================================================================
# MAIN
# =============================================================================
inp = open("stayhome.in10")
world = inp.read().split('\n')[:-1]
airports = []
#print(map1)
N = len(world)
M = len(world[0])
visited = [[-1 for j in range(M)] for i in range(N)]
goBack = [[-1 for j in range(M)] for i in range(N)]

for i in range(N):
    for j in range(M):
        if world[i][j] == 'S':
            sotiris = (i,j)
        elif world[i][j] == 'W':
            start = (i,j)
        elif world[i][j] == 'A':
            airports.append((i,j))
        elif world[i][j] == 'T':
            final = (i,j)
    
q1 = deque([start]) #starting place
q2 = deque(airports) #queue with all the airports
q3 = deque([sotiris]) 
timer = 1
toQ1 = []
toQ2 = []
toQ3 = []
airflag = False
timeReachedAirport = -1
visited[start[0]][start[1]] = 2
visited[sotiris[0]][sotiris[1]] = 1
toBreak = False
jobDone = False

while len(q1) != 0 or len(q2) != 0 or len(q3) != 0 :
    if toBreak == True:
        break
    if timer % 2 == 0 :
        while len(q1) != 0 :
            if toBreak == True:
                break
            spot = q1.popleft()
            nextSpots = nextSpot(spot)
            for x in nextSpots :
                if visited[x[0]][x[1]] == -1 or visited[x[0]][x[1]] == 1 and airflag == False:
                    visited[x[0]][x[1]] = 2 #2 is code for Infected
                    toQ1.append(x)
                if visited[x[0]][x[1]] == -1 and airflag == True:
                    visited[x[0]][x[1]] = 2 #2 is code for Infected
                    toQ1.append(x)
                if world[x[0]][x[1]] == 'A' and airflag == False :
                    airflag = True
                    timeReachedAirport = timer + 5
                if world[x[0]][x[1]] == 'T':
                    print("IMPOSSIBLE")
                    toBreak = True
                    break
        q1 = deque(toQ1)
        toQ1.clear()

    if airflag == True and timer == timeReachedAirport:
        for x in airports:
            if visited[x[0]][x[1]] == -1 :
                visited[x[0]][x[1]] = 2
                toQ2.append(x)
        q2 = deque(toQ2)
        toQ2.clear()
        
    if airflag == True and timer > timeReachedAirport and timer % 2 == 1:
        while len(q2) != 0 :
            if toBreak == True:
                break
            spot = q2.popleft()
            nextSpots = nextSpot(spot)
            for x in nextSpots :
                if visited[x[0]][x[1]] == -1 :
                    visited[x[0]][x[1]] = 2 #2 is code for Infected
                    toQ2.append(x)
                if world[x[0]][x[1]] == 'T' :
                    print("IMPOSSIBLE")
                    toBreak = True
                    break
        q2 = deque(toQ2)
        toQ2.clear()

    if toBreak == True:
        break
    
    while len(q3) != 0:
        if toBreak == True:
            break
        spot = q3.popleft()
        nextSpots = nextSpot(spot)
        for x in nextSpots :
            if visited[x[0]][x[1]] == -1 :
                visited[x[0]][x[1]] = 1 #1 is code for Possible Place that sotiris is now
                toQ3.append(x)
                goBack[x[0]][x[1]] = positionLetter(spot,x)
            if world[x[0]][x[1]] == 'T' :
           #     print("Job Done")
                jobDone = True
                toBreak = True
                break
    q3 = deque(toQ3)
    toQ3.clear()
    timer += 1
#print(timeReachedAirport)
if jobDone :
    print(timer-1)
    print("".join(finish(goBack,final)))
    print(goBack)

print("--- %s seconds ---" % (time.time() - start_time))






























 
                
        