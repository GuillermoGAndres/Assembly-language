title "Ejemplo para lectura de numeros" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada pagina de codigo
	.model small ;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386		;directiva para indicar version procesador
	.stack 64 	;Define el tamano del segmento de stack, se mide en bytes
	.data		;Definicion del segmento de datos
;Datos - Variables
max_digitos		equ 	2 	;constante, no ocupa espacio en memoria
ingresa_num		db 		0Ah,0Dh,"Ingresa un numero de hasta ",max_digitos+30h," digitos, y presiona [enter] para salir: $"
digitos 		db 		max_digitos dup(0) 	;duplica 'max_digitos' veces el valor 0 de tipo byte
						;esta reservando espacio de la memoria de datos para la variable 'digitos'
;digitos 		db 		4 dup(0) 	;duplica 4 bytes con el valor 0
									;sirve para reservar 4 bytes para la variable digitos
									
cuentadigitos	db		0	;variable para contar el número de digitos que se han ingresado

	.code				;segmento de codigo
inicio:					;etiqueta inicio
	mov ax,@data 		;AX = directiva @data, @data es una variable de sistema que contiene la direccion del segmento de datos 
	mov ds,ax 			;DS = AX, inicializa segmento de datos
;Código - Programa
	lea dx,[ingresa_num]	;DX apunta la cadena 'ingresa_num'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'
lee_numero:
	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO
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
	
	;Se imprime el caracter
	mov ah,02h		;AH=02h para int 21h
	mov dl,al 		;DL=AL, que contiene el caracter ingresado por el usuario
	int 21h 		;int 21h opcion AH=02h, imprime el caracter contenido en DL

	;Incrementamos contador y regresamos a leer el siguiente caracter
	inc [cuentadigitos] 	;se incrementa el contador
	jmp lee_numero		;regresa al flujo de lee_numero

salir:					;inicia etiqueta salir
	mov ah,4Ch			;AH = 4Ch, opcion para terminar programa
	mov al,0			;AL = 0 Exit Code, codigo devuelto al finalizar el programa
						;AX es un argumento necesario para interrupciones
	int 21h				;señal 21h de interrupcion, pasa el control al sistema operativo
	end inicio			;fin de etiqueta inicio, fin de programa