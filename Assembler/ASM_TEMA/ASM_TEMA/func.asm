.386							 ; Директива для использования набора операций процессора 80386
.MODEL  FLAT, STDCALL			 ; Определяем модель памяти
EXTERN  GetStdHandle@4    :	PROC ; Получение дескриптора.
EXTERN  WriteConsoleA@20  :	PROC ; Вывод в консоль.
EXTERN  CharToOemA@8      :	PROC ; Строку в OEM кодировку.
EXTERN  ReadConsoleA@20   :	PROC ; Ввод с консоли.
EXTERN  ExitProcess@4     :	PROC ; Функция выхода из программы.
EXTERN  lstrlenA@4        : PROC ; Функция определения длины строки.

; макрокомманды.
CODESTR MACRO C_STR:REQ
	LEA EAX, C_STR
	PUSH EAX						
	PUSH EAX
	CALL CharToOemA@8			; Директива CALL вызывает некоторую функцию
ENDM

INPUT MACRO PARAM:REQ
local CONVERT_, NEXT, NEXT1 ; указываем локальные метки
	PUSH 0					; Помещаем 5-й аргумент в стек (резерв).
	PUSH OFFSET LENS		; Помещаем 4-й аргумент в стек (адрес переменной для количества символов). 
	PUSH 200				; Помещаем 3-й аргумент в стек (максимальное количество символов).
	PUSH OFFSET BUF			; Помещаем 2-й аргумент в стек (адрес начала строки для ввода).
	PUSH DIN				; Помещаем 1-й аргумент в стек (дескриптор ввода).
	CALL ReadConsoleA@20

	PUSH OFFSET BUF
	SUB LENS, 2	
	MOV ECX, LENS			; Регистр EСX служит для временного хранения адреса некоторой области данных и используется как счетчик.
	MOV ESI, OFFSET BUF
	XOR EBX, EBX			; Регистр EBX служит для хранения адреса некоторой области данных, а также является вычислительным регистром.
	XOR EAX, EAX

	; Перевод из строки в первое число.
	; Проверяем, отрицательно ли число.
	MOV BL, [ESI]
	CMP BL, '0'	
	JE ERROR
	CMP BL, '-'
	JNE CONVERT_			; Если не минус, то переход сразу к конвертированию.
	SUB LENS, 1				; Если минус, то уменьшить длину строки на 1.
	MOV ECX, LENS 
	INC ESI					; Переход на следующий символ строки (цифру).

	; продолжаем перевод
	CONVERT_:				
	MOV BL,[ESI];сначала проверим что символ >= '0'
	CMP BL,'0'
	JAE NEXT				; если символ >='0' то идем дальше
	JMP ERROR
	NEXT:	
	CMP BL,'9'
	JBE NEXT1				; если символ <='9' то обрабатываем
	JMP ERROR
	NEXT1:
	SUB BL, '0'				; вычитаем '0' чтобы получить число
	MOV EDX, 10 
	MUL EDX  
	ADD EAX, EBX 
	INC ESI 
	LOOP CONVERT_
	MOV PARAM, EAX
ENDM

OUTPUT MACRO buffer:REQ

	PUSH OFFSET buffer
	CALL lstrlenA@4			; Помещаем в EAX количество символов в строке STR_F.
	PUSH 0					; Помещаем 5-й аргумент в стек (резерв).
	PUSH OFFSET LENS		; Помещаем 4-й аргумент в стек (адрес переменной для количиства символов).
	PUSH EAX				; Помещаем 3-й аргумент в стек (количество символов в строке).
	PUSH OFFSET buffer		; Помещаем 2-й аргумент в стек (адрес начала строки для вывода).
	PUSH DOUT				; Помещаем 1-й аргумент в стек (дескриптор вывода).
	CALL WriteConsoleA@20

ENDM

CONVERT_FROM10TOSTR MACRO OPER:REQ
	local START, FUNC1, FUNC2, FUNC3, CONVERTS
	MOV EBX, OPER
	MOV EAX, OPER
	XOR EDI, EDI 
	XOR ECX, ECX
	XOR EDX, EDX

	START:
	CMP EBX, 10
	JAE FUNC1
	JB FUNC2
	FUNC1:
		DIV S_10
		ADD DX, '0'
		PUSH EDX ; кладем данные в стек, для инвертирования
		ADD EDI, 1
		XOR EDX, EDX
		XOR EBX,EBX
		MOV BX, AX
		MOV ECX, 2
	LOOP START
	FUNC2:
	ADD AX, '0'

	FUNC3:
	PUSH EAX ; кладем данные в стек, для инвертирования
	ADD EDI, 1
	MOV ECX, EDI
	CONVERTS:
		POP [ESI]
		INC ESI
	LOOP CONVERTS
	PUSH ' '	
	POP [ESI]
	INC ESI
	OUTPUT BUF
	XOR EAX, EAX
	XOR EBX, EBX
	XOR EDI, EDI
	XOR EDX, EDX
	XOR ECX, ECX
