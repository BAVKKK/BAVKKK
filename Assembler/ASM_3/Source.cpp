#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <conio.h>
#include <locale.h>
extern "C" float __stdcall sec(float eps, int* i);

void main()
{
	setlocale(0, "");
	int i = 1;
	float eps;
	float x;
	printf("��������� ����� ���:\nx + ln(x + 0.5) - 0.5 = 0\n[a,b] = [0,2]\n");
	printf("������� Eps: ");
	scanf("%f", &eps);
	x = sec(eps, &i);
	printf("����� x = %f\n", x);
	printf("���������� �������� i = %d\n", i);
	_getch();
}