
#
#---------------------------------------------------------------
# CCID: wenjian2                 
# Lecture Section:      
# Instructor: Nelson Amaral           
# Lab Section:          
# Teaching Assistant:   
#---------------------------------------------------------------
# 

#---------------------------------------------------------------
# GLOBAL VARIABLES FOR TESTING
# 
# IMPORTANT: 
# 	- You may not define any additional global variables
# 	- You may change the initial values of the global variables
# 	  below only to test your program
# 	- You may not, at any point in your code, load the address
# 	  or value of any global variable, for example, using the
# 	  la or lw instructions on any of the global variables
# 	- For example, do not do `la t0, numArray` or 
# 	  `lw t0, lenArray` 
#---------------------------------------------------------------
.data
.align 2
 numArray:	.word 1, 2, 3, 4, -5, 6, -7, 8, -9, 10,2,4,6,-2,5,-10,2,4,1,-1	# This is the array of numbers to sort
# numArray:	.word -3,-2,-4,-5,-1,-8,-9,-6,-7,-1	# This is the array of numbers to sort
# numArray:	.word 1,2,3,4,5,7,-9,10,8,6	# This is the array of numbers to sort
lenArray:	.word 20	# This is the number of elements in the array
.include "./common.s"

.text
#---------------------------------------------------------------------------------------------
# visualize_sort
#
# Description:
# 	Sorts the array of numbers and draws the sorting process on the terminal
#
# Arguments:
# 	a0: the address of the array to sort
# 	a1: the number of elements in the array
#
# Return Value:
# 	none
#
# Register Usage:
# s0: array
# s1: num elements in array
# s2: outer loop counter (i)
# s3: key (arr[i])
# s4: inner loop counter (j)
# s5: temp (arr[j])
#---------------------------------------------------------------------------------------------
visualize_sort:

   	addi sp, sp, -24  # Decrease stack pointer by 24
    sw ra, 0(sp)  # Save return address on stack
    sw s0, 4(sp)  # Save s0 on stack
    sw s1, 8(sp)  # Save s1 on stack
    sw s2, 12(sp)  # Save s2 on stack
    sw s3, 16(sp)  # Save s3 on stack
    sw s4, 20(sp)  # Save s4 on stack
    sw s5, 24(sp)  # Load s5 from stack

    mv s0, a0  # s0 = a0(array address)
    mv s1, a1  # s1 = a1(num elements in array)
    li s2, 1  # Initialize outer loop counter (i) to 1
    # Insertion sort
    sort_outer_loop:
        bge s2, s1, end_outer_loop  # If outer loop counter < num elements in array, go to end_outer_loop
        slli t0, s2, 2  # Multiply outer loop counter by 4
        add t0, s0, t0  # t0 = &arr[i]
        lw s3, 0(t0)  # s3 = key (arr[i])
        addi s4, s2, -1  # s4 = inner loop counter (j)
        
        # draw index of key highlighted (s2)
        mv a0, s0  # Move array address to a0
        mv a1, s1  # Move num elements in array to a1
        mv a2, s2  # Move index of key to a2
        jal ra, draw  # Call draw function with a0(array), a1(num elements in array), and a2(index of key)
        li t0, 500000  # Set delay count
        delay_loop:
            addi t0, t0, -1  # Decrement delay count
            bnez t0, delay_loop  # If delay count is not zero, continue the loop


        sort_inner_loop:
            #while (j >= 0 && arr[j] > key)
            bltz s4, end_inner_loop  # If inner loop counter < 0, go to end_inner_loop
            slli t1, s4, 2  # Multiply inner loop counter by 4
            add t1, s0, t1  # t1 = &arr[j]
            lw s5, 0(t1)  # t2 = arr[j]
            blt s5, s3, end_inner_loop  # If arr[j] < arr[i], go to end_inner_loop

            # Shifting Right
            addi t1, t1, 4  # t1 = &arr[j + 1]
            sw s5, 0(t1)  # arr[j + 1] = arr[j]
            addi s4, s4, -1  # j--
            j sort_inner_loop

        end_inner_loop:
            # Insertion into sorted spot
            slli t1, s4, 2  # Multiply inner loop counter by 4
            add t1, s0, t1  # t1 = &arr[j]
            addi t1, t1, 4  # t1 = &arr[j + 1]
            sw s3, 0(t1)  # arr[j + 1] = arr[i]
            addi s2, s2, 1  # i++

            #draw with index of j+1 highlighted (s4+1)
            mv a0, s0  # Move array address to a0
            mv a1, s1  # Move num elements in array to a1
            addi a2, s4, 1  # Move index of j+1 to a2
            jal ra, draw  # Call draw function with a0(array), a1(num elements in array), and a2(index of key)
            li t0, 500000  # Set delay count
            delay_loop2:
                addi t0, t0, -1  # Decrement delay count
                bnez t0, delay_loop2  # If delay count is not zero, continue the loop

            j sort_outer_loop

    end_outer_loop:
        lw s5, 24(sp)  # Load s5 from stack
	 	lw s4, 20(sp)  # Load s4 from stack
        lw s3, 16(sp)  # Load s3 from stack
        lw s2, 12(sp)  # Load s2 from stack
        lw s1, 8(sp)  # Load s1 from stack
		lw s0, 4(sp)  # Load s0 from stack
        lw ra, 0(sp)  # Load ra from stack
        addi sp, sp, 28  # Increase stack pointer by 24
        jalr zero, ra, 0     # return

#---------------------------------------------------------------------------------------------
# max
#
# Description:
# 	Returns the maximum value in the array
#
# Arguments:
# 	a0: the address of the array
# 	a1: the number of elements in the array
#
# Return Value:
# 	a0: the maximum value in the array
#
# Register Usage:
# t0: current element
# t1: start pointer
# a0: current max
# a1: end pointer
#---------------------------------------------------------------------------------------------
max:
    beqz a1, exit_max # if num of elements is 0, exit 

    mv t1, a0  # start pointer
    lw a0, 0(t1)  # current max
    lw t0, 0(t1)  # current element
    slli a1, a1, 2  # size of array in bytes
    add a1, t1, a1  # add to start pointer

    max_loop:
        beq t1, a1, exit_max  # if start pointer equals end pointer, exit
        bgt t0, a0, new_max # if current element is greater than current max, update max
        addi t1, t1, 4  # increment start pointer
        lw t0, 0(t1)  # load next element
        j max_loop 

    new_max:
        mv a0, t0  # update max
        j max_loop

    exit_max:
        jalr	zero, ra, 0
#---------------------------------------------------------------------------------------------
# min
#
# Description:
# 	Returns the minimum value in the array
#
# Arguments:
# 	a0: the address of the array
# 	a1: the number of elements in the array
#
# Return Value:
# 	a0: the minimum value in the array
#
# Register Usage:
# t0: current element
# t1: start pointer
# a0: current min
# a1: end pointer
#---------------------------------------------------------------------------------------------
min:
    beqz a1, exit_min # if num of elements is 0, exit 

    mv t1, a0  # start pointer
    lw a0, 0(t1)  # current min
    lw t6, 0(t1)  # current element
    slli a1, a1, 2  # size of array in bytes
    add a1, t1, a1  # add to start pointer

    min_loop:
        beq t1, a1, exit_min  # if start pointer equals end pointer, exit
        blt t6, a0, new_min # if current element is less than current min, update min
        addi t1, t1, 4  # increment start pointer
        lw t6, 0(t1)  # load next element
        j min_loop 

    new_min:
        mv a0, t6  # update min
        j min_loop

    exit_min:
        jalr	zero, ra, 0  # return

