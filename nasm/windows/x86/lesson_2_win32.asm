;; example of macro using

global _start
extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

%define ZERO 0
%define IS_ZERO ZERO

%xdefine ONE 1
%xdefine IS_ONE ONE

%define GREETINGS 'Hello from macro!'
%strlen length GREETINGS

section .text

;;
_start:
	mov [character], DWORD 0x00000a30 ;;"0\n"
	
	mov eax, [character]
	add eax, IS_ZERO	;; added 0 to eax
	
	%define ZERO 1
	
	mov [character], eax
	
	mov ebp, esp
	sub esp, 4
	
	push -11
	call _GetStdHandle@4
	mov ebx, eax
	
	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push 0
	lea eax, [ebp-4]
	push eax
	push 2
	push character
	push ebx
	call _WriteFile@20
	
	
	mov [character], BYTE '0'
	
	mov eax, [character]
	add eax, IS_ZERO	;; added 1 to eax
	mov [character], eax
	
	push 0
	lea eax, [ebp-4]
	push eax
	push 2
	push character
	push ebx
	call _WriteFile@20

	mov [character], BYTE '0'
	mov eax, [character]
	
	%xdefine ONE 0
	
	add eax, IS_ONE	;; added 1 to eax
	mov [character], eax
	
	push 0
	lea eax, [ebp-4]
	push eax
	push 2
	push character
	push ebx
	call _WriteFile@20
	
	push 0
	lea eax, [ebp-4]
	push eax
	push length
	push greetings
	push ebx
	call _WriteFile@20
	
	push 0
	call _ExitProcess@4

section .bss
	character resd 1

section .data
	greetings db GREETINGS