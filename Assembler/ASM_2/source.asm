.386
.MODEL FLAT
.CODE
_find_position PROC
PUSH EBP
MOV EBP, ESP

ADD EBP, 8			; 4 байта - адрес возврата, 4 байта - EBP 
MOV EDX, [EBP] + 8	; помещаем комбинацию символов
MOV EDI, 0			; устанавливаем начало строки !
MOV ECX, 0			; счетчик длины найденной комбинации в строке

START:
CMP [EBP]+12, EDI	; если строка закончилась, а комбинация так и не была найдена - ошибка
JB ERROR

MOV EAX, [EBP]		; считываем символ
MOV AL, [EAX + EDI] ; получаем адрес текущего символа
MOV BL, [EDX]		; получаем адрес символа с комбинации
CMP AL, BL			; сравниваем два символа
JE yes				; если верно, то переходим к следующим символам. Иначе только к след. символу в строке и начинаем считывать комбинацию сначала

INC EDI
MOV EDX, [EBP] + 8	
MOV ECX, 0
JMP START

yes:
INC EDI
INC EDX
INC ECX
CMP ECX, [EBP+4]		; сравниваем найденную длину комбинации, с изначальной. Если совпадает, то вхождение найдено.
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


