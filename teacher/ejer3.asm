;Ejercicio de Clase: Imprimir la cadena de caracteres 'hola' 20 veces
title "Ejercicio de clase" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Datos - Variables
hola		db		"Hola mundo!",0Ah,0Dh,"$"
	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;Código - Programa

	mov cx,20d 			;CX = 20d, prepara CX para loop de 20 iteraciones
;Impresión de la cadena 'hola'
	lea dx,[hola]		;Obtiene la direccion de donde inicia la cadena 'hola'
loop1:
	mov ah,09h			;AH = 09h, prepara AH para interrupcion 21h
	int 21h				;int 21h, AH = 09h. Imprime en pantalla la cadena que empieza en DX
						;Se imprimen los caracteres hasta encontrar $
	loop loop1

salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa