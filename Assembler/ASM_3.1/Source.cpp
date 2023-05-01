#define _CRT_SECURE_NO_WARNINGS
#include <locale>
#include <conio.h>
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>  

using namespace std;

extern "C" float SecantMethod(float eps, int* CountIter, float d);

void main()
{
	setlocale(LC_ALL, "ru");
	float Rez = 0.0; // Переменная для хранения результата
	int Iter = 0;	// Переменная для хранения количества итераций
	cout << "Входные данные:\n";
	cout << "Введите точность: ";

	float eps;
	cin >> eps;
	float d = 0.1;

	Rez = SecantMethod(eps, &Iter, d);	// Вызов функции на языке ассемблера

	cout << "\nРезультат: \n";
	cout << "Количество итераций: " << Iter << "\nОтвет: ";
	cout << setprecision(16) << Rez << '\n';
}
