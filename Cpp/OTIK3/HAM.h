#pragma once
#include <iostream>
#include <vector>
#include <map>
#include <list>
#include <string>
#include <fstream>
#include <math.h>

#define ALPH2_L 32
#define WORD_L 9
using namespace std;

const int ALPHABET[ALPH2_L] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
const vector<int> H1 = {0,0,0,0,1,1,0,0,0};
const vector<int> H2 = {0,1,1,1,0,0,1,0,0};
const vector<int> H3 = {1,0,1,1,0,0,0,1,0};
const vector<int> H4 = {1,1,0,1,1,0,0,0,1};
const vector<vector<int>> H = { H1, H2, H3, H4 };


const vector<int> G1 = { 0,0,0,0,1 };
const vector<int> G2 = { 0,1,1,1,0 };
const vector<int> G3 = { 1,0,1,1,0 };
const vector<int> G4 = { 1,1,0,1,1 };
const vector<vector<int>> G = { G1, G2, G3, G4 };


void check_code(map <int, vector <int> >& alph);
void check_code(vector <int>& t1, string & mode);
void Create_code(map <int, vector <int> >& alph);
void dec_to_bin(map <int, vector <int> >& alph);
void input(map <int, vector <int> >& alph, string& str_in);
void code(map <int, vector <int> >& alph, string& code_str, string& str_in);
void find_value(map <int, vector <int> >& alph, vector <vector <int> >& inp, string& val);
void decode(map <int, vector <int> >& alph, vector <vector <int> >& inp, string& str_in);
void make_syndroms(vector <string>& syndroms);
