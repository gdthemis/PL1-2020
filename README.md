# PL1-2020
My solutions to 2020 exercises 

Contains the solutions and some testcases.

## Problem Set 1 :

### Powers2 :

Given a positive integer number n and a positive integer k, find a representation of n such that n is a sum of k powers of 2. If you have more than one choice use the lexicogaraphically shorter solution.
The output should be in this way :
inp : n = 42, k = 6 => 2^5 + 2^4 + 2^1 + 2^1 + 2^0 + 2^0 => [2,2,1,0,0,1]

Languages : c++, Standard ML of New Jersey, Prolog

### Coronographs :

Given a graph G, determine if the graph is a Coronograph.

A coronograph is a graph that has one cycle and on every node of the cycle there should be a tree with at least one node (including the root).

Languages : C++, Standard ML of New Jersey

## Problem Set 2 :

### Stay Home :

Given a map of the world, that contains obstacles, paths, Airports and corona virus contaminated places, find a way to reach the final destination without being infected. You can walk on the map one step every second. Corona virus is expanding to every neighbour place every 2 seconds but, if corona virus reaches an airport, after 5 seconds all airports will be contaminated. 

Languages : Python 3, Standard ML of New Jersey, Java

## Problem Set 3 :

### Vaccine

Given a 2 stacks, one empty and one loaded with the letters "A", "C", "G", "U", find a way to move all the elements of the loaded stack to the empty one, so that the letters will be grouped. You have three available moves :

"p" : will push the top element of the loaded stack to the other.

"c" : will transform all the letters of the loaded stack to their complements (from the RNA basis, A <-> U, C <-> G).

"r" : will reverse the initally empty stack.

You should find the most efficient way to do it, which means you need to do as less moves as you can. 

Languages : Python 3, Java
