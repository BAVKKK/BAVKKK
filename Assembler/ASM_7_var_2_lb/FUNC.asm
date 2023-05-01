.386
.MODEL FLAT
.CODE
@make_string@12 PROC

PUSH EBP
MOV EBP, ESP
			
MOV EDI, [EBP+8]	; В EDI - пустая строка для хранения инверсированной
MOV ESI, EDX		; В ESI - указатель на текущий символ
					; В EDX - строка, в ECX - длина исходной строки
MOV EAX, ECX		; Временно сохраняем значение ECX в EAX, поскольку ECX будет использован для 2 циклов

DEC ESI				; Уменьшаем указатель на 1, чтобы не записывать символ конца строки

INVERT:				; Функция инвертирования
MOV BL, [ESI+ECX]	; Помещаем последний эллемент в EDI
MOV [EDI], BL
INC EDI
LOOP INVERT

MOV BL, 0
MOV [EDI], BL		; Добавляем в инвертируемую строку символ конца строки

MOV ECX, EAX
SUB EDI, ECX		; Смещаем указатель строки на первый эллемент в ней

COMPARE:			; Посимвольно сравниваем строки
MOV BL, [EDX]		
MOV BH, [EDI]
CMP BL, BH
JB EX_0				; Если хотя бы один символ различается, то выходим с кодом 0
INC EDI
INC EDX
LOOP COMPARE

EX_1:
MOV EAX, 1			; Возвращаем 1
POP EBP
RET 4

EX_0:
MOV EAX, 0			; Возвращаем 0
POP EBP
RET 4

@make_string@12 ENDP
END


