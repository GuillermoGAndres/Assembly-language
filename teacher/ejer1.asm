title "Ejercicio 1: expresion matematica" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Variables
x			db		35h		;variable x de tipo byte
y			db		23h		;variable y de tipo byte
z			db		18h		;variable z de tipo byte
w 			db 		?		;variable w de tipo byte, para almacenar el resultado
	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
	mov ax,0			;AX = 0000h, inicializar registro en 0s
;AQUI VA SU CODIGO
	mov al,[x]			;AL = [x], copia el contenido de x en registro AL de tamano byte (8 bits)
	add al,[y]			;AL = AL + [y]
	sub al,[z]			;AL = AL - [z]
	add al,4 			;AL = AL + 4
	mov [w],al 			;[w] = AL
	
salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa