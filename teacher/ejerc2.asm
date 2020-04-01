title "Ejercicio 2: expresion matematica" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Variables
num1	dw		0E1C0h,548Bh,0A637h		;num1 de tipo word
num2	dw		0C193h,0F250h,0DF76h	;num2 de tipo word
res		dw		?,?,?,?					;res de tipo word
	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;AQUI VA SU CODIGO
	mov ax,[num1]		;AX = [num1], copia el primer bloque de num1 en registro AX de tamano word
;...
;SUMAR PRIMEROS BLOQUES Y GUARDAR
;...
	mov ax,[num1+2]		;AX = [num1+2], copia el segundo bloque de num1 en registro AX
;...
;SUMAR SEGUNDOS BLOQUES Y GUARDAR
;...
	mov ax,[num1+4]		;AX = [num1+4], copia el tercer bloque de num1 en registro AX
;...
;SUMAR TERCEROS BLOQUES Y GUARDAR
;...
;...
;GUARDAR ACARREO (SI HAY) EN CUARTO BLOQUE DE res
;...
salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa