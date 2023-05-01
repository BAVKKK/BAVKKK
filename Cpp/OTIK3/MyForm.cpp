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
		else MessageBox::Show("�������� ����� ������ ", "��������� �������", MessageBoxButtons::OK, MessageBoxIcon::Question);
	}
	catch (int msg)
	{
		if (msg < 0)
			file_err(msg);
		else
		{
			String^ message = "��������� ������ ���������:\n" + "\n��������� ��������� ���������.\n\n";
			if (mode_of_work->SelectedIndex == 1)
			{
				if (msg == 0)
				message += "������ �� ����������!\n";
				else
				{
					message += "������ �������\n ";
				}
			}
			MessageBox::Show(message, "��������� ", MessageBoxButtons::OK, MessageBoxIcon::Information);
		}
	}
	


}

void file_err(int msg)
{
	switch(msg)
	{
		case -1:
			MessageBox::Show("�� ������� ������� ����. ", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -2:
			MessageBox::Show("���� ����. ", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -3:
			MessageBox::Show("��������� ������������ �����. ", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -4:
			MessageBox::Show("��������� ������������ �����.\n����� ���������� �������� ���. ", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		case -5:
			MessageBox::Show("� �������� ������������������ ���������� ������", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
		default:
			MessageBox::Show("����������� ������", "��������� �� ������ ", MessageBoxButtons::OK, MessageBoxIcon::Error);
			break;
	}
}