;; example of using preprocessor loops and contexts

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

%macro DECLARE_STINGS 3
%1:
%rep %3
	db %2, 0xa
%endrep
%endmacro

%macro if 1
	%push if
	;;condition code macro param
	j%-1	%$ifnot
%endmacro

%macro else 0
	%ifctx if
		%repl else
		jmp %$ifend
	
		%$ifnot:
	%else
		%error "Expected 'if' before 'else'"
	%endif
	
%endmacro

%macro endif 0
	%ifctx if
		%$ifnot:
		%pop
	%elifctx	else
		%$ifend:
		%pop
	%else
		%error "Expected 'if' or 'else' before 'endif'"
	%endif
%endmacro

segment .data
	DECLARE_STINGS message, "String line", 4
	msgLen equ $ - $$
	
	msg db "The greatest value: ", '0', 0xa, 0
	msg2Len equ $ - msg
segment .text

_start:

	mov ebp, esp
	sub esp, 8
	
	push -11
	call _GetStdHandle@4
	mov [ebp-8], eax
	
	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push 0
	lea eax, [ebp-4]
	push eax
	push msgLen
	push message
	push DWORD [ebp-8]
	call _WriteFile@20
	
	xor eax, eax
	xor ebx, ebx
	
	mov eax, 5
	mov ebx, 9
	cmp eax, ebx
	
	if ae
		add [msg + msg2Len - 3], eax
	else
		add [msg + msg2Len - 3], ebx
	endif
	
	push 0
	lea eax, [ebp-4]
	push eax
	push msg2Len
	push msg
	push DWORD [ebp-8]
	call _WriteFile@20

	push 0
	call _ExitProcess@4

