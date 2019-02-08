	section .text
	global _start
_start:
	mov edx, 10
	mov ecx, name
	mov ebx, 1
	mov eax, 4
	int 80h

	mov [name], dword 'Nuha'

	mov edx, 10
	mov ecx, name
	mov ebx, 1
	mov eax, 4
	int 80h

	mov eax, 1
	int 80h

	section .data
	name db 'Zara Ali ', 0xa
