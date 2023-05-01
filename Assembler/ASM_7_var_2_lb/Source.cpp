#include <iostream>
#include <conio.h>
#include <locale>

#define N 50

extern "C" int __fastcall make_string(int len, char* p_line, char* inv);

int main()
{
	char* line = new char[N];
	std::cout << "Input line: ";
	std::cin >> line;
	int len = strlen(line);
	char* inv = new char[N];
	if (len != 0)
	{
		if (make_string(len, line, inv))
		{
			std::cout << "Equal\n";
		}
		else std::cout << "Not equal\n";

	}
	else std::cout << "Check Input\n";

	return 0;
}
