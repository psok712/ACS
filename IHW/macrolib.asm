# ����� ������ �� �����.
.macro print_str(%x)
.data
str:	.asciz %x
.text
	push(a0)
	li a7, 4	# ������ 4 ������� � ������� �7.
	la a0, str	# ������ � a0 ���� ������.
	ecall		# ������� �� �����.
	pop(a0)
.end_macro

# ���� ���������� ��������� � �������.
.macro input_n(%x)
	push(a0)
invalid_input:
	print_str("\nEnter the number of elements in the array (from 1 to 10): ")
	li a7, 5			# ������ 5 ������� � ������� �7.
	ecall				# �������� 5 �������, ����� ������ � ���������� ������������� ��������.
	li s2, 1			# ������������� � �2 ������ �������.
	li s3, 10			# ������������� � �3 ������� �������.
	blt a0, s2, invalid_input	# ��������� �� ������ �������.
	bgt a0, s3, invalid_input	# ��������� �� ������� �������.
	mv %x, a0			# ���� ��� �����, ������� ����� � %x.
	pop(a0)
.end_macro

# ���� ������� c ����������.
.macro input_array(%arr %size)
.text
	print_str("Enter array elements:\n")
	push(t0)
	push(a3)
	la t0, %arr 		# ������ ������ �� ������.
	mv a3, %size  		# ������ � ������� a3 ������ �������.
fill:
	beqz a3, end 		# ������� ������ �� �������(����� a3 == 0).
	input_int (s4)		# ������ ������������� �������� � ����������.
	sw s4, (t0)		# ������ ��������� �������� � ������.
	addi t0, t0, 4		# ���������� 4 �����, ����� ������� � ���������� ��������.
	addi a3, a3, -1		# �������� ������� �� 1.
	j fill			# ��������� � ����� �������� �����.
end:
	pop(t0)
	pop(s3)
.end_macro

# ����� ������������ �������� � �������.
.macro find_min(%arr %size %min %num_min)
	push(t0)
	push(a1)
	push(a2)
	push(a3)
	la t0, %arr
	mv a1, %size		# ������ ����������� ������� � ������� �1, ����� ��������.(�������)
	lw a2, (t0)		# ������ ������ �������� ������� � �2, ����� ��������� �������� ��������.
	mv a3, %size		# ������ ����� ������� �������� � �������(1 ��. - n �����, 2 ��. - n - 1 �����, ...).
find:
	beqz a1, end		# ���� ������� ����� ����, �� ����������� ��������.
	lw s0, (t0)
	bgt s0, a2, not_update	# ���� ������� ������ ��������, �� ������ �� ��������� � ��������� �� �����.
	mv a2, s0		# ��������� ��� �������.
	mv a3, a1		# ��������� ����� ������������ ��������.
not_update:
	addi t0, t0, 4		# ��������� � ���������� ��������.
	addi a1, a1, -1		# ������� ��������� �� 1.
	j find			# ��������� � ����� ��������.
end:	
	mv %min, a2
	mv %num_min, a3
	pop(t0)
	pop(a1)
	pop(a2)
	pop(a3)
.end_macro
	
.macro swap_min(%arr %arr_copy %size %min %num_min)
	push(t0)
	push(t1)
	push(a2)
	la t1, %arr_copy
	la t0, %arr
  	mv a2, %size
input_B:
  	beqz a2, end
  	beq a2, %size, insert_min 
  	beq a2, %num_min, insert_first
  	lw t6, (t0)
  	sw t6, (t1)
cont:
  	addi t1, t1, 4
  	addi t0, t0, 4
  	addi a2, a2, -1
  	j input_B
insert_first:
	la s1, %arr
	lw t6, (s1)
	sw t6, (t1)
	j cont
insert_min:
	sw %min, (t1)
	j cont  
end:
	pop(t0)
	pop(t1)
	pop(a2)
.end_macro
	
	
.macro print_array(%arr %size) 
	push(t1)
	push(s1)
	la t1, %arr
	mv s1, %size
print:
	beqz s1, end
	lw a0, (t1)
	print_int(a0)
	print_str(" ")
	addi s1, s1, -1
	addi t1, t1, 4
	j print
end:
	pop(t1)
	pop(s1)
.end_macro
	
	
	
# ���� �������������� ��������
.macro input_int(%x)
	push (a0)
	li a7, 5
	ecall
	mv %x, a0
	pop (a0)
.end_macro

# ������� �� ����� ������� ��������
.macro print_int (%x)
	push(a0)
	li a7, 1
	mv a0, %x
	ecall
	pop(a0)
.end_macro

# ���������� ��������� �������� �� �����.
.macro push(%x)
	addi sp, sp, -4
	sw %x, (sp)
.end_macro

# ������������ �������� � ������� ����� � �������.
.macro pop(%x)
	lw %x, (sp)
	addi sp, sp, 4
.end_macro

# ���������� ���������.
.macro exit
    	li a7, 10	# ������ 10 ������� � ������� �7.
    	ecall	# ��������� ���������.
.end_macro
