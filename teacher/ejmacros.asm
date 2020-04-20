title "Ejemplo de uso de macros" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
clear macro	;Macro para limpiar pantalla de la terminal
	mov ah,00h 	;ah = 00h, limpia la pantalla
	mov al,03h	;al = 03h. opcion de interrupcion
	int 10h		;llama interrupcion 10h
endm
	.data		;Definicion del segmento de datos
;Datos - Variables
mensaje1		db 		"Hola mundo! Presiona [enter] para limpiar la pantalla...$"
mensaje2		db 		"Presiona [enter] para finalizar...$"
	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos

;Impresion del mensaje1
	lea dx,[mensaje1] 	;DX = direccion donde comienza mensaje1
	mov ah,09h 	
	int 21h				;int 21h con opcion 09h. Imprime la cadena de caracteres apuntada por DX hasta encontrar '$'
;lee entrada de teclado
;Ciclo hasta que la tecla ingresada es [enter]
lee_teclado1:
	mov ah,01h
	int 21h				;int 21h con opcion 01h. Lectura de teclado con eco
	cmp al,0Dh 			;compara si la entrada de teclado fue [enter]
	jne lee_teclado1	;Si no fue [enter], regresa a lee_teclado1
	
	clear 			;Macro para limpiar pantalla

;Impresion del mensaje2
	lea dx,[mensaje2] 	;DX = direccion donde comienza mensaje2
	mov ah,09h 	
	int 21h				;int 21h con opcion 09h. Imprime la cadena de caracteres apuntada por DX hasta encontrar '$'
;Vuelve a leer entrada de teclado
;Ciclo hasta que la tecla ingresada es [enter]
lee_teclado2:
	mov ah,01h
	int 21h				;int 21h con opcion 01h. Lectura de teclado con eco
	cmp al,0Dh 			;compara si la entrada de teclado fue [enter]
	jne lee_teclado2	;Si no fue [enter], regresa a lee_teclado2

salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa
