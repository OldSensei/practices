	;; numeric data representation

	section .data
	message db 'The result is: '
	len equ $ - message
	
	endLine db 0xa, 0xd
	lenEndLine equ $ - endLine

	num1 db '12345'
	num2 db '23456'
	sum db '     '
	
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

;;; BCD representation

	mov esi, 4
	mov ecx, 5
	clc

add_loop:
	mov al, [num1 + esi]
	adc al, [num2 + esi]
	aaa
	pushf
	or al, 30h
	popf

	mov [sum + esi], al
	dec esi
	loop add_loop

	mov edx, len
	mov ecx, message
	mov ebx, 1
	mov eax, 4
	int 0x80

	mov edx, 5
	mov ecx, sum
	mov ebx, 1
	mov eax, 4
	int 0x80
	
	mov eax, 1
	int 0x80
