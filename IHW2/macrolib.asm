# Вывод строчки на экран.
.macro	print_str (%line)
.data
str:	.asciz %line
.text
	push(a0)
	li a7, 4
	la a0, str
	ecall
	pop(a0)
.end_macro

# Ввод с клавиатуры параметра x.
.macro input_x (%x)
	pushD (fa0)
	push (t1)
	push (t2)
invalid_input:
	print_str("\nEnter parameter x in the range (-1,1): ")
	li a7, 7
	ecall
	li t1, -1	
	fcvt.d.w fa1, t1		# fa1 = -1.0
	li t2, 1
	fcvt.d.w fa2, t2		# fa2 = 1.0
	flt.d t1, fa0, fa2		# if fa0 < fa2 => t1 = 1 else => t1 = 0
	beqz t1, invalid_input
	flt.d t1, fa1, fa0
	beqz t1, invalid_input		# if fa1 < fa0 => t1 = 1 else => t1 = 0
	fmv.d %x, fa0
	popD (fa0)
	pop (t1)
	pop (t2)
.end_macro

# Computes the absolute value of %src_reg
.macro abs(%x)
.data
null: .double 0
.text
	pushD (fa0)
	pushD (fa1)
	push (a0)
	push (t0)
	push (t1)
	fld fa0, null, a0 # ft0 stores 0
	fle.d t1, %x, fa0 # src_reg <= 0 => src_reg = -src_reg (it is needed to be like this)
	li t0, -1 
	mul t1, t1, t0 # if (t1 == 1) => t1 = -1 but if (t1 == 0) => t1 = 0
	beqz t1, finish # if (t1 == 0) => x > 0 => return x, else t1 = -1 => ft1 = -ft1 => return ft1
	fcvt.d.w fa1, t1 # fa1 = -1
	fmul.d %x, fa1, %x # src_reg = -1 * src_reg
finish:
	pop (t1)
	pop (t0)
	pop (a0)
	popD (fa1)
	popD (fa0)
.end_macro

# Аналогичный кусок программы по вычислению функции 1 / (1 - x) на С++
#    double num;
#    const double eps = 0.0005;
#    double res = 0;
#    double prev_res;
#    double square = 1;
#    do {
#        prev_res = res;
#        res += square;
#        square *= num;
#    } while (std::abs(res - prev_res) > eps);
#    std::cout << res << std::endl;

.macro func_count (%x %res)
.data
eps:		.double 0.0005
res:		.double 0.0
prev_res:	.double 0.0
square:		.double 1.0
.text
	pushD (fs0)
	pushD (fs1)
	pushD (fs2)
	pushD (fs3)
	pushD (fs4)
	pushD (fs5)
	push (s0)
	push (s1)
	push (s2)
	push (s3)
	push (t1)
	fld fs0, eps, s0	# fs0 = eps (= 0.0005)
	fld fs1, res, s1	# fs1 = res (= 0.0)
	fld fs2, prev_res, s2	# fs2 = prev_res (= 0.0)
	fld fs3, square, s3	# fs3 = square (= 1.0)
	fmv.d fs4, %x 		# fs4 = x
while:
	fmv.d fs2, fs1		# prev_res = res
	fadd.d fs1, fs1, fs3	# res += square
	fmul.d fs3, fs3, fs4	# square *= x
	fsub.d fs5, fs1, fs2	# res - prev_res
	abs (fs5)
	fle.d t1, fs5, fs0	# if res - prev > eps => t1 = 1, else => t1 = 0
	beqz t1, while		# if t1 == 0 => while
	fmv.d %res, fs1		# %res = fs1
	pop (t1)
	pop (s3)
	pop (s2)
	pop (s1)
	pop (s0)
	popD (fs5)
	popD (fs4)
	popD (fs3)
	popD (fs2)
	popD (fs1)
	popD (fs0)
.end_macro 

# Ввод целочисленного значения
.macro input_int(%x)
	push (a0)
	li a7, 5	
	ecall		
	mv %x, a0	
	pop (a0)
.end_macro

# Вывод дробного значения на экран.
.macro print_double (%numb) 
	pushD (fa0)
	li a7, 3
	fmv.d fa0, %numb
	ecall
	popD (fa0)
.end_macro

# Сохранение регистра на стеке.
.macro pushD (%reg)
	addi sp, sp, -8
	fsd %reg, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр.
.macro popD (%reg)
	fsd %reg, (sp)
	addi sp, sp, 8
.end_macro

# Сохранение регистра на стеке.
.macro push (%reg)
	addi sp, sp, -4
	lw %reg, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр.
.macro pop (%reg)
	lw %reg, (sp)
	addi sp, sp, 4
.end_macro

# Завершение программы.
.macro exit
	li a7, 10
	ecall
.end_macro
