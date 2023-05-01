#include <conio.h>
#include <locale>
#include <iostream>
#include <string>
#define N 50

extern "C" void __fastcall make_string(int val, char* p_line, char* output);

void main()
{

	char* line = new char[N];
	int val;
	std::cout << "Input line: ";
	std::cin >> line;
	std::cout << "Input val: ";
	std::cin >> val;
	char* ans = new char[N*val]; 
	int len = strlen(line);
	if (len != 0)
	{
		make_string(val, line, ans);
		std::cout << ans;
	}
	else std::cout << "Check Input\n";

}
