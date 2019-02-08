	;; strings

	section .data
	message db 'Hello!', 0xa, 0xd, 0

	message2 db 'Length is: '
	len equ 11

	section .bss
	length resb 1
	hword resw 1
	cutted resw 3
	
	section .text
	global _start

_start:
;;; Copy word (2 bytes) from message
	mov esi, message
	mov edi, hword
	movsw

	mov eax, 4
	mov ebx, 1
	mov ecx, hword
	mov edx, 2
	int 0x80

	xor eax, eax
	
	cld
	mov esi, message
	mov edi, cutted
	mov ecx, 5
	rep movsb

	mov [edi + 6], BYTE 0xa

	mov eax, 4
	mov ebx, 1
	mov ecx, cutted
	mov edx, 6
	int 0x80
	
	mov eax, 1
	int 0x80
