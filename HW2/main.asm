.data
x:	.word # делимое
del:	.word # делитель
error:  .asciz "Error: Division by zero!"
line_1:	.asciz "x // del = "
line_2:	.asciz "x % del = "
format_string:
    .asciz "\n"

.text
	# Присваиваем регистрам адреса памяти наших чисел
	la t0, x
	la t1, del
	li t4, 0
	
	# Вводим с клавиатуры два числа: делимое и делитель
	li a7 5
	ecall
	mv t0 a0
	ecall
	mv t1 a0
	
	# Проверка делителя на ноль
if_0:	
	bnez t1, else_0
	la a0, error
        li a7, 4
        ecall
        li a0, 0
        li a7, 10
        ecall
else_0:
	if_x_more_0:	
			bltz t0, if_x_less_0
			li t2, 0
			j if_del_more_0
	if_x_less_0:	
			li t2, 1
			neg t0, t0
	if_del_more_0:	
			bltz t1, if_del_less_0
			li t3, 0
			j while
	if_del_less_0:	
			li t3, 1
			neg t1, t1
	while:	
		sub t0, t0, t1
		bltz t0, end_while
		addi t4, t4, 1
		j while
	end_while:
		add t0, t0, t1
		if_t2_1:
			beqz t2, if_t2_0
			if_t3_1:
				beqz t3, if_t3_0
				neg t0 t0
				j end
			if_t3_0:
				neg t0 t0
				neg t4 t4
				j end
		if_t2_0:
			if_t3:
				li a1, 1
				beqz t3, end
				neg t4 t4
			j end
	end:
		la a0, line_1
		li a7, 4
		ecall
		mv a0, t4
		li a7, 1
		ecall
		la a0, format_string
		li a7, 4
		ecall
		
		la a0, line_2
		li a7, 4
		ecall
		mv a0, t0
		li a7, 1
		ecall
		li a7, 10
		ecall
