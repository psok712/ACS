.include "macrolib.asm"
.data
	buf1:    .space 100                                 # Буфер для первой строки
	buf2:    .space 100                                 # Буфер для второй строки
	buf3:    .space 100                                 # Буфер для третьей строки
	buf4:    .space 100                                 # Буфер для четвертой строки
	buf5:    .space 100                                 # Буфер для пятой строки
	buf6:    .space 100                                 # Буфер для шестой строки
	empty_test_str: .asciz ""                           # Пустая тестовая строка
	short_test_str: .asciz "not_empty"                  # Короткая тестовая строка
	long_test_str:  .asciz "a roza upala na lapu azora" # Длинная тестовая строка
.text
.global main

main:
	# Первое тестрирование
	la a1 buf1
	la a2 empty_test_str
	print_str_imm("Исходная строка \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 2)
	print_str_imm("Скопированные первые два символа: \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	
	# Второе тестирование
	la a1 buf2
	la a2 short_test_str
	print_str_imm("Исходная строка \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 50)
	print_str_imm("Скопированные первые 50 символов: \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Третий тест
	la a1 buf3
	la a2 long_test_str
	print_str_imm("Исходная строка \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 10)
	print_str_imm("Скопированные первые 10 символов: \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Четвертое тестирование
	la a1 buf4
	print_str_imm("Введите строку: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Исходная строка \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 7)
	print_str_imm("Скопированные первые 16 символов: \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Fifth test
	la a1 buf5
	print_str_imm("Введите строку: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Исходная строка \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 0)
	print_str_imm("Скопированные первые 9 символов: \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	exit
