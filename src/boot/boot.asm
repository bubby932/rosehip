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

    ; ax = (fat_boot->root_entry_count * 32)
    mov ax, [root_entry_count]
    imul ax, 32

    ; bx = (fat_boot->bytes_per_sector - 1)
    mov bx, [bytes_per_sector]
    sub bx, 1

    ; ax = (ax + bx)
    add ax, bx

    ; ax = (ax / fat_boot->bytes_per_sector)
    mov dx, 0
    idiv word [bytes_per_sector]

    cmp ax, 0
    je .no_remainder

    .with_remainder:
    inc ax
    .no_remainder:

    ; C:
    ; first_data_sector = fat_boot->reserved_sector_count + (fat_boot->table_count * fat_boot->table_size_16) + root_dir_sectors;

    ; root_dir_sectors = ax
    mov [root_dir_sectors], ax

    ; cx = (fat_boot->table_count * fat_size)
    mov cx, [table_count]
    imul cx, [table_size_16]

    ; bx = (fat_boot->reserved_sector_count + cx)
    mov bx, [reserved_sector_count]
    add bx, cx
 
    ; ax = (bx + root_dir_sectors (ax))
    add ax, bx

    ; first_data_sector = ax
    mov [first_data_sector], ax

    ; C: first_root_dir_sector = first_data_sector - root_dir_sectors;
    sub ax, [root_dir_sectors]
    mov [first_root_dir_sector], ax

    ; C: first_sector_of_cluster = ((cluster - 2) * fat_boot->sectors_per_cluster) + first_data_sector;
    
    ; ax = (cluster - 2)
    

something_broke:
    cli
    hlt

root_dir_sectors: dw 0
first_data_sector: dw 0
first_root_dir_sector: dw 0

times 510-($-$$) db 0
dw 0AA55h

buffer: