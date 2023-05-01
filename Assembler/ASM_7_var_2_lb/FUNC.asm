.386
.MODEL FLAT
.CODE
@make_string@12 PROC

PUSH EBP
MOV EBP, ESP
			
MOV EDI, [EBP+8]	; � EDI - ������ ������ ��� �������� ���������������
MOV ESI, EDX		; � ESI - ��������� �� ������� ������
					; � EDX - ������, � ECX - ����� �������� ������
MOV EAX, ECX		; �������� ��������� �������� ECX � EAX, ��������� ECX ����� ����������� ��� 2 ������

DEC ESI				; ��������� ��������� �� 1, ����� �� ���������� ������ ����� ������

INVERT:				; ������� ��������������
MOV BL, [ESI+ECX]	; �������� ��������� �������� � EDI
MOV [EDI], BL
INC EDI
LOOP INVERT

MOV BL, 0
MOV [EDI], BL		; ��������� � ������������� ������ ������ ����� ������

MOV ECX, EAX
SUB EDI, ECX		; ������� ��������� ������ �� ������ �������� � ���

COMPARE:			; ����������� ���������� ������
MOV BL, [EDX]		
MOV BH, [EDI]
CMP BL, BH
JB EX_0				; ���� ���� �� ���� ������ �����������, �� ������� � ����� 0
INC EDI
INC EDX
LOOP COMPARE

EX_1:
MOV EAX, 1			; ���������� 1
POP EBP
RET 4

EX_0:
MOV EAX, 0			; ���������� 0
POP EBP
RET 4

@make_string@12 ENDP
END


