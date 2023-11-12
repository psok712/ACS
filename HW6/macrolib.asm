# Печать целочисленного регистра
.macro print_int(%x)
	push(a0)
	li a7, 1
	mv a0, %x
	ecall
	pop(a0)
.end_macro

# Печать непосредственного целочисленного значения
.macro print_imm_int(%x)
   push(a0)
   li a7, 1
   li a0, %x
   ecall
   pop(a0)
.end_macro

# Ввод целого числа в регистр в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

# Ввод целого числа с консоли в указанный регистр,
# исключая регистр a0
.macro read_int(%x)
   push(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop(a0)
.end_macro

# Печать строки
.macro print_str_imm(%x)
.data
	str: .asciz %x
.text
   push(a0)
   li a7, 4
   la a0, str
   ecall
   pop(a0)
.end_macro

# Печать строки из регистра
.macro print_str_reg(%x)
	mv a0 %x
	li a7 4
	ecall
.end_macro

# Печать непосредственного символа
.macro print_char(%x)
   push(a0)
   li a7, 11
   li a0, %x
   ecall
   pop(a0)
.end_macro

# Переход на новую строку
.macro newline
   print_char('\n')
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

# Функция копирования строки регистра src в строку регистра dest 
.macro strncpy(%dest %src %num)
	push(a1)
	push(a2)
	push(a3)
	push(t2)
	push(t0)
	mv a1, %dest
	mv a2, %src
	li a3, %num
	jal strncpy
	pop(t0)
	pop(t2)
	pop(a3)
	pop(a2)
	pop(a1)
end:
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro
