	;; example of calling procedures

	section .text
	global _start

_start:
	mov ecx, 6d
	mov edx, 3d

	call sum

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
	mov edx, 2
	int 0x80
	
	mov eax, 1
	int 0x80

sum:
	mov eax, ecx
	add eax, edx
	add eax, '0'
	ret

	section .data
	message db "Sum of 6 and 3 is: "
	len equ $ - message

	endLine db 0xa, 0xd
	len2 equ 2
	
	section .bss
	res resb 1
