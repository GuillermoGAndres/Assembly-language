title "Ejemplo de operaciones logicas and, or, not, xor, test" ;directiva 'title' opcional
	.model small	;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	.386			;directiva para indicar version procesador
	.stack 64		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
exCode	db	0		;variable exCode de tipo byte
var1	dw	0FFFFh	;variable var1 de tipo word
var2	dw	04422h	;variable var2 de tipo word
	.code			;segmento de codigo
inicio:				;etiqueta start
	mov ax,@data 	;AX = directiva @data
	mov ds,ax 		;DS = AX, inicializa registro de segmento de datos
	;Instruccion AND - Conjuncion logica
	mov ax,[var1]	;AX = [var1] = FFFFh
	mov bx,[var2]	;BX = [var2] = 4422h
	and ax,bx 		;AX = AX AND BX = FFFFh AND 4422h = 4422h
	;Instruccion OR - Disyuncion logica
	mov ax,[var1]	;AX = [var1] = FFFFh
	mov bx,[var2]	;BX = [var2] = 4422h
	or ax,bx 		;AX = AX OR BX = FFFFh OR 4422h = FFFFh
	;Instruccion XOR - (OR exclusivo) Disyuncion logica exclusiva
	mov ax,[var1]	;AX = [var1] = FFFFh
	mov bx,[var2]	;BX = [var2] = 4422h
	and ax,bx 		;AX = AX XOR BX = FFFFh XOR 4422h = BBDDh
	;Instruccion NOT - Negacion por Complemento a 1
	mov ax,[var1]	;AX = [var1] = FFFFh
	not ax 			;AX = NOT(AX) = NOT(FFFFh) = 0000h
	;Instruccion NEG - Negacion por Complemento a 2
	mov ax,[var1]	;AX = [var1] = FFFFh
	neg ax 			;AX = NEG(AX) = NEG(FFFFh) = 0001h
	;Instruccion TEST - Comparacion logica (AND)
	mov ax,[var1]	;AX = [var1] = FFFFh
	mov bx,[var2]	;BX = [var2] = 4422h
	test ax,bx 		;AX AND BX = FFFFh AND 4422h = 4422h, C = 0, O = 0, A = *, S = 0, Z = 0, P = 1
salir:				;inicia etiqueta Salir
	mov ah,4Ch		;AH = 4Ch, opcion para terminar programa
	mov al,[exCode]	;AL = 0 exit Code, codigo devuelto al finalizar el programa
	int 21h			;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio		;fin de etiqueta inicio, fin de programa