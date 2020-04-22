title "afal"
	.model small
	.stack 64
	.386
	
	.data
	sum	dw	0000d
	poten	dw	0001d
	array	db	2,5,4,3
	max	db	4
	.code
inicio:
	mov ax,@data
	mov ds, ax
	xor ax, ax
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov ch, 00d
	mov cl, max

	mov di, cx
	dec di

ajustar:
	mov ax, poten
	mov bh,00d
	mov bl, [array+di]
	mul bx
	add sum, ax

	mov ax,10d
	mul poten
	mov poten, ax
	dec di
	loop ajustar
	
	

salir:
	mov ax, 4c00h
	int 21h
	end inicio
