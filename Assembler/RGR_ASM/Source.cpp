#include <iostream>
#include <vector>
#include <string>
#include <stdio.h>

extern "C" int func(const char* str, int len);

#pragma warning(disable : 4996)

using namespace std;

void main()
{
	const int N = 255;
	const char* str;
	string s;
	str = new char[N];
	int n, count = 0;
	cout << "n=: ";
	cin >> n; 
	cout << "Input text:\n";
	vector <int> vec;
	_flushall();
	while (vec.size() < n)
	{
		getline(cin, s);
		if (s != "")
		{
			count = func(s.c_str(), s.size());
			vec.push_back(count);
		}
		
	}
	cout << "Results:\n";
	for (int i = 0; i < vec.size(); i++)
	{	
		cout << "Line " << i + 1 << ": " << vec[i] << '\n';
	}
	system("pause");
}
