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
	flags : out std_logic_vector(Fbits-1 downto 0)
	);
end entity alu;
	

architecture behavioral of alu is
	constant ALU_ADD : std_logic_vector(selopbits-1 downto 0) := "0000";
	constant ALU_SUB : std_logic_vector(selopbits-1 downto 0) := "0001";
	constant ALU_SLL : std_logic_vector(selopbits-1 downto 0) := "0010";
	constant ALU_SRL : std_logic_vector(selopbits-1 downto 0) := "0011";
	constant ALU_SRA : std_logic_vector(selopbits-1 downto 0) := "0100";
	constant ALU_AND : std_logic_vector(selopbits-1 downto 0) := "0101";
	constant ALU_OR  : std_logic_vector(selopbits-1 downto 0) := "0110";
	constant ALU_XOR : std_logic_vector(selopbits-1 downto 0) := "0111";
	constant ALU_BEQ : std_logic_vector(selopbits-1 downto 0) := "1000";
	constant ALU_BLT : std_logic_vector(selopbits-1 downto 0) := "1001";
	constant ALU_BLTU : std_logic_vector(selopbits-1 downto 0) := "1010";
	constant ALU_SLT: std_logic_vector(selopbits-1 downto 0) := "1011";
	constant ALU_SLTU : std_logic_vector(selopbits-1 downto 0) :="1100";
	
	constant ALU_LOAD : std_logic_vector(selopbits-1 downto 0) := "1101";
	constant ALU_STORE : std_logic_vector(selopbits-1 downto 0) := "1110";
	
	constant ALU_JAL : std_logic_vector(selopbits-1 downto 0) :="1111";
	
	signal result : integer;
begin
process(op1, op2, selop)
begin

case selop is
	when ALU_ADD =>
		res <= op1+op2;
	when ALU_SUB =>
		result <= to_integer(signed(op1))-to_integer(signed(op2));
		res = std_logic_vector(to_signed(result));
	when ALU_SLL =>
		res <= op1<<op2[4:0];
	when ALU_SRL =>
		res <= op1>>op2[4:0];
	when ALU_SRA =>
		res <= op1>>*op2[4:0];
	when ALU_AND =>
		res <= op1&op2;
	when ALU_OR =>
		res <= op1|op2;
	when ALU_XOR =>
		res <= op1^op;
	when ALU_BEQ =>
		if to_integer(signed(op1))-to_integer(signed(op2)) > 0 then
			flag = '1';
		else 
			flag = '0';	
		end if;
	when ALU_BLT =>
		if to_integer(signed(op1))-to_integer(signed(op2)) > 0 then
			flag ='1';
		else 
			flag = '0';
		end if;
	when ALU_BLTU =>
		if to_integer(unsigned(op1))-to_integer(unsigned(op2)) > 0 then
			flag ='1';
		else 
			flag = '0';
		end if;	
	when ALU_SLT =>
		result = to_integer(signed(op1))-to_integer(signed(op2));
		res = std_logic_vector(to_signed(result));
	when ALU_SLTU =>
		result = to_integer(unsigned(op1))-to_integer(unsigned(op2));	
		res = std_logic_vector(to_unsigned(result));

	when ALU_LOAD =>
		res = op1+op2;
	when ALU_STORE =>
		res = op1+op2;
			
		
		
	when ALU_JAL =>
		res <= op1;
	when ALU_
end process;




end architecture behavioral;


