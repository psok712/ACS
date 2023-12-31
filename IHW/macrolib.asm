# Вывод строки на экран.
.macro print_str(%x)
.data
str:	.asciz %x
.text
	push(a0)
	li a7, 4	# Кладем 4 команду в регистр а7.
	la a0, str	# Кладем в a0 нашу строку.
	ecall		# Выводим на экран.
	pop(a0)
.end_macro

# Ввод количества элементов в массиве.
.macro input_n(%x)
	push(a0)
invalid_input:
	print_str("\nEnter the number of elements in the array (from 1 to 10): ")
	li a7, 5			# Кладем 5 команду в регистр а7.
	ecall				# Вызываем 5 команду, чтобы ввести с клавиатуры целочисленное значение.
	li s2, 1			# Устанавливаем в а2 нижнюю границу.
	li s3, 10			# Устанавливаем в а3 верхнюю границу.
	blt a0, s2, invalid_input	# Проверяем на нижнюю границу.
	bgt a0, s3, invalid_input	# Проверяем на верхнюю границу.
	mv %x, a0			# Если все верно, заносим число в %x.
	pop(a0)
.end_macro

# Ввод массива c клавиатуры.
.macro input_array(%arr %size)
.text
	print_str("Enter array elements:\n")
	push(t0)
	push(a3)
	la t0, %arr 		# Кладем ссылку на массив.
	mv a3, %size  		# Кладем в регистр a3 размер массива.
fill:
	beqz a3, end 		# Условие выхода из массива(когда a3 == 0).
	input_int (s4)		# Вводим целочисленное значение с клавиатуры.
	sw s4, (t0)		# Кладем введенное значение в массив.
	addi t0, t0, 4		# Прибавляем 4 байта, чтобы перейти к следующему элементу.
	addi a3, a3, -1		# Убавляет счетчик на 1.
	j fill			# Переходим к новой итерации цикла.
end:
	pop(t0)
	pop(s3)
.end_macro

# Поиск минимального элемента и его номера в массиве.
.macro find_min(%arr %size %min %num_min)
	push(t0)
	push(a1)
	push(a2)
	push(a3)
	la t0, %arr
	mv a1, %size		# Кладем размерность массива в регистр а1, чтобы изменять.(счетчик)
	lw a2, (t0)		# Кладем первое значение массива в а2, чтобы обновлять значение минимума.
	mv a3, %size		# Кладем номер первого значения в массиве(1 эл. - n номер, 2 эл. - (n - 1) номер, ...).
find:
	beqz a1, end		# Если счетчик равен нулю, то заканчиваем итерации.
	lw s0, (t0)		# Заносим в s0 элемент массива.
	bgt s0, a2, not_update	# Если элемент больше минимума, то ничего не обновляем и переходим по метке.
	mv a2, s0		# Обновляем наш минимум.
	mv a3, a1		# Обновляем номер минимального элемента.
not_update:
	addi t0, t0, 4		# Переходим к следующему элементу.
	addi a1, a1, -1		# Счетчик уменьшаем на 1.
	j find			# Переходим к новой итерации.
end:	
	mv %min, a2		# Заносим найденное минимальное значение в метку.
	mv %num_min, a3		# Заносим найденный номер минимального значения в метку.
	pop(t0)
	pop(a1)
	pop(a2)
	pop(a3)
.end_macro
	
.macro swap_min(%arr %arr_copy %size %min %num_min)
	push(t0)
	push(t1)
	push(a2)
	la t1, %arr_copy		# Кладем в t1 массив, который нужно сформировать по первому массиву.
	la t0, %arr			# Кладем в t0 первый массив.
  	mv a2, %size			# Кладем в a2 счетчик.
input_B:
  	beqz a2, end			# Если счетчик равен нулю, то выходим из цикла.
  	beq a2, %size, insert_min 	# Если счетчик равен размерности(по нашему обозначению), то переходим по метке, чтобы занести минимальный элемент.
  	beq a2, %num_min, insert_first	# Если счетчик равен номеру минимального элемента, то вставляем в эту позицию первый элемент первого массива.
  	lw t6, (t0)			# Иначе заносим в t6 элемент первого массива.
  	sw t6, (t1)			# И заносим его во второй массив.
cont:
  	addi t1, t1, 4			# Переходим к заполнению следующего элемента.
  	addi t0, t0, 4			# Переходим к следующему элементу массива
  	addi a2, a2, -1			# Уменьшаем счетчик.
  	j input_B			# Повторяем заполнение.
insert_first:
	la s1, %arr			# Считываем ссылку на начало первого массива в s1.
	lw t6, (s1)			# Заносим первый элемент массива в t6.
	sw t6, (t1)			# Заносим первый элемент на позицию минимального.
	j cont				# Переходим к продолжению, чтобы изменить счетчики.
insert_min:
	sw %min, (t1)			# Заносим минимальный элемент на позицию первого.
	j cont  			# Переходим к продолжению, чтобы изменить счетчики.
end:
	pop(t0)
	pop(t1)
	pop(a2)
.end_macro
	
	
.macro print_array(%arr %size) 
	push(t1)
	push(s1)
	la t1, %arr		# Кладем ссылку на массив в t1.
	mv s1, %size		# Кладем размерность массива в s1.
print:
	beqz s1, end		# Если счетчик равен нулю, то выходим из цикла.
	lw a0, (t1)		# Заносим в a0 элемент массива.
	print_int(a0)		# Вызываем макрос печати элемента в консоль.
	print_str(" ")		# Ставим между элементом пробел.
	addi s1, s1, -1		# Изменяем счетчик.
	addi t1, t1, 4		# Переходим к новому элементу массива.
	j print			# Повторяем предыдущие действия.
end:
	pop(t1)
	pop(s1)
.end_macro
	
	
	
# Ввод целочисленного значения
.macro input_int(%x)
	push (a0)
	li a7, 5	# Кладем 5 команду в регистр а7.
	ecall		# Вводим значение из клавиатуры.
	mv %x, a0	# Кладем в метку введенное значение.
	pop (a0)
.end_macro

# Вывести на экран целочисленное значение
.macro print_int (%x)
	push(a0)
	li a7, 1	# Кладем 1 команду в регистр а7.
	mv a0, %x	# Кладем в a0 значение из метки.
	ecall		# Выводи на экран.
	pop(a0)
.end_macro

# Сохранение заданного регистра на стеке.
.macro push(%x)
	addi sp, sp, -4
	sw %x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр.
.macro pop(%x)
	lw %x, (sp)
	addi sp, sp, 4
.end_macro

# Завершение программы.
.macro exit
    	li a7, 10	# Кладем 10 команду в регистр а7.
    	ecall		# Завершаем программу.
.end_macro
