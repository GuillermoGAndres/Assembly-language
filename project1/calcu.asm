;;; Calculadora en ensamblador
;;; @autor : Andres Urbano Guillermo
;;; @date: April 14 2020

	title "Calculadora"
	.model small
	.386
	.stack 64

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	num1	dw	01A2Eh
	num2	dw	0BC1Ah
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	unidad	dw	0
	decimaa	dw	0
	centesimas	dw	0
	milesimas	dw	0
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
	push [num1]
	push [num2]
	call SUMA 		;Deje en la pila el resultado
	pop ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
salir:
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Aqui salimos de leer nuestro primer numero que esta guardado en digits ahora hay que guardar ese numero en una varible y convertirdo en decimal, so
	mov cx, word ptr[cuentadigitos]
ajustar:
	mov di, cx
	xor ax,ax		;Inicializo el contador
	sub [digitos+di] , 30h
	loop ajustar
	
	
	
	mov ax, 4c00h
	int 21h
	end inicio
	
	
