title "Ejemplo para imprimir datos en pantalla y uso de macros" ;directiva 'title' opcional
	.model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	.386		;directiva para indicar version procesador
	.stack 64		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
clear macro
	mov ah,00h 	;ah = 00h, limpia la pantalla
	mov al,03h	;al = 03h. opcion de interrupcion
	int 10h		;llama interrupcion 10h
endm clear
posicionaCursor macro renglon,columna
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov ax,0200h 	;preparar ax para interrupcion, opcion 2
	int 10h 	;interrupcion que maneja entrada y salida de video
endm posicionaCursor
	.data			;Definicion del segmento de datos
exCode	db	0		;variable exCode de tipo byte
texto	db	"Hola Mundo! [enter] para salir$"	;cadena de caracteres texto
numero	db	'1','2','3','$'	;variable numero de tipo byte
bcd1	db	4		;variable bcd1 de tipo byte, representa el numero 4 en bcd
bcd2	db	9		;variable bcd2 de tipo byte, representa el numero 9 en bcd
temp1	db	?		;variable temp1 de tipo byte
temp2	db	?		;variable temp2 de tipo byte
	.code			;segmento de codigo
inicio:				;etiqueta start
	mov ax,@data 	;AX = directiva @data
	mov ds,ax 		;DS = AX, inicializa registro de segmento de datos
	clear			;ejecuta macro clear
	posicionaCursor 00h,00h ;posiciona cursor en renglon 0, columna 0
	;Imprime cadena de caracteres. Contenido de la variable texto
	lea dx,[texto]	;Obtiene posicion de memoria de la cadena que contiene la variable 'texto'
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.

	posicionaCursor 01h,00h ;posiciona cursor en renglon 1, columna 0
	;Imprime cadena de caracteres. Contenido de la variable numero
	lea dx,[numero]	;Obtiene posicion de memoria de la cadena que contiene la variable 'numero'
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.

	posicionaCursor 03h,00h ;posiciona cursor en renglon 2, columna 0
	;Imprime cadena de caracteres. Contenido de la variable numero
	mov al,'A'		;al = 'A' = 41h
	mov ah,09h		;opcion 9 para interrupcion 10h
	mov bl,0Eh		;bl = 0Eh , guarda los atributos del caracter
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h			;interrupcion 10h. Imprime cadena.
	posicionaCursor 04h,00h ;posiciona cursor en renglon 4, columna 0
	;Imprimir numero bcd
	mov ax,0		;inicilizar ax a 0
	mov al,[bcd1] 	;AL = [bcd1] carga el contenido de bcd1 en AL
	add al,[bcd2]	;AL = AL + [bcd2], suma el contenido de bcd2 con AL y lo guarda en AL
	aaa				;ASCII Adjust after Addition - una suma de dos valores bcd cuyo resultado esta en hexadecimal y guarda unidades en AL y decenas en AH 
	or ax,3030h 	;obtiene el equivalente en ascii de los digitos bcd guardados en ah (decenas) y en al (unidades) 
	mov [temp1],al 	;guarda el ascii del valor de las unidades
	mov [temp2],ah 	;guarda el ascii del valor de las decenas
	;Imprime digito de decenas
	mov al,[temp2] 	;cargar valor de decenas
	mov ah,09h 		;opcion 9 para interrupcion 10h
	mov bl,0Fh		;bl = 0Eh , guarda los atributos del caracter
	mov cx,1 		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.
	posicionaCursor 04h,01h ;posiciona cursor en renglon 4, columna 1
	;Imprime digito de centenas
	mov al,[temp1] 	;cargar valor de unidades
	mov ah,09h 		;opcion 9 para interrupcion 10h
	mov bl,0Fh		;bl = 0Eh , guarda los atributos del caracter
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.
et1:				;inicia etiqueta 'et1'
	mov ah,10h 		;opcion 10 para interrupcion
	int 16h			;interrupcion 16h (maneja la entrada del teclado)
	in al,60h 		;entrada desde teclado, guarda el dato del teclado (direccionado por 60h) en AL
	cmp al,01Ch		;compara la entrada de teclado si fue [enter]
	jnz et1			;si no es [enter] regresa a et1
salir:				;inicia etiqueta 'salir'
	mov ah,4Ch		;AH = 4Ch, opcion para terminar programa
	mov al,[exCode]	;AL = 0 exit Code, codigo devuelto al finalizar el programa
	int 21h			;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio		;fin de etiqueta inicio, fin de programa