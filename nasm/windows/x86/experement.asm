global _start
	
section .data align=4
	la dw 0xA, 0xB
	ALIGN 16
	dd 0xC
	
section .text
_start:
	XOR eax, eax
	ALIGN 16
	mov eax, 0xA
	
section .data
	lb dw 0xFA