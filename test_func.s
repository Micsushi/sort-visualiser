#
# CMPUT 229 Public Materials License
# Version 1.0
#
# Copyright 2020 University of Alberta
# Copyright 2023 Farel Nicholas Adrian Lukas
#
#
# This software is distributed to students in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the disclaimer below in the documentation
#    and/or other materials provided with the distribution.
#
# 2. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#-------------------------------
# Sorting Algorithm Visualizer Functions Tester
#
# Author: Farel Nicholas Adrian Lukas
# Date: May 24, 2023
#
# Tests the functions in the sorting algorithm visualizer
#-------------------------------
#

.data
lbracket:	.asciz "["
rbracket:	.asciz "]\n"
comma:		.asciz ", "
expected:	.asciz "Expected: "
actual:		.asciz "Actual:   "
newline:	.asciz "\n"

max_str: .asciz "=== Max ===\n"
min_str: .asciz "=== Min ===\n"
max_range_str:	.asciz "=== Max Range ===\n"
sep_pos_str:	.asciz "=== Separator Position ===\n"
bar_height_str:	.asciz "=== Bar Height ===\n"

target_element_str: .asciz "Target Element: "
target_element: .word 0

test_arr_str:	.asciz "Test Array: "

# test array 1
test_arr1_original:	.word 6, 10, -7, -9, 1, -4, -5, 2, -1, 9
test_arr1_copy:	.word 6, 10, -7, -9, 1, -4, -5, 2, -1, 9

# test array 2
test_arr2_original:	.word 3, 5, 8, 6, 2, 9, 4, 10, 7, 1
test_arr2_copy:	.word 3, 5, 8, 6, 2, 9, 4, 10, 7, 1

# test array 3
test_arr3_original:	.word -2, -3, -8, -5, -7, -6, -1, -10, -4, -9
test_arr3_copy:	.word -2, -3, -8, -5, -7, -6, -1, -10, -4, -9

test_arr_len:	.word 10

max_expected: .word 0
min_expected: .word 0
max_range_expected: .word 0
sep_pos_expected: .word 0
bar_height_expected: .word 0

saved_a0:	.word 0
saved_a1:	.word 0
saved_a2:	.word 0
saved_ra:	.word 0

.text
#---------------------------------------------------------------------------------------------
# main_test_func
# 
# Description:
# 	Test the functions in the sorting algorithm visualizer
#---------------------------------------------------------------------------------------------
main_test_func:
	# set array 1 expected values
	li	t0, 10
	sw	t0, max_expected, t1
	li	t0, -9
	sw	t0, min_expected, t1
	li	t0, 19
	sw	t0, max_range_expected, t1
	li	t0, 21
	sw	t0, sep_pos_expected, t1
	li	t0, 4
	sw	t0, bar_height_expected, t1
	li	t0, 2
	sw	t0, target_element, t1

	# test with array 1
	la	a0, test_arr1_original	# a0 <- test_arr
	la	a1, test_arr1_copy	# a1 <- test_arr_copy
	lw	a2, test_arr_len	# a2 <- test_arr_len
	jal	test_this_array

	# set array 2 expected values
	li	t0, 10
	sw	t0, max_expected, t1
	li	t0, 1
	sw	t0, min_expected, t1
	li	t0, 10
	sw	t0, max_range_expected, t1
	li	t0, 40
	sw	t0, sep_pos_expected, t1
	li	t0, 8
	sw	t0, bar_height_expected, t1
	li	t0, 2
	sw	t0, target_element, t1

	# test with array 2
	la	a0, test_arr2_original	# a0 <- test_arr
	la	a1, test_arr2_copy	# a1 <- test_arr_copy
	lw	a2, test_arr_len	# a2 <- test_arr_len
	jal	test_this_array

	# set array 3 expected values
	li	t0, -1
	sw	t0, max_expected, t1
	li	t0, -10
	sw	t0, min_expected, t1
	li	t0, 10
	sw	t0, max_range_expected, t1
	li	t0, 0
	sw	t0, sep_pos_expected, t1
	li	t0, -8
	sw	t0, bar_height_expected, t1
	li	t0, -2
	sw	t0, target_element, t1

	# test with array 3
	la	a0, test_arr3_original	# a0 <- test_arr
	la	a1, test_arr3_copy	# a1 <- test_arr_copy
	lw	a2, test_arr_len	# a2 <- test_arr_len
	jal	test_this_array

	# exit
	li a7, 10	# a7 = 10
	ecall


