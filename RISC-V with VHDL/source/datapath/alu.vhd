----------------------------------------------------------
--! @file alu
--! @A alu for calculation 
-- Filename: alu.vhd
-- Description: A alu  for calculation
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
	selopbits : positive := 4;		--! selop bit
	flagbits : positive := 3		--! flags bit
	);
	port(
	--INPUTS
	op1 : in std_logic_vector(31 downto 0);		--! 32-bit operand1
	op2 : in std_logic_vector(31 downto 0);		--! 32-bit operand2
	selop : in std_logic_vector(3 downto 0);	--! X-bit operation selection
	--OUTPUTS
	res : out std_logic_vector(31 downto 0) := (others => '0');	--! 32-bit result
	flags : out std_logic_vector(flagbits-1 downto 0) := (others => '0')	--! F-bit result of comparison for branch
	);
end entity alu;
	
--! @brief Architecture definition of alu
--! @details More details about this alu element.

architecture behavioral of alu is
	constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";		--! ADDITION operation
	constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";		--! SUBTRACTION operation
	constant ALU_SLL : std_logic_vector(3 downto 0) := "0010";		--!	SHIFT LEFT LOGICAL operation
	constant ALU_SRL : std_logic_vector(3 downto 0) := "0011";		--! SHIFT RIGHT LOGICAL operation
	constant ALU_SRA : std_logic_vector(3 downto 0) := "0100";		--! SHIFT RIGHT ARITHMETIC operation
	constant ALU_AND : std_logic_vector(3 downto 0) := "0101";		--! AND operation
	constant ALU_OR  : std_logic_vector(3 downto 0) := "0110";		--! OR operation
	constant ALU_XOR : std_logic_vector(3 downto 0) := "0111";		--! EXCLUSIVE OR operation
	constant ALU_BEQ : std_logic_vector(3 downto 0) := "1000";		--! BRANCH IF EQUAL operation
	constant ALU_BLT : std_logic_vector(3 downto 0) := "1001";		--! BRANCH IF LESS THAN operation
	constant ALU_BLTU : std_logic_vector(3 downto 0) := "1010";		--! BRANCH IF LESS THAN UNSIGNED operation
	constant ALU_JAL : std_logic_vector(3 downto 0) := "1011";		--! JUMP AND LINK operation
	constant ALU_LUI : std_logic_vector(3 downto 0) := "1100";		--! LOAD UPPER IMMEDIATE operation

	
begin

process(op1, op2, selop)
begin

	--! Initialization of output
	--res <= (others => '0');
	--flags <= (others => '0');

	--! Case for different selop, running different operation
	case selop is
		when ALU_ADD =>
			res <= std_logic_vector(signed(op1) + signed(op2));
		when ALU_SUB =>
			res <= std_logic_vector(signed(op1) - signed(op2));
		when ALU_SLL =>
			if to_integer(unsigned(op2)) < 32 then
				res <= std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2(31 downto 0)))));
			else 
				res <= (others =>'0');
			end if;
			
		when ALU_SRL =>
			if to_integer(unsigned(op2)) < 32 then
				res <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2(31 downto 0)))));
			else 
				res <= (others =>'0');
			end if;
			
		when ALU_SRA =>
			if to_integer(unsigned(op2)) < 32 then
				res <= std_logic_vector(shift_right(signed(op1), to_integer(unsigned(op2(31 downto 0)))));		
			else 
				if op1(31) ='1' then
					res <= (others => '1');
				else
					res <= (others => '0');
				end if;
			end if;
		when ALU_AND =>
			res <= op1 and op2;
		when ALU_OR =>
			res <= op1 or op2;
		when ALU_XOR =>	
			res <= op1 xor op2;
		--Should I do both beq and blt to adapt ble case?
		when ALU_BEQ =>
			flags(2) <= '0';
			flags(1) <= '0';
			if to_integer(signed(op1))-to_integer(signed(op2)) = 0 then
				flags(0) <= '1';
			else 
				flags(0) <= '0';
			end if;
			report "BEQ result, op1-op2 = "&integer'image(to_integer(signed(op1))-to_integer(signed(op2)));
		--problem here
		when ALU_BLT =>
			flags(2) <= '0';
			flags(0) <= '0';
			if to_integer(signed(op1))-to_integer(signed(op2)) < 0 then
				flags(1) <='1';
			else 
				flags(1) <='0';
			end if;
			report "BLT result, op1-op2 = "&integer'image(to_integer(signed(op1))-to_integer(signed(op2)));
		when ALU_BLTU =>
			flags(0) <= '0';
			flags(1) <= '0';
			if unsigned(op1) < unsigned(op2)  then
				flags(2) <='1';
			else 
				flags(2) <='0';
			end if;		
		when ALU_JAL =>
			res <= op1;
		when ALU_LUI => 
			res <= op2;
		when others =>
			null;
	end case;
	
end process;
end architecture behavioral;



