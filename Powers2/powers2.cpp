//
//  main.cpp
//  Ask1
//
//  Created by Georgios Themelis on 4/4/20.
//  Copyright © 2020 Georgios Themelis. All rights reserved.
// https://stackoverflow.com/questions/14516915/read-numeric-data-from-a-text-file-in-c/14517130 gia to diavasma file
//

#include <iostream>
#include <cmath>
#include <vector>
#include <map>
#include <fstream>
#include <string>

using namespace std;

vector<int> seira (int N, int K)
{
    int x = 0, sum = K, temp = 1;
    vector<int> exponents(K+400, 0);
//    map<int,int> lista;
//    for (int i = 0; i < K; i++) {
//        lista[i] = 0;
//    }
    vector<int> empty(1,-1);
    for (int i = 0; i < K; i++) {
        x = 1;
        temp = 1;
        while (sum + temp < N + 1) {
            sum += temp;
            temp = pow(2,x);
            x++;
            }
        exponents[x - 1] ++;
//        cout << x << endl;
        
     }
    if (sum == N) {
        return exponents;
    }
    else{
        return empty;
    }
}


int main(int argc, const char * argv[]) {
   ifstream inFile;
   inFile.open(argv[1]);
    int i = 0;
    int a;
    vector<int> pinakas;
    while (inFile >> a) {
        pinakas.push_back(a);
//        cout << pinakas[i] <<endl;
        i++;
    }
   inFile.close();
    int j = 1;
    for (i = 0; i < pinakas[0]; i++) {
//        cout << pinakas[i] <<endl;
    vector<int> test;
    test = seira(pinakas[j], pinakas[j+1]);
    if (test[0] == -1) {
        cout <<"[]" <<endl;
    }
    else
    {
    while(test.size() > 0) {
        if (test[test.size() - 1] == 0) {
            test.erase(test.end()-1);
        }
        else
            break;
    }
    cout<<"[";
    for (long unsigned int i = 0; i < test.size() - 1; i++) {
        cout << test[i] << ",";
    }
    cout << test[test.size()-1] <<"]"<<endl;
//    cout << test[0] << endl;
        }
        j += 2;
    }
//    for (i = 0; i < pinakas.size(); i++) {
//        cout << pinakas[i] <<endl;
//    }
    return 0;
}