#---------------------------------------------------------------------------------------------
# max_range
#
# Description:
# 	Finds the maximum range possible for the array of numbers with zero bounds
# 	max_range = max(range(a), max(a)-0, 0-min(a)), where a is the array of numbers
#
# Arguments:
# 	a0: the address of the array
# 	a1: the number of elements in the array
#
# Return Value:
# 	a0: the maximum range for the array
#
# Register Usage:
# s0: start of array
# s1: num elements in array
# s2: max
# s3: min
#---------------------------------------------------------------------------------------------
max_range:
 	# Increase stack and Save return address
    addi sp, sp, -20 # Adjust sp
    sw ra, 0(sp) # Save ra into stack
    sw s0, 4(sp) # Save s0 into stack
    sw s1, 8(sp) # Save s1 into stack
    sw s2, 12(sp) # Save s2 into stack
    sw s3, 16(sp) # Save s3 into stack

	# save a0 and a1
    mv s0, a0 # s0 = a0
    mv s1, a1 # s1 = a1

	# Call max
    jal ra, max # Call max function with a0(array) and a1(num elements in array)
    mv s2, a0 # s2 = max

	# Call min
	mv a0, s0 # a0 = s0(array)
    mv a1, s1 # a1 = s1(num elements in array)
    jal ra, min # Call min function with a0(array) and a1(num elements in array)
    mv s3, a0 # s3 = min

	# Check if max and min are positive or negative
    bltz s2, max_negative # If max is negative, go to max_negative
	bltz s3, min_negative # If min is negative, go to min_negative

	# max and min are positive
    mv a0, s2 # max range = max
    j max_range_exit

    max_negative:
		# max is negative, min is also negative
        mv a0, s3 # max range = min
        not a0, s3 # max range = ~min
        addi a0, a0, 1  # max range = abs(min)
		j max_range_exit

    min_negative:
		# min is negative, max is positive
        sub a0, s2, s3 # max range = max - min

	# Restore stack
    max_range_exit:
        lw s3, 16(sp) # Load s3 from stack
        lw s2, 12(sp) # Load s2 from stack
        lw s1, 8(sp) # Load s1 from stack
        lw s0, 4(sp) # Load s0 from stack
        lw ra, 0(sp) # Load ra from stack
        addi sp, sp, 20 # Adjust sp
    	jalr	zero, ra, 0 



#---------------------------------------------------------------------------------------------
# separator_pos
#
# Description:
# 	Computes where the separator should be placed on the screen
#
# Arguments:
# 	a0: the address of the array
# 	a1: the number of elements in the array
#
# Return Value:
# 	a0: the position of the separator
#
# Register Usage:
# t1: calculations
# s0: start of array
# s1: num elements in array
# s2: max_range
# s3: max
#---------------------------------------------------------------------------------------------
separator_pos:
	addi sp, sp, -20 # Adjust sp
	sw ra, 0(sp) # Save ra into stack
	sw s0, 4(sp) # Save s0 into stack
	sw s1, 8(sp) # Save s1 into stack
	sw s2, 12(sp) # Save s2 into stack
	sw s3, 16(sp) # Save s3 into stack

	# Initialize Variables
    mv s0, a0 # s0 = a0(array)
    mv s1, a1 # s1 = a1(num elements in array)

	# Call max_range
    jal ra, max_range # Call max_range with a0(array) and a1(num of elements in array)
    mv s2, a0 # s2 = a0(max_range)

	# Call max
    mv a0, s0 # a0 = s0(array)
    mv a1, s1 # a1 = s1(num elements in array)
    jal ra, max # Call max with a0(array) and a1(num of elements in array)
    mv s3, a0 # s3 = a0(max)

    bltz s3, max_position # If max is negative, go to max_position
    j separator_formula # Else go to separator_formula

	# max is negative
	max_position:
		li s3, 0 # max = 0

	separator_formula:
		li t1, 40 # t1 = r-2
		mul t1, t1, s3 # t1 = (r-2) * max
		div a0, t1, s2 # a0 = (r-2) * max / max_range

		# Restore stack
		lw s3, 16(sp) # Load s3 from stack
		lw s2, 12(sp) # Load s2 from stack
		lw s1, 8(sp) # Load s1 from stack
		lw s0, 4(sp) # Load s0 from stack
		lw ra, 0(sp) # Load ra from stack
		addi sp, sp, 20 # Adjust sp
		jalr	zero, ra, 0	# return



#---------------------------------------------------------------------------------------------
# bar_height
#
# Description:
# 	Computes the height of the bar for the given number
#
# Arguments:
# 	a0: the address of the array
# 	a1: the number of elements in the array
# 	a2: the number to compute the bar height for
#
# Return Value:
# 	a0: the height of the bar
#
# Register Usage:
# t1: calculations
# s0: start of array
# s1: num elements in array
# s2: number
# s3: max_range
#---------------------------------------------------------------------------------------------
bar_height:
    addi sp, sp, -20 # Adjust sp
    sw ra, 0(sp) # Save ra into stack
    sw s0, 4(sp) # Save s0 into stack
    sw s1, 8(sp) # Save s1 into stack
    sw s2, 12(sp) # Save s2 into stack
    sw s3, 16(sp) # Save s3 into stack

    # Initialize Variables
    mv s0, a0 # s0 = a0(array)
    mv s1, a1 # s1 = a1(num elements in array)
    mv s2, a2 # s2 = a2(number)

    # Call max_range
    jal ra, max_range # Call max_range with a0(array) and a1(num of elements in array)
    mv s3, a0 # s3 = a0(max_range)

    # Calculate bar height
    li t1, 40 # t1 = r-2
    mul t1, t1, s2 # t1 = (r-2) * number
    div a0, t1, s3 # a0 = (r-2) * number / max_range

    # Restore stack
    lw s3, 16(sp) # Load s3 from stack
    lw s2, 12(sp) # Load s2 from stack
    lw s1, 8(sp) # Load s1 from stack
    lw s0, 4(sp) # Load s0 from stack
    lw ra, 0(sp) # Load ra from stack
    addi sp, sp, 20 # Adjust sp
    jalr zero, ra, 0 # return
#---------------------------------------------------------------------------------------------
# draw
#
# Description:
# 	Draws the array of numbers onto the terminal, 
# 	taking into account the separator and relative bar heights
#
# Arguments:
# 	a0: the address of the array to draw
# 	a1: the number of elements in the array
# 	a2: the index of element to be highlighted
#
# Return Value:
# 	none
#
# Register Usage:
# s0: array
# s1: num elements in array
# s2: index of element to be highlighted
# s3: current index
# s4: separator position
# s5: bar height
#
#---------------------------------------------------------------------------------------------
draw:
   	addi sp, sp, -28  # Decrease stack pointer by 24
    sw ra, 0(sp)  # Save return address on stack
    sw s0, 4(sp)  # Save s0 on stack
    sw s1, 8(sp)  # Save s1 on stack
    sw s2, 12(sp)  # Save s2 on stack
    sw s3, 16(sp)  # Save s3 on stack
    sw s4, 20(sp)  # Save s4 on stack
    sw s5, 24(sp)  # Load s5 from stack

    mv s0, a0  # s0 = a0(array address)
    mv s1, a1  # s1 = a1(num elements in array)
    mv s2, a2  # s2 = a2(index of element to be highlighted)
    li s3, 0  # Initialize index of current element to 0

	# 1)Get separator position
    jal ra, separator_pos  # Call separator_pos function
    mv s4, a0  # Move separator position to s4

    draw_loop:
        bge s3, s1, draw_exit  # If current index >= number of elements, exit loop

		# 2.1)Get bar height
        mv a0, s0 # Move array address to a0
        mv a1, s1 # Move num elements in array to a1
        slli t0, s3, 2  # Multiply current index by 4
        add t0, t0, s0  # Add current index to array pointer
        lw a2, 0(t0)  # Load current element into a2
        jal ra, bar_height  #Call bar_height function with a0(array), a1(num elements in array), and a2(current element)
        mv s5, a0  # Move bar height to s5

		# 2.2)Set color
		slli t0, s3, 2  # Multiply current index by 4
        add t0, t0, s0  # Add current index to array pointer
        lw t0, 0(t0)  # Load current element into a2
        beq s2,s3, highlight  # If current index == highlighted index, jump to highlight
		bltz t0, red  # If current element < 0, jump to red
		li a3, 10  # Else, set color to green
		j draw_element  # Jump to draw_element
		red:
			li a3, 9  # Set color to red
			j draw_element  # Jump to draw_element
		# 3) Override color if highlighted
		highlight:
			li a3, 12  # Set color to blue

		# 4) Draw element
		draw_element:
			mv a0, s3  # Move current index to a0
			mv a1, s4  # Move separator position to a1
            sub a2, s4, s5  # Move bar height to a2			
            bgt a2, a1, increment_a1  # If a2 > a1, jump to increment_a1
            j continue  # Else, jump to continue
            increment_a1:
                addi a1, a1, 1  # Increment a1 by 1
            continue:
                jal ra, GLIR_PrintOVLine  # Call with a0(current index), a1(separator position),a2(bar height), and a3(color)
			addi s3, s3, 1  # Increment current index
			j draw_loop  # Jump to draw_loop

    draw_exit:
    	lw s5, 24(sp)  # Load s5 from stack
	 	lw s4, 20(sp)  # Load s4 from stack
        lw s3, 16(sp)  # Load s3 from stack
        lw s2, 12(sp)  # Load s2 from stack
        lw s1, 8(sp)  # Load s1 from stack
		lw s0, 4(sp)  # Load s0 from stack
        lw ra, 0(sp)  # Load ra from stack
        addi sp, sp, 28  # Increase stack pointer by 24
        jalr zero, ra, 0  # Return to caller
