	title "Suma de dos numeos"	; Programa que suma dos numeros
	.model small
	.386
	.stack 64		;reseve 64 bytes
	.data			;reserve storage for data
;;; Definicion de variables (datos)
	x	db	35h	;53 decimal
	y	db	23h	;35 decimal
	z	db	?
;;; Definicion de staments (codigo)
	.code			
inicio:	mov ax,@data		;Etiqueta llamada inicio, @data tiene la direccion de segmento de datos
	mov ds, ax
	mov ax, 0		;Inicializa el registro ax = 00 00h
;;;Statament
	mov al,x		;move al = x
	add al,y
	;; lea ax,x  Con eso obtienes la direccion de x
	;; lea ax,y  direccion de y

	mov z,al		;z = al
salir:	mov ah, 4Ch		;4Ch Opcion para terminar el programa(llama la funcion 4C del vector interrupt)
	mov al,1		; 0 exit code, codigo devuelto al finalizar el programa
	;; AX ES UN ARGUMENTO NECESARIO PARA INTERRUPCIONES
	;; mov ax,4c00h;
	int 21h   		;Señal de interrupcion 21h, pasa el control al sistema operativo
	end inicio
	
	
