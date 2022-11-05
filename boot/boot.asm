[org 0x7C00]
[bits 16]

start:
    mov si, hello_world
    call puts

panic:
    cli
    hlt

puts:
    push si
    push ax

.loop:
    lodsb 
    or al, al
    jz .done

    mov ah, 0x0e
    mov bh, 0

    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret


hello_world: db 'Hello, Rosehip!', 0