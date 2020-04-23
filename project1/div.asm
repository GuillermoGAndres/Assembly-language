	title "a"
	.model small
	.stack 64
	.386
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

	num1	dw	9999d
	num2	dw	9999d
	dmil	dw	10000d
	aux	dw	?
	.code				;segmento de codigo
IMPRIME_BX	proc  		;Se pasa un numero a traves del registro BX que se va a imprimir con 5 digitos

;Calcula digito de unidades de millar
	mov ax,bx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
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
				;; imprime_caracter 0Ah
				;Macro para imprimir caracter
							;0Ah es salto de linea
	ret 					;intruccion ret para regresar de llamada a procedimiento
endp

inicio:
	mov ax, @data
	mov ds, ax
	xor ax,ax
;;; _______________________________

	mov ax, num1
	mul num2

	div dmil

	mov bx, ax
				;Necesito guardar antes de que se pierda
	mov aux, dx
	call IMPRIME_BX

	mov bx, aux
	call IMPRIME_BX
	
	

salir:
	mov ax, 4c00h
	int 21h
	end inicio

	
	
	