test_this_array:
	# save a0, a1, a2
	sw	a0, saved_a0, t0	# saved_a0 <- a0
	sw	a1, saved_a1, t0	# saved_a1 <- a1
	sw	a2, saved_a2, t0	# saved_a2 <- a2

	# save ra
	sw	ra, saved_ra, t0	# saved_ra <- ra

	# PRINT TEST ARRAY
	la	a0, test_arr_str	# a0 <- "Test Array: "
	li	a7, 4	# a7 = 4
	ecall	# print "Test Array: "
	lw	a0, saved_a0	# a0 <- test_arr
	lw	a1, saved_a2	# a1 <- test_arr_len
	# la	a0, test_arr_original	# a0 <- test_arr
	# lw	a1, test_arr_len	# a1 <- test_arr_len
	jal	print_test_array

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# === MAX ===
	# print header
	la	a0, max_str	# a0 <- "=== Max ==="
	li	a7, 4	# a7 = 4
	ecall	# print "=== Max ==="

	# print expected
	la	a0, expected	# a0 <- "Expected: "
	li	a7, 4	# a7 = 4
	ecall	# print "Expected: "
	lw	a0, max_expected	# a0 <- max_expected
	li	a7, 1	# a7 = 1
	ecall	# print max_expected

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print actual
	la	a0, actual	# a0 <- "Actual: "
	li	a7, 4	# a7 = 4
	ecall	# print "Actual: "
	lw	a0, saved_a1	# a0 <- test_arr_copy
	lw	a1, saved_a2	# a1 <- test_arr_len
	jal	max	# max
	li	a7, 1	# a7 = 1
	ecall	# print max

	# print newlines
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# === MIN ===
	# print header
	la	a0, min_str	# a0 <- "=== Min ==="
	li	a7, 4	# a7 = 4
	ecall	# print "=== Min ==="

	# print expected
	la	a0, expected	# a0 <- "Expected: "
	li	a7, 4	# a7 = 4
	ecall	# print "Expected: "
	lw	a0, min_expected	# a0 <- min_expected
	li	a7, 1	# a7 = 1
	ecall	# print min_expected

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print actual
	la	a0, actual	# a0 <- "Actual: "
	li	a7, 4	# a7 = 4
	ecall	# print "Actual: "
	lw	a0, saved_a1	# a0 <- test_arr_copy
	lw	a1, saved_a2	# a1 <- test_arr_len
	jal	min	# min
	li	a7, 1	# a7 = 1
	ecall	# print min

	# print newlines
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# === MAX RANGE ===
	# print header
	la	a0, max_range_str	# a0 <- "=== Max Range ==="
	li	a7, 4	# a7 = 4
	ecall	# print "=== Max Range ==="

	# print expected
	la	a0, expected	# a0 <- "Expected: "
	li	a7, 4	# a7 = 4
	ecall	# print "Expected: "
	lw	a0, max_range_expected	# a0 <- max_range_expected
	li	a7, 1	# a7 = 1
	ecall	# print max_range_expected

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print actual
	la	a0, actual	# a0 <- "Actual: "
	li	a7, 4	# a7 = 4
	ecall	# print "Actual: "
	lw	a0, saved_a1	# a0 <- test_arr_copy
	lw	a1, saved_a2	# a1 <- test_arr_len
	jal	max_range	# max_range
	li	a7, 1	# a7 = 1
	ecall	# print max_range

	# print newlines
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# === SEPARATOR POSITION ===
	# print header
	la	a0, sep_pos_str	# a0 <- "=== Separator Position ==="
	li	a7, 4	# a7 = 4
	ecall	# print "=== Separator Position ==="

	# print expected
	la	a0, expected	# a0 <- "Expected: "
	li	a7, 4	# a7 = 4
	ecall	# print "Expected: "
	lw	a0, sep_pos_expected	# a0 <- sep_pos_expected
	li	a7, 1	# a7 = 1
	ecall	# print sep_pos_expected

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print actual
	la	a0, actual	# a0 <- "Actual: "
	li	a7, 4	# a7 = 4
	ecall	# print "Actual: "
	lw	a0, saved_a1	# a0 <- test_arr_copy
	lw	a1, saved_a2	# a1 <- test_arr_len
	jal	separator_pos	# separator_pos
	li	a7, 1	# a7 = 1
	ecall	# print separator_pos
	
	# print newlines
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# === BAR HEIGHT ===
	# print header
	la	a0, bar_height_str	# a0 <- "=== Bar Height ==="
	li	a7, 4	# a7 = 4
	ecall	# print "=== Bar Height ==="

	# print target element
	la	a0, target_element_str	# a0 <- "Target Element: "
	li	a7, 4	# a7 = 4
	ecall	# print "Target Element: "
	lw	a0, target_element	# a0 <- target_element
	li	a7, 1	# a7 = 1
	ecall	# print target_element

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print expected
	la	a0, expected	# a0 <- "Expected: "
	li	a7, 4	# a7 = 4
	ecall	# print "Expected: "
	lw	a0, bar_height_expected	# a0 <- bar_height_expected
	li	a7, 1	# a7 = 1
	ecall	# print bar_height_expected

	# print newline
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# print actual
	la	a0, actual	# a0 <- "Actual: "
	li	a7, 4	# a7 = 4
	ecall	# print "Actual: "
	lw	a0, saved_a1	# a0 <- test_arr_copy
	lw	a1, saved_a2	# a1 <- test_arr_len
	lw	a2, target_element	# a2 <- target_element
	jal	bar_height	# bar_height
	li	a7, 1	# a7 = 1
	ecall	# print bar_height

	# print newlines
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"
	la	a0, newline	# a0 <- "\n"
	li	a7, 4	# a7 = 4
	ecall	# print "\n"

	# load ra
	lw	ra, saved_ra	# restore return address

	ret


