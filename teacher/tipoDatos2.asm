;Esto es un comentario
title "Estructura de un programa en lenguaje ensamblador" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Constantes
constante		equ		10		;definicion de una constante decimal
constanteHex	equ		10h		;definicion de una constante hexadecimal
constanteSuma	=		constante + constanteHex	;definicion de una constante asignada como la operacion de otras dos
variableMem		db 		constanteSuma ;definicion de variable en memoria que contiene el valor de constanteSuma
;Caracteres (ASCII)
letraA			db 		'A'		;definicion de un caracter cuyo valor en memoria es su equivalente en codigo ASCII
letras			db 		'ABCDEFGH'	;definicion de una cadena de caracteres
;Datos decimales codificados en binario
bcds			db		1,2,3	;datos decimales (0-9) codificados en binario, cada digito en una localidad de memoria diferente
;Datos de un byte (8 bits)
datoByte1		db 		8		;define dato con signo de un byte
datoByte2		db 		-8		;define dato con signo de un byte
datoByte3		db 		254		;define dato sin signo de un byte
datoByte4		db 		0E0h	;define dato hexadecimal de un byte
;Datos de una word/palabra (16 bits)
datoWord1		dw 		2544	;decimal 2544 = 09F0h
datoWord2		dw 		87ACh	;87ACh = 34,732d
;Datos de doubleword/doble palabra (32 bits)
datoDword1		dd 		254400	;254,400d = 0003E1C0h
datoDword2		dd 		87AC1234h	;87AC1234h = 2,276,201,012d
;Numeros reales, de punto flotante y quadwords (64 bits)
numReal1 		dd 		1.234	;1.234 = 3F9DF3B6h
numReal2		dq 		123.4	;123.4 = 405ED99999999999h
;variables
exCode			db 		0		;variable exCode con valor 0
pointer			dw 		0001h 	;variable pointer con valor 0001h
uninitialized	db 		?		;variable uninitialized de valor no inicializado pero reservado
uninitArray		db 		100 dup(?)	;reserva 100 bytes no inicializados para la variable uninitArray

;Define estructura
ESTRUC		struc
entero8b		db 		00h 	
caracter		db 		'A'
entero16b		dw		0000h
entero32b		dd 		00000000h
entero64b		dq		0000000000000000h
ESTRUC 			ends
;Variable tipo ESTRUC
estruc1			ESTRUC<12h,'Z',1234h,12345678h,123456789ABCDEF0h>

	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
	mov ax,[datoWord1]	;AX = datoWord1
	mov bx,[datoWord2] 	;BX = datoWord2
	lea cx,[inicio]		;CX = localidad del segmento de codigo a la que apunta la etiqueta inicio
	lea dx,[numReal1]	;DX = localidad del segmento de datos a la que apunta la variable numReal1
	mov bp,sp			;BP = SP, inicializa el registro BP con la primera localidad de la pila
						;se recomienda realizar esta operacion siempre que se vaya a utilizar la pila
	push ax 			;pone el contenido del registro ax en el tope de la pila => [] -> [AX]
	push bx 			;pone el contenido del registro bx en el tope de la pila => [AX] -> [BX AX]
	pop cx 				;saca el contenido del tope de la pila y lo guarda en CX
	pop dx 				;saca el contenido del tope de la pila y lo guarda en DX 
salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,[exCode]		;AL = [exCode] = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa