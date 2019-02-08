	;; inc/dec/add/sub instruction

	SYS_EXIT 	equ 1
	SYS_WRITE 	equ 4
	STDOUT 		equ 1
	
	section .data
	value dw 1
	prtVal db '0'
	
	section .text
	global _start

_start:
	inc WORD [value]
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	
	add byte [value], '0'
	mov ecx, value
	mov edx, 1
	int 80h

	
	sub WORD [value], '0' 	; stuppid but just for example
	
	dec WORD [value]
	add byte [value], '0'

	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, value
	mov edx, 1
	int 0x80

	;; multiplication

	mov al, 3
	mov bl, 2
	mul bl
	
	mov byte [value], al
	add byte [value], '0'
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, value
	mov edx, 1
	int 0x80

	;; divide

	mov ax, 16
	mov bl, 8
	div bl
	mov [value], al
	add byte [value], '0'
	
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, value
	mov edx, 1
	int 0x80
	
	mov eax, SYS_EXIT
	int 80h
	
