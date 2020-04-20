;;; Calculadora en ensamblador
;;; @autor : Andres Urbano Guillermo
;;; @date: April 14 2020

	title "Calculadora"
	.model small
	.386
	.stack 64

clear macro	;Macro para limpiar pantalla de la terminal
	mov ah,00h 	;ah = 00h, limpia la pantalla
	mov al,03h	;al = 03h. opcion de interrupcion
	int 10h		;llama interrupcion 10h
endm
	.data
	titulo	db	"TER arodaluclaC"
	color	db	1d
	salto	db	0Ah,"$"	;0Ah es salto de linea
	tab	db	09h,"$" ;tab horizontal
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	msg1	db	"Ingrese el primer numero: $"
	msg2	db	"Ingrese el segundo numero: $"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	num1	dw	01A2Eh
	num2	dw	0BC1Ah
	.code
;;; SUMA con dos Operandos de 16 bits
SUMA proc
	mov bp, sp
	mov bx, [bp+2]
	add bx, [bp+4]
	mov [bp+2], bx
	ret
	endp
	
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
;;; ;;;;;;;;;;;;;;;;;;;;
	;; Imprimer un tab horizontal
	lea dx, tab
	mov ah, 09h
	int 21h
;;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Titulo de la interfaz
	mov cx, 15		;Tamaño de la cadena
	mov di, 0d		;Indice 
loop1:	
	mov al,[titulo + di]
	mov ah, 09h
	mov bl, color		;Rango de colores
	int 10h
	inc color		;Aumentamos para cambiar el rango
	inc di			;Para recorrer la cadena
	loop loop1
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Imprimer un salto de linea
	lea dx, salto
	mov ah, 09h
	int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Inicio leer los dos primeros numeros
;;;Imprimir mensaje
startProgram:
	lea dx, msg1
	mov ah, 09h
	int 21h
;;;Leer del teclado(scanf, cin, input,..,n);
lee_teclado1:
	mov ah, 01h	
	int 21h
	cmp al, 0Dh		;Compara el caracter detectado con el caracter enter
	jne lee_teclado1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;Suma
	push [num1]
	push [num2]
	call SUMA 		;Deje en la pila el resultado
	pop ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
salir:
	mov ax, 4c00h
	int 21h
	end inicio
	
	
