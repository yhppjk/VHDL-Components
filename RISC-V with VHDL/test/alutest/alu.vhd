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
	flagbits : positive := 3
	);
	port(
	--INPUTS
	op1 : in std_logic_vector(31 downto 0);
	op2 : in std_logic_vector(31 downto 0);
	selop : in std_logic_vector(3 downto 0);
	--OUTPUTS
	res : out std_logic_vector(31 downto 0);
	flags : out std_logic_vector(flagbits-1 downto 0)
	);
end entity alu;
	

architecture behavioral of alu is
	constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
	constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
	constant ALU_SLL : std_logic_vector(3 downto 0) := "0010";
	constant ALU_SRL : std_logic_vector(3 downto 0) := "0011";
	constant ALU_SRA : std_logic_vector(3 downto 0) := "0100";
	constant ALU_AND : std_logic_vector(3 downto 0) := "0101";
	constant ALU_OR  : std_logic_vector(3 downto 0) := "0110";
	constant ALU_XOR : std_logic_vector(3 downto 0) := "0111";
	constant ALU_BEQ : std_logic_vector(3 downto 0) := "1000";
	constant ALU_BLT : std_logic_vector(3 downto 0) := "1001";
	constant ALU_BLTU : std_logic_vector(3 downto 0) := "1010";
	constant ALU_JAL : std_logic_vector(3 downto 0) := "1011";
	constant ALU_LUI : std_logic_vector(3 downto 0) := "1100";
	
	signal result : integer;
	signal local_selop : std_logic_vector(3 downto 0);
begin

process(op1, op2)
begin

	res <= (others => '0');
	flags <= (others => '0');

	case selop is
		when ALU_ADD =>
			res <= std_logic_vector(signed(op1) + signed(op2));
		when ALU_SUB =>
			res <= std_logic_vector(signed(op1)-signed(op2));
		when ALU_SLL =>
			res <= std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
		when ALU_SRL =>
			res <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
		when ALU_SRA =>
			res <= std_logic_vector(shift_right(signed(op1), to_integer(unsigned(op2(4 downto 0)))));		
		when ALU_AND =>
			res <= op1 and op2; 
		when ALU_OR =>
			res <= op1 or op2;
		when ALU_XOR =>	
			res <= op1 xor op2;
		when ALU_BEQ =>
			if to_integer(signed(op1))-to_integer(signed(op2)) = 0 then
				flags(0) <= '1';
			end if;
		when ALU_BLT =>
			if to_integer(signed(op1))-to_integer(signed(op2)) < 0 then
				flags(1) <='1';
			end if;
		when ALU_BLTU =>
			if to_integer(unsigned(op1))-to_integer(unsigned(op2)) < 0 then
				flags(2) <='1';
			end if;			
		when ALU_JAL =>
			res <= op1;
		when ALU_LUI => 
			res <= op2;
		when others =>
	end case;
end process;

end architecture behavioral;


