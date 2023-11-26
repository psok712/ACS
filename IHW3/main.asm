.include "macrolib.asm"

.data
ans: .space 100
substr: .asciz "ta\n"

.text
.global main
main:
	read_file(s8)
	count_punctuation_symbol(s8 s7)
	int_to_string(s7 ans)
	la s9, ans
	write_file(s9)
	print_str_imm("If you want to continue press Y, otherwise press N")
	newline
	reuse(s8)
	beqz s8, end
	print_str(s7)
end:
	exit
	
