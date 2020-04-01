	;; Hola mundo en lenguaje ensamblador para arquitectura intel x86
	title "Hola mundo"
	.model small		;64kb de dates memory and 64kb of code memory
	.386 			;model of process intel 80386
	.data			;Definimos el segmento de datos
	msg	db	"Hola mundo!", '$'

	.code
	main proc
	mov ax, SEG msg
	mov ds ax
	mov dx, offset
