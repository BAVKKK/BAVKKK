#include <conio.h>
#include <locale>
#include <iostream>
#define N 50

extern "C" int find_position(char* p_line, int p_len_2, char* p_line_2, int p_len);

void main()
{

	char* line = new char[N];
	char* order = new char[N];
	std::cout << "Input line and order: ";
	std::cin >> line;
	std::cout << "Input order: ";
	std::cin >> order;
	if (strlen(line) != 0 && strlen(order) != 0)
	{
		int ans = find_position(line, strlen(order), order, strlen(line)); 
		if (ans == 0)
			std::cout << "Order not found\n";
		else std::cout << "Counter is: " << ans << '\n';
	}
	else std::cout << "Check Input\n";
}

