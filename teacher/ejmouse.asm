title "Ejemplo para uso del mouse" ;directiva 'title' opcional
	.model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	.386		;directiva para indicar version procesador
	.stack 256		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
clear	macro 	;para limpiar la pantalla
	mov ah,00h 	;ah = 00h opcion de modo de video para int 10h
	mov al,03h	;al = 03h, opcion para modo de video, limpia la pantalla
	int 10h		;llama interrupcion 10h
endm
posiciona_cursor	macro renglon,columna 	;para posicionar el cursor del teclado en la posicion renglon,columna
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov ax,0200h 	;preparar ax para interrupcion, opcion 2. 
	int 10h 	;interrupcion que maneja entrada y salida de video
endm 
inicializa_ds	macro 	;para el valor inicial del DS
	mov ax,@data 	;lee posicion del segmento de datos del programa
	mov ds,ax 	;establece registro DS en segmento de datos del programa
endm
int_teclado	macro	;para entradas del teclado 
	mov ah,01h 	;opcion 01, modifica bandera Z, si Z = 1, no hay datos en buffer de teclado. Si Z = 0, hay datos en el buffer de teclado
	int 16h		;interrupcion 16h (maneja la entrada del teclado)
endm
revisa_mouse	macro	;para verificar si existe el driver del mouse
	mov ax,0		;opcion 0
	int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
					;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm
muestra_cursor_mouse	macro	;para hacer visible el cursor del mouse
	mov ax,1		;opcion 1
	int 33h			;llama interrupcion 33h para manejo del mouse. Habilita la visibilidad del cursor del mouse en el programa
endm
modo_video	macro modo 	;para establecer el modo de video utilizado en el programa
	mov al,modo 		;carga en al el valor para establecer modo de video
	mov ah,0 			;opcion AH = 00h para modo de video con int 10h 
	int 10h 			;llama interrupcion 10h para establecer modo de video
endm
oculta_cursor_teclado	macro 	;para ocultar el cursor del teclado
	mov ah,01h		;opcion AH = 01h del cursor de teclado en int 10h
	mov cx,2607h 	;valor necesario en CX = 2607h para ocultar el cursor del teclado
	int 10h 		;llama interrupcion 10h
endm
lee_posicion_mouse	macro 	;para obtener la posicion actual del mouse con resolucion 640x200, CX almacena el valor de la columna y DX el del renglon
	mov ax,3 	;opcion AX = 0003h para leer posicion actual del mouse con int 33h
	int 33h 	;llama interrupcion 33h
endm
imprime_cadena	macro loc_cadena 	;para imprimir una cadena segun el nombre que se pasa como parametro
	lea dx,[loc_cadena] 	;se obtiene la localidad de memoria de la cadena y se guarda en DX
	mov ax,0900h	;opcion 9 para interrupcion 21h. Imprime una cadena apuntada por el registro DX
	int 21h			;interrupcion 21h. Imprime cadena.
endm
	.data
nomouse		db 	'No se encuentra driver de mouse. Presione cualquier tecla para salir$' ;cadena nomouse, se muestra cuando el driver del mouse no existe
cerrar 		db 	'Presione cualquier tecla para cerrar el programa$' ;cadena cerrar, se muestra cuando existe driver y el programa se esta ejecutando
columna		db 	'Columna: $' 	;cadena columna, se muestra cuando existe driver y el programa se esta ejecutando
renglon		db 	'Renglon: $' 	;cadena renglon, se muestra cuando existe driver y el programa se esta ejecutando
clicder		db 	'Clic derecho            $' 	;cadena clicder, se muestra cuando existe driver y se hace clic derecho con el mouse
clicizq		db 	'Clic izquierdo          $'		;cadena clicizq, se muestra cuando existe driver y se hace clic izquierdo con el mouse
clicderizq	db 	'Clic derecho e izquierdo$'		;cadena clicderizq, se muestra cuando existe driver y se hace clic izquierdo y derecho con el mouse
noclic		db 	'                        $' 	;cadena noclic, se muestra cuando existe driver y limpia el area de status de los botones del mouse
numaux8		db 	8 	;variable numaux8 que almacena el valor 8 para hacer el calculo de las coordenadas del cursor del mouse en resolucion 80x25 
tempax 		dw	0	;variable tempax para almacenar el valor del AX temporalmente
tempbx 		dw	0 	;variable tempbx para almacenar el valor del BX temporalmente
tempcx 		dw	0	;variable tempcx para almacenar el valor del CX temporalmente
tempdx 		dw	0 	;variable tempdx para almacenar el valor del DX temporalmente
	.code