ENDM

.DATA							 ; Директива определяет начало сегмента данных (данные, которые имеют начальное значение)
	STR_F DB "Введите первое число, а затем второе: ", 10, 0
								 ; "10" - переход на новую строку, "0" - завершение строки
								 ; Директива DB - тип данных хранящий 1 байт
	STR_Sec DB "Результат вычиcления: ", 0
	STR_ERR DB "Ошибка. Некорректный ввод.", 0	
								
								; Директива DD - тип данных хранящий 1 DWORD, то есть 4 байта
								; Знак "?" используется для инициализированных(?) данных
	DIN		DD ?				; Дескриптор ввода
	DOUT	DD ?				; Дескриптор вывода
	BUF		DB 200 dup (?)		; Буфер для строк длиной 200 байт
	LENS	DD ?				; Для количества выведенных символов
	FIRST	DD 0
	SECOND	DD 0
	SUM		DD ?
	DIFF	DD ?
	PROD	DD ?
	QUO		DD ?
	S_10	DD 10
	SIGN    DB 0

.CODE							; Директива определяет начало сегмента кода
	MAIN proc					; MAIN - название процедуры, директива proc - описывает процедуру
								; Регистр EAX - служит для временного хранения (аккамулирования) данных
	; Перекодировка STR_F, STR_Sec, STR_ERR
	CODESTR STR_F
	CODESTR STR_Sec
	CODESTR STR_ERR

	; Помещаем дескриптор ввода в DIN
	PUSH -10						
	CALL GetStdHandle@4 
	MOV DIN, EAX

	; Помещаем дескриптор вывода в DOUT
	PUSH -11
	CALL GetStdHandle@4
	MOV DOUT, EAX

	; Выводим строку на экран консоли
	OUTPUT STR_F

	; Ввод первого числа и второго числа.
	INPUT FIRST	
	INPUT SECOND

	; выводим сообщение с результатом.
	OUTPUT STR_Sec

	; сложение.
	MOV EAX, FIRST
	MOV EBX, SECOND
	ADD EAX, SECOND
	MOV SUM, EAX
	MOV ESI, OFFSET BUF ; начало строки хранится в переменной buf
	CONVERT_FROM10TOSTR SUM

	; деление.
	QUOTIENT:
	MOV EAX, FIRST
	MOV EBX, SECOND
	DIV EBX
	MOV QUO, EAX

	; вычитание.
	 MOV EAX, FIRST
	 MOV EBX, SECOND
	 CMP EAX, EBX		; Сравнивем два числа
	 JNB SUBTRACTION	; Если первое число больше или равно, продолжаем, иначе меняем местами со вторым

	SWAP_F_S:
	MOV SIGN, 1
	MOV FIRST, EBX
	MOV SECOND, EAX
	XOR EDX, EDX

	SUBTRACTION:
	MOV EAX, FIRST
	MOV EBX, SECOND
	SUB EAX, EBX
	MOV DIFF, EAX
	MOV ESI, OFFSET BUF; начало строки хранится в переменной buf

	CMP SIGN, 0				; Если результат не отрицательный, 
	JE OUTDIFF				; то выходим, иначе добавляем '-'
	MOV AX, '-'				; 45 - код знака '-'.
	MOV [ESI], AX
	INC ESI

	OUTDIFF:	
	CONVERT_FROM10TOSTR DIFF
	
	; умножение.
	MOV EAX, FIRST
	MUL SECOND
	MOV PROD, EAX
	MOV ESI, OFFSET BUF		; начало строки хранится в переменной buf
	CONVERT_FROM10TOSTR PROD

	; вывод деления.
	MOV ESI, OFFSET BUF		; начало строки хранится в переменной buf
	CONVERT_FROM10TOSTR QUO

	; выход из программы.
	PUSH 0					; параметр: код выхода
	CALL ExitProcess@4

	; В случае ошибки.
	ERROR:
	OUTPUT STR_ERR
	PUSH 0
	CALL ExitProcess@4		; выход

	MAIN ENDP ; Директива ENPD завершает описание процедуры
	END MAIN  ; Директива END завершает программу, MAIN - имя первой выполняемой процедуры
