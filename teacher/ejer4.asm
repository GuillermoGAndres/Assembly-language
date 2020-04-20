;Ejercicio de Clase: Dados dos números, 'x' y 'y'
;Si x >= y, imprimir la cadena 'hola'
;Si x < y, imprimir la cadena 'adios'
title "Ejercicio de clase" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Datos - Variables
x		db		10
y		db		20
hola		db		"Hola mundo!",0Ah,0Dh,"$"
adios		db		"Adios mundo!",0Ah,0Dh,"$"
	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;Código - Programa

	mov al,[x]			;AX = [x]
	cmp al,[y]			;Compara AL con [y]
	jb et_adios 			;Si AL < [y], entonces salta a etiqueta adios
et_hola:
	lea dx,[hola]		;Obtiene la direccion de donde inicia la cadena 'hola'
	jmp imprimir_cadena
et_adios:
	lea dx,[adios]		;Obtiene la direccion de donde inicia la cadena 'adios'
imprimir_cadena:
	mov ah,09h			;AH = 09h, prepara AH para interrupcion 21h
	int 21h				;int 21h, AH = 09h. Imprime en pantalla la cadena que empieza en DX
						;Se imprimen los caracteres hasta encontrar $
salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa