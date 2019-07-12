; simple example of print and exit

global _start
extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

STD_OUT_HANDLE equ -11

segment .data
greetings db "Hello world from WIN32!", 0xA
msgLen equ $ - greetings


segment .text

_start:
	mov ebp, esp
	sub esp, 4
	
	push STD_OUT_HANDLE
	call _GetStdHandle@4
	mov ebx, eax
	
	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push 0
	lea eax, [ebp-4]
	push eax
	push msgLen
	push greetings
	push ebx
	call _WriteFile@20
	
	push 0
	call _ExitProcess@4
	