inicio:
	inicializa_ds	;"inicializando" el registro DS
	clear			;limpiar pantalla
	revisa_mouse	;macro para revisar driver de mouse
	xor ax,0FFFFh	;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz mouse	;Si existe el driver del mouse, entonces salta a 'mouse'
	;Si no existe el driver del mouse entonces se ejecutan las siguientes instrucciones
	imprime_cadena nomouse 	;macro para imprimir una cadena de caracteres definida, recibe como parametro el nombre de la cadena
	jmp teclado_fin		;salta a 'teclado_fin' para finalizar el programa ya que no se encuentra el driver
mouse:
	oculta_cursor_teclado	;macro que ejecuta la interrupcion para ocultar el cursor del teclado
	muestra_cursor_mouse	;macro que ejecuta la interrupcion para mostrar el cursor del mouse
	imprime_cadena cerrar 	;macro para imprimir cadena cuyo nombre es 'cerrar'
info_mouse:
	posiciona_cursor 1,0	;macro para posicionar cursor del teclado en renglon = 1 y columna = 0
	imprime_cadena columna 	;macro para imprimir cadena cuyo nombre es 'columna'
	posiciona_cursor 1,9	;macro para posicionar cursor del teclado en renglon = 1 y columna = 9
	lee_posicion_mouse 		;macro para leer la posicion actual del cursor del mouse, al inicio se encuentra en el centro de la pantalla, renglon = 12 y columna = 40
	mov [tempbx],bx 	;almacena el valor del status de los botones del mouse en una variable temporal
	mov ax,dx 		;lee renglon del mouse dx=(0,199) y guarda en ax
	div [numaux8] 	;calcula el valor del renglon en resolucion 80x25 (columnasXrenglones)
	mov dx,ax 		;devuelve valor a registro dx 
	xor dh,dh 		;remueve parte alta de dx, el valor del renglon (0,24) cabe en dl
	mov [tempdx],dx	;almacena valor hexadecimal del renglon en variable temporal para DX
	mov ax,cx  		;lee columna del mouse cx=(0,639) y guarda en ax
	div [numaux8] 	;obtiene el valor de la columna en resolucion 80x25 (columnasXrenglones)
	mov cx,ax 		;devuelve el valor a registro cx
	xor ch,ch 		;remueve parte alta de cx, el valor del renglon (0,79) cabe en cl
	mov [tempcx],cx ;almacena valor hexadecimal del renglon en variable temporal para CX
	mov ax,cx 		;obtiene el valor hexadecimal del renglon 
	aam 			;convierte el valor hexadecimal en AX a Decimal Codificado en Binario (BCD), guarda las decenas en AH y las unidades en AL
	or ax,3030h		;pasa los valores BCD a su representacion en ASCII ('0' - 30h en ASCII a '9' - 39h en ASCII)
	mov [tempax],ax ;almacena caracteres ASCII en variable temporal para AX
	mov al,ah 		;pone el caracter de las decenas en AL para imprimirlo
	mov ah,09h 		;opcion 9 para interrupcion 10h, imprime el caracter ASCII en AL
	mov bl,0Fh		;bl = 0Fh , pone atributo de color al caracter que se imprime, 0Fh = blanco
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.
	posiciona_cursor 1,10	;macro para posicionar cursor del teclado en renglon = 1 y columna = 10
	mov ax,[tempax]	;recupera el valor temporal de AX, en AH estan las decenas y en AL estan las unidades
	mov ah,09h 		;opcion 9 para interrupcion 10h, imprime el caracter ASCII en AL
	mov bl,0Fh		;bl = 0Fh , pone atributo de color al caracter que se imprime, 0Fh = blanco
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.
	
	posiciona_cursor 2,0	;macro para posicionar cursor del teclado en renglon = 2 y columna = 0
	imprime_cadena renglon 	;macro para imprimir cadena cuyo nombre es 'renglon'
	posiciona_cursor 2,9 	;macro para posicionar cursor del teclado en renglon = 2 y columna = 9
	mov ax,[tempdx]	;obtiene el valor hexadecimal del renglon almacenado anteriormente
	aam 			;convierte el valor hexadecimal en AX a Decimal Codificado en Binario (BCD), guarda las decenas en AH y las unidades en AL
	or ax,3030h		;pasa los valores BCD a su representacion en ASCII ('0' - 30h en ASCII a '9' - 39h en ASCII)
	mov [tempax],ax ;almacena caracteres ASCII en variable temporal para AX
	mov al,ah 		;pone el caracter de las decenas en AL para imprimirlo
	mov ah,09h 		;opcion 9 para interrupcion 10h, imprime el caracter ASCII en AL
	mov bl,0Fh		;bl = 0Fh , pone atributo de color al caracter que se imprime, 0Fh = blanco
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.

	posiciona_cursor 2,10	;macro para posicionar cursor del teclado en renglon = 2 y columna = 10
	mov ax,[tempax] ;recupera el valor temporal de AX, en AH estan las decenas y en AL estan las unidades
	mov ah,09h 		;opcion 9 para interrupcion 10h, imprime el caracter ASCII en AL
	mov bl,0Fh		;bl = 0Fh , pone atributo de color al caracter que se imprime, 0Fh = blanco
	mov cx,1		;cx = 1, se imprimira CX veces el caracter contenido en AL
	int 10h 		;interrupcion 10h. Imprime cadena.
	
	posiciona_cursor 3,0 	;macro para posicionar cursor del teclado en renglon = 2 y columna = 10
	mov bx,[tempbx] 	;recupera el valor temporal de BX que almacena el status de los botones del mouse
	and bx,00000011b 	;mascara aplicada sobre BX para ignorar los bits que no corresponden a los botones derecho e izquierdo del mouse
	cmp bx,3			;compara si el valor del registro BX es 3, eso implicaria que ambos botones del mouse estan presionados
	je clic_derecho_izquierdo 	;si BX = 3 entonces se cumple condicion y salta a la etiqueta 'clic_derecho_izquierdo'
	cmp bx,2			;compara si el valor del registro BX es 2, eso implicaria que el boton derecho del mouse esta presionado
	je clic_derecho 	;si BX = 2 entonces se cumple condicion y salta a la etiqueta 'clic_derecho'
	cmp bx,1 			;compara si el valor del registro BX es 1, eso implicaria que el boton izquierdo del mouse esta presionado
	je clic_izquierdo 	;si BX = 1 entonces se cumple condicion y salta a la etiqueta 'clic_izquierdo'
	jmp no_clic 		;salto incondicional a etiqueta 'no_clic'
