.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_EXIT, 60
.equ STREAM_REGISTER, %r15

_print_char:
	movq %rax, %rsi
	movq $1, %rax
	movq STREAM_REGISTER, %rdi
	movq $1, %rdx
	syscall
	retq

.globl _print_number
_print_number:
	pushq %rax
	pushq %rdx
	pushq %rbx
	pushq %r8
	movq $10, %r8
	movq $0, %rdx
	div %r8
	test %rax, %rax
	je _print_number.l1
	callq _print_number@PLT
_print_number.l1:
	movq digits@GOTPCREL(%rip), %rax
	addq %rdx, %rax
	callq _print_char@PLT
	orq %rax, %rax
	js _error
	popq %r8
	popq %rbx
	popq %rdx
	popq %rax
	retq

.globl _print_string
_print_string:
	movq %rax, %rsi
	movq %rbx, %rdx
	movq $SYS_WRITE, %rax
	movq STREAM_REGISTER, %rdi
	syscall
	orq %rax, %rax
	js _error
	ret

.globl _pseudo_lib_exit
_pseudo_lib_exit:
	movq %rax, %rdi
	movq $SYS_EXIT, %rax
	syscall

_error:
	neg %rax
	movq %rax, %rdi
	movq $SYS_EXIT, %rax
	syscall

.globl _load_strlen_to_rbx
_load_strlen_to_rbx:
	mov %rax, %rbx
_load_strlen_to_rbx.l1:
	cmpb $0, (%rbx)
	je _load_strlen_to_rbx.l2
	inc %rbx
	jmp _load_strlen_to_rbx.l1
_load_strlen_to_rbx.l2:
	sub %rax, %rbx
	ret

.global _load_str_to_pool
_load_str_to_pool:
	movq $0, %r8
_load_str_to_pool.l1:
	cmpq %rbx, %r8
	jge _load_str_to_pool.l2
	movb (%rax, %r8), %cl
	movb %cl, (%rdi, %r8)
	incq %r8
	jmp _load_str_to_pool.l1
_load_str_to_pool.l2:
	leaq (%rdi), %rax
	ret

.global _pseudo_lib_init
_pseudo_lib_init:
	ret

.section .rodata
.type digits, @object
.align 16
digits:
	.ascii "0123456789"
