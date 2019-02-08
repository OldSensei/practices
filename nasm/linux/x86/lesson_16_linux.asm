	;; example of using of macro

	%macro write 2
	 mov eax, 4
	 mov ebx, 1
	 mov ecx, %1
	 mov edx, %2
	 int 80h
	%endmacro
	
	section .text
	global _start

_start:
	
	write msg1, len1
	write msg2, len2

	mov eax, 1
	int 0x80

	section .data
	msg1 db "Hello!", 0xa, 0xd
	len1 equ 8

	msg2 db "World!", 0xa, 0xd
	len2 equ $-msg2
