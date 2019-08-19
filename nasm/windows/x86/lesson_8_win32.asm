;;example of procedure calling

global _start

extern  _GetStdHandle@4
extern  _WriteFile@20
extern  _ExitProcess@4

STD_OUT_HANDLE equ -11

section .data
	message db "Hello from procedure!", 0xa
	len equ $ - message
	
section .text
;; eax - message ebx - handle of OUTPUT ecx - message length
PrintMessage:
	mov ebp, esp
	sub esp, 12
	mov [ebp - 8], eax ;; message address
	mov [ebp - 12], ecx ;; message length
	lea eax, [ebp-4]	
	
	push 0
	push eax
	push DWORD [ebp - 12]
	push DWORD [ebp - 8]
	push ebx
	call _WriteFile@20
	ret
	
_start:
	push STD_OUT_HANDLE
	call _GetStdHandle@4
	mov ebx, eax
	
	mov eax, message
	mov ecx, len
	
	call PrintMessage
	
	push 0
	call _ExitProcess@4