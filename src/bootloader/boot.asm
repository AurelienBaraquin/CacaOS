org 0x7c00 ; start address
bits 16

ENDL1 equ 0x0d
ENDL2 equ 0x0a

; FAT 12 header
jmp short start
nop ; pad out to 3 bytes

bpbOEM db "MSWIN4.1" ; OEM name, 8 bytes
bpbBytesPerSector dw 512 ; bytes per sector, 2 bytes
bpbSectorsPerCluster db 1 ; sectors per cluster, 1 byte
bpbReservedSectors dw 1 ; reserved sectors, 2 bytes
bpbFATsCount db 2 ; number of FATs, 1 byte
bpbRootEntries dw 0E0h ; number of root entries, 2 bytes
bpbTotalSectors dw 2880 ; total number of sectors, 2 bytes, 2880 * 512 = 1.44 MB
bpbMedia db 0F0h ; media descriptor, 1 byte
bpbSectorsPerFAT dw 9 ; sectors per FAT, 2 bytes
bpbSectorsPerTrack dw 18 ; sectors per track, 2 bytes
bpbHeads dw 2 ; number of heads, 2 bytes
bpbHiddenSectors dd 0 ; number of hidden sectors, 4 bytes
bpbTotalSectorsBig dd 0 ; total number of sectors, 4 bytes

; expended boot sector
ebrDriveNumber db 0 ; drive number, 1 byte
    db 0
ebrBootSignature db 29h ; boot signature, 1 byte
ebrVolumeID dd 12h, 34h, 56h, 78h ; volume ID, 4 bytes
ebrVolumeLabel db "  CACA OS  " ; volume label, 11 bytes
ebrFileSystem db "FAT12   " ; file system type, 8 bytes

start:
    jmp main

puts:
    push ax ; ax is used to store the character
    push si ; si is used to store the string
.loop:
    lodsb ; load byte from si to al
    or al, al ; check if al is 0
    jz .done ; if al is 0, jump to .done
    mov ah, 0x0e ; set ah to 0x0e because we are using interrupt 0x10 to print character
    int 0x10 ; call interrupt 0x10 to print character
    jmp .loop ; jump to .loop

.done
    pop si
    pop ax
    ret



main:
    ; set ax, ds, es, ss to 0
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax ; ss is used to store stack pointer

    ; set sp to 0x7c00 because we are using 0x7c00 as stack to avoid overwriting our code
    mov sp, 0x7c00

    mov si, str ; set si to str
    call puts ; call puts to print string

    hlt

.halt ; infinite loop
    jmp .halt

str: db "OMG ça marche !", ENDL1, ENDL2, 0 ; string to print

times 510-($-$$) db 0 ; pad with zeros
dw 0xaa55 ; boot signature, using to identify bootable device
