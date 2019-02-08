	;; example of loop
	section .bss
	num resb 1

	section .data
	endline db 0xa,0xd
	
	section .text
	global _start
	
_start:
	mov BYTE [num], '0'
	mov ecx, 10
	
l1:	
	mov eax, 4
	mov ebx, 1
	push ecx

	mov ecx, num
	mov edx, 1
	int 0x80

	inc BYTE [num]
	
	pop ecx
	loop l1

	mov eax, 4
	mov ebx, 1
	mov ecx, endline
	mov edx, 2
	int 0x80
	
	mov eax, 1
	int 0x80
	
	
