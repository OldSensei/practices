	;; conditions

	section .text
	global _start

_start:
	mov ecx, [num1]
	cmp ecx, [num2]

	mov eax, 4
	mov edx, len
	mov ecx, msg
	mov ebx, 1
	int 0x80

	mov ecx, [num1]
	cmp ecx, [num2]
	
	jg greater

	mov eax, 4
	mov edx, 1
	mov ecx, num2
	mov ebx, 1

exit:	
	mov eax, 1
	int 0x80

greater:
	mov eax, 4
	mov edx, 1
	mov ecx, num1
	mov ebx, 1
	int 0x80

	jmp exit
	
	section .data
	msg db 'Greatest: '
	len equ $ - msg

	num1 dd '7'
	num2 dd '5'
	
	section .bss
	num resb 2
