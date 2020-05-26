title "Ejercicio 7"
;@author Andres Urbano Guillermo Gerardo
.model small
.386
.stack 64

print macro texto
	;Imprime cadena de caracteres. Contenido de la variable texto
	lea dx,[texto]	;Obtiene posicion de memoria de la cadena que contiene la variable 'texto'
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
endm

	.data
	x db 0,2,3,4,7,8,9,10,12,15,18,20,17,14,13,11,9,6,4,2,1,0
	f dw 22 dup(?)		;reserva 100 bytes no inicializados para la variable uninitArray
	t db "expresion1",0Ah,0Dh,"$"
	t2 db "expresion2",0Ah,0Dh,"$"
	t3 db "expresion3",0Ah,0Dh,"$"
	divisor db 2d
	.code
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
	;;;;;;;;;;;;;;;;;;;;;;;
	mov cx, 22 ;Recorrer los primeros n del arreglo
	xor bx, bx
	;;Van a llevar el control
	mov di, 0	;di registro indice
	mov si, 0	;si registro indice
loop1:
	mov bl, [x+di]
	;;Logica
	cmp bl, 5
	jbe expresion1
	cmp bl, 10
	jbe expresion2
;Considerando que en el arreglo no hay numeros negativos, queda perfecto
expresion3:
	;print t3
	;x/2 + 4*x - 5
	;Dividiendo/divisor ,Dividiendo registro ax, divisor(implicito)
	;Resultado se guarda en ax, al cociente ,ah residuo 
	xor ax, ax
	mov al, bl
	div [divisor]
	;borramos el residuo y guardamos el resultado en la pila
	mov ah,0d
	push ax
	;multiplicador * Multiplicando -- x * 4
	mov al, 4
	mul bl
	;ax tiene la multiplicacion
	sub ax, 5d
	pop dx ; Sacamos nuestro valor de la pila
	;Sumanos
	add ax,dx

	jmp salir

expresion1:
	;print t
	;x^2 + 3 = x*x + 3
	;El resultado de la multiplicacion se guarada en ax, al sera el Multiplicando,bl mi multiplicador
	mov al, bl
	mul bl
	add ax, 3d
	jmp salir

expresion2:
	;print t2
	;f(xn-1) - 2
	mov ax, [f + si - 2] ;valor anterior
	sub ax, 2d

salir:	
	;Save result f
	mov dx, ax
	mov [f+si], dx
	inc di
	add si, 2d
	loop loop1

fin:
	mov ax, 4c00h
	int 21h
	end inicio

