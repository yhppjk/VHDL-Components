#This datapath testbench has been checked 20/09/2023

## What is this?
This is the testbench of datapath, which is the biggest testbench in this projet.

## What are these files?

### Components
	1. ALU
	2. Interface
	3. Mux
	4. Program counter
	5. Register 
	6. Register file
	7. Write-to-PC
	8. Memory parts
	etc...

### Packages
	1. alu package
	2. memory parts packages
	3. interface package
	4. Register file package
	
### datapath testbench
	1. datapath 
	2. datapath_tb
	3. datapath package
	
## How it works?
#### Structure
	-- The datapath should connect to memory and Control Unit. 
	-- We have the memory part but without control Unit
	
#### Control Unit
	-- The signal changes of control unit should be simulated by a list to make the datapath react properly.
	-- With the signals provided by control unit, the alu will run and values will save or change.
	
#### The datapath_tb
	-- Assemble the datapath and memory parts
	-- Contain serval function and procedure will make run the test
	-- It will get the test cases from the list and run test automatically
	-- It can report if the test is pass, if the value is correct.

## How to use the testbench

#### rv32i-test1.s
	-- This is a assembler file provided by prof.
	-- It can translate the instructions by using makefile.
	-- use the ihexconv.exe to get the init value of apb_init_mem.
	
#### apb_init_mem_pkg.vhd
	-- This is the list of instructions
	-- It will give init value to Memory
	-- With these instructions, the datapath can run tests
	
#### testfile.txt	
	-- With different mnemonic, the testbench will give different CU signals
	-- As a result, the datapath will run different types of instructions
	-- This is a list for checking the result, address, PC value and flags
	-- It will check the result and destination for add and addi
	-- It will check flags and PC value for beq, bne, blt
	-- It will check PC value for jump.