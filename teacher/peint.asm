title "EyPC 2020-1 - Proyecto final (Codigo Base - User Interface)" ;directiva 'title' opcional
	ideal			;activa modo ideal del Turbo Assembler
	model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	stack 256		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
	macro clear
		mov ah,00h 	;ah = 00h, limpia la pantalla
		mov al,03h	;al = 03h. opcion de interrupcion
		int 10h		;llama interrupcion 10h
	endm
	macro posicionaCursor renglon,columna
		mov dh,renglon	;dh = renglon
		mov dl,columna	;dl = columna
		mov ax,0200h 	;preparar ax para interrupcion, opcion 2
		int 10h 	;interrupcion que maneja entrada y salida de video
	endm 
	macro inicia 	;para el valor inicial del DS
		mov ax,@data
		mov ds,ax
	endm
	macro inteclado	;para entradas del teclado 
		mov ah,10h 	;opcion 10
		int 16h		;interrupcion 16h (maneja la entrada del teclado)
		in al,60h 	;entrada desde teclado
	endm
	macro revisamouse	;para verificar si existe el driver del mouse
		mov ax,0		;opcion 0
		int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
						;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
	endm
	macro muestracursormouse	;para hacer el cursor del mouse visible
		mov ax,1		;opcion 1
		int 33h			;llama interrupcion 33h para manejo del mouse. Habilita la visibilidad del cursor del mouse en el programa
	endm
	macro modovideo modo
		mov al,modo
		mov ah,0
		int 10h
	endm
	macro ocultacursorteclado
		mov ah,01h
		mov cx,2607h
		int 10h
	endm
	macro imprimeselector renglon,columna
		mov dh,renglon
		mov dl,columna
		mov ax,0200h 	;preparar ax para interrupcion, opcion 2
		int 10h 	;interrupcion que maneja entrada y salida de video
		mov bl,0Fh
		mov ah,09h
		mov al,31
		mov cx,1
		int 10h
	endm
	dataseg
nomouse		db 	'No se encuentra driver de mouse. [Enter] para salir$'
;Los siguientes comentarios sirven de ayuda visual en codigo fuente
;numero de columna, se pondra el numero de columna de la UI
;				000,	001		002		003		004		005		006		007		008		009		010		011		012		013		014		015		016		017		018		019		020		021		022		023		024		025		026		027		028		029		030		031		032		033		034		035		036		037		038		039		040		041		042		043		044		045		046		047		048		049		050		051		052		053		054		055		056		057		058		059		060		061		062		063		064		065		066		067		068		069		070		071		072		073		074		075		076		077		078		079
renglon0	db	201,	164,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	'P',	'E',	'I',	'N',	'T',	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	203,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	187
renglon1	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	'C',	'O',	'L',	'O',	'R',	'E',	'S',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon2	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon3	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	0Eh,	0Eh,	0Eh,	' ',	0Ah,	0Ah,	0Ah,	' ',	0Ch,	0Ch,	0Ch,	' ',	09h,	09h,	09h,	' ',	' ',	186
renglon4	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	0Eh,	0Eh,	0Eh,	' ',	0Ah,	0Ah,	0Ah,	' ',	0Ch,	0Ch,	0Ch,	' ',	09h,	09h,	09h,	' ',	' ',	186
renglon5	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon6	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon7	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	'F',	'O',	'R',	'M',	'A',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon8	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon9	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon10	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	219,	' ',	' ',	219,	' ',	219,	' ',	219,	219,	219,	' ',	' ',	186
renglon11	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	219,	' ',	' ',	219,	219,	219,	' ',	' ',	219,	' ',	' ',	219,	219,	219,	' ',	' ',	186
renglon12	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	219,	' ',	' ',	219,	' ',	219,	' ',	219,	219,	219,	' ',	' ',	186
renglon13	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon14	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon15	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	218,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	191,	186
renglon16	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	179,	' ',	' ',	' ',	' ',	' ',	'B',	'O',	'R',	'R',	'A',	'R',	' ',	' ',	' ',	' ',	' ',	179,	186
renglon17	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	192,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	217,	186
renglon18	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	204,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	185
renglon19	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon20	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	218,	196,	196,	196,	196,	196,	196,	196,	196,	191,	' ',	' ',	' ',	' ',	186
renglon21	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	179,	' ',	'C',	'E',	'R',	'R',	'A',	'R',	' ',	179,	' ',	' ',	' ',	' ',	186
renglon22	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	192,	196,	196,	196,	196,	196,	196,	196,	196,	217,	' ',	' ',	' ',	' ',	186
renglon23	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon24	db	200,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	202,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	188
color		db 	0Eh 	;variable color que almacena el atributo actual de color para interrupcion 10h
; 00h: Negro
; 01h: Azul
; 02h: Verde
; 03h: Cyan
; 04h: Rojo
; 05h: Magenta
; 06h: Cafe
; 07h: Gris Claro
; 08h: Gris Oscuro
; 09h: Azul Claro
; 0Ah: Verde Claro
; 0Bh: Cyan Claro
; 0Ch: Rojo Claro
; 0Dh: Magenta Claro
; 0Eh: Amarillo
; 0Fh: Blanco
forma 		db 	1	;variable para almacenar la forma de la herramienta de dibujo en el lienzo
; 1: punto
; 2: cruz +
; 3: cruz x
; 4: cuadro (3x3)
selectorcolor	db 	63	;variable selectorcolor que guarda el valor de la columna donde se encuentra el selector de color
; 63: en amarillo
; 67: en verde
; 71: en rojo 
; 75: en azul
selectorforma	db 	63	;variable selectorforma que guarda el valor de la columna donde se encuentra el selector de forma
; 63: en punto
; 67: en cruz +
; 71: en cruz x
; 75: en cuadro (3x3)
numaux8		db 	8 	;variable numaux8 que almacena el valor 8 para hacer el calculo de las coordenadas del cursor del mouse en resolucion 80x25 
	codeseg
