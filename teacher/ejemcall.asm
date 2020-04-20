title "Ejemplo instrucción CALL" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	clear  macro
		mov ah,0
		mov al,3
		int 10h
	endm
	.data		;Definicion del segmento de datos
;Datos - Variables
var1			db		0
num_cuadrado	dw		0
	.code				;segmento de codigo
;Ejemplo de procedimiento: paso de parámetros por variables
CUADRADO_VARS proc
	push bp
	mov bp,sp
	mov al,[var1]
	mul al
	mov [num_cuadrado],ax
	mov sp,bp
	pop bp
	ret
	endp

;Ejemplo de procedimiento: paso de parámetros por registros
CUADRADO_REGS 	proc 
	push bp
	mov bp,sp
	mov al,cl
	mul al
	mov sp,bp
	pop bp
	ret
	endp

;Ejemplo de procedimiento: paso de parámetros por stack
CUADRADO_STACK 	proc 
	mov bp,sp
	mov ax,[bp+2]
	xor ah,ah
	mul al
	mov [bp+2],ax
	ret
	endp
inicio:
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;Código - Programa
	;Paso de parametros por variables
	mov [var1],10d			;[var1] = 0Ah
	call CUADRADO_VARS		;ejecuta procedimiento CUADRADO_VARS
	mov bx,[num_cuadrado]	;BX = [num_cuadrado], lee el valor de la variable modificada en procedimiento CUADRADO_VARS

	;Paso de parametros por registros
	mov cl,10d				;CL = 0Ah
	call CUADRADO_REGS		;ejecuta procedimiento CUADRADO_REGS
	mov cx,ax				;CX = AX, lee el valor del registro AX modificado en procedimiento CUADRADO_REGS

	;Paso de parametros por registros
	mov dx,10d				;DX = 000Ah
	push dx					;Introduce el contenido de DX a la pila
	call CUADRADO_STACK 	;ejecuta procedimiento CUADRADO_STACK
	pop dx					;DX = cima de la pila, lee el valor de la pila modificado en procedimiento CUADRADO_STACK

salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa