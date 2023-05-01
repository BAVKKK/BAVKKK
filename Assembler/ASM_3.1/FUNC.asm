.386
.MODEL FLAT, C

.DATA				 
Xk1 QWORD 0.6		; начальное приближение х0
Xk  QWORD 0.0		; начальное приближение х1
					
X	QWORD 0.0
COUNTER DWORD 0		; счетчик итераций
CONST QWORD 3.0
FXk   QWORD 0.0
FXk1  QWORD 0.0
EPS DWORD ?
DEL DWORD ?
COUNT DWORD ?

COUNTMAX DWORD 1000 ; максимальное количество итераций

.CODE 

SecantMethod PROC 

	PUSH EBP
	MOV EBP, ESP
	MOV EDX, [EBP]+8
	MOV EPS, EDX
	MOV EDX, [EBP]+ 12
	MOV COUNT, EDX
	MOV EDX, [EBP] + 16	; дел
	MOV DEL, EDX
	XOR EAX, EAX
	XOR EBX, EBX

	FINIT
	FLD DEL					;ST(0)=del
	FLD Xk1					;ST(0)=x0=0.6 ST(1)=del
	FADDP ST(1), ST(0)		;Складываем X0 и del, запоминаем ST(0)=x0+del
	FSTP Xk					;Запоминаем st(0) в x1

	BEGIN:					;Находим х, потом проверяем 
		
		INC COUNTER			;Увеличиваем счетчик
		;Находим f(Xk)
		FLD Xk				
		FSTP X
		CALL FUNC
		FSTP FXk

		;Находим f(Xk-1)
		FLD Xk1
		FSTP X
		CALL FUNC
		FSTP FXk1
	
		CALL SM
		
		FLD Xk
		FSTP Xk1
		FSTP Xk

		JMP CHECK
	
	CHECK:
		FLD Xk				;st(0)=Xk
		FLD Xk1				;st(0)=Xk1  st(1)=Xk
		FSUBP ST(1), ST(0)  ;st(0)=Xk-Xk1
		FABS
		FLD EPS				;st(0)=eps  st(1)= |Xk-Xk1|
		FCOMPP
		FSTSW AX			; после сравнения флаги сохраняются в регистре АХ
		SAHF				; флаги загружаются в регистр флагов EFLAGS
		JA EXIT				; если ST(0) > ST(1), т.е. CF=0, то на вершине стека 
							; находится большее число
		MOV EAX, COUNTER	; Проверка чтобы не уйти в бесконечный цикл
		CMP EAX, COUNTMAX
		JNC EXIT			; если ST(0) > ST(L), т.е. CF=0, то на вершине стека 
							; находится большее число
		JMP BEGIN

	EXIT:
		
		FLD Xk
		MOV EAX, COUNT

		MOV EBX, COUNTER
		MOV [EAX], EBX

		POP EBP
		RET 
SecantMethod ENDP 

FUNC PROC ; Вычисление функции, задающей левую часть.
	
	;(cos(x)/sin(x))-x/3

	FLD X				; st(0)= x
	FCOS				; st(0)= cos(x)
	FLD X				; st(0)= x		 st(1)= cos(x)
	FSIN				; st(0)= sin(x)  st(1)= cos(x)
	FDIVP ST(1), ST(0)	; st(0)= ctg(x)
	FLD X				; st(0)= x		 st(1)= ctg(x)
	FLD CONST			; st(0)= 3		 st(1)= x		st(2)= ctg(x)
	FDIVP ST(1), ST(0)	; st(0)= x/3	 st(1)= ctg(x)
	FSUBP ST(1), ST(0)	; st(0)= ctg(x)-x/3

	RET
FUNC ENDP

SM PROC					; Вычисление функции, задающей левую часть.
	
	; x = Xk - (FXk*(Xk-Xk1))/(FXk-FXk1)

	FLD Xk				; st(0)= xk
	FLD Xk				; st(0)= xk							st(1)= xk
	FLD Xk1				; st(0)= xk1						st(1)= xk			 st(2)= xk
	FSUBP ST(1), ST(0)	; st(0)= (Xk-Xk1)					st(1)= xk

	FLD FXk				; st(0)= fxk						st(1)= (Xk-Xk1)		 st(2)= xk
	FMULP ST(1), ST(0)	; st(0)= fxk*(Xk-Xk1)				st(1)= xk
	FLD FXk				; st(0)= fxk						st(1)= fxk*(Xk-Xk1)  st(2)= xk
	FLD FXk1			; st(0)= fxk1						st(1)= fxk			 st(2)= fxk*(Xk-Xk1)  st(3)=xk
	FSUBP ST(1), ST(0)	; st(0)= fxk-fxk1					st(1)= fxk*(Xk-Xk1)  st(2)= xk
	FDIVP ST(1), ST(0)	; st(0)= fxk*(Xk-Xk1)/(fxk-fxk1)	st(1)= xk
	FSUBP ST(1), ST(0)	; st(0)= xk-fxk*(Xk-Xk1)/(fxk-fxk1)  

	RET
SM ENDP

END
