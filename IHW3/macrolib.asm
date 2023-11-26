# Функция чтения содержимого файла
.macro read_file(%buf_reg)
	push(a0)
	push(a1)
	push(a2)
	push(a7)
	push(t0)
	push(t4)
	push(t5)
	push(t6)
	push(s0)
	push(s1)
	push(s2)
.eqv    NAME_SIZE 256		# Размер буфера для имени файла
.eqv    TEXT_SIZE 512		# Размер буфера для текста

.data
	er_name_mes:    .asciz "Incorrect file name\n"
	er_read_mes:    .asciz "Incorrect read operation\n"
	file_name:      .space	NAME_SIZE		# Имячитаемого файла
	strbuf:	        .space  TEXT_SIZE		# Буфер для читаемого текста
.text
    	print_str_imm("Input path to file for reading: ")
    	# Ввод имени файла с консоли эмулятора
    	str_get(file_name, NAME_SIZE)
    	open(file_name, READ_ONLY)
    	li s1 -1		# Проверка на корректное открытие
    	beq a0 s1 er_name	# Ошибка открытия файла
    	mv s0 a0       		# Сохранение дескриптора файла

    	# Выделение начального блока памяти для для буфера в куче
    	allocate(TEXT_SIZE)	# Результат хранится в a0
    	mv s3, a0		# Сохранение адреса кучи в регистре
    	mv s5, a0		# Сохранение изменяемого адреса кучи в регистре
    	li s4, TEXT_SIZE	# Сохранение константы для обработки
    	mv s6, zero		# Установка начальной длины прочитанного текста
    	###############################################################
read_loop:
    	# Чтение информации из открытого файла
    	###read(s0, strbuf, TEXT_SIZE)
    	read_addr_reg(s0, s5, TEXT_SIZE) # чтение для адреса блока из регистра
    	# Проверка на корректное чтение
    	beq a0 s1 er_read	# Ошибка чтения
    	mv s2 a0       		# Сохранение длины текста
    	add s6, s6, s2		# Размер текста увеличивается на прочитанную порцию
    	# При длине прочитанного текста меньшей, чем размер буфера,
    	# необходимо завершить процесс.
    	bne s2 s4 end_loop
    	# Иначе расширить буфер и повторить
    	allocate(TEXT_SIZE)	# Результат здесь не нужен, но если нужно то...
    	add s5 s5 s2		# Адрес для чтения смещается на размер порции
    	b read_loop		# Обработка следующей порции текста из файла
end_loop:
    	###############################################################
    	# Закрытие файла
    	close(s0)
    	#li   a7, 57       	# Системный вызов закрытия файла
    	#mv   a0, s0       	# Дескриптор файла
    	#ecall             	# Закрытие файла
    	###############################################################
    	# Установка нуля в конце прочитанной строки
    	###la	t0 strbuf	# Адрес начала буфера
    	mv t0 s3		# Адрес буфера в куче
    	add t0 t0 s6		# Адрес последнего прочитанного символа
    	addi t0 t0 1		# Место для нуля
    	sb zero (t0)		# Запись нуля в конец текста
    	###############################################################
    	# Вывод текста на консоль
    	###la 	a0 strbuf
    	mv a0 s3	# Адрес начала буфера из кучи
    	j finish
er_name:
    	# Сообщение об ошибочном имени файла
    	la a0 er_name_mes
    	li a7 4
    	ecall
    	# И завершение программы
    	exit
er_read:
    	# Сообщение об ошибочном чтении
    	la a0 er_read_mes
    	li a7 4
    	ecall
    	# И завершение программы
    	exit
finish:
	mv %buf_reg a0
	pop(s2)
	pop(s1)
	pop(s0)
	pop(t6)
	pop(t5)
	pop(t4)
	pop(t0)
	pop(a7)
	pop(a2)
	pop(a1)
	pop(a0)
.end_macro

