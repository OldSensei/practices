	;; example of working with files

	section .text
	global _start
	
_start:
	;; create file
	mov eax, 8
	mov ebx, file_name
	mov ecx, 0777
	int 0x80

	mov [f_desc], eax

	;; write to file
	mov edx, len
	mov ecx, msg
	mov ebx, [f_desc]
	mov eax, 4
	int 0x80

	mov eax, 6
	mov ebx, [f_desc]
	int 0x80

	mov eax, 5
	mov ebx, file_name
	mov ecx, 0
	mov edx, 0777
	int 0x80

	mov [f_in], eax

	mov eax, 3
	mov ebx, [f_in]
	mov ecx, info
	mov edx, 16
	int 0x80

	
	mov eax, 6
	mov ebx, [f_in]
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, info
	mov edx, 16
	int 0x80
	
	mov eax, 1
	int 0x80

	section .data
	file_name db 'test.txt', 0x0
	
	msg db 'Hello from file!'
	len equ $ - msg
	
	section .bss
	f_desc resd 1
	f_in resd 1
	info resb 17
