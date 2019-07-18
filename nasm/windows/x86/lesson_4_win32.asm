;; example of condition macro.

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

section .data
	message:
%ifdef SOLUTION1
	db 'This is the solution 1', 0xa ;; compile with -dSOLUTION1 if the string is need
%else
	db 'This is an another solution', 0xa
%endif
	len equ $-message

%macro TEST_TOKEN_TYPE 0-1
	jmp %%start_process
	%%token_type:
	%if %0=0
		db 'There is no token', 0xa
	%else
		%ifstr %1
			db 'There is a string: ', %1, 0xa
		%else
			%ifnum %1
				%defstr NUM_STR %1
				db 'There is a number: ', NUM_STR, 0xa
				%undef NUM_STR
			%else
				%defstr TOKEN_STR %1
				db 'There is just a token: ', TOKEN_STR, 0xa
				%undef TOKEN_STR
			%endif
		%endif
	%endif
	
	%%start_process:
	lea ecx, [%%token_type]
	mov [ebp - 8], ecx
	mov [ebp - 12], DWORD %%start_process -  %%token_type

%endmacro

section .text
_start:
	mov ebp, esp
	sub esp, 12
	
	push -11
	call _GetStdHandle@4
	mov ebx, eax
	
	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push 0
	lea eax, [ebp-4]
	push eax
	push len
	push message
	push ebx
	call _WriteFile@20
	
	TEST_TOKEN_TYPE 'string argument'
	
	push 0
	lea eax, [ebp-4]
	push eax
	push DWORD [ebp - 12] ;; length
	push DWORD [ebp - 8] ;; effective address of message
	push ebx
	call _WriteFile@20
	
	TEST_TOKEN_TYPE TOKEN
	
	push 0
	lea eax, [ebp-4]
	push eax
	push DWORD [ebp - 12] ;; length
	push DWORD [ebp - 8] ;; effective address of message
	push ebx
	call _WriteFile@20

	TEST_TOKEN_TYPE 742
	
	push 0
	lea eax, [ebp-4]
	push eax
	push DWORD [ebp - 12] ;; length
	push DWORD [ebp - 8] ;; effective address of message
	push ebx
	call _WriteFile@20
	
	push 0
	call _ExitProcess@4
