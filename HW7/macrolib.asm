# Выводит строку на экран.
.macro print_str(%str)
.data
	str: .asciz %str
.text
	push(a0)
	push(a7)
	la a0, str
	li a7, 4
	ecall
	pop(a7)
	pop(a0)
.end_macro

# Переводи программу в спящий режим.
.macro sleep(%time)
	push(a0)
	push(a7)
	li a0, %time
	li a7, 32
	ecall
	pop(a7)
	pop(a0)
.end_macro

.macro read_int_a0
	push(a7)
	li a7, 5
	ecall
	pop(a7)
.end_macro

# Преобразование числа в нужный нам вид(от 0 до 15).
.macro convertNumber(%num)
	push(s10)
	li s10, 16
	blt %num, s10, only_digit
	j need_to_divide
only_digit: 
	convertDigit(%num)
	j end
need_to_divide:
	rem %num, %num, s10
	convertDigit(%num)
	addi %num, %num, 128
end:
	pop(s10)
.end_macro

# Преобразует цифру в формат для цифрового симуляторя для её отображения.
.macro convertDigit(%num)
	beqz a0, _zero
	
	addi a0, a0, -1
	beqz a0, _one
	
	addi a0, a0, -1
	beqz a0, _two
	
	addi a0, a0, -1
	beqz a0, _three
	
	addi a0, a0, -1
	beqz a0, _four
	
	addi a0, a0, -1
	beqz a0, _five
	
	addi a0, a0, -1
	beqz a0, _six
	
	addi a0, a0, -1
	beqz a0, _seven
	
	addi a0, a0, -1
	beqz a0, _eight
	
	addi a0, a0, -1
	beqz a0, _nine
	
	addi a0, a0, -1
	beqz a0, _ten
	
	addi a0, a0, -1
	beqz a0, _eleven
	
	addi a0, a0, -1
	beqz a0, _twelve
	
	addi a0, a0, -1
	beqz a0, _thirteen
	
	addi a0, a0, -1
	beqz a0, _fourteen
	
	addi a0, a0, -1
	beqz a0, _fifteen
_zero:
	li a0, 63 
	j end
_one:
	li a0, 6
	j end
_two:
	li a0, 0x5b
	j end
_three:
	li a0, 79
	j end
_four:
	li a0, 0x66
	j end
_five:
	li a0, 109
	j end
_six:
	li a0, 125
	j end
_seven:
	li a0, 7
	j end
_eight:
	li a0, 127
	j end
_nine:
	li a0, 111
	j end
_ten:
	li a0, 119
	j end
_eleven:
	li a0, 124
	j end
_twelve:
	li a0, 57
	j end
_thirteen:
	li a0, 94
	j end
_fourteen:
	li a0, 121
	j end
_fifteen:
	li a0, 113
	j end
end:
.end_macro

.macro push(%x)
	addi sp, sp, -4
	sw %x, (sp)	
.end_macro

.macro pop(%x)
	lw %x, (sp)
	addi sp, sp, 4
.end_macro

.macro exit
	li a7, 10
	ecall
.end_macro
