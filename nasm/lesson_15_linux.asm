	section .text
	global _start

_start:
	mov bx, 3
	call factorial
	add ax, '0'
	mov [fact], ax

	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, fact
	mov edx, 1
	int 0x80

	mov eax, 1
	int 0x80

factorial:
	cmp bl, 1
	jg process
	mov ax, 1
	ret

process:
	dec bl,
	call factorial
	inc bl,
	mul bl
	ret

	section .data
	msg db 'Factorial 3 is: '
	len equ $-msg

	section .bss
	fact resb 1
	