#---------------------------------------------------------------------------------------------
# print_test_array
# 
# Description:
# 	Prints the contents of an array in a0.
#---------------------------------------------------------------------------------------------
print_test_array:
	addi	sp, sp, -20	# allocate stack space
	sw	ra, 16(sp)	# save return address
	sw	s0, 12(sp)	# save s0
	sw	s1, 8(sp)	# save s1
	sw	s2, 4(sp)	# save s2
	sw	s3, 0(sp)	# save s3

	# save arguments
	mv	s0, a0	# s0 <- array
	mv	s1, a1	# s1 <- array length

	# print [
	la a0, lbracket	# s0 <- "["
	li a7, 4	# a7 = 4
	ecall
	
	# print test_arr
	li	s2, 0	# s2 <- 0
	bge	s2, s1, print_test_array_end	# if s2 >= s1, goto print_test_array_end
	print_test_array_loop:
		# print test_arr[i]
		slli	s3, s2, 2	# s3 <- i * 4
		add	s4, s0, s3	# s4 <- test_arr + i * 4
		lw	a0, 0(s4)	# a0 <- test_arr[i]
		li	a7, 1	# a7 = 1
		ecall

		addi	s2, s2, 1	# i++
		bge	s2, s1, print_test_array_end	# if s2 >= s1, goto print_test_array_end

		# print ", "
		la	a0, comma	# a0 <- ", "
		li	a7, 4	# a7 = 4
		ecall

		j	print_test_array_loop

	print_test_array_end:

	# print ]
	la a0, rbracket	# s0 <- "]"
	li a7, 4	# a7 = 4
	ecall

	lw	ra, 16(sp)	# restore return address
	lw	s0, 12(sp)	# restore s0
	lw	s1, 8(sp)	# restore s1
	lw	s2, 4(sp)	# restore s2
	lw	s3, 0(sp)	# restore s3
	addi	sp, sp, 20	# deallocate stack space

	ret

# include the student's functions
.include	"./visualizer.s"
