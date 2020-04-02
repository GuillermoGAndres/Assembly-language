	title "Suma con acarreo"
	.model small
	.386
	.stack 64

	.data
	num1	dw	0e1c0h,  548bh, 0a637h 
	num2	dw	0c193h,  0f250h, 0df76h
	res	dw	?, ?, ?, ?

	.code
inicio:	mov ax, @data
	mov ds, ax
	xor ax, ax
	;; ----------------
	clc			;Limpia el carry c=0
	mov ax, [num1]
	adc ax, [num2]
	mov [res], ax
	;; segundo word
	mov ax, [num1 + 2]
	adc ax, [num2 + 2]
	mov [res + 2], ax
	;; tercera word
	mov ax, [num1 + 4]
	adc ax, [num2 + 4]
	mov [res + 4], ax
	;; Sumar el ultimo acarreo
	 adc [res + 6], 0
	
	

salir:	mov ax, 4c00h
	int 21h
	end inicio
