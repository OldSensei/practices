	;; bit operations

	SYS_EXIT equ 1
	SYS_WRITE equ 4
	STDOUT equ 1

	section .data
	
	pattern dw 0x03
	
	oddstring db 'this is odd', 0xa
	oddstringLen equ $ - oddstring
	
	evenstring db 'this is even', 0xa
	evenstringLen equ $ - oddstring
	
	section .text
	global _start
	
_start:
	and WORD [pattern], 0x01
	add BYTE [pattern], '0'
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, pattern
	mov edx, 1
	int 0x80

	mov WORD eax, 9h
	and eax, 0x1
	jz evnn
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, oddstring
	mov edx, oddstringLen
	int 0x80
	jmp exit
evnn:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, evenstring
	mov edx, evenstringLen
	int 0x80
	
exit:	
	mov eax, SYS_EXIT
	int 0x80
