title "Impresion de un numero decimal de 5 dígitos" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small 		;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386				;directiva para indicar version procesador
	.stack 64 			;Define el tamano del segmento de stack, se mide en bytes
;Macros
imprime_caracter	macro 	caracter ;'0'-30h, '1'-31h, '2'-32h,...,'9'-39h
	mov ah,02h				;preparar AH para interrupcion, opcion 02h
	mov dl,caracter 		;DL = caracter a imprimir
	int 21h 				;int 21h, AH=02h, imprime el caracter en DL
endm
	.data				;Definicion del segmento de datos
;Datos - Variables
diezmil		dw		10000d
mil			dw		1000d
cien 		dw 		100d
diez		dw		10d
	.code				;segmento de codigo
IMPRIME_BX	proc  		;Se pasa un numero a traves del registro BX que se va a imprimir con 5 digitos
;Calcula digito de decenas de millar
	mov ax,bx 				;pasa el valor de BX a AX para division de 16 bits
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [diezmil]			;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito decenas de millar 
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter

;Calcula digito de unidades de millar
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [mil]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter

;Calcula digito de centenas
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [cien]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter

;Calcula digito de decenas
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [diez]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter

;Calcula digito de unidades
	mov ax,cx 				;Recuperamos el residuo de la division anterior
							;Para este caso, el residuo debe ser un número entre 0 y 9
							;al hacer AX = CX, el residuo debe estar entre 0000h y 0009h
							;=> AX = 000Xh -> AH=00h y AL=0Xh
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter

;Imprimir salto de linea
	imprime_caracter 0Ah 	;Macro para imprimir caracter
							;0Ah es salto de linea
	ret 					;intruccion ret para regresar de llamada a procedimiento
endp
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;Código - Programa
	mov bx,321d
	call IMPRIME_BX
	
	mov bx,5562d
	call IMPRIME_BX
	
	mov bx,65535d
	call IMPRIME_BX

	mov bx,1d
	call IMPRIME_BX

	mov bx,-1d 			;BX = FFFFh
	call IMPRIME_BX

salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa