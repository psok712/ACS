.include "macrolib.asm"

.data
x:		.double 0.0

.text
.globl main

main:
repeat:
	fld fa5, x, t0
	input_x (fa5)
	func_count (fa5 fa6)
	print_str ("Received value: ")
	print_double (fa6)
	print_str("\nIf you want to continue entering data, press any number except 0, otherwise press 0: ")
	input_int (t6)
	beqz t6, end
	j repeat
end:	
	exit