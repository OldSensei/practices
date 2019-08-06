;;there is example of using struc/endstruc and istruc

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

STD_OUT_HANDLE equ -11

	;; next the defenition of structure "mystruc"
	STRUC mystruc
		.mt_field_long: resd 1
		.mt_field_word: resw 1
		.mt_field_str: resb 32
	ENDSTRUC

segment .data
	;; instance for struct
	instance_my_struct:
		istruc mystruc
			at mystruc.mt_field_long, dd 0xA
			at mystruc.mt_field_word, dw 0x5
			at mystruc.mt_field_str
						db "Hello World", 0xa,0xd
						db "Yet more hello!", 0xa, 0x0
		iend
		
		msgLen equ $ - (instance_my_struct + mystruc.mt_field_str)

segment .text
_start:
	push ebp
	mov ebp, esp
	sub esp, 4
	
	push STD_OUT_HANDLE
	call _GetStdHandle@4
	mov ebx, eax
		
	push 0
	lea eax, [ebp-4]
	push eax
	push msgLen
	;; access to field
	push instance_my_struct + mystruc.mt_field_str
	push ebx
	call _WriteFile@20
	
	push 0
	call _ExitProcess@4