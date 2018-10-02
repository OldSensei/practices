	;; inc/dec/add/sub instruction

	SYS_EXIT 	equ 1
	SYS_WRITE 	equ 4
	STDOUT 		equ 1
	
	section .data
	value dw 0
	prtVal db '0'
	
	section .text
	global _start

_start:
	inc WORD [value]
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	
	mov ecx, [value]
	add ecx, '0'
	mov [prtVal], ecx
	
	mov ecx, prtVal
	mov edx, 1
	int 0x80

	mov eax, SYS_EXIT
	int 80h
	
