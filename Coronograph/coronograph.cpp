// A C++ Program to detect cycle in an undirected graph
//https://www.geeksforgeeks.org/graph-implementation-using-stl-for-competitive-programming-set-1-dfs-of-unweighted-and-undirected/
#include<iostream>
#include <list>
#include <limits.h>
#include <sys/resource.h>
#include <vector>
#include <fstream>
#include <algorithm>
using namespace std;
//int counter = 0;
vector<int> cycle;
vector<int> trees1;
vector<unsigned short> incycle;
vector<unsigned short> visited;
class Graph
{
    bool circle = false;
    int V; // No. of vertices
    vector<int> *adj; // Pointer to an array containing adjacency lists
    bool isCyclicUtil(int v, int parent);

public:

    Graph(int V); // Constructor
    void addEdge(int v, int w); // to add an edge to graph
    bool isCyclic(); // returns true if there is a cycle
    int count = 0;
    long int getNodes(int w){ // μετράω τους κόμβους
//        vector<int>::iterator i;
        incycle[w] = true;
        count++;
        for (auto i = adj[w].begin(); i != adj[w].end(); ++i) {
            if (!incycle[*i]){ 
                getNodes(*i);
            }
        }
        return count;
    }
    int sum() // επιστρέφει το ολικό άθροισμα όλων των κόμβων
    {
        int s = 0;
        for (long unsigned int i = 0; i < cycle.size(); i++) {
            count = 0;
            trees1.push_back(getNodes(cycle[i]));
            s += trees1[trees1.size() - 1];
            if (s > V) {
                return -1;
            }
        }
        return s;
    }
    void printing() {
        sort(trees1.begin(), trees1.end());
//        cout << "CORONA " << trees1.size() << endl;
        printf("CORONA ");
        printf("%lu", trees1.size());
        printf("\n");
        for (long unsigned int i = 0; i < trees1.size() - 1; i++) {
//            cout << trees1[i] << " " ;
            printf("%d ", trees1[i]);
        }
//        cout << trees1[trees1.size()-1]<< endl;
        printf("%d", trees1[trees1.size()-1]);
        printf("\n");
    }
};

Graph::Graph(int V)
{
    this->V = V;
    adj = new vector<int>[V];
}

void Graph::addEdge(int v, int w)
{
    adj[v].push_back(w); // Add w to v’s list.
    adj[w].push_back(v); // Add v to w’s list.
}

bool Graph::isCyclicUtil(int v, int parent)
{
    visited[v] = true;
    for (long unsigned int i =  0; i < adj[v].size(); ++i)
    {
        if (!visited[adj[v][i]])
        {
        if (isCyclicUtil(adj[v][i], v))
        {
            if (cycle[0] != adj[v][i] and circle == false) {
                incycle[adj[v][i]] = true;
                cycle.push_back(adj[v][i]);
                return true;
            }
            else
            {
                circle = true;
                return true;
            }
        }
        }
        else if (adj[v][i] != parent )
        {
            cycle.push_back(adj[v][i]);
            incycle[adj[v][i]] = true;
            return true;
        }
    }
    return false;
}

bool Graph::isCyclic()
{
    circle = false;
    visited.clear();
    incycle.clear();
    cycle.clear();
    trees1.clear();
    for(int i = 0; i <V; ++i){
        visited.push_back(false);
        incycle.push_back(false);
    }
    if (isCyclicUtil(0, -1))
        return true;
    return false;
}

int main(int argc, char **argv)
{
//     ifstream inFile;
//       inFile.open(argv[1]);
//        int i = 0;
//        int a, q, e;
//        int b;
//        inFile >> a;
//    for (i = 0; i < a; i++) {
//        inFile >> b;
//        Graph fuck(b);
//        int s = b;
//        inFile >> b;
//        for (int y = 0; y < b ; y++) {
//            inFile >> q;
//            inFile >> e;
//            fuck.addEdge(q-1,e-1);
//        }
    int rec;
    FILE * in = fopen(argv[1], "r");
    fscanf(in, "%d", &rec);
    int q, e, b;
    for (int i = 0; i < rec; i++) {
        fscanf(in, "%d", &b);
        Graph test(b);
        int s = b;
        fscanf(in, "%d", &b);
        for (int y = 0; y < b ; y++) {
            fscanf(in, "%d", &q);
            fscanf(in, "%d", &e);
            test.addEdge(q-1,e-1);
        }
        if (s != b) {
            cout << "NO CORONA" << endl;
            continue;
        }
        else
        {
            if (!test.isCyclic()) {
                cout << "NO CORONA" << endl;
                continue;
            }

            if (test.sum() == b) {
            test.printing();
                continue;
            }
            else
            {
                cout << "NO CORONA" << endl;
                continue;
            }
        }
    }
//       inFile.close();
}

