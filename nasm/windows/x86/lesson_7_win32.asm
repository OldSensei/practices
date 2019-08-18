;; example of using stack

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

STD_OUT_HANDLE equ -11

section .data
chars:
	db '0'
	db '1'
	db '2'
	db '3'
	db '4'
	db '5'
	db '6'
	db '7'
	db '8'
	db '9'
	db 'A'
	db 'B'
	db 'C'
	db 'D'
	db 'E'
	db 'F'
	
hex_num_str: times 8 db 0
			db 0xa
hex_str_len equ $ - hex_num_str

bin_num_str: times 33 db 0
			db 0xa
bin_str_len equ $ - bin_num_str

section .bss
	output_handle resd 1
	printed_len resd 1

%macro print_message 2
	push 0
	push printed_len
	push %1 ;;output len 
	push %2 ;;str
	push DWORD [output_handle]
	call _WriteFile@20
%endmacro

%macro print_dword_hex 1
	pushad
	
	mov eax, %1
	mov ecx, 0x0
%%loop:
	
	rol eax, 0x4
	mov bl, al
	and bl, 0xF
	
	lea edi, [hex_num_str + ecx]	
	lea esi, [chars + ebx]
	movsb
	
	inc ecx
	cmp ecx, 0x8
	jne %%loop

	print_message hex_str_len, hex_num_str
	
	popad
%endmacro

%macro print_dword_bin 1
	pushad
	
	mov eax, %1
	mov ecx, 0x0
%%loop:

	rol eax, 1
	mov bl, al
	and bl, 0x1
	
	mov edx, '0'
	add edx, ebx

	lea edi, [bin_num_str + ecx]
	mov [edi], dl
	
	inc ecx
	cmp ecx, 0x20
	jne %%loop

	print_message bin_str_len, bin_num_str
	
	popad
%endmacro

section .text

_start:
	xor ebx, ebx
	
	push STD_OUT_HANDLE
	call _GetStdHandle@4
	mov [output_handle], eax
	
	;; simple stack tracking
	print_dword_hex esp
	push DWORD 0x02
	print_dword_hex esp
	
	;;print EFLAGS
	pushfd
	pop eax
	print_dword_bin eax
	
	push 0
	call _ExitProcess@4
	
