.386
.model flat,C

cnt MACRO

START:
CMP ECX, 0
JE EXIT
DEC ECX
INC ESI
MOV AL, [ESI]
CMP AL, 32
JNE START

INC EDX


ENDM

.DATA
	SIZ DD ?
	SRTR DD ? 

.CODE
	func PROC
		PUSH EBP
		MOV EBP, ESP
		MOV EBX, [EBP+8] ; помещаем входную строку в ESI
		MOV ESI, EBX     
		MOV EBX, [EBP+12] 
		MOV SIZ, EBX     ; в SIZ размер строки
		MOV SRTR, ESI    ; перемещаем исходную строку в SRTR
		XOR EDX, EDX
		
		MOV ECX, SIZ
		MOV ESI, SRTR
		DEC ESI
		MOV EAX, SRTR
		ADD EAX, ECX
		DEC EAX
		MOV AL, [EAX]
		CMP AL, 32
		JE F_0
		INC EDX

		F_0:
		CMP ECX, 0
		JE EXIT
		cnt
		JMP F_0

EXIT:
		XOR EAX, EAX
		MOV EAX, EDX
		POP EBP
		RET
	func ENDP
END

