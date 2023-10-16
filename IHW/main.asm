.include "macrolib.asm"

.data
	.align  2		# ������ ������������.
	array_A:    .space 40 	# �������� ������ ��� ������ �� ������������� ���������� ���������
	array_B:    .space 40 	# �������� ������ ��� ������, ���� ����� ���������� ��� ������� �������� ������� A

.text
.globl main

main:
repeat:
	input_n(t2)				# ������ ����������� �������. ��������� � ������� t2.
	input_array(array_A t2)			# ������ ������ � ��������� ������ � �������� t0.
	find_min(array_A t2 t3 t5)		# ���� �������� � ��������� ����������� � ����� ������������ �������� � �������� t3 � t5 ��������������.
	swap_min(array_A array_B t2 t3 t5)	# ��������� ������ � � ������ ������ ������� � �����������.
	print_str("Source array: ")
	print_array(array_A t2)			# ������� �������������� ������ � �������.
	print_str("\nResult array: ")
	print_array(array_B t2)			# ������� �������������� ������ � �������
	print_str("\nIf you want to continue entering data, press any number except 0, otherwise press 0: ")
	input_int(t6)
	beqz t6, end				# �������� �� ��������� ��������.
	j repeat				# ��������� � ������� ���������.
end:	
	exit					# ���������� ���������.
