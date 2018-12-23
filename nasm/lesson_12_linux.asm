;;; The programm calculate sum for array of number
	
	section .text
	global _start

_start:
	
	mov ecx, 3		; lenght of array
	mov eax, array2
	mov ebx, 0
calc:
	add ebx, [eax]
	add eax, BYTE 1
	loop calc

	add ebx, '0'
	mov [sum], ebx

	mov eax, 4
	mov ebx, 1
	mov ecx, sum
	mov edx, 1
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, newLine
	mov edx, 2
	int 0x80

	mov eax, 1
	int 0x80
	
	section .data
	array db 0x2, 0x3, 0x4
	
array2:
	db 0x1
	db 0x2
	db 0x3
	
	newLine db 0xa, 0xd
	
	section .bss
	sum resb 1
