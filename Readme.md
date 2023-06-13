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
##### memory interface guideline
	--Section 2.2 "Read transfers", Figure 2-3
	--at T2 edge the memory interface detects the CPU transaction request  
	--(Address is ADDR1, read because PWRITE=0, PENABLE=0 because is the  
	--first clock of the transfer); in the following clock cycles the CPU's  
	--memory interface
	--maintains values for address, PWRITE, but change PENABLE = 1.
	--   at T3 edge the memory device answers with the data DATA1 and  
	--PREADY=1 (meaning last clock cycle of transfer)
	--
	--
	--Section 2.2 "Read transfers", Figure 2-4 is the same, but the memory  
	--device inserts two wait states (edges T3 and T4)
	--by saying PREADY = 0 ("I'm not ready, please wait), and provide the  
	--requested value ar T5 saying PREADY = 1
	--("Here's the value you requested, transfer ended")
	--
	--Tests: A combination of operation (read/write which means rd_i=1, wr_i  
	--= 0 / rd_i = 0, wr_i = 1), a few addresses, size 00/01/10/11,  
	--signed/unsigned 0/1, with a memory device answering with 0/1/2 wait  
	--states. The memory device must answer
	--the read value with some known value (eg. 0000...000 when not  
	--answering a read, 1010...1010 when answering a read).
	--In isolation (with several clock cycles with no transfers between one  
	--transfer and the next one) and with no
	--"space" between two consecutive transfers.
#### 26/05/2023
	-- alu assert the calculation. the op1, op2, operation, and correct result.
	-- CPU interface Programming
#### 31/05/2023
	-- mock is not a register but a reaction element to show the right reaction wave in the modelsim
	-- create 2 signal to modify the num_wait and dataread
	
	-- create some block to reuse (register and mux)
	-- Maybe, the interface is a combination block, with some small blocks
	-- the sensitivity list should be the signals input.
	-- 
#### 02/06/2023
	-- seperate the FSM in to 2 different block, one for switch state, one for give value in different state
	-- verify the signal PSEL, PENABLE, PREADY by using assert in different position.
	
#### 02/06/2023	
	-- do a procedure to isolate the value change for the Address, unsigned, dataread, etc.
	-- do a list (like ALU_pkg) which contains all the test statement(and the correct result)
	-- now it is the test for the case of 32-bit, so it names test_rd32_transfer. After this, there will have rd16, rd8.
	-- not sure about how a procedure fonctionne 
		procedure test_rd32_transfer (
			constant addr_val: std_logic_vector(29 downto 0);
			constant size_val: std_logic_vector(1 downto 0);
			constant unsigned_val : std_logic;
			constant numwait_val : integer;
			constant wdata_val : std_logic_vector(31 downto 0);
			constant dataread_val : std_logic_vector(31 downto 0)
		);
		begin
			rd_i <= '1';
			wr_i <= '0';
			size_i <= size_val;
			
			addr_i <= addr_val;
			unsigned_i <= unsigned_val;
			num_wait <= numwait_val;
			
			wdata_i <= wdata_val;
			dataread <= dataread_val;
			
			wait until rising_edge(tb_clk) and testing = '1';
			--wait until rising_edge(tb_clk) and testing = '0';
			for i in 0 to num_wait loop
				wait until rising_edge(tb_clk);
			end loop;
		end procedure test_rd32_transfer;
		
#### 09/06/2023
	-- check PSTRB as how to check PADDR √
	-- able to check if the operation need 2 step or 1 step (unaligned?)
	-- check PREQ / PSEL √
	-- check byte lane(if the PSTRB will change this byte lane)
	-- when the interface is doing a read transfer, the PSTRB must be low √
	
	for every byte lane, at each transfer:
	assert not(byte lane is relevant(need calculation))   or  (PWDATA's Actual byte lane value  =  PWDATA's Expected byte lane value(need calculation))
		report" ..... "
		severity warning