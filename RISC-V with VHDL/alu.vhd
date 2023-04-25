----------------------------------------------------------
--! @file alu
--! @A alu for calculation 
-- Filename: alu.vhd
-- Description: A alu 
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! alu entity description

--! Detailed description of this
--! alu design element.

entity alu is 
	generic(
	selopbits : positive := 4;
	flagbits : positive := 6
	);
	port(
	--INPUTS
	op1 : in std_logic_vector(31 downto 0);
	op2 : in std_logic_vector(31 downto 0);
	selop : in std_logic_vector(selopbits-1 downto 0);
	--OUTPUTS
	res : out std_logic_vector(31 downto 0);
	flags : out std_logic
	);
end entity alu;
	


architecture behavioral of alu is
	constant	ALU_ADD : std_logic_vector(selopbits-1 downto 0) := "0000";
	constant	ALU_SUB : std_logic_vector(selopbits-1 downto 0) := "0001";
	constant ALU_SLL : std_logic_vector(selopbits-1 downto 0) := "0010";
	constant ALU_SRL : std_logic_vector(selopbits-1 downto 0) := "0011";
	constant ALU_SRA : std_logic_vector(selopbits-1 downto 0) := "0100";
	constant ALU_AND : std_logic_vector(selopbits-1 downto 0) := "0101";
	constant ALU_OR  : std_logic_vector(selopbits-1 downto 0) := "0110";
	constant ALU_XOR : std_logic_vector(selopbits-1 downto 0) := "0111";
	constant ALU_JAL : std_logic_vector(selopbits-1 downto 0) := "1000";
	constant ALU_LUI : std_logic_vector(selopbits-1 downto 0) := "1001";
	constant ALU_BEQ : std_logic_vector(selopbits-1 downto 0) := "1010";
	constant ALU_SLTI: std_logic_vector(selopbits-1 downto 0) := "1011";
	constant ALU_SLTIU : std_logic_vector(selopbits-1 downto 0) :="1100";
	
	

begin
process(op1, op2, selop)
begin

end process;




end architecture behavioral;


