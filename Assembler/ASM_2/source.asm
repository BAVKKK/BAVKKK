.386
.MODEL FLAT
.CODE
_find_position PROC
PUSH EBP
MOV EBP, ESP

ADD EBP, 8			; 4 ����� - ����� ��������, 4 ����� - EBP 
MOV EDX, [EBP] + 8	; �������� ���������� ��������
MOV EDI, 0			; ������������� ������ ������ !
MOV ECX, 0			; ������� ����� ��������� ���������� � ������

START:
CMP [EBP]+12, EDI	; ���� ������ �����������, � ���������� ��� � �� ���� ������� - ������
JB ERROR

MOV EAX, [EBP]		; ��������� ������
MOV AL, [EAX + EDI] ; �������� ����� �������� �������
MOV BL, [EDX]		; �������� ����� ������� � ����������
CMP AL, BL			; ���������� ��� �������
JE yes				; ���� �����, �� ��������� � ��������� ��������. ����� ������ � ����. ������� � ������ � �������� ��������� ���������� �������

INC EDI
MOV EDX, [EBP] + 8	
MOV ECX, 0
JMP START

yes:
INC EDI
INC EDX
INC ECX
CMP ECX, [EBP+4]		; ���������� ��������� ����� ����������, � �����������. ���� ���������, �� ��������� �������.
JE EXIT
JMP START

EXIT:
SUB EDI, ECX
INC EDI
POP EBP
MOV EAX, EDI
RET

ERROR:
POP EBP
MOV EAX, 0
RET

_find_position ENDP
END


