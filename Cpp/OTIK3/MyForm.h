#pragma once
#include "HAM.h"


namespace OTIK3 {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	/// <summary>
	/// Сводка для MyForm
	/// </summary>
	public ref class MyForm : public System::Windows::Forms::Form
	{
	public:
		MyForm(void)
		{
			InitializeComponent();
			//
			//TODO: добавьте код конструктора
			//
		}

	protected:
		/// <summary>
		/// Освободить все используемые ресурсы.
		/// </summary>
		~MyForm()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::Button^ START;
	private: System::Windows::Forms::Label^ label1;
	private: System::Windows::Forms::ComboBox^ mode_of_work;
	protected:

	private:
		/// <summary>
		/// Обязательная переменная конструктора.
		/// </summary>
		System::ComponentModel::Container ^components;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Требуемый метод для поддержки конструктора — не изменяйте 
		/// содержимое этого метода с помощью редактора кода.
		/// </summary>
		void InitializeComponent(void)
		{
			System::ComponentModel::ComponentResourceManager^ resources = (gcnew System::ComponentModel::ComponentResourceManager(MyForm::typeid));
			this->START = (gcnew System::Windows::Forms::Button());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->mode_of_work = (gcnew System::Windows::Forms::ComboBox());
			this->SuspendLayout();
			// 
			// START
			// 
			this->START->BackColor = System::Drawing::Color::WhiteSmoke;
			this->START->Location = System::Drawing::Point(261, 382);
			this->START->Name = L"START";
			this->START->Size = System::Drawing::Size(242, 63);
			this->START->TabIndex = 0;
			this->START->Text = L"LET GO!";
			this->START->UseVisualStyleBackColor = false;
			this->START->Click += gcnew System::EventHandler(this, &MyForm::START_Click);
			// 
			// label1
			// 
			this->label1->BackColor = System::Drawing::Color::Transparent;
			this->label1->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 16, System::Drawing::FontStyle::Regular, System::Drawing::GraphicsUnit::Point,
				static_cast<System::Byte>(204)));
			this->label1->Location = System::Drawing::Point(255, 22);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(284, 38);
			this->label1->TabIndex = 1;
			this->label1->Text = L"<SVYATAZAR 3.0>";
			// 
			// mode_of_work
			// 
			this->mode_of_work->FormattingEnabled = true;
			this->mode_of_work->Items->AddRange(gcnew cli::array< System::Object^  >(2) { L"Кодирование", L"Декодирование" });
			this->mode_of_work->Location = System::Drawing::Point(261, 186);
			this->mode_of_work->Name = L"mode_of_work";
			this->mode_of_work->Size = System::Drawing::Size(242, 24);
			this->mode_of_work->TabIndex = 2;
			// 
			// MyForm
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(8, 16);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->BackColor = System::Drawing::SystemColors::Control;
			this->BackgroundImage = (cli::safe_cast<System::Drawing::Image^>(resources->GetObject(L"$this.BackgroundImage")));
			this->BackgroundImageLayout = System::Windows::Forms::ImageLayout::Stretch;
			this->ClientSize = System::Drawing::Size(756, 470);
			this->Controls->Add(this->mode_of_work);
			this->Controls->Add(this->label1);
			this->Controls->Add(this->START);
			this->FormBorderStyle = System::Windows::Forms::FormBorderStyle::Fixed3D;
			this->MaximizeBox = false;
			this->Name = L"MyForm";
			this->Text = L"MyForm";
			this->Load += gcnew System::EventHandler(this, &MyForm::MyForm_Load);
			this->ResumeLayout(false);

		}
#pragma endregion
	private: System::Void MyForm_Load(System::Object^ sender, System::EventArgs^ e) {
	}
	private: System::Void START_Click(System::Object^ sender, System::EventArgs^ e);
	};
}
