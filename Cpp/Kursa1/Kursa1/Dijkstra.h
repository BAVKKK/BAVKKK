#pragma once
#ifndef QUEEN_H
#define QUEEN_H
int const Inf = 1000000000;
int** EmptyRoads(int** r, int n);
int** newgraph(int** rw, int** rd, int** ed, int n);
int Isolation(int** ed, int n, int A, int B);
int** ActualRoad(int** ar, int** rw, int** rd, int** ed, int n);
int* ThisIsTheWay(int* sh, int** ed, int n);
int* BuildWay(int** ed, int* sh, int n, int A, int B, int** ar, int* v);

#endif QUEEN_H