.386
.MODEL FLAT

.DATA
 CONST DD 3		; точное решение, константа для вычисления f(x)
 X DD ?			; x
 X0 DD 0.6		; x0 = 0.6
 delt DD 0.2	; малая величина > 0
 X1 DD 0.8		; x1 = x0 + delt
 F_X1 DD ?		; f(x1)
 EPS DD ?		; точность вычисления eps
 I DD ?			; адрес переменной для количества итераций
 Y DQ ?			; f(x)

.CODE
 _sec@8 PROC

 PUSH EBP
 MOV EBP, ESP
 MOV EAX, [EBP] + 8		; переданное значение eps
 MOV EPS, EAX
 MOV EAX, [EBP] + 12	; переданный адрес переменной для возврата количества итераций
 MOV I, EAX
 XOR EBX, EBX			; обнуляем счетчик итераций

 FINIT					; инициализация сопроцессора

 ; вычисляем f(x1)
 FLD X1					; загружаем в стек сопа
 FSTP X					; сохраняем из вершины стека в память
 CALL f					; вызываем ф-цию уравнения
 FLD Y					; кладем в стек
 FSTP F_X1
 ; x = x0
 FLD X0
 FSTP X
 loop_1:
 INC EBX				; увеличиваем счетчик итераций
 CALL f					; y = f(x0)
 CALL new_x				; x = x - f(x1)*(x1 - x0)/(f(x1) - f(x0))
 FLD X					; ST(0) = x
 FLD CONST				; ST(0) = 0.5 ST(1) = x
 FSUBP					; ST(0) = x - 0.5
 FABS					; ST(0) = |x - 0.5|
 FLD EPS				; ST(0) = EPS ST(1) = |x - 0.5|
 FCOMPP					; сравниваем EPS и |x - 0.5|
 FSTSW AX				; загрузка флагов в AX
 SAHF					; загрузка флагов в EFLAGS
 JC loop_1				; если СF=1 (EPS < |x - 0.5|), идем на следующую итерацию
 ; иначе выходим из функции

 MOV EAX, I				; запоминаем количество итераций
 MOV [EAX], EBX
 FLD X					; ST(0) = X - возвращаемое значение
 POP EBP
 RET
 _sec@8 ENDP

 ;x = x - f(x)*(b - x)/(f(b) - f(x))
 ;x = x - f(x1)*(x1 - x0)/(f(x1) - f(x0))
 new_x PROC; ST(0) ST(1) ST(2) ST(3)
 FLD X			; x
 FLD X1			; x1 x
 FLD X0			; x0 x1 x
 FSUBP			; x1-x0 x
 FLD F_X1		; f(x1) x1-x0 x
 FMULP			; f(x1)*(x1-x0) x
 FLD F_X1		; f(x1) f(x1)*(x1-x0) x
 FLD Y			; f(x0) f(x1) f(x1)*(x1-x0) x
 FSUBP			; f(x1)-f(x0) f(x1)*(x1-x0) x
 FDIVP			; f(x1)*(x1-x0)/(f(x1)-f(x0)) x
 FSUBP			; x-f(x1)*(x1-x0)/(f(x1)-f(x0))
 FSTP X

 RET
 new_x ENDP

 ; f(x) = 1/tan(x) - x/3
 f PROC
 ; ST(0) ST(1) ST(2)
 FLD1				; 1
 FLD X				; x 1
 FPTAN				; 1 tan(x)
 FDIV ST(0),ST(1)	; 1/tan(x)
 FLD CONST			; 3 1/tan(x)
 FLD X				; x 3 1/tan(x)
 FDIV ST(0),ST(1)	; x /3 1/tan(x)
 FSUBP ST(1), ST(0)	; 1/tan(x) - x/3
 FSTP Y
 RET
 f ENDP
END