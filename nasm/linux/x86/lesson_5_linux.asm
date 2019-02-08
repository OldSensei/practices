	;; constants and variables
	;; equ

	SYS_EXIT 	equ 1
	SYS_WRITE	equ 4
	STDIN 		equ 0
	STDOUT 		equ 1

	section .text
	global _start

_start:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, msg1
	mov edx, len1
	int 80h

	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, stars
	mov edx, starLen
	int 0x80
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, msg2
	mov edx, len2
	int 80h

	mov eax, SYS_EXIT
	int 80h

	section .data
	msg1 db 'Hello, programmers!', 0xa, 0xd
	len1 equ $ - msg1

	msg2 db 'Welcome to the world!', 0xa, 0xd
	len2 equ $ - msg2

	stars times 9 db '*'
	db 0xa, 0xd
	starLen equ $ - stars
	
