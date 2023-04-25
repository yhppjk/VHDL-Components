----------------------------------------------------------
--! @file mux4togen
--! @mux 4 to generic 
-- Filename: mux4togen.vhd
-- Description: mux 4 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023

--	A 4:1 MUX "mux2ALU" selects between the values of rs2 from the register file, the I-immediate, the U-immediate, and the J-immediate as the 32-bit ALU input operand2.
--		Selection "sel2ALU" is 2 bits: 0 (default) to select rs2, 1 to select I-immediate, 2 to select J-immediate, and 3 to select U-immediate
--			a) Select I-immediate for ADDI, SLTI, SLTIU, ANDI, ORI, XORI, SLLI, SRLI, SRAI, and LOAD: instructions with opcodes OP-IMM or LOAD
--			b) Select U-immediate for AUIPC, LUI: instructions with opcodes AUIPC or LUI
--			c) Select S-immediate for STORE: instructions with opcode STORE
--			d) Select rs2 (default) for all other instructions: ADD, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA, SUB, JALR (operand2 unused), JAL (operand2 unused), BEQ, BNE, BLT, BGE, BLTU, BGEU




----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 4 to 1 entity description

--! Detailed description of this
--! mux 4 to generic design element.
ENTITY mux4togen IS
	GENERIC (
		width: INTEGER :=4;
		prop_delay : time := 0 ns		--! prop delay
);
	
	PORT (
		din0 :  IN	std_logic_vector(width-1 downto 0);	--! input 0 of mux
		din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
		din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
		din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
		sel	:	IN std_logic_vector(1 downto 0) := "00";		--! selection of mux
		dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);
END ENTITY mux4togen;

--! @brief Architecture definition of mux4togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux4togen IS

	constant MUX2_I : std_logic_vector(1 downto 0) := "01";	--! constant of mux2 selection I-immediate
	constant MUX2_U : std_logic_vector(1 downto 0) := "11";	--! constant of mux2 selection U-immediate
	constant MUX2_J : std_logic_vector(1 downto 0) := "10";	--! constant of mux2 selection S-immediate
	constant MUX2_rs2 : std_logic_vector(1 downto 0) := "00";	--! constant of mux2 selection rs2
BEGIN
	no_delay: if prop_delay = 0 ns generate
		PROCESS(din1,din2,din3,din0,sel) is
		BEGIN
			case(sel) is 
			when "00" =>
				dout <= din0;
			when "01" =>
				dout <= din1;
			when "10" =>
				dout <= din2;
			when "11" =>
				dout <= din3;
			when others =>
				dout <= (others => 'X');
			end case;
		END PROCESS;
	end generate no_delay;

	with_delay:	if prop_delay /= 0 ns generate
		PROCESS(din1,din2,din3,din0,sel) is
		BEGIN
			case(sel) is 
			when "00" =>
				dout <= din0 after prop_delay;
			when "01" =>
				dout <= din1 after prop_delay;
			when "10" =>
				dout <= din2 after prop_delay;
			when "11" =>
				dout <= din3 after prop_delay;
			when others =>
				dout <= (others => 'X') after prop_delay;
			end case;
		END PROCESS;
	end generate with_delay;
END ARCHITECTURE Behavioral;