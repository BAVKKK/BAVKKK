#include "HAM.h"

void Create_code(map <int, vector <int> >& alph)
{
	ofstream fout;
	fout.open("output.txt");
	fout << "ALPHABET" << '\n';
	// Генерируем наш алфавит
	dec_to_bin(alph);
	for (int l = 0; l < ALPH2_L; l++) 
	{
		vector<int> letter = alph[l];
		vector<int> res = letter;
		for (int i = 0; i < G.size(); i++) {
			int temp_sum = 0;
			for (int j = 0; j < 5; j++) {
				temp_sum += letter[j] * G[i][j];
			}
			res.push_back(temp_sum % 2);
		}
		alph[l] = res;
		fout << l << ": ";
		for (int k = 0; k < alph[l].size(); k++)
		{
			fout << res[k];
		}
		fout << '\n';
	}
	string mode = "check_correct";
	int i;
	//Проверяем алфавит на наличие ошибок при кодировании
	try
	{	
		for (i = 0; i < ALPH2_L; i++)
		{
			check_code(alph[i], mode);
		}
	}
	catch (int msg)
	{
		if (msg == -6)
		fout << "\nВНИМАНИЕ! В СГЕНЕРИРОВАННОМ АЛФАВИТЕ ЕСТЬ ОШИБКИ! Проверьте слово номер: " << i << '\n';
		else 
			fout << "\nАлфавит сгенерирован ВЕРНО!\n";
	}
	
}

void dec_to_bin(map <int, vector <int> >& alph) 
{

	vector <int> bin;
	for (int i = 0; i < ALPH2_L; i++)
	{
		int temp = i;
		while (temp)
		{
			bin.push_back(temp % 2);
			temp /= 2;
		}
		while (bin.size() < 5)
		{
			bin.push_back(0);
		}
		std::reverse(bin.begin(), bin.end());
		alph[i] = bin;
		bin.clear();
	}

}

void check_code(map <int, vector <int> >& alph) 
{
	vector<vector<int>> result;
	for (int i = 0; i < ALPH2_L; i++) {
		vector<int> res;
		vector<int> t1 = alph[i];
		for (int j = 0; j < H.size(); j++) {
			int sum = 0;
			for (int l = 0; l < t1.size(); l++) {
				sum += t1[l] * H[j][l];
			}
			res.push_back(sum%2);
		}
		result.push_back(res);
	}
} 

void check_code(vector <int>& t1, string& mode)
{
	string syndrom;
	vector<int> res;
	int cnt = 0;
	for (int j = 0; j < H.size(); j++)
	{
		int sum = 0;
		for (int l = 0; l < t1.size(); l++)
		{
			sum += t1[l] * H[j][l];
		}
		if (mode == "check_correct" && sum % 2)
		{
			cnt++;
		}
		else if (mode == "")
		{
			syndrom += to_string(sum % 2);
		}
		res.push_back(sum % 2);
		if (cnt != 0)
			throw - 3;
	}
		
	if (mode == "")
	{
		vector <string> syndroms;
		make_syndroms(syndroms);
		string good = "0000";
		if (syndrom != good)
		{
			for (int i = 0; i < syndroms.size(); i++)
			{
				if (syndrom == syndroms[i])
				{
					mode = to_string(i);
				}
			}
			if (mode == "")
				mode = "ERR";
		}

	}

}

void input(map <int, vector <int> >& alph, string& str_in)
{
	fstream fin;
	fin.open("input.txt");
	if (!fin.is_open()) //Проверка на открываемость файла
		throw - 6;
	else if (fin.peek() == EOF) //Проверка файла на пустоту
		throw - 2;
	getline(fin, str_in);
	fin.close();
}

void code(map <int, vector <int> >& alph, string& code_str, string& str_in)
{
	char symb;
	string val;
	int tt;
	vector <int> temp;
	for (int i = 0; i < str_in.size()+1; i++)
	{
		if (val.size() > 2)
			throw - 3;
		symb = str_in[i];
		if (symb == ' ' || symb == '\0')
		{	
			temp = alph[stoi(val)];
			for (int j = 0; j < WORD_L; j++)
			{
				tt = temp[j];
				code_str += to_string(tt);
			}
			val = "";
		}
		else
		{
			val += symb;
		}		
	}
	ofstream fout;
	fout.open("output.txt", ios::out | ios::app);
	fout << "Закодированная строка\n" << code_str << '\n';
	throw 0;
}

void find_value(map <int, vector <int> >& alph, vector <int> & inp, string& val)
{
	for (int i = 0; i < ALPH2_L; i++)
	{
		if (inp == alph[i])
		{
			val = to_string(i);
		}
	}
}

void decode(map <int, vector <int> >& alph, vector <vector <int> >& inp, string& str_in) // Записываем декодированную последовательность построчно в вектора
{
	ofstream fout;
	fout.open("output.txt", ios::out | ios::app);
	int ERR = 0;
	int j = 0;
	if ( (str_in.size() + 1) % WORD_L == 0)
		throw - 3;
	else
	{
		int dt = str_in.size() / WORD_L;
		inp.resize(dt);
		char symb = str_in[0];
		inp[0].push_back(atoi(&symb));
		for (int i = 1; i < str_in.size(); i++)
		{		
			symb = str_in[i];
			if (i % WORD_L)
			{				
				inp[j].push_back(atoi(&symb));
			}
			else
			{
				j++;
				inp[j].push_back(atoi(&symb));
			}
		}
	}
	string synd ="";
	string val;
	for (int i = 0; i < inp.size(); i++)
	{
		check_code(inp[i], synd);

		if (synd != "")
		{
			ERR++;
			if (synd == "ERR")
			{
				fout << "Невозможно определить позицию!\n";
			}
			else 
			{
				if (inp[i][stoi(synd)])
					inp[i][stoi(synd)] = 0;

				else inp[i][stoi(synd)] = 1;

				find_value(alph, inp[i], val);
				if (val != "")
				{
					fout << "Ошибка в " << (stoi(synd) + 1) << " бите; ";
					fout << "Слова номер: " << i + 1 << '\n';
					val = "";
				}

		
			}
			synd = "";
		}
	}
	fout << "ОТВЕТ:\n";
	for (int i = 0; i < inp.size(); i++)
	{
		val = "";
		find_value(alph, inp[i], val);
		if (val != "")
		{
			fout << val << " ";
		}
		else fout << "_";

	}
	fout << '\n';
	fout.close();
	throw ERR;
}

void make_syndroms(vector <string>& syndroms)
{
	string temp;
	int j = 0;
	for (int i = 0; i < WORD_L; i++)
	{
		temp = to_string(H[0][i]) + to_string(H[1][i]) + to_string(H[2][i]) + to_string(H[3][i]);
		syndroms.push_back(temp);
	}
}