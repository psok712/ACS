.include "macrolib.asm"

.data
	.align  2		# Ставим выравнивание.
	array_A:    .space 40 	# Выделяем память под массив из максимального количества элементов
	array_B:    .space 40 	# Выделяем память под массив, куда будем копировать под условие элементы массива A

.text
.globl main

main:
repeat:
	input_n(t2)				# Вводим размерность массива. Сохраняем в регистр t2.
	input_array(array_A t2)			# Вводим массив и сохраняем начало в регистре t0.
	find_min(array_A t2 t3 t5)		# Ищем максимум и сохраняем минимальный и номер минимального элемента в регистры t3 и t5 соответственно.
	swap_min(array_A array_B t2 t3 t5)	# Заполняем массив В и меняем первый элемент с минимальным.
	print_str("Source array: ")
	print_array(array_A t2)			# Вывести сформированный массив в консоль.
	print_str("\nResult array: ")
	print_array(array_B t2)			# Вывести сформированный массив в консоль
	print_str("\nIf you want to continue entering data, press any number except 0, otherwise press 0: ")
	input_int(t6)
	beqz t6, end				# Проверка на введенное значение.
	j repeat				# Переходим к повтору программы.
end:	
	exit					# Завершение программы.
