.386
.MODEL FLAT
.CODE
@make_string@12 PROC

PUSH EBP
MOV EBP, ESP
			
MOV EBX, 0			; EBX - ������ �� ������ ������
MOV ESI, EDX		; � ESI - ��������� �� ������� ������
MOV EAX, [EBP+8]	; � EAX - �������� ������ ( 4 ����� - ����� ��������, 4 ����� - EBP)
					; � EDX - ������, � ECX - ���������� ����������� ��������
					;MOV EDI, EAX

START:

ITER:
MOV BL, [ESI]
CMP BL, 0
JE yes
MOV [EAX], BL
INC ESI
INC EAX
JMP ITER

yes:
MOV ESI, EDX

LOOP START

EXIT:
MOV [EAX], BL
POP EBP
RET 4

@make_string@12 ENDP
END


