	;; @author: Guillermo Gerardo Andres Urbano
	title "Ejercicio 4 imprimir hola y adios"
	.model small
	.386
	.stack 64
	
	.data
	x	db	10d
	y	db	20d
	w	db	"Hola", 0ah,0dh,"$"
	g	db	"Adios", 0ah,0dh,"$"
	.code
inicio:	mov ax,@data
	mov ds, ax
	xor ax, ax
	
	mov ah, x
	mov bh, y
	cmp ax,bx
	jae flujo1
	sub ah, bh
	jmp flujo2
flujo1:
	lea dx,w
	mov ah, 09h
	int 21h
flujo2:
	lea dx,g
	mov ah, 09h
	int 21h

fin:	mov ax, 4c00h
	int 21h
	end inicio
