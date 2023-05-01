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
	float Rez = 0.0; // ���������� ��� �������� ����������
	int Iter = 0;	// ���������� ��� �������� ���������� ��������
	cout << "������� ������:\n";
	cout << "������� ��������: ";

	float eps;
	cin >> eps;
	float d = 0.1;

	Rez = SecantMethod(eps, &Iter, d);	// ����� ������� �� ����� ����������

	cout << "\n���������: \n";
	cout << "���������� ��������: " << Iter << "\n�����: ";
	cout << setprecision(16) << Rez << '\n';
}
