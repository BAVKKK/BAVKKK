#include "MyForm.h"
#include <Windows.h>

using namespace OTIK3;

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	Application::EnableVisualStyles();
	Application::SetCompatibleTextRenderingDefault(false);
	Application::Run(gcnew MyForm);
	return 0;
}

void file_err(int msg);

System::Void OTIK3 :: MyForm :: START_Click(System::Object^ sender, System::EventArgs^ e)
{
	map <int, vector <int> > alph;
	try
	{
		Create_code(alph);
		string str, code_str;
		input(alph, str);
		vector <vector <int> > inp;
		if (mode_of_work->SelectedIndex == 0)
		{
			code(alph, code_str, str);
		}
		else if (mode_of_work->SelectedIndex == 1)
		{
			decode(alph, inp, str);
		}
		else MessageBox::Show("Выберите режим работы ", "Сообщение системы", MessageBoxButtons::OK, MessageBoxIcon::Question);
	}
	catch (int msg)
	{
		if (msg < 0)
			file_err(msg);
		else
		{
			String^ message = "Результат работы программы:\n" + "\nПрограмма сработала корректно.\n\n";
			if (mode_of_work->SelectedIndex == 1)
			{
				if (msg == 0)
				message += "ОШИБОК НЕ ОБНАРУЖЕНО!\n";
				else
				{
					message += "ОШИБКИ НАЙДЕНЫ\n ";
				}
			}
			MessageBox::Show(message, "Результат ", MessageBoxButtons::OK, MessageBoxIcon::Information);
		}
	}
	


}

void file_err(int msg)
{
	switch(msg)
	{
		case -1:
			MessageBox::Show("Не удалось открыть файл. ", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -2:
			MessageBox::Show("Файл пуст. ", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -3:
			MessageBox::Show("Проверьте корректность ввода. ", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -4:
			MessageBox::Show("Проверьте корректность ввода.\nТакой комбинации символов нет. ", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -5:
			MessageBox::Show("В заданной последовательности содержится ошибка", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		default:
			MessageBox::Show("Неизвестная ошибка", "Сообщение об ошибке ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
	}
}