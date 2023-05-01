.386							 ; ��������� ��� ������������� ������ �������� ���������� 80386
.MODEL  FLAT, STDCALL			 ; ���������� ������ ������
EXTERN  GetStdHandle@4    :	PROC ; ��������� �����������.
EXTERN  WriteConsoleA@20  :	PROC ; ����� � �������.
EXTERN  CharToOemA@8      :	PROC ; ������ � OEM ���������.
EXTERN  ReadConsoleA@20   :	PROC ; ���� � �������.
EXTERN  ExitProcess@4     :	PROC ; ������� ������ �� ���������.
EXTERN  lstrlenA@4        : PROC ; ������� ����������� ����� ������.

; �������������.
CODESTR MACRO C_STR:REQ
	LEA EAX, C_STR
	PUSH EAX						
	PUSH EAX
	CALL CharToOemA@8			; ��������� CALL �������� ��������� �������
ENDM

INPUT MACRO PARAM:REQ
local CONVERT_, NEXT, NEXT1 ; ��������� ��������� �����
	PUSH 0					; �������� 5-� �������� � ���� (������).
	PUSH OFFSET LENS		; �������� 4-� �������� � ���� (����� ���������� ��� ���������� ��������). 
	PUSH 200				; �������� 3-� �������� � ���� (������������ ���������� ��������).
	PUSH OFFSET BUF			; �������� 2-� �������� � ���� (����� ������ ������ ��� �����).
	PUSH DIN				; �������� 1-� �������� � ���� (���������� �����).
	CALL ReadConsoleA@20

	PUSH OFFSET BUF
	SUB LENS, 2	
	MOV ECX, LENS			; ������� E�X ������ ��� ���������� �������� ������ ��������� ������� ������ � ������������ ��� �������.
	MOV ESI, OFFSET BUF
	XOR EBX, EBX			; ������� EBX ������ ��� �������� ������ ��������� ������� ������, � ����� �������� �������������� ���������.
	XOR EAX, EAX

	; ������� �� ������ � ������ �����.
	; ���������, ������������ �� �����.
	MOV BL, [ESI]
	CMP BL, '0'	
	JE ERROR
	CMP BL, '-'
	JNE CONVERT_			; ���� �� �����, �� ������� ����� � ���������������.
	SUB LENS, 1				; ���� �����, �� ��������� ����� ������ �� 1.
	MOV ECX, LENS 
	INC ESI					; ������� �� ��������� ������ ������ (�����).

	; ���������� �������
	CONVERT_:				
	MOV BL,[ESI];������� �������� ��� ������ >= '0'
	CMP BL,'0'
	JAE NEXT				; ���� ������ >='0' �� ���� ������
	JMP ERROR
	NEXT:	
	CMP BL,'9'
	JBE NEXT1				; ���� ������ <='9' �� ������������
	JMP ERROR
	NEXT1:
	SUB BL, '0'				; �������� '0' ����� �������� �����
	MOV EDX, 10 
	MUL EDX  
	ADD EAX, EBX 
	INC ESI 
	LOOP CONVERT_
	MOV PARAM, EAX
ENDM

OUTPUT MACRO buffer:REQ

	PUSH OFFSET buffer
	CALL lstrlenA@4			; �������� � EAX ���������� �������� � ������ STR_F.
	PUSH 0					; �������� 5-� �������� � ���� (������).
	PUSH OFFSET LENS		; �������� 4-� �������� � ���� (����� ���������� ��� ���������� ��������).
	PUSH EAX				; �������� 3-� �������� � ���� (���������� �������� � ������).
	PUSH OFFSET buffer		; �������� 2-� �������� � ���� (����� ������ ������ ��� ������).
	PUSH DOUT				; �������� 1-� �������� � ���� (���������� ������).
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
		PUSH EDX ; ������ ������ � ����, ��� ��������������
		ADD EDI, 1
		XOR EDX, EDX
		XOR EBX,EBX
		MOV BX, AX
		MOV ECX, 2
	LOOP START
	FUNC2:
	ADD AX, '0'

	FUNC3:
	PUSH EAX ; ������ ������ � ����, ��� ��������������
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

