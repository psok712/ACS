.include "macrolib.asm"

.global main

.data
arr:	.space 40

.text
main:
	input_n (t0)
	print_str ("Введите элементы массива:\n")
	input_array (t0 t2)
	sum_array (t0 t1 t2 t3)
	print_str ("Количество просуммированных элементов: ")
	print_int (t3)
	print_str ("\nСумма элементов: ")
	print_int (t1)
	exit
