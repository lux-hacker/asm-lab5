bits	64
section	.data
matrix:
	dq	0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625
	dq	0.015625, 0.0625, 0.09375, 0.0625, 0.015625
	dq	0.023475, 0.09375, 0.0140625, 0.09375, 0.0234375
	dq	0.015625, 0.0625, 0.09375, 0.0625, 0.015625
	dq	0.00390625, 0.015625, 0.023475, 0.015625, 0.00390625
zero dq	0.0
section .text
img	equ 8
w	equ	img+8
h	equ w+8
c	equ	h+8
s 	equ	c+8

global	gaussian_blur_asm
gaussian_blur_asm:
	push rax
	push rbx
	push rdx
	push rcx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push rbp
	mov	rbp, rsp
	sub	rsp, s+8

	mov	rax, [rdi]
	mov	[rbp-img], rax
	mov	[rbp-w], rsi, 
	mov	[rbp-h], rdx
	mov [rbp-c], rcx
	mov [rbp-s], r8

	mov r15, [rbp-w]
	mov r14, [rbp-h]
	sub	r15, 2
	sub	r14, 2
	
	mov	ecx, 2
	.m0:
		push	rcx
		mov	ecx, 2
		.m1:
			push	rcx
			mov	ecx, 0
			.m2:
				movss	xmm0, [zero]
				push	rcx
				mov ecx, 0
				.m3:
					push rcx
					mov ecx, 0
					.m4:
						pop r9 ;m
						pop	r10 ;k
						pop	r11 ;j
						pop	r12 ;i
						push	r12
						push	r11
						push	r10		
						push	r9
						sub	r12, 2
						add	r12, r9
						imul	r12, [rbp-w]
						imul	r12, [rbp-c]
						sub	r11, 2
						add	r11, rcx
						imul	r11, [rbp-c]
						mov r13, [rbp-img]
						add	r12, r11
						add	r12, r10
						imul	r12, [rbp-s]
						add r13, r12
						movzx	r8d, byte [r13]
						cvtsi2sd	xmm1, r8d
						mov	rax, r9
						imul	rax, 5
						add rax, rcx
						imul	rax, 8
						mulsd	xmm1, [matrix+rax]
						addsd	xmm0, xmm1
						.test:
						inc	rcx
						cmp rcx, 5
						jl	.m4
					.end_m4:
					pop rcx
					inc	rcx
					cmp	rcx, 5
					jl	.m3
				.end_m3:
				pop	r9 ;k
				pop	r10;j
				pop	r11;i
				push	r11
				push	r10
				push	r9
				imul	r11, [rbp-c]
				imul	r11, [rbp-w]
				imul	r10, [rbp-c]
				add r11, r10
				add r11, r9
				mov r12, [rbp-img]
				imul	r11, [rbp-s]
				add r12, r11
				
				cvtsd2si r13, xmm0
				mov byte [r12], r13b

				pop rcx
				inc	rcx
				cmp	rcx, [rbp-c]
				jl	.m2
			.end_m2:
			pop rcx
			inc	ecx
			cmp	ecx, r15d
			jl	.m1
		.end_m1:
		pop	rcx
		inc	ecx
		cmp	ecx, r14d
		jl	.m0
	.end_m0:
	leave
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rcx
	pop rdx
	pop rbx
	pop rax
	ret
