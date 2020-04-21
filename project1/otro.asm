	title "afal"
	.model small
	.stack 64
	.386
	
	.data
	num	dw	1543d
	num2	dw	9999d

	.code
inicio:
	mov ax,@data
	mov ds, ax
	xor ax, ax
	
	mov ax,num
	add ax,num2

salir:
	mov ax, 4c00h
	int 21h
	end inicio
