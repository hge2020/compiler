#  
#  COMMIT (Compiler & Micro-architecture)
#

.text
.align 4


	la   sp, stack
	j				main
.space 0x00000050

.data
.align 4
stack: