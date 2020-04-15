;;; Calculadora en ensamblador
;;; @autor : Andres Urbano Guillermo
;;; @date: April 14 2020

	title "Calculadora"
	.model small
	.386
	.stack 64

	.data
	titulo		db	"Calculadora RETR"
	color		db	1d 

	.code
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
;;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Titulo de la interfaz
	mov cx, 16		;Tamaño de la cadena
	mov di, 0d		;Indice 
loop1:	
	mov al,[titulo + di]
	mov ah, 09h
	mov bl, color		;Rango de colores
	int 10h
	inc color		;Aumentamos para cambiar el rango
	inc di			;Para recorrer la cadena
	loop loop1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
salir:
	mov ax, 4c00h
	int 21h
	end inicio
	
	
