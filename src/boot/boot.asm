[org 0x7C00]
[bits 16]

%define ENDL 0x0D, 0x0A

jmp short start
nop

; fat16 info

db 'ROSE HIP'
dw 512
db 1
dw 1
db 2
dw 0E0h
dw 2880
db 0F0h
dw 9
dw 18
dw 2
dd 0
dd 0

; extended boot record
db 0
db 0
db 29h
db 'test'
db 'ROSE HIP OS'
db 'FAT16   '

start:
    cli
    hlt

db 'hi', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h