clic_izquierdo:
	lea dx,[clicizq] 	;carga en DX la localidad inicial de la cadena 'clicizq'
	jmp imprime 		;salto incondicional a etiqueta 'imprime'
clic_derecho:
	lea dx,[clicder] 	;carga en DX la localidad inicial de la cadena 'clicder'
	jmp imprime 		;salto incondicional a etiqueta 'imprime'
clic_derecho_izquierdo:
	lea dx,[clicderizq] 	;carga en DX la localidad inicial de la cadena 'clicderizq'
	jmp imprime 		;salto incondicional a etiqueta 'imprime'
no_clic:
	lea dx,[noclic] 	;carga en DX la localidad inicial de la cadena 'noclic'
imprime:
	mov ax,0900h	;opcion 9 para interrupcion 21h, imprime la cadena apuntada por DX hasta encontrar el caracter '$' (fin de cadena)
	int 21h			;interrupcion 21h. Imprime cadena.
	int_teclado 	;macro para revisar si hay entrada de teclado
	jnz salir		;si se detecta entrada de teclado, Z = 0 y salta a 'salir'
	jmp info_mouse 	;salta a etiqueta 'info_mouse', vuelve a obtener informacion de mouse e imprimirla
teclado_fin:
	int_teclado 	;macro para revisar si hay entrada de teclado
	jnz salir 		;si se detecta entrada de teclado, Z = 0 y salta a 'salir'
	jmp teclado_fin ;salta a etiqueta 'teclado_fin'
salir:
	clear			;limpiar pantalla
	mov ax,04C00h	;opcion 4c, exitCode = 00h de int 21h
	int 21h			;sale del programa
	end inicio 		;Fin del programa