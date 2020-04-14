;;; Calculadora en ensamblador
;;; @autor : Andres Urbano Guillermo
;;; @date: April 14 2020

	title "Calculadora"
	.model small
	.386
	.stack 64

	.data
	titulo	db	"Calculadora RETRO$"


	.code
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax
;;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lea bp,[titulo]
	mov ax, 1300h
	mov bl, 03h
	mov dh, 00h
	mov dl, 00h
	int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
salir:
	mov ax, 4C00h
	int 21
	end inicio
	
	
