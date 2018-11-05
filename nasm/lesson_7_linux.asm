	;; bit operations

	SYS_EXIT equ 1
	SYS_WRITE equ 4
	STDOUT equ 1

	section .data
	pattern dw 0x03

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

	mov eax, SYS_EXIT
	int 0x80
