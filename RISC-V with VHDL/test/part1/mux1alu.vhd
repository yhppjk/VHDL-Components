----------------------------------------------------------
--! @file mux2togen
--! @mux 2 to generic 
-- Filename: mux2togen.vhd
-- Description: mux 2 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023
--
--	A 2:1 MUX "mux1ALU" selects between the values of rs1 from the register file and the PC register as the 32-bit ALU input operand1.
--	Selection "sel1ALU" is 1 bit: 0 (default) to select rs1, 1 to select PC
--			a) Select PC for AUIPC, JALR, JAL: instructions with opcodes AUIPC, JALR, or JAL
--			b) Select rs1 (default) for all other instructions: ADDI, SLTI, SLTIU, ANDI, ORI, XORI, SLLI, SRLI, SRAI, LOAD, LUI (operand1 unused), ADD, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA, SUB, STORE, BEQ, BNE, BLT, BGE, BLTU, BGEU
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 2 to 1 entity description

--! Detailed description of this
--! mux 2 to generic design element.
ENTITY mux2togen IS
	GENERIC (
		width: INTEGER :=4;
		prop_delay : time := 0 ns		--! prop delay
);
	PORT (
		din0 :  IN  std_logic_vector(width-1 downto 0);	--! input 0 of mux
		din1 :  IN	std_logic_vector(width-1 downto 0);	--! input 1 of mux
		sel	:	IN std_logic :=0;							--! selection of mux
		dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);	
END ENTITY mux2togen;

--! @brief Architecture definition of mux2togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux2togen IS
	constant MUX1_PC : std_logic :='1';					--! constant of mux1 selection pc
	constant MUX1_rs1 : std_logic := '0';				--! constant of mux1 selection rs1

BEGIN
	no_delay: if prop_delay = 0 ns generate
	dout <= din0 when sel = MUX1_rs1 else din1;
	end generate no_delay;

	with_delay:	if prop_delay /= 0 ns generate
	dout <= din0 after prop_delay when sel = MUX1_rs1 else din1 after prop_delay;
	end generate with_delay;
END ARCHITECTURE Behavioral;