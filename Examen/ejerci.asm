title "ejerci"
    .model small
    .386
    .stack 64

    .data
x    db    10
y    dw    0
z    db     50
w   dw 	 0
    .code
inicio:
    mov ax,48B0h
    mov ds,ax
    mov al,[x]
    mov bl,[z]
    mul bl
    mov [y],ax
    cmp ax,300d
    jl salir
    cmp ax,1000d
    jg salir
    mov al,[u]
    mov bl,[v]
    mul bl
    mov [w],ax
salir:
    mov ax,4C00h
    int 21h
end inicio