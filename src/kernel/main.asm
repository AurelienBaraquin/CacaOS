org 0x7c00 ; start address
bits 16

ENDL1 equ 0x0d
ENDL2 equ 0x0a

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
    xor ax, ax ; we can also use mov ax, 0 but xor is faster
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; set sp to 0x7c00 because we are using 0x7c00 as stack to avoid overwriting our code
    mov sp, 0x7c00

    mov si, str ; set si to str
    call puts ; call puts to print string

    hlt

.halt ; infinite loop
    jmp .halt

str: db "Yaaaaaa !", ENDL1, ENDL2, 0 ; string to print

times 510-($-$$) db 0 ; pad with zeros
dw 0xaa55 ; boot signature, using to identify bootable device
