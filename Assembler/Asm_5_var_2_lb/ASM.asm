.386
.MODEL FLAT
.CODE
@make_string@12 PROC

PUSH EBP
MOV EBP, ESP
			
MOV EBX, 0			; EBX - отступ от начала строки
MOV ESI, EDX		; В ESI - указатель на текущий символ
MOV EAX, [EBP+8]	; В EAX - выходная строка ( 4 байта - адрес возврата, 4 байта - EBP)
					; В EDX - строка, в ECX - количество необходимых повторов
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


