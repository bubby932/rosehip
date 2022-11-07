[org 0x7C00]
[bits 16]

%define ENDL 0x0D, 0x0A

jmp short start
nop

; fat16 info

oem_name:               db 'ROSE HIP'
bytes_per_sector:       dw 512
sectors_per_cluster:    db 1
reserved_sector_count:  dw 1
table_count:            db 2
root_entry_count:       dw 0E0h
total_sectors_16:       dw 2880
media_type:             db 0F0h
table_size_16:          dw 9
sectors_per_track:      dw 18
head_side_count:        dw 2
hidden_sector_count:    dd 0
total_sectors_32:       dd 0

; extended boot record
ebr_drive_number:       db 0
nt_flags_reserved:      db 0
ebr_signature:          db 29h
ebr_serial_number:      db 'test'
ebr_volume_identifier:  db 'ROSE HIP OS'
ebr_system_identifier:  db 'FAT16   '

; Since this is the bootloader, all we need for FAT16 is reading the root directory,
; no directory recursion or writing to disk. That's for the kernel to handle.
start:
    ; C:
    ; root_dir_sectors = ((fat_boot->root_entry_count * 32) + (fat_boot->bytes_per_sector - 1)) / fat_boot->bytes_per_sector;

    ; asm:
    ; (fat_boot->root_entry_count * 32)
    mov bx, [root_entry_count]
    mul bx, 32

    ; (fat_boot->bytes_per_sector - 1)
    mov cx, [bytes_per_sector]
    dec cx

    ; () + ()
    add bx, bx, cx

    ; () / fat_boot->bytes_per_sector
    div bx, bx, [bytes_per_sector]

    ; C:
    ; first_data_sector = fat_boot->reserved_sector_count + (fat_boot->table_count * fat_size) + root_dir_sectors;

    ; asm:
    ; fat_boot->reserved_sector_count
    mov al, [reserved_sector_count]

    ; (fat_boot->table_count * fat_size)
    mov ah, [table_size_16]
    mul ah, [table_count]

    ; () + ()
    add al, al, ah

    ; () + root_dir_sectors
    mov ax, al
    add ax, ax, bx

    ; TODO - 
    ; We have the first data sector, now we just need to read it and begin parsing the FAT.
    ; From there, we need to actually read 'KERNEL  BIN'

times 510-($-$$) db 0
dw 0AA55h

buffer: