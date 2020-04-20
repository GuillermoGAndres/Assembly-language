title "Ejemplo de operaciones aritmeticas mul, imul" ;directiva 'title' opcional
	.model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	.386		;directiva para indicar version procesador
	.stack 64		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
num_byte	db	20h		;variable num_byte de tipo byte 
num_word	dw	1234h	;variable num_word de tipo word 
productoB	db	?,?		;variable productoB de tipo byte (ocupa 2 bytes), almacena el resultado de una multiplicacion sin signo de dos numeros de 8 bits
productoW	dw	?,?		;variable productoW de tipo word (ocupa 2 words, 4 bytes), almacena el resultado de una multiplicacion sin signo de dos numeros de 16 bits
cocienteB	db	?		;variable cocienteB de tipo byte, almacena el cociente de una division sin signo de un dividendo de 16 bits con un divisor de 8 bits
residuoB	db	?		;variable residuoB de tipo byte, almacena el residuo de una division sin signo de un dividendo de 16 bits con un divisor de 8 bits
cocienteW	dw	?		;variable cocienteW de tipo word, almacena el cociente de una division sin signo de un dividendo de 32 bits con un divisor de 16 bits
residuoW	dw	?		;variable residuoW de tipo word, almacena el residuo de una division sin signo de un dividendo de 32 bits con un divisor de 16 bits
	.code				;segmento de codigo
inicio:					;etiqueta start
	mov ax,@data 		;AX = directiva @data
	mov ds,ax 			;DS = AX, inicializa registro de segmento de datos
;Limpiar registro AX y DX (para evitar confusiones)
	mov ax,0
	mov dx,0
;Instruccion mul 8 bits
	mov al,35h				;AL = 35h
	mul [num_byte]			;AX = AL * [num_byte] = 35h * 20h = 06A0h. AH diferente de 00h => C=1, O=1
	;Guarda resultado en memoria (variable productoB)
	mov [productoB],al 		;[productoB] = AL = A0h
	mov [productoB+1],ah 	;[productoB+1] = AH = 06h
;Instruccion mul 16 bits
	mov ax,1200h			;AX = 1200h
	mul [num_word]			;DX:AX = AX * [num_word] = 1200h * 1234h = 0147A800h. => DX=0147h, AX=A800h. DX diferente de 0000h => C=1, O=1
	;Guarda resultado en memoria (variable productoW)
	mov [productoW],ax 		;[productoW] = AX = A800h
	mov [productoW+2],dx 	;[productoW+2] = DX = 0147h
;Instruccion div 8 bits
	mov ax,06A5h			;AX = 06A5h
	div [num_byte]			;AL = AX / [num_byte] = 06A5h / 20h = 35h, Cociente
							;AH = AX % [num_byte] = 06A5h % 20h = 05h, Residuo
	;Guarda resultado en memoria (variables cocienteB y residuoB)
	mov [cocienteb],al 		;[cocienteb] = AL = 35h
	mov [residuoB],ah 		;[residuoB] = AL = 05h
;Instruccion div 16 bits
	mov dx,0147h 			;DX = 0147h
	mov ax,0A80Ah			;AX = A80Ah
	div [num_word]			;AX = DX:AX / [num_word] = 0147A80Ah / 1234h = 1200h, Cociente
							;DX = DX:AX % [num_word] = 0147A80Ah % 1234h = 000Ah, Residuo
	;Guarda resultado en memoria (variables cocienteW y residuoW)
	mov [cocienteW],ax 		;[cocienteW] = AX = 1200h
	mov [residuoW],dx 		;[residuoW] = DX = 000Ah
salir:					;inicia etiqueta Salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,00h			;AL = 0 exit Code, codigo devuelto al finalizar el programa
	int 21h				;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa