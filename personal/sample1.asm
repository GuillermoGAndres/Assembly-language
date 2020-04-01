	.model small
	.stack	100h
	.data
	msg	db "Merry Christmas!",'$'
	.code		 ;Define su segmento de codigo
	main	proc		;Crea un procedimiento llamdao main (funcion)
	mov ax, SEG msg
	mov	ds, ax
	mov	dx, offset msg
	mov	ah, 9
	int	21h		;Señal de interrupcion 21h, pasa el control al sistema operativo
	mov	ax, 4c00h	;AX ES UN ARGUMENTO NECESARIO PARA INTERRUPCIONES,4h Opcion para terminar el programa,  0 exit code, codigo devuelto al finalizar el programa
	int	21h		;Señal de interrupcion 21h, pasa el control al sistema operativo
	main	endp
	end	main
