;;; Imprimie el titulo con letras de color
	title "Hola mundo retro asembly"
	.model small
	.386
	.stack 64

	.data
	texto		db	"Hola mundo"
	contador	db	1d
	back		db	11d
	.code
inicio:
	mov ax, @data
	mov ds, ax
	xor ax, ax

	mov cx, 10d

	mov dh, 0d		;Row cursor
	mov dl, 0d		;Column cursor
	mov di, 0d		;Indice que se dezplaza
loop1:
	mov al, [texto + di]
	mov ah, 09h
	
	mov bl,contador
	;; mov cx,1
	
	int 10h
	
	inc contador
	;; Mover el cursor
	mov ah, 02h
	int 10h
	inc dh
	inc di
	 loop loop1

fin:
	mov ax, 4c00h
	int 21h
	end inicio
	
