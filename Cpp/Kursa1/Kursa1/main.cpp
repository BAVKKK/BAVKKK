#include "Dijkstra.h"
#include <iostream>
#include <locale.h>
#include <algorithm>
#include <fstream>
using namespace std;


int main()
{
    fstream fin;
    fin.open("input.txt");
    ofstream fout;
    fout.open("out.txt");
    setlocale(LC_ALL, "ru");
	int n;
    fin >> n;
	if (n > 1)
	{
		int A = Inf, B = Inf, i, j;
		string a, b;
		string* town = new string[n]; // Заводим массив стрингов для хранения названий городов
		for (i = 0; i < n; i++)
			fin >> town[i];
		fin >> a >> b;
		for (i = 0; i < n; i++)
		{
			if (a == town[i]) A = i;
			else if (b == town[i]) B = i;
		}
		if (B == Inf || A == Inf)
		{
			fout << "Путешествие закончилось, не успев начаться!";
		}
		else
		{
			string typeroad, town1, town2;
			int townind1, townind2;
			int way;
			int** rw = new int* [n]; //готовим таблицу смежности железных дорог
			for (i = 0; i < n; i++)
				rw[i] = new int[n];
			rw = EmptyRoads(rw, n);
			int** rd = new int* [n];//готовим таблицу смежности шоссейных дорог
			for (i = 0; i < n; i++)
				rd[i] = new int[n];
			rd = EmptyRoads(rd, n);
			while (fin) //Ввод систем дорог
			{
				fin >> typeroad >> town1 >> town2 >> way;
				for (int e = 0; e < n; e++)
				{
					if (town1 == town[e]) townind1 = e;
					else if (town2 == town[e]) townind2 = e;
				}
				if (typeroad == "ЖД")
				{
					if (rw[townind1][townind2] == 0 && way > 0)
					{
						rw[townind1][townind2] = way;
						rw[townind2][townind1] = way;
					}
					else if (way < rw[townind1][townind2] && way > 0)
					{
						rw[townind1][townind2] = way;
						rw[townind2][townind1] = way;
					}
					else if (way < 0) fout << "Проверьте корректность входных данных. Введено неверное расстояние между городами " << town1 << " и " << town2 << '\n';
				}
				else
				{
					if (rd[townind1][townind2] == 0 && way > 0)
					{
						rd[townind1][townind2] = way;
						rd[townind2][townind1] = way;
					}
					else if (way < rd[townind1][townind2] && way > 0)
					{
						rd[townind1][townind2] = way;
						rd[townind2][townind1] = way;
					}
					else if (way < 0) fout << "Проверьте корректность входных данных. Введено неверное расстояние между городами " << town1 << " и " << town2 << '\n';
				}
			}
			int ctrl = 1;
			int** ed = new int* [n]; //составляем таблицу смежности кратчайших дорог
			for (i = 0; i < n; i++)
				ed[i] = new int[n];
			ed = newgraph(rw, rd, ed, n);
			ctrl = Isolation(ed, n, A, B);
			if (ctrl != 0)
			{
				int** ar = new int* [n]; //составляем таблицу актуальны кратчайших дорог
				for (i = 0; i < n; i++)
					ar[i] = new int[n];
				ar = ActualRoad(ar, rw, rd, ed, n);
				int* sh = new int[n]; //Заводим массив для хранения кратчайших расстояний от пункта A
				for (i = 0; i < n; i++)
					sh[i] = Inf;
				sh[A] = 0;
				sh = ThisIsTheWay(sh, ed, n);
				if (sh[B] != Inf)
				{
				fout << "Кратчайшее расстояние от города " << town[A] << " до города " << town[B] << '\n';
				fout << sh[B] << '\n';
					int* v = new int[n]; //Заводим массив для хранения посещенных городов
					for (int i = 0; i < n; i++) v[i] = Inf;
					v = BuildWay(ed, sh, n, A, B, ar, v);
					i = 0;
					while (v[i] != Inf && i != n)
					{
						i++;
					}
					int k = i;
					fout << '\n';
					int act;
					int cnt = 0;
					for (i = 1; i < k - 1; i++)
					{
						act = ar[v[i - 1]][v[i]];
						if (act != ar[v[i]][v[i + 1]])
						{
							fout << "Точка пересадки: " << town[v[i]] << '\n';
							cnt++;
						}
					}
					if (!cnt) fout << "Точек пересадок нет!" << '\n';
					cout << "Программа сработала, беги смотреть результат!";
				}
				else fout << "Лети на самолете, город изолирован от общей системы дорог:)" << '\n';
			}
			else fout << "Лети на самолете, город изолирован от общей системы дорог:)" << '\n';
		}
	}
	else fout << "Ошибка, введено неверное количество городов!";
    return 0;
}