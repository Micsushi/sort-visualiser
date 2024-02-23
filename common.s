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
# Sorting Algorithm Visualizer
#
# Author: Farel Nicholas Adrian Lukas
# Date: May 24, 2023
#
# Performs an insertion sort on an array of numbers and visualizes the 
# sorting process using GLIR.
#-------------------------------
#

.include	"./GLIR.s"


.data
_EXIT:          .word 10

.align 2
screenRows:	.word 42	# This is the number of rows the GLIR terminal will have


.text
#---------------------------------------------------------------------------------------------
# main
# 
# Description:
# 	This is the main function of the program.
#---------------------------------------------------------------------------------------------
main:
	# Start the GLIR terminal
	lw	a0, screenRows	# rows
	lw	a1, lenArray	# cols
	jal	GLIR_Start
	
	# Run the visualizer
	la	a0, numArray	# a0 <- address of numArray
	lw	a1, lenArray	# a1 <- lenArray
	jal	visualize_sort
	
	# End the GLIR terminal
	jal	GLIR_End
	
	# Exit program
	lw	a7, _EXIT
	ecall
