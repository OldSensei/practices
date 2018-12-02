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

	messageForBitwiseOr db 'Result of 1000 OR 0001:', 0xa
	messageLen equ $ - messageForBitwiseOr	

	messageXoring db 'Result of 1010 XOR 1100:', 0xa
	messageXoringLen equ $ - messageXoring	

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

	mov eax, 9h
	and eax, 0x1
	jz evnn
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	
	mov ecx, oddstring
	mov edx, oddstringLen
	int 0x80
	jmp next
evnn:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, evenstring
	mov edx, evenstringLen
	int 0x80
	
next:
;;; or operation
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, messageForBitwiseOr
	mov edx, messageLen
	int 0x80
	
	mov eax, 1000b
	mov ebx, 0001b
	or eax, ebx
	add eax, '0'
	
	mov [result], eax
	mov BYTE [result + 1], 0xa
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, result
	mov edx, 2
	int 0x80

	mov al, 1010b
	mov bl, 1100b
	xor al, bl
	add al, '0'
	mov BYTE [result], al
	mov BYTE [result + 1], 0xa
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, messageXoring
	mov edx, messageXoringLen
	int 0x80

	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, result
	mov edx, 2
	int 0x80

;;; exit
	mov eax, SYS_EXIT
	int 0x80

	section .bss
	result resd 1
