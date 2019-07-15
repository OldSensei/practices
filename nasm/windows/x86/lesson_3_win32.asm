;; example of multi-line macro

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

;;greedy macro param
%macro PRINT 2+
	jmp %%strend
	;; local variable for data of string
	%%str: db %2
	%%len: dd $ - %%str
	
%%strend:
	sub esp, 4
	
	push 0
	push esp 
	
	push DWORD [%%len]
	push %%str
	push %1
	call _WriteFile@20
	add esp, 4
%endmacro

section .text

_start:
	mov ebp, esp
	
	push -11
	call _GetStdHandle@4
	mov ebx, eax
	
	PRINT ebx, "Hello from multi-line macro!", 0x0
	
	push 0
	call _ExitProcess@4