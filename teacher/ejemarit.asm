title "Ejemplo de operaciones aritmeticas add, sub, inc, dec, adc" ;directiva 'title' opcional
	.model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	.386			;directiva para indicar version procesador
	.stack 64		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
exCode	db	0		;variable exCode de tipo byte
count	dw	1		;variable count de tipo word
num1	dw 	0F520h	;variable num1 de tipo word = F520h
num2	dw 	0C52Fh	;variable num2 de tipo word = C52Fh
resultado	dw	0,0	;variable resultado de tipo word = 00000000h, almacena el resultado de una suma
	.code			;segmento de codigo
inicio:				;etiqueta start
	mov ax,@data 	;AX = directiva @data
	mov ds,ax 		;DS = AX, inicializa registro de segmento de datos
	;Valor inicial de registros
	mov ax,4		;AX = 0004h
	mov bx,2		;BX = 0002h
	mov cx,8		;CX = 0008h
	;Instruccion add
	add ax,bx 		;AX = AX + BX = 0006h
	add cx,[count]	;CX = CX + [count] = 0009h
	add [count],cx 	;[count] = [count] + CX = 000Ah
	;Instruccion sub
	sub	cx,ax 		;CX = CX - AX = 0005h
	sub [count],bx 	;[count] = [count] - BX = 0008h
	;Instrucciones inc y dec
	inc [count]		;[count] = [count] + 1
	dec [count]		;[count] = [count] - 1
	inc cx 			;CX = CX + 1
	dec cx 			;CX = CX - 1
	;Instruccion adc
	clc				;Bandera de carry a cero
	mov ax,[num1]	;AX = contenido de la primera localidad de num1
	adc ax,[num2]	;AX = AX + [num2] + bit de carry = [num1] + [num2] + 0
	mov [resultado],ax 	;[resultado] = AX
	adc [resultado+2],0 	;[resultado + 2] = [resultado + 2] + 0 + Carry
	;Instruccion sbb
	stc 			;Bandera de carry a uno
	mov ax,[num1] 	;AX = contenido de [num1] = F520h
	sbb ax,[num2]	;AX = AX - [num2] - Carry = F520h - C52Fh - 1 = 2FF0h
	;Instruccion CMP - Comparacion aritmetica (SUB)
	mov ax,[num1]	;AX = [num1] = FFFFh
	mov bx,[num2]	;BX = [num2] = 4422h
	cmp ax,bx 		;AX - BX = FFFFh - 4422h = BBDDh
salir:				;inicia etiqueta Salir
	mov ah,4Ch		;AH = 4Ch, opcion para terminar programa
	mov al,[exCode]	;AL = 0 exit Code, codigo devuelto al finalizar el programa
	int 21h			;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio		;fin de etiqueta inicio, fin de programa