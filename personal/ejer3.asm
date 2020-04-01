	title "Imprimir la cadena 20 veces"
	.model small
	.386
	.stack 64

	.data
	hola	db	"Hola mundo!", 0ah,0dh,"$"

	.code
inicio:	mov ax, @data
	mov ds, ax
	;;Statament
	mov cx, 20d
loop1:	
	;; Impriesion de la cadena
	lea dx,hola
	mov ah, 09h
	int 21h
	loop loop1

fin:	mov ah, 4ch
	mov al, 00h
	int 21h
	end inicio