inicio:
	inicia			;"inicializando" el registro DS
	clear			;limpiar pantalla
	revisamouse		;macro para revisar driver de mouse
	xor ax,0FFFFh	;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz imprimeui	;Si existe el driver del mouse, entonces salta a 'imprimeui'
	;Si no existe el driver del mouse entonces se ejecutan las siguientes instrucciones
	lea dx,[nomouse]
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado'
imprimeui:
	ocultacursorteclado 	;macro para ocultar el cursor del teclado
	muestracursormouse 		;macro para mostrar el cursor del mouse
	call UI 		;llama procedimiento que imprimer la interfaz de usuario del programa
mouse:
	mov ax,3
	int 33h
	xor bx,0001h
	jnz mouse
	mov ax,dx
	div [numaux8]
	mov dx,ax
	xor dh,dh
	mov ax,cx
	div [numaux8]
	mov cx,ax
	xor ch,ch
	cmp cx,60
	jge botoncerrar0
lienzo:
	jmp mouse
botoncerrar0:
	cmp dx,19
	jge botoncerrar1
	jmp mouse
botoncerrar1:
	cmp cx,65
	jge botoncerrar2
	jmp mouse
botoncerrar2:
	cmp dx,22
	jle botoncerrar3
	jmp mouse
botoncerrar3:
	cmp cx,74
	jle salir
	jmp mouse
teclado:
	inteclado
	cmp al,01Ch		;compara la entrada de teclado si fue [enter]
	jnz teclado
salir:
	clear			;limpiar pantalla
	mov ax,04C00h	;opcion 4c
	int 21h			;sale del programa

;procedimiento UI
;no requiere parametros de entrada
;Dibuja la interfaz de usuario del programa 
proc UI
	mov bp,sp
	mov di,0		;di = 0000h, registro indice a 0
	mov dh,0		;dh = 00h, para poner cursor en renglon 0
	mov dl,0		;dl = 00h, para poner cursor en columna 0
	mov cx,25		;cx = 25d = 19h. Prepara registro CX para loop. Recorre 25 renglones para mostrar la interfaz de usuario de programa
renglon:
	push cx 		;almacena primer valor de CX  
	mov cx,50h		;preparando para loop
columna:
	push cx 		;almacena temporalmente el valor de CX en la pila
	mov ax,0200h	;prepara opcion 2 para posicionar cursor
	mov bh,0		;prepara bx, pagina 0
	int 10h			;coloca el cursor en (dh,dl)
	mov al,[renglon0+di]	;al = [bx+di]
	cmp al,09h
	je azul
	cmp al,0Ch
	je rojo 
	cmp al,0Eh
	je amarillo
	cmp al,0Ah
	je verde 
	mov bl,0Fh
	jmp imprimircaracter
azul:
	mov al,219
	mov bl,09h		;bl = 0Eh , guarda los atributos del caracter
	jmp imprimircaracter
rojo:
	mov al,219
	mov bl,0Ch
	jmp imprimircaracter
amarillo:
	mov al,219
	mov bl,0Eh
	jmp imprimircaracter
verde:
	mov al,219
	mov bl,0Ah
imprimircaracter:
	mov ah,09h		;opcion 9 para interrupcion 10h
	mov cx,1		;cx = 1, se imprimiran cx caracteres
	int 10h			;interrupcion 10h. Imprime el caracter contenido en AL, CX veces.
	inc di 			;di = di + 1, recorrido por columna
	inc dl 			;dl = dl + 1, recorre a la siguiente columna
	pop cx 			;saca el valor de CX almacenado temporalmente en la pila
	loop columna	;salto a 'columna' si CX es diferente de 0
	mov dl,0		;para regresar a la columna 0
	inc dh			;se recorre un renglon
	pop cx 			;recupera valor de registro CX almacenado anteriormente
	loop renglon 	;salta a renglon si CX diferente de 0
	imprimeselector 2,[selectorcolor]
	imprimeselector 9,[selectorforma]
	ret 			;Regreso de llamada a procedimiento
endp	 			;Indica fin de procedimiento UI para el ensamblador
	end inicio 		;Fin del programa