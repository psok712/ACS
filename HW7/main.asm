.include "macrolib.asm"

.text 
main:
	jal subroutine
	exit


subroutine:
	li s1, -1
	li t1, 1
	print_str("Нажмите на Esc, чтобы завершить программу\n")
loop:	
	li t0, 0x1b
	beq a0, t0, left
	j right
right:
	li a1, 0xffff0011
	li a0, 0
	sb a0, (a1)
	li a1, 0xffff0010
	j print
left:
	li a1, 0xffff0010
	li a0, 0
	sb a0, (a1)
	li a1, 0xffff0011
print:
	li a0, 128
	sb a0, (a1)
	read_int_a0
	bltz a0, end
	convertNumber(a0)
	sb a0, (a1)
	sleep(712)
	mul t1, t1, s1
	j loop
end:
	ret