# Записывает строку, хранящуюся в регистре %str_reg, в файл, указанный пользователем.
.macro write_file(%str_reg)
	push(a0)
	push(a1)
	push(a2)
	push(a7)
	push(t0)
	push(t4)
	push(t5)
	push(t6)
	push(s0)
	push(s1)
	push(s2)
	mv a3 %str_reg
	length(a3, a2)
		
.eqv	NAME_SIZE 256		# Размер буфера для имени файла

.data
	prompt:  .asciz "Input path to the read file: "	# Путь до читаемого файла
	default_name: .asciz "default_file.txt"      	# Имя файла по умолчанию
	file_name: .space	NAME_SIZE		# Имя читаемого файла
.text
    	# Вывод подсказки
    	la a0 prompt
    	li a7 4
    	ecall
    
    	# Ввод имени файла с консоли эмулятора
    	la a0 file_name
    	li a1 NAME_SIZE
    	li a7 8
    	ecall
    	# Убрать перевод строки
    	li  t4 '\n'
    	la  t5  file_name
    	mv  t3 t5		# Сохранение начала буфера для проверки на пустую строку
loop:
    	lb t6 (t5)
    	beq t4 t6 replace
    	addi t5 t5 1
    	b loop
replace:
    	beq t3 t5 default	# Установка имени введенного файла
    	sb zero (t5)
    	mv a0, t3 		# Имя, введенное пользователем
    	b out
default:
    	la a0, default_name 	# Имя файла по умолчанию

out:
    	# Открыть (для записи) несуществующий файл
    	li a7, 1024     	# системный вызов для открытия файла
    	li a1, 1        	# Открыт для записи (флаги 0: чтение, 1: запись)
    	ecall             	# открыть файл (дескриптор файла возвращается в a0)
    	mv s6, a0       	# сохранить дескриптор файла

    	# Записать в только что открытый файл
    	li a7, 64       	# системный вызов для записи в файл
    	mv a0, s6       	# дескриптор файла
    	mv a1, a3       	# адрес буфера, из которого следует писать
    	ecall             	# записать в файл

    	# Закрыть файл
    	li a7, 57       	# системный вызов для закрытия файла
    	mv a0, s6       	# дескриптор файла, который нужно закрыть
    	ecall             	# закрыть файл
	pop(s2)
	pop(s1)
	pop(s0)
	pop(t6)
	pop(t5)
	pop(t4)
	pop(t0)
	pop(a7)
	pop(a2)
	pop(a1)
	pop(a0)
.end_macro

# Функция вычисления длины заданной строки 
.macro length(%str_reg, %ans_reg)
	push(t1)
	push(t2)
	push(s1)
	mv t1 %str_reg
	li s1 0
loop:
	lb t2 (t1)
	beqz t2 end
	addi s1 s1 1
	addi t1 t1 1
	j loop
end:
	mv %ans_reg s1
	pop(s1)
	pop(t2)
	pop(t1)
.end_macro

# Просит пользователя написать Y или N для записи дополнительных данных в консоль.
.macro reuse(%flag_reg)
	push(a2)
	push(a3)
	push(a4)
	read_str(a2)
	lb a3 (a2)
	li a4 'Y'
	beq a3 a4 yes
	li a4 'N' 
	beq a3 a4 no
loop:
	print_str_imm("Enter only Y or N!")
	newline
	read_str(a2)
	lb a3 (a2)
	li a4 'Y'
	beq a3 a4 yes
	li a4 'N' 
	beq a3 a4 no
	j loop
yes:
	li %flag_reg 1
	j finish
no:
	li %flag_reg 0
finish:
	pop(a4)
	pop(a3)
	pop(a2)
.end_macro

# Считайте строку (максимальный размер — 4096 символов) в данный регистр, за исключением регистра a0.
.macro read_str(%str_reg)
.data
	str: .space 4096
.text
	push(a0)
	push(a1)
	push(a7)
	la a0 str
	li a1 4096 
	li a7 8
	ecall
	mv %str_reg a0
	pop(a7)
	pop(a1)
	pop(a0)
.end_macro

# Печатает строку из данного регистра, кроме регистра a0.
.macro print_str(%str_reg) 
	push(a0)
	push(a7)
	mv a0 %str_reg
	li a7 4
	ecall
	pop(a7)
	pop(a0)
.end_macro

.macro newline
	push(a0)
	push(a7)
	li a0 '\n'
	li a7 11
	ecall
	pop(a7)
	pop(a0)
.end_macro

#-------------------------------------------------------------------------------
# Ввод строки в буфер заданного размера с заменой перевода строки нулем
# %strbuf - адрес буфера
# %size - целая константа, ограничивающая размер вводимой строки
.macro str_get(%strbuf, %size)
    la      a0 %strbuf
    li      a1 %size
    li      a7 8
    ecall
    push(s0)
    push(s1)
    push(s2)
    li	s0 '\n'
    la	s1	%strbuf
next:
    lb	s2  (s1)
    beq s0	s2	replace
    addi s1 s1 1
    b	next
replace:
    sb	zero (s1)
    pop(s2)
    pop(s1)
    pop(s0)
.end_macro

#-------------------------------------------------------------------------------
# Открытие файла для чтения, записи, дополнения
.eqv READ_ONLY	0	# Открыть для чтения
.eqv WRITE_ONLY	1	# Открыть для записи
.eqv APPEND	    9	# Открыть для добавления
.macro open(%file_name, %opt)
    li   	a7 1024     	# Системный вызов открытия файла
    la      a0 %file_name   # Имя открываемого файла
    li   	a1 %opt        	# Открыть для чтения (флаг = 0)
    ecall             		# Дескриптор файла в a0 или -1)
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла
.macro read(%file_descriptor, %strbuf, %size)
    li   a7, 63       		# Системный вызов для чтения из файла
    mv   a0, %file_descriptor  	# Дескриптор файла
    la   a1, %strbuf   		# Адрес буфера для читаемого текста
    li   a2, %size 		# Размер читаемой порции
    ecall             		# Чтение
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла,
# когда адрес буфера в регистре
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       		# Системный вызов для чтения из файла
    mv   a0, %file_descriptor   # Дескриптор файла
    mv   a1, %reg   		# Адрес буфера для читаемого текста из регистра
    li   a2, %size 		# Размер читаемой порции
    ecall             		# Чтение
.end_macro

#-------------------------------------------------------------------------------
# Закрытие файла
.macro close(%file_descriptor)
    li   a7, 57       		# Системный вызов закрытия файла
    mv   a0, %file_descriptor  	# Дескриптор файла
    ecall             		# Закрытие файла
.end_macro

#-------------------------------------------------------------------------------
# Выделение области динамической памяти заданного размера
.macro allocate(%size)
    li a7, 9
    li a0, %size	# Размер блока памяти
    ecall
.end_macro

# Печатает введенную строку
.macro print_str_imm(%str_imm)
.data
	str: .asciz %str_imm
.text
	push(a0)
	push(a7)
	la a0 str
	li a7 4
	ecall
	pop(a7)
	pop(a0)
.end_macro

# Преобразует int в строку
.macro int_to_string(%num_reg, %ans_label)
	la s0, %ans_label
	li s1, 0
	mv s3, %num_reg
	beqz s3, null
	addi s3, s3, 1
	beqz s3, is_negative
	li s4, 10
	addi s3, s3, -1
loop:
	beqz s3, finish
	rem s5, s3, s4
	addi s5, s5, 48 # преобразуем в символ таблицы ascii
	sb s5, (s0)
	addi s0, s0, 1
	addi s1, s1, 1
	div s3, s3, s4
	j loop
finish:
	sub s0 s0 s1
	li s2 2
	div s3 s1 s2 # s3 = length / 2
	li s2 0 # счетчик
for:
	beq s2 s3 end # while (s2 != length / 2): swap(str[s2], str[length - s2 - 1]
	sub s4 s1 s2 # s4 = length - s2
	addi s4 s4 -1 # s4 = length - s2 - 1 
	add s0 s0 s2 # go to str[s2]
	lb s5 (s0) # s5 = str[s2]
	sub s0 s0 s2 # go back to str[0]
	add s0 s0 s4 # go to str[length - s2 - 1]
	lb s6 (s0) # s6 = str[length - s2 - 1]
	sb s5 (s0) # str[length - s2 - 1] = s5
	sub s0 s0 s4 # go back to str[0]
	add s0 s0 s2 # go to str[s2]
	sb s6 (s0) # str[s2] = s6
	sub s0 s0 s2 # go back to str[0]
	addi s2 s2 1 # ++s2
	j for
null:
	li s1 48 # ascii код для 0
	sb s1 (s0)
	j end
is_negative:
	li s1 45 # ascii код для -
	sb s1 (s0)
	addi s0 s0 1
	li s1 49 # ascii код для 1
	sb s1 (s0)
	addi s0 s0 -1 # recover s0, so s0 is pointing to the start of the string
end:	
.end_macro


.macro count_punctuation_symbol (%str_reg %ans_reg)
.data
punctuation_symbol:	.word 0x21, 0x22, 0x27, 0x2C, 0x2D, 0x2E, 0x3A, 0x3B, 0x3F
punctuation_count:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
	push (t1)
	push (t2)
	push (s1)
	li s1, 9	# Загружаю размер массивов
	mv t1, %str_reg
loop:
	lb t2, (t1)
	beqz t2 end
	checking_symbol (t2 punctuation_symbol punctuation_count s1)
	addi t1, t1, 1
	j loop
end:
	counting_unique_symbol (t2 punctuation_count s1)
	mv %ans_reg, t2
	pop (s1)
	pop (t2)
	pop (t1)
.end_macro

# Функция проверки символа на принадлежность к знакам препинания
# Если да, то в массиве подсчета ставим 1 на месте этого знака.
.macro checking_symbol (%symbol_reg %array_symbol_label %count_array_label %size)
	push (a0)
	push (a1)
	push (a2)
	push (a3)
	push (a4)
	la a4, %count_array_label
	la a3, %array_symbol_label
	li a1, 0
loop:
	beq a1, %size, end
	lw a0, (a3)
	beq a0, %symbol_reg, add_to
	addi a1, a1, 1
	addi a3, a3, 4
	addi a4, a4, 4
	j loop
add_to:
	li a2, 1
	sw a2, (a4)
	pop (a4)
	pop (a3)
	pop (a2)
	pop (a1)
	pop (a0)
end:
.end_macro

# Функция подсчета не нулевых элементов массива, то есть мы собираем информацию
# какие знаки препинания уже встретили, в массиве они обозначены 1.
.macro counting_unique_symbol (%ans_reg %count_array_label %size)
	push (a0)
	push (a1)
	push (a2)
	push (a3)
	la a3, %count_array_label
	li a0, 0	# Счетчик количества пройденных элементов
	li a1, 0	# Счетчик количества не нулевых элементов
loop:
	beq a0, %size, end
	lw a2, (a3)
	addi a3, a3, 4
	addi a0, a0, 1
	beqz a2, loop
	addi a1, a1, 1
	j loop
end:
	mv %ans_reg, a1
	pop (a3)
	pop (a2)
	pop (a1)
	pop (a0)
.end_macro

.macro push(%x_reg)
	addi sp sp -4
	sw %x_reg (sp)
.end_macro

.macro pop(%x_reg)
	lw %x_reg (sp)
	addi sp sp 4
.end_macro

.macro exit
	li a7 10
	ecall
.end_macro