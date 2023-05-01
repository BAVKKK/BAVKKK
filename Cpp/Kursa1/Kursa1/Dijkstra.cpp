#include "Dijkstra.h"
#include <iostream>
#include <locale.h>
#include <algorithm>
#include <fstream>
using namespace std;

int** EmptyRoads(int** r, int n)
{
	int i, j;
	for (i = 0; i < n; i++)
	{
		r[i][i] = 0;
		for (j = i + 1; j < n; j++)
		{
			r[i][j] = 0;
			r[j][i] = r[i][j];
		}
	}
	return r;
}
int** newgraph(int** rw, int** rd, int** ed, int n)
{
	int i, j;
	for (i = 0; i < n; i++)
	{
		ed[i][i] = 0;
		for (j = i + 1; j < n; j++)
		{
			if (rw[i][j] && rd[i][j])
			{
				ed[i][j] = min(rw[i][j], rd[i][j]);
				ed[j][i] = ed[i][j];
			}
			else if (rw[i][j])
			{
				ed[i][j] = rw[i][j];
				ed[j][i] = ed[i][j];
			}
			else
			{
				ed[i][j] = rd[i][j];
				ed[j][i] = ed[i][j];
			}
		}
	}
	return ed;
}
int** ActualRoad(int** ar, int** rw, int** rd, int** ed, int n)
{
	int i, j;
	for (i = 0; i < n; i++)
	{
		ar[i][i] = 0;
		for (j = i + 1; j < n; j++)
		{
			if (ed[i][j] == rw[i][j] && ed[i][j] !=0)
			{
				ar[i][j] = 1;
				ar[j][i] = ar[i][j];
			}
			else if (ed[i][j] == rd[i][j] && ed[i][j] != 0)
			{
				ar[i][j] = 2;
				ar[j][i] = ar[i][j];
			}
			else
			{
				ar[i][j] = 0;
				ar[j][i] = ar[i][j];
			}
			
		}
	}
	return ar;
}
int Isolation(int** ed, int n, int A, int B)
{
	int* check = new int[n];
	int i, j, ctrl = 1;
	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{
			check[i] += ed[i][j];
		}
		if (check[i] == 0 && (i == B || i==A))
		{
			ctrl = 0;
		}
	}
	return ctrl;
}
int* ThisIsTheWay(int* sh, int** ed, int n)
{	
	int i, j;
	int* v = new int[n]; //Заводим массив для хранения посещенных городов, 1 - посещен, 0 - нет
	for (i = 0; i < n; i++)
		v[i] = 0;
	int close, shortway; //Заводим локальные переменные отвечающие за индекс ближайшего города, кратчайшую дорогу, соответсвенно
	do {
		close = Inf;
		shortway = Inf;
		for ( i = 0; i < n; i++)
		{ 
			if ((v[i] == 0) && (sh[i] < shortway)) // Проверяем, посещена ли вершина, и является ли текущий путь до нее кратчайшим
			{ 
				shortway = sh[i]; //Если да, то обновляем данные
				close = i;
			}
		}
		if (close != Inf)
		{
			for ( i = 0; i < n; i++) //Проверяем, является ли новый короткий путь до города, кратчайшим. Сравниваем с прошлым значением. 
			{
				if (ed[close][i] > 0)
				{
					if (shortway + ed[close][i] < sh[i])
					{
						sh[i] = shortway + ed[close][i];
					}
				}
			}
			v[close] = 1;
		}
	} while (close < Inf);
	return sh;
}
int* BuildWay (int**ed, int*sh, int n, int A, int B, int**ar, int* v)
{
  v[0] = B; // начинаем поиск с конца
  int k = 1; 
  int length = sh[B]; // Расстояние до города В

  while (B != A) // Пока не вернулись в первый город
  {
	for (int i = 0; i < n; i++) // просматриваем все города на наличия связи
	  if (ed[i][B] != 0)   
	  {
		if (length - ed[i][B] == sh[i])// определяем длину пути из предыдыдущего города, если длина совпала с полученной, то переход был отсюда
		{                 
			length -= ed[i][B];
		  B = i;       
		  v[k] = i;
		  k++;
		}
	  }
  }
 
  return v;
}