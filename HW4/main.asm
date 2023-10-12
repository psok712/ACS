.text
.globl main

main:	
	li s0, 1 # Тестрирование максимального значения факториала
	li t2, 0xffffffff
	
	max_factorial:
		mv a0, s0
		jal fact
		addi s0, s0, 1
		divu t3, t2, s0
		bltu a0, t3, max_factorial
	addi s0, s0, -1 # Вычитаем единицу, поскольку значение в s0 уже не поместилось
	
	# Вывод результата
	mv a0, s0
	li a7, 1
	ecall
	
	# Завершение программы
	li a7, 10
	ecall

# Подпрограмма для вычисления факториала с помощью цикла
factorial:
	li a1, 1 # текущее значение факториала
	
	factorial_for:
		mul a1, a1, a0
		addi a0, a0, -1
		bgtz a0, factorial_for
	
	mv a0, a1
	ret
	



# Подпрограмма вычисления факториала рекурсией
fact:   
	addi    sp sp -8        ## Запасаем две ячейки в стеке
        sw      ra 4(sp)        ## Сохраняем ra
        sw      s1 (sp)         ## Сохраняем s1

        mv      s1 a0           # Запоминаем N в s1
        addi    a0 s1 -1        # Формируем n-1 в a0
        li      t0 1
        ble     a0 t0 done      # Если n<2, готово
        jal     fact            # посчитаем (n-1)!
        mul     s1 s1 a0        # s1 пережил вызов
	# Возврат из подпрограммы
done:   
	mv      a0 s1           # Возвращаемое значение
        lw      s1 (sp)         ## Восстанавливаем sp
        lw      ra 4(sp)        ## Восстанавливаем ra
        addi    sp sp 8         ## Восстанавливаем вершину стека
        ret
