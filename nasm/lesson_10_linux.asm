	;; numeric data representation

	section .data
	message db 'The result is: '
	len equ $ - message
	
	endLine db 0xa, 0xd
	lenEndLine equ $ - endLine
	
	section .bss
	res resb 1
	
	section .text
	global _start

_start:

;;; ascii representation
	mov eax, '5'
	sub eax, '0'
	
	mov ebx, '2'
	sub ebx, '0'

	sub eax, ebx
	
	add eax, BYTE '0'
	mov [res], al

	mov eax, 4
	mov ebx, 1
	mov ecx, message
	mov edx, len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, res
	mov edx, 1
	int 0x80
	
	mov eax, 4
	mov ebx, 1
	mov ecx, endLine
	mov edx, lenEndLine
	int 0x80
	
;;;  aaa/aas/aam/aad
	xor eax, eax
	
	mov al, '9'
	sub al, '3'
	aas
	or al, 30h
	
	mov [res], al

	mov eax, 4
	mov ebx, 1
	mov ecx, message
	mov edx, len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, res
	mov edx, 1
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, endLine
	mov edx, lenEndLine
	int 0x80

	mov eax, 1
	int 0x80
