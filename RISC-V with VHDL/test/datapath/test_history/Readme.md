# This Folder has stored 4 test cases of datapath_tb

## 2 Addi, 3 Add, 1 BNE, 3 BLT

## 2 Addi, 3 Add, 1 BEQ, 3 BLT

## 2 Addi, 3 Add, 1 BNE, 1 BEQ, 3 BLT

## 2 Addi, 3 Add, 1 BEQ, 1 BNE, 3 BLT

#Each cases have 3 files
	-- rv32i-test1.s
		The original assembler code for creating list of instruction
	
	-- apb_init_mem_pkg.vhd
		The compiled and hexconv list of instruction
	
	-- testfile.txt
		The test cases, contained every instruction's type and result