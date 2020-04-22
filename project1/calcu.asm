;;; Calculadora en ensamblador
;;; @autor : Andres Urbano Guillermo
;;; @date: April 14 2020

	title "Calculadora"
	.model small
	.386
	.stack 64
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Macros
imprime_caracter	macro 	caracter ;'0'-30h, '1'-31h, '2'-32h,...,'9'-39h
	mov ah,02h				;preparar AH para interrupcion, opcion 02h
	mov dl,caracter 		;DL = caracter a imprimir
	int 21h 				;int 21h, AH=02h, imprime el caracter en DL
endm
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear macro	;Macro para limpiar pantalla de la terminal
	mov ah,00h 	;ah = 00h, limpia la pantalla
	mov al,03h	;al = 03h. opcion de interrupcion
	int 10h		;llama interrupcion 10h
endm
	.data
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	titulo	db	"TER arodaluclaC"
	color	db	1d
	salto	db	0Ah,"$"	;0Ah es salto de linea
	tab	db	09h,"$" ;tab horizontal
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Valores para ajustar la entrada
	max_digitos	equ	4 ;Constante no ocupa espacio de memoria/cantidad maxima para la entrada
	digitos	db	max_digitos dup(0)
	cuentadigitos	db	0
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	msg1	db	"Ingrese el primer numero, maximo ",max_digitos+30h," y presiona [enter para confirmar]: $"
	msg2	db	"Ingrese el segundo numero, maximo ",max_digitos+30h," y presiona [enter para confirmar]: $"
	
	msgback	db	"�Desea volver al inicio? [Y/N]: $"
	msgwarn db	"Esa letra no es Y ni N, por favor vuelva a intentar escribirlo :d$"
	max	equ	1
	holaMundo	db	"Hola mundo$"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	msgsuma		db	"La suma de ambos numeros es :$"
	msgresta	db	"La resta de ambos numeros es :$"
	msgresta2	db	"La resta de ambos numeros es: un numero negativo$"
	msgmulti	db	"La multiplicacion de ambos numeros es :$"
	msgcocien	db	"La cociente de ambos numeros es :$"
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; num1	dw	01A2Eh
	;; num2	dw	0BC1Ah
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	diezmil		dw		10000d
	mil		dw		1000d
	cien 		dw 		100d
	diez		dw		10d
	
	array	db	0,0,0,0
	num1	dw	0000d
	num2	dw	0000d
	poten	dw	0001d
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.code
;;; SUMA con dos Operandos de 16 bits
SUMA proc
	mov bp, sp
	mov bx, [bp+2]
	add bx, [bp+4]
	mov [bp+2], bx
	ret
	endp

;;; ********************************************************************************************
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

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
;;; ;;;;;;;;;;;;;;;;;;;;
	;; Imprimer un tab horizontal
	lea dx, tab
	mov ah, 09h
	int 21h
;;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Titulo de la interfaz
	mov cx, 15		;Tama�o de la cadena
	mov di, 0d		;Indice 
loop1:	
	mov al,[titulo + di]
	mov ah, 09h
	mov bl, color		;Rango de colores
	int 10h
	inc color		;Aumentamos para cambiar el rango
	inc di			;Para recorrer la cadena
	loop loop1
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Imprimer un salto de linea
	lea dx, salto
	mov ah, 09h
	int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Inicio leer los dos primeros numeros
;;;Imprimir mensaje
startProgram:
	;; Inicializar variables para cuando entre nuevamentes
	mov num1, 0000d
	mov num2, 0000d
	mov poten, 0001d
	mov cuentadigitos, 0d
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lea dx, msg1
	mov ah, 09h
	int 21h
;;;Leer del teclado(scanf, cin, input,..,n);
	;//lee_teclado1:
	;//mov ah, 01h		;Con ECO (Es decir cade vez que escribes se muestra en la pantalla)
	;//int 21h
	;//cmp al, 0Dh		;Compara el caracter detectado con el caracter enter
	;//jne lee_teclado1
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lee_numero:
	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO (No se muestra se utiliza mucho en contrase�as de UNIX)
	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	je salir			;Si tecla es [enter], salta a etiqueta imprimir_num
	
	;Las siguientes dos comparaciones sirven para verificar si la tecla presionada se encuentra entre 30h y 39h
	;es decir, los digitos 0-9
	;Si está fuera de ese rango, entonces la tecla no fue un carácter numérico	
	cmp al,30h 			
	jl lee_numero 		;Si el valor ASCII de la tecla es menor a 30h, no es número y regresa a leer caracteres
	cmp al,39h 			
	jg lee_numero		;Si el valor ASCII de la tecla es mayor a 39h, no es número y regresa a leer caracteres
	
	;La siguiente comparacion sera para revisar si el contador de digitos ya alcanzo el maximo permitido
	mov bl,max_digitos		;Copia a BL el valor de la constante max_digitos
	cmp [cuentadigitos],bl	;Compara cuentadigitos con BL
	jge lee_numero 		;Si cuentadigitos es mayor o igual que BL, entonces regresa a leer numeros

	;Si el contador aun no alcanza el maximo, entonces permitimos el digito y lo almacenamos
	;ademas de incrementar el contador e imprimir el numero que no se ha imprimido
	mov di,word ptr [cuentadigitos] 	;utilizamos 'cuentadigitos' como indice para acceder la variable 'digitos'
				;se hace un "cast" de cuentadigitos ya que es de tamaño byte
	;; Esto solo ajusta la parte baja de di, la parte highter no la ajusta entonces la tenemos que ajustar
	mov bh, 0h
	mov bl, cuentadigitos
	mov di, bx
	
;;; ;;;;
	;; Aqui en mi array ya obtengo mi 
	lea bx,array
	mov bl,al
	sub bl,30h
				;sub al, 30h
	mov [array+di],bl
	
;;; ;;
	mov [digitos + di],al 	;Guardamos el caracter del teclado en la localidad 'di-esima' de la variable 'digitos'

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Aqui es donde vamos a tratar el caracter 
	;Se imprime el caracter
	mov ah,02h		;AH=02h para int 21h
	mov dl,al 		;DL=AL, que contiene el caracter ingresado por el usuario
	int 21h 		;int 21h opcion AH=02h, imprime el caracter contenido en DL

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;Incrementamos contador y regresamos a leer el siguiente caracter
	inc [cuentadigitos] 	;se incrementa el contador
	jmp lee_numero		;regresa al flujo de lee_numero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;Suma
	;; push [num1]
	;push [num2]			
	;//call SUMA 		;Deje en la pila el resultado
	;//pop ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
salir:
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Aqui salimos de leer nuestro primer numero que esta guardado en digits ahora hay que guardar ese numero en una varible y convertirdo en decimal, so	

				;//	mov cx, word ptr[cuentadigitos]

	lea cx,num1
	
	mov ch,00d
	mov cl, cuentadigitos
	
	mov di, cx
	dec di
	
	;; Convertimos nuestro digitos ascii en numeros
ajustar:
	mov ax, poten
	mov bh,00d
	mov bl, [array+di]
	mul bx
	add num1, ax

	mov ax,10d
	mul poten
	mov poten, ax
	dec di
	loop ajustar

	mov ax, num1
	xor ax, ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;

;; Imprimer un salto de linea
	lea dx, salto
	mov ah, 09h
	int 21h
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Vamos a leer el numero 2 se puede acortar codigo utilizando un macro pero por cuestiones de tiempo lo dejamos asi
	mov cuentadigitos, 0d
	mov poten, 0001d
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Imprimir mensaje
	lea dx, msg1
	mov ah, 09h
	int 21h
;;;Leer del teclado(scanf, cin, input,..,n);
	;//lee_teclado1:
	;//mov ah, 01h		;Con ECO (Es decir cade vez que escribes se muestra en la pantalla)
	;//int 21h
	;//cmp al, 0Dh		;Compara el caracter detectado con el caracter enter
	;//jne lee_teclado1
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lee_numero2:
	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO (No se muestra se utiliza mucho en contrase�as de UNIX)
	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	je salir2			;Si tecla es [enter], salta a etiqueta imprimir_num
	
	;Las siguientes dos comparaciones sirven para verificar si la tecla presionada se encuentra entre 30h y 39h
	;es decir, los digitos 0-9
	;Si está fuera de ese rango, entonces la tecla no fue un carácter numérico	
	cmp al,30h 			
	jl lee_numero2 		;Si el valor ASCII de la tecla es menor a 30h, no es número y regresa a leer caracteres
	cmp al,39h 			
	jg lee_numero2		;Si el valor ASCII de la tecla es mayor a 39h, no es número y regresa a leer caracteres
	
	;La siguiente comparacion sera para revisar si el contador de digitos ya alcanzo el maximo permitido
	mov bl,max_digitos		;Copia a BL el valor de la constante max_digitos
	cmp [cuentadigitos],bl	;Compara cuentadigitos con BL
	jge lee_numero2 		;Si cuentadigitos es mayor o igual que BL, entonces regresa a leer numeros

	;Si el contador aun no alcanza el maximo, entonces permitimos el digito y lo almacenamos
	;ademas de incrementar el contador e imprimir el numero que no se ha imprimido
	mov di,word ptr [cuentadigitos] 	;utilizamos 'cuentadigitos' como indice para acceder la variable 'digitos'
				;se hace un "cast" de cuentadigitos ya que es de tamaño byte
	;; Esto solo ajusta la parte baja de di, la parte highter no la ajusta entonces la tenemos que ajustar
	mov bh, 0h
	mov bl, cuentadigitos
	mov di, bx
	
;;; ;;;;
	;; Aqui en mi array ya obtengo mi 
	lea bx,array
	mov bl,al
	sub bl,30h
				;sub al, 30h
	mov [array+di],bl
	
;;; ;;
	mov [digitos + di],al 	;Guardamos el caracter del teclado en la localidad 'di-esima' de la variable 'digitos'

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Aqui es donde vamos a tratar el caracter 
	;Se imprime el caracter
	mov ah,02h		;AH=02h para int 21h
	mov dl,al 		;DL=AL, que contiene el caracter ingresado por el usuario
	int 21h 		;int 21h opcion AH=02h, imprime el caracter contenido en DL

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;Incrementamos contador y regresamos a leer el siguiente caracter
	inc [cuentadigitos] 	;se incrementa el contador
	jmp lee_numero2		;regresa al flujo de lee_numero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;Suma
	;; push [num1]
	;push [num2]			
	;//call SUMA 		;Deje en la pila el resultado
	;//pop ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
salir2:
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Aqui salimos de leer nuestro primer numero que esta guardado en digits ahora hay que guardar ese numero en una varible y convertirdo en decimal, so	

				;//	mov cx, word ptr[cuentadigitos]

	lea cx,num2
	
	mov ch,00d
	mov cl, cuentadigitos
	
	mov di, cx
	dec di
	
	;; Convertimos nuestro digitos ascii en numeros
ajustar2:
	mov ax, poten
	mov bh,00d
	mov bl, [array+di]
	mul bx
	add num2, ax

	mov ax,10d
	mul poten
	mov poten, ax
	dec di
	loop ajustar2

	mov ax, num2

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lea dx, salto
	mov ah, 09h
	int 21h
;;; ;;;;;;;;;;;;;;;;;;;;
	mov bx, num1
	call IMPRIME_BX
;;; ;;;;;;;;;;;;;;
	;; lea dx, salto;;mov ah, 09h;	int 21h			
;;; ;;;;;;;;;;;;;;;;;;;;
	mov bx, num2
	call IMPRIME_BX
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;
	lea dx, salto
	mov ah, 09h
	int 21h
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OPERACIONES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Ya tengo un num1 y num
;;; ;;;;;;;;;;;;;;;;;;;;;SUMA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;	msgsuma	db	"La suma de ambos numeros es :$"
	lea dx, msgsuma
	mov ah, 09h
	int 21h

	mov bx, num1
	add bx, num2

	call IMPRIME_BX

	lea dx, salto
	mov ah, 09h
	int 21h
;;; ;;;;;;;;;;;;;;;;;;;;;;RESTA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov bx, num1
	sub bx, num2
	js negativo
	jmp positivo

negativo:
	lea dx, msgresta2
	mov ah, 09h
	int 21h
	jmp saltar

positivo:
	lea dx, msgresta
	mov ah, 09h
	int 21h
	call IMPRIME_BX

saltar:
	lea dx, salto
	mov ah, 09h
	int 21h
	
;;; ;;;;;;;;;;;;;;;;;;;;;;MULTIPLICACION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	lea dx, msgmulti
	mov ah, 09h
	int 21h

	mov ax, num1
	mul num2

	mov bx, ax
	call IMPRIME_BX

	lea dx, salto
	mov ah, 09h
	int 21h


;;; ;;;;;;;;;;;;;;;;;;;;;;;;DIVISION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;











	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PREGUNTAR AL USUARIO SI QUIERE VOLVER ENTRAR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
preguntar:
	
	lea dx, msgback
	mov ah, 09h
	int 21h
	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	mov cuentadigitos, 0d
	
lee_char:
	mov ah,01h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO (No se muestra se utiliza mucho en contrase�as de UNIX)
				;cmp al,0Dh 			;compara si la tecla presionada fue [enter]
				;je salir3			;Si tecla es [enter], salta a etiqueta imprimir_num
;;; ;;;;;;;;;;;
	lea dx, salto
	mov ah, 09h
	int 21h
;;; ;;;;;;;;;;,
	cmp al, 59h
	je startProgram
	cmp al, 4Eh
	je finporfin
;;; ;;;;;;;;;;;;;;;;;;;
	lea dx, msgwarn
	mov ah, 09h
	int 21h

	lea dx, salto
	mov ah, 09h
	int 21h
	
;;; ;;;;;;;;;;;
	jmp preguntar
	
	
	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finporfin:
	mov ax, 4c00h
	int 21h
	end inicio
	
	
