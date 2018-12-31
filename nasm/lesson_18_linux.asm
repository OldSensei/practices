	;; allocation of memory
	section .text
	global _start

_start:
	mov eax, 45 		; sys_brk
	xor ebx, ebx
	int 0x80

	add eax, 16384
	mov ebx, eax
	mov eax, 45
	int 0x80

	cmp eax, 0
	jl exit
	mov edi, eax
	sub edi, 4
	mov ecx, 4096
	xor eax, eax
	std
	rep stosd
	cld

	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, len
	int 0x80

exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80

	section .data
	msg db "Allocate 16 kb of memory!", 0xa
	len equ $ - msg
