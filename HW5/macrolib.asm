# Вывод строки на экран
.macro print_str(%x)
.data
str:	.asciz %x
.text
	push(a0)
	li a7, 4
	la a0, str
	ecall
	pop(a0)
.end_macro

# Ввод количеста элементов в массиве(исключая регистр a0)
.macro input_n(%x)
	push(a0)
invalid_input:
	print_str("Введите количество элементов в массиве(от 1 до 10): ")
	li a7, 5
	ecall
	li a2, 1
	li a3, 10
	blt a0, a2, invalid_input
	bgt a0, a3, invalid_input
	mv %x, a0
	pop(a0)
.end_macro

# Ввод целочисленного значения
.macro input_int(%x)
	push (a0)
	li a7, 5
	ecall
	mv %x, a0
	pop (a0)
.end_macro

# Ввод массива с клавиатуры
.macro input_array(%size %arr)
.text
	la %arr, arr
	mv t3, %size 
fill:
	beqz t3, end
	input_int (t4)
	sw t4, (%arr)
	addi %arr, %arr, 4
	addi t3, t3, -1
	j fill
end:
	la %arr, arr
.end_macro

# Суммирование элементов массива
.macro sum_array (%size %sum %arr %el_sum)
	mv a0, zero
	push (a0)
	mv %sum, a0
	pop (a0)
	push (a0)
	mv %el_sum, a0
	pop (a0)
	li t5, 2147483647
	li t6, -2147483648
read:   
	lw a0, (%arr)
	addi %el_sum, %el_sum, 1
	addi %arr, %arr, 4
	bgtz %sum, more
	j less
more:
	sub t4, t5, %sum
	blt t4, a0, overflow
	j addition
less:
	sub t4, t6, %sum
	blt a0, t4, overflow
addition:
	mv a1, %el_sum
	add %sum, %sum, a0
	blt %el_sum, %size, read
	j after_el_sum
overflow:
	lw a0, (%arr)
	addi %arr, %arr, 4
	addi %el_sum, %el_sum, 1
	blt %el_sum, %size, overflow
after_el_sum:
	mv %el_sum, a1
.end_macro

# Вывести на экран интовое значение
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro


# Сохранение заданного регистра на стеке
.macro push(%x)
	addi sp, sp, -4
	sw %x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw %x, (sp)
	addi sp, sp, 4
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro
