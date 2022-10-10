%include "/usr/local/share/csc314/asm_io.inc"


segment .data


segment .bss


segment .text
	global  asm_main

asm_main:
	push	ebp
	mov		ebp, esp
	; ********** CODE STARTS HERE **********

	call	read_int
	mov		ebx, eax	; ebx is A
	call	read_char
	call	read_char	; sets to al initially
	mov		esi, eax	; sets al to eax to avoid getting overridden during next read call
	call	read_int
	mov		ecx, eax	; ecx is B

	cmp		esi, 43		; ascii for + is 43
	je		addition
	cmp		esi, 45		; ascii for - is 45
	je		subtraction
	cmp		esi, 42		; ascii for * is 42
	je		multiplication
	cmp		esi, 47		; ascii for / is 47
	je		division
	cmp		esi, 37		; ascii for % is 37
	je		modulus
	cmp 	esi, 94		; ascii for ^ is 94
	je		exponential

	addition:
	add		ecx, ebx	; add A into B
	mov		eax, ecx
	jmp		print

	subtraction:
	sub		ebx, ecx	; subtract B from A
	mov		ecx, ebx
	jmp		print

	multiplication:
	mov		eax, ebx	; moves A to eax
	imul	ecx
	mov		ecx, eax	; moves eax to ecx - ecx is being used for storing jump to print
	jmp		print

	division:
	mov		eax, ebx	; move A to eax
	mov		edx, 0		; set edx to 0
	idiv	ecx			; divide eax by ecx
	mov		ecx, eax	; set ecx to eax for safe storage
	jmp		print

	modulus:
	mov		eax, ebx	; move A to eax
	mov		edx, 0		; set edx to 0
	idiv	ecx			; divide eax by ecx
	mov		ecx, edx	; move edx (which should be remainder) to ecx for storage

	exponential:
	mov		edi, 0		; intialize register as an 'i" for a for loop (int i = 0)
	mov		esi, ecx	; will be used for comparison in loop and frees up ecx
	mov 	eax, 1		; move A to eax for imul, set to 1 for first loop
	loop:
	cmp		edi, esi	; check our 'i' vs our B
	jge		print
	imul	ebx
	inc		edi
	mov		ecx, eax
	jmp		loop

	print:
	mov		eax, '='	; doesn't need al
	call	print_char
	call	print_nl
	mov		eax, ecx	; move ecx into eax for printing
	call 	print_int
	call 	print_nl


	; *********** CODE ENDS HERE ***********
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret
