title "Ejercicio 7"
;@author Andres Urbano Guillermo Gerardo
.model small
.386
.stack 64

.data
	num1 db 2 ;Eligir numero que quiera funcionara
	num2 db 5 ;Eligir numero que quiera funcionara
	result dw ?
	.code
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
	xor bx, bx

	mov bl, num1
	
	cmp bl, 9d
	jg expresion3

	mov bl,	num2
	cmp bl, 9
	jg expresion3

	mov bl, num1
	cmp bl, num2
	jge expresion1
	jl expresion2
	jmp fin

expresion3:
	jmp fin
expresion2:
	;resultado = num2! = factorial(num2).
	mov al, [num2]
	mov cx, ax
	xor ax, ax
	mov ax, 1
	mov result, 1
	mov dx, 1d;
loop1:
	mov ax, dx
	push dx ;Guardare mi valor de dx en la pila, ya dx se ocupa el multiplicacion
	mul result
	mov result, ax
	pop dx
	inc dx
	loop loop1
	jmp fin

expresion1:
	;x^2 + 3 = x*x + x
	;El resultado de la multiplicacion se guarada en ax, al sera el Multiplicando,bl mi multiplicador
	;;multiplicador * Multiplicando -- x * 4
	mov al, bl
	mul bl
	xor bx,bx
	mov bl, [num1]
	
	add ax, bx
	mov result, ax
	jmp fin


fin:
	mov ax, 4c00h
	int 21h
	end inicio