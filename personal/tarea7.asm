	title "Ejercicio 7"
	.model small
	.386
	.stack 64
	
	.data
	tecla_enter	equ	0Dh
	N_mayus	equ	'N'
	N_minus	equ	'n'
	caracter	db	0
	
	.code
inicio:
	mov ax, @data
	mov ds, ax
lee_teclado:
	mov ah, 08h
	int 21h
	mov [caracter], al
	cmp [caracter], tecla_enter
	je salir
	cmp [caracter], N_mayus
	je salir
	cmp [caracter], N_minus
	je salir
	jmp lee_teclado
salir:
	mov ah, 4Ch
	mov al, 0
	int 21h
	end inicio
	