.DATA							 ; ��������� ���������� ������ �������� ������ (������, ������� ����� ��������� ��������)
	STR_F DB "������� ������ �����, � ����� ������: ", 10, 0
								 ; "10" - ������� �� ����� ������, "0" - ���������� ������
								 ; ��������� DB - ��� ������ �������� 1 ����
	STR_Sec DB "��������� ����c�����: ", 0
	STR_ERR DB "������. ������������ ����.", 0	
								
								; ��������� DD - ��� ������ �������� 1 DWORD, �� ���� 4 �����
								; ���� "?" ������������ ��� ������������������(?) ������
	DIN		DD ?				; ���������� �����
	DOUT	DD ?				; ���������� ������
	BUF		DB 200 dup (?)		; ����� ��� ����� ������ 200 ����
	LENS	DD ?				; ��� ���������� ���������� ��������
	FIRST	DD 0
	SECOND	DD 0
	SUM		DD ?
	DIFF	DD ?
	PROD	DD ?
	QUO		DD ?
	S_10	DD 10
	SIGN    DB 0

.CODE							; ��������� ���������� ������ �������� ����
	MAIN proc					; MAIN - �������� ���������, ��������� proc - ��������� ���������
								; ������� EAX - ������ ��� ���������� �������� (���������������) ������
	; ������������� STR_F, STR_Sec, STR_ERR
	CODESTR STR_F
	CODESTR STR_Sec
	CODESTR STR_ERR

	; �������� ���������� ����� � DIN
	PUSH -10						
	CALL GetStdHandle@4 
	MOV DIN, EAX

	; �������� ���������� ������ � DOUT
	PUSH -11
	CALL GetStdHandle@4
	MOV DOUT, EAX

	; ������� ������ �� ����� �������
	OUTPUT STR_F

	; ���� ������� ����� � ������� �����.
	INPUT FIRST	
	INPUT SECOND

	; ������� ��������� � �����������.
	OUTPUT STR_Sec

	; ��������.
	MOV EAX, FIRST
	MOV EBX, SECOND
	ADD EAX, SECOND
	MOV SUM, EAX
	MOV ESI, OFFSET BUF ; ������ ������ �������� � ���������� buf
	CONVERT_FROM10TOSTR SUM

	; �������.
	QUOTIENT:
	MOV EAX, FIRST
	MOV EBX, SECOND
	DIV EBX
	MOV QUO, EAX

	; ���������.
	 MOV EAX, FIRST
	 MOV EBX, SECOND
	 CMP EAX, EBX		; ��������� ��� �����
	 JNB SUBTRACTION	; ���� ������ ����� ������ ��� �����, ����������, ����� ������ ������� �� ������

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
	MOV ESI, OFFSET BUF; ������ ������ �������� � ���������� buf

	CMP SIGN, 0				; ���� ��������� �� �������������, 
	JE OUTDIFF				; �� �������, ����� ��������� '-'
	MOV AX, '-'				; 45 - ��� ����� '-'.
	MOV [ESI], AX
	INC ESI

	OUTDIFF:	
	CONVERT_FROM10TOSTR DIFF
	
	; ���������.
	MOV EAX, FIRST
	MUL SECOND
	MOV PROD, EAX
	MOV ESI, OFFSET BUF		; ������ ������ �������� � ���������� buf
	CONVERT_FROM10TOSTR PROD

	; ����� �������.
	MOV ESI, OFFSET BUF		; ������ ������ �������� � ���������� buf
	CONVERT_FROM10TOSTR QUO

	; ����� �� ���������.
	PUSH 0					; ��������: ��� ������
	CALL ExitProcess@4

	; � ������ ������.
	ERROR:
	OUTPUT STR_ERR
	PUSH 0
	CALL ExitProcess@4		; �����

	MAIN ENDP ; ��������� ENPD ��������� �������� ���������
	END MAIN  ; ��������� END ��������� ���������, MAIN - ��� ������ ����������� ���������
