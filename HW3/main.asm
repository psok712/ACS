.data
arr:      .space 10 # Массив на 10 элементов по 4 байта каждый

# Cтроки для вывода в консоль
num_elements:  .string "Введите количество элементов (от 1 до 10): "
prompt_elements:    .string "Введите элементы массива:\n"
sum_message:    .string "\nСумма элементов массива: "
num_elements_message:  .string "\nЭлементов в массиве: "
even_message:    .string "\nКоличество четных элементов: "
odd_message:    .string "\nКоличество нечетных элементов: "
wrong_num_message:    .string "Некорректное количество элементов. Попрбуйте ещё раз.\n"
overflow_message:    .string "\nПереполнение. Элементов просуммированно: "

.text
main:
   	# Ввод числа элементов в массиве
    	la a0, num_elements
    	li a7, 4
   	ecall
    	li a7, 5
    	ecall
    	mv t0, a0
    
    	# Проверка на корректное количество элементов
    	li a2, 1
    	li a3, 10
    	blt t0, a2, invalid_input
    	bgt t0, a3, invalid_input
    	la a0, prompt_elements
    	li a7, 4
    	ecall
    
    	li t1, 0  # Количество чётных
    	li t2, 0  # Количество нечётных
    	li t3, 0  # Сумма элементов массива
    	la t4, arr
    	mv t5, t0
    

input_loop:
    	beq t5, zero, endloop
    	li a7, 5
    	ecall
    	mv s6, a0
    	sw s6, (t4)
    	addi t4, t4, 4
    	addi t5, t5, -1
    	b input_loop


endloop:
    	la t4 arr


sum_loop:
    	bge t5, t0, sum_output
    	lw s6, (t4)
    
    	bge t3, zero, validate_sum
    	bge s6, zero, no_overflow
    	add t3, t3, s6
    	ble t3, zero, no_overflow
    	la a0, overflow_message
    	li a7, 4
    	ecall

    	add s8, t2, t1
    	li a7, 1
    	mv a0, s8
    	ecall

    	sub t3, t3, s6
    	j sum_output


validate_sum:
    	ble s6, zero, no_overflow
    	add t3, t3, s6
    	bge t3, zero, no_overflow
    	la a0, overflow_message
    	li a7, 4
    	ecall

    	add s8, t2, t1
    	li a7, 1
    	mv a0, s8
    	ecall

    	sub t3, t3, s6
    	j sum_output


no_overflow:
    	li s1, 2
    	rem s2, s6, s1
    	beq s2, zero, even
    	addi t2, t2, 1
    	j continue


even:
    	addi t1, t1, 1


continue:
    	addi t5, t5, 1
    	addi t4, t4, 4
    	j sum_loop


sum_output:
    	la a0, sum_message
    	li a7, 4
    	ecall

    	li a7, 1
    	mv a0, t3
    	ecall


evenness_ouput:
    	la a0, even_message
    	li a7, 4
    	ecall
    	li a7, 1
    	mv a0, t1
    	ecall
    
    	la a0, odd_message
    	li a7, 4
    	ecall

    	li a7, 1
    	mv a0, t2
    	ecall
    
    	li, a7, 10
   	ecall
        

invalid_input:
    	la a0, wrong_num_message
    	li a7, 4
    	ecall
    	j main
 
