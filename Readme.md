# This is a repository for my internship in UPV
---
## My mission is to design a processor of RISC-V. So VHDL is necessary for me.


### Here I record some of the abstract of meeting

#### 29/03/2023 
		--time values
		--read delay(time) /= 0 then
				-- if (read_delay /= 0 ns) then
				--     ouput <= value; -- regular assignment
				-- else
				--     ouput <= value after read_delay; -- delayed assignment
				-- end if;
				--prop_delay to all the source

#### 31/03/2023
	-- read risc-V standard
	-- get a list of operations in calculation units
	-- rv32I chapter 2
#### 04/04/2023
	--Continue to read the document and comparer with Paco's risc-V summary to tell what calculation is need for every operation? 
	--These commandes, which may use ALU to calculate?
	--What is the ALU operation for each commande who need ALU?
	--What if the input data length is different from 32-bits? (EEI?)(Not for ALU but other)
	--What if comparer a unsigned with a signed?(BLT / BLTU)
	--jump (pc+4), how to know it? 
	--FENCE instruction
	--Maybe write a list like Paco's by reading the PDF.
#### 27/04/2023
	-- create a test bench for alu first
	-- the test bench should use record and array to verify the result of alu
	-- it will be many differents situations
	-- computer can calculate the result
	-- comparer the result with alu result 
	-- the test bench will run automatically and reply a error or a message of finish.	
#### 23/05/2023
	-- Make more test for alu test
	-- To generate the exact place of the error by function
	-- Show the wrong result and the correct one
	-- Be awared that test the extreme circustance
	-- The memory interface should start after the alu, with the pdf and the instruction in mail.