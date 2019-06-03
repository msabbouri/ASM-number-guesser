section .data

print_prompt:	db		"Enter range, low to high: ", 10, 0
scan_prompt:	db		"%d %d", 0
think_prompt:	db		"Think of an integer between %d and %d!", 10, 0
is_prompt:		db		"Is your number Less than, Equal to, or Greater than %d (l, e, g)?", 0
guess_prompt:	db		"I guessed it!", 10, 0
cheat_prompt:	db		"You must be cheating!", 10, 0
scan1_prompt:	db		"%c", 0

jump_case:		db		'g', 'l', 'e'
jump_tgt:		dq		main.case_greater, main.case_less, main.case_equal

section .text

	global main
	extern printf
	extern scanf

main:

	push rbp
	mov rbp, rsp
	sub rsp, 32
	
	mov	rdi, print_prompt
	call printf
	
	mov rdi, scan_prompt
	lea rsi, [rbp]  
	lea rdx, [rbp - 8]    
	call scanf
	
	mov rsi, [rbp]
	mov rdx, [rbp - 8]

	mov rdi, think_prompt
	call printf

.while:

	mov rsi, [rbp]
	mov rdx, [rbp - 8]
	cmp rsi, rdx
	jg .case_cheat

	mov rax, [rbp] ; mid = low
	add rax, [rbp - 8] ; mid += high
	mov rdx, 0
	mov rcx, 2
	idiv rcx

	mov [rbp - 24], rax ; store mid
	mov rsi, [rbp - 24] ; print mid

	mov rdi, is_prompt
	call printf

	mov rdi, scan1_prompt
	lea rsi, [rbp - 16] ; letter input
	call scanf

	mov rsi, 0
	mov rsi, [rbp] ; low
	mov rdx, [rbp - 8] ; high
	mov rcx, [rbp - 24] ; mid
	mov dl, [rbp - 16]

	mov r15, 0

.case_loop:

	cmp byte[jump_case + r15], dl
	jne .continue_case_loop

	jmp qword[jump_tgt + 8 * r15]

.continue_case_loop:

	inc r15
	cmp r15, 4
	jne .case_loop
	
	jmp .case_default

.case_greater:

	inc rcx
	mov [rbp], rcx

	mov rsi, [rbp]
	jmp .while

.case_less:

	dec rcx
	mov [rbp - 8], rcx
	
	mov rsi, [rbp - 8]
	jmp .while

.case_equal:

	mov rdi, guess_prompt
	call printf

	jmp .end

.case_cheat:

	mov rdi, cheat_prompt
	call printf

	jmp .end

.case_default:

	jmp .while

.end:

	pop rbp
	add rsp, 32
	ret

