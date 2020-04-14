;;;@autor: Guillermo G. Andres Urbano
;;;@date: 30 March 2020
	title "Ecuacion de 3 variables sumas y restas"
	.model small
	.386
	.stack 64
	.data
	x	db	35h
	y	db	23h
	z	db	18h
	w	db	?
	.code
	main	proc
inicio:	mov ax,@data
	mov ds,ax
	xor ax,ax				;Inicializo a cero a ax

	mov al,x
	add al,y
	sub al,z
	add al,04h

	mov w,al

fin:	mov ax,4c00h
	int 21h
	main endp

	endp main
	
	
	
