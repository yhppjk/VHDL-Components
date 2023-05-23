----------------------------------------------------------
--! @file alu_pkg
--! @A alu_pkg can combine multipal counter to count.
-- Filename: alu_pkg.vhd
-- Description: A alu_pkg can test the reaction of a register file.
-- Author: YIN Haoping
-- Date: March 27, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

--! alu_pkg package description

--! Detailed description of this
--! alu_pkg design element.
PACKAGE alu_pkg IS
--! alu_pkg package description

--! Detailed description of this
--! alu_pkg design element.
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
	
	function error_event (alu_code : std_logic_vector(3 downto 0) ) return string;
	
	function change_to_string(data : std_logic_vector) return string;

	type test_t is
	record
	  op1                         : std_logic_vector(31 downto 0);
	  op2                         : std_logic_vector(31 downto 0);
	  selop                       : std_logic_vector(3 downto 0);
	  exp_res                     : std_logic_vector(31 downto 0);
	  exp_flags                   : std_logic_vector(2 downto 0); -- (0) is EQ flag, (1) is LT flag, (2) is the LTU flag
	end record;
	type test_vectors_t is array (0 to 98) of test_t;

	CONSTANT vectors: test_vectors_t := (					--each selop shall have enough cases, 16 for exemple.
    -- 							op1                 op2                 		selop    			exp_res             exp_flags
	-- ADD
    -- Test case 1: Basic addition
    ("00000000000000000000000000000010", "00000000000000000000000000000001", ALU_ADD, "00000000000000000000000000000011", "000"),
    -- Test case 2: Result is zero
    ("00000000000000000000000000000001", "11111111111111111111111111111111", ALU_ADD, "00000000000000000000000000000000", "000"),
    -- Test case 3: Negative result
    ("00000000000000000000000000000001", "11111111111111111111111111111110", ALU_ADD, "11111111111111111111111111111111", "000"),
    -- Test case 4: Positive overflow, result is negative
    ("01111111111111111111111111111111", "01111111111111111111111111111111", ALU_ADD, "11111111111111111111111111111110", "000"),
    -- Test case 5: Negative overflow, result is positive
    ("10000000000000000000000000000000", "10000000000000000000000000000000", ALU_ADD, "00000000000000000000000000000000", "000"),
    -- Test case 6: Max positive + Min negative
    ("01111111111111111111111111111111", "10000000000000000000000000000000", ALU_ADD, "11111111111111111111111111111111", "000"),
    -- Test case 7: Min positive + Max negative
    ("00000000000000000000000000000001", "11111111111111111111111111111111", ALU_ADD, "00000000000000000000000000000000", "000"),
    -- Test case 8: Max negative + Max negative
    ("10000000000000000000000000000000", "10000000000000000000000000000000", ALU_ADD, "00000000000000000000000000000000", "000"),
    -- Test case 9: Max positive + Max positive
    ("01111111111111111111111111111111", "01111111111111111111111111111111", ALU_ADD, "11111111111111111111111111111110", "000"),
    -- Test case 10: Max positive + 1
    ("01111111111111111111111111111111", "00000000000000000000000000000001", ALU_ADD, "10000000000000000000000000000000", "000"),
    -- Test case 11: Max negative + 1
    ("10000000000000000000000000000000", "00000000000000000000000000000001", ALU_ADD, "10000000000000000000000000000001", "000"),
    -- Test case 12: Max positive + Min positive
    ("01111111111111111111111111111111", "00000000000000000000000000000001", ALU_ADD, "10000000000000000000000000000000", "000"),
    -- Test case 13: Min negative + Max negative
    ("10000000000000000000000000000001", "10000000000000000000000000000000", ALU_ADD, "00000000000000000000000000000001", "000"),
    -- Test case 14: Mid positive + Mid positive
    ("00000000111111111111111111111111", "00000000111111111111111111111111", ALU_ADD, "00000001111111111111111111111110", "000"),
    -- Test case 15: Mid negative + Mid negative
    ("11111111000000000000000000000000", "11111111000000000000000000000000", ALU_ADD, "11111110000000000000000000000000", "000"),
	
	-- SUB
    -- Test case 1: Basic subtraction
    ("00000000000000000000000000000100", "00000000000000000000000000000010", ALU_SUB, "00000000000000000000000000000010", "000"),
    -- Test case 2: Subtracting a larger number from a smaller one
    ("00000000000000000000000000000111", "00000000000000000000000000001000", ALU_SUB, "11111111111111111111111111111111", "000"),
    -- Test case 3: Subtracting the maximum representable value
    ("00000000000000000000000000000000", "11111111111111111111111111111111", ALU_SUB, "00000000000000000000000000000001", "000"),
    -- Test case 4: Subtracting the minimum representable value
    ("00000000000000000000000000000000", "00000000000000000000000000000001", ALU_SUB, "11111111111111111111111111111111", "000"),
    -- Test case 5: Subtracting zero
    ("00000000000000000000000000000101", "00000000000000000000000000000000", ALU_SUB, "00000000000000000000000000000101", "000"),
    -- Test case 6: Subtracting a number from itself
    ("00000000000000000000000000001100", "00000000000000000000000000001100", ALU_SUB, "00000000000000000000000000000000", "000"),
    -- Test case 7: Subtracting a negative number
    ("00000000000000000000000000000000", "11111111111111111111111111111011", ALU_SUB, "00000000000000000000000000000101", "000"),
    -- Test case 8: Subtracting a negative number from a positive number
    ("00000000000000000000000000001001", "11111111111111111111111111111001", ALU_SUB, "00000000000000000000000000010000", "000"),
    -- Test case 9: Subtracting a positive number from a negative number
    ("11111111111111111111111111110101", "00000000000000000000000000000110", ALU_SUB, "11111111111111111111111111110011", "000"),
    -- Test case 10: Subtracting from a negative number
    ("11111111111111111111111111110101", "00000000000000000000000000000101", ALU_SUB, "11111111111111111111111111111000", "000"),
    -- Test case 11: Subtracting the maximum negative number
    ("00000000000000000000000000000000", "10000000000000000000000000000000", ALU_SUB, "10000000000000000000000000000000", "000"),
    -- Test case 12: Subtracting the maximum positive number from a positive number
    ("00000000000000000000000000001010", "01111111111111111111111111111111", ALU_SUB, "10000000000000000000000000000101", "000"),
    -- Test case 13: Subtracting the maximum positive number from the maximum negative number
    ("10000000000000000000000000000000", "01111111111111111111111111111111", ALU_SUB, "10000000000000000000000000000001", "000"),
    -- Test case 14: Subtracting a mid-range positive number from a mid-range negative number
    ("11111111100000000000000000000000", "00000000011111111111111111111111", ALU_SUB, "11111111111111111111111111100001", "000"),
    -- Test case 15: Subtracting a mid-range negative number from a mid-range positive number
    ("00000000011111111111111111111111", "11111111100000000000000000000000", ALU_SUB, "00000000100000000000000000000011", "000"),
	
	-- SLL
    ("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_SLL, "00000000000000000000000000000010", "000"),
	("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_SLL, "00000000000000000000000000000010", "000"), -- SLL(1 << 1)
	("00000000000000000000000000000001", "00000000000000000000000000000010", ALU_SLL, "00000000000000000000000000000100", "000"), -- SLL(1 << 2)
	("10000000000000000000000000000000", "00000000000000000000000000000001", ALU_SLL, "00000000000000000000000000000000", "000"), -- SLL(-2147483648 << 1)
	("01111111111111111111111111111111", "00000000000000000000000000000001", ALU_SLL, "11111111111111111111111111111110", "000"), -- SLL(2147483647 << 1)
	("00000000000000000000000000000000", "00000000000000000000000000000001", ALU_SLL, "00000000000000000000000000000000", "000"), -- SLL(0 << 1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_SLL, "00000000000000000000000000000001", "000"), -- SLL(1 << 0)
	("00000000000000000000000000000001", "00000000000000000000000000011111", ALU_SLL, "10000000000000000000000000000000", "000"), -- SLL(1 << 31)
	("00000000000000000000000000000010", "00000000000000000000000000011111", ALU_SLL, "00000000000000000000000000000000", "000"), -- SLL(2 << 31)
	
	-- SRL
    ("00000000000000000000000000000010", "00000000000000000000000000000001", ALU_SRL, "00000000000000000000000000000001", "000"), 
	("00000000000000000000000000000010", "00000000000000000000000000000001", ALU_SRL, "00000000000000000000000000000001", "000"), -- SRL(2 >> 1)
	("00000000000000000000000000000100", "00000000000000000000000000000010", ALU_SRL, "00000000000000000000000000000001", "000"), -- SRL(4 >> 2)
	("10000000000000000000000000000000", "00000000000000000000000000000001", ALU_SRL, "01000000000000000000000000000000", "000"), -- SRL(-2147483648 >> 1)
	("01111111111111111111111111111111", "00000000000000000000000000000001", ALU_SRL, "00111111111111111111111111111111", "000"), -- SRL(2147483647 >> 1)
	("00000000000000000000000000000000", "00000000000000000000000000000001", ALU_SRL, "00000000000000000000000000000000", "000"), -- SRL(0 >> 1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_SRL, "00000000000000000000000000000001", "000"), -- SRL(1 >> 0)
	("10000000000000000000000000000000", "00000000000000000000000000011111", ALU_SRL, "00000000000000000000000000000001", "000"), -- SRL(-2147483648 >> 31)
	("01111111111111111111111111111111", "00000000000000000000000000011111", ALU_SRL, "00000000000000000000000000000000", "000"), -- SRL(2147483647 >> 31)
	
	-- SRA
    ("11111111111111111111111111111110", "00000000000000000000000000000001", ALU_SRA, "11111111111111111111111111111111", "000"), 
	("00000000000000000000000000000010", "00000000000000000000000000000001", ALU_SRA, "00000000000000000000000000000001", "000"), -- SRA(2 >> 1)
	("00000000000000000000000000000100", "00000000000000000000000000000010", ALU_SRA, "00000000000000000000000000000001", "000"), -- SRA(4 >> 2)
	("10000000000000000000000000000000", "00000000000000000000000000000001", ALU_SRA, "11000000000000000000000000000000", "000"), -- SRA(-2147483648 >> 1)
	("01111111111111111111111111111111", "00000000000000000000000000000001", ALU_SRA, "00111111111111111111111111111111", "000"), -- SRA(2147483647 >> 1)
	("00000000000000000000000000000000", "00000000000000000000000000000001", ALU_SRA, "00000000000000000000000000000000", "000"), -- SRA(0 >> 1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_SRA, "00000000000000000000000000000001", "000"), -- SRA(1 >> 0)
	("10000000000000000000000000000000", "00000000000000000000000000011111", ALU_SRA, "11111111111111111111111111111111", "000"), -- SRA(-2147483648 >> 31)
	("01111111111111111111111111111111", "00000000000000000000000000011111", ALU_SRA, "00000000000000000000000000000000", "000"), -- SRA(2147483647 >> 31)
	
	-- AND
    ("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_AND, "00000000000000000000000000000000", "000"), 
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_AND, "00000000000000000000000000000111", "000"), -- AND(15 & 7)
	("00000000000000000000000000010101", "00000000000000000000000000011011", ALU_AND, "00000000000000000000000000010001", "000"), -- AND(21 & 27)
	("10000000000000000000000000000000", "00000000000000000000000000000000", ALU_AND, "00000000000000000000000000000000", "000"), -- AND(-2147483648 & 0)
	("01111111111111111111111111111111", "11111111111111111111111111111111", ALU_AND, "01111111111111111111111111111111", "000"), -- AND(2147483647 & -1)
	("00000000000000000000000000000000", "11111111111111111111111111111111", ALU_AND, "00000000000000000000000000000000", "000"), -- AND(0 & -1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_AND, "00000000000000000000000000000000", "000"), -- AND(1 & 0)
	
	-- OR
    ("00000000000000000000000000000011", "00000000000000000000000000000101", ALU_OR, "00000000000000000000000000000110", "000"), -- 		--res changed 111
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_OR, "00000000000000000000000000001111", "000"), -- OR(15 | 7)
	("00000000000000000000000000010101", "00000000000000000000000000011011", ALU_OR, "00000000000000000000000000011111", "000"), -- OR(21 | 27)
	("10000000000000000000000000000000", "00000000000000000000000000000000", ALU_OR, "10000000000000000000000000000000", "000"), -- OR(-2147483648 | 0)
	("01111111111111111111111111111111", "11111111111111111111111111111111", ALU_OR, "11111111111111111111111111111111", "000"), -- OR(2147483647 | -1)
	("00000000000000000000000000000000", "11111111111111111111111111111111", ALU_OR, "11111111111111111111111111111111", "000"), -- OR(0 | -1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_OR, "00000000000000000000000000000001", "000"), -- OR(1 | 0)
	
	-- XOR
    ("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_XOR, "00000000000000000000000000000000", "000"), 
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_XOR, "00000000000000000000000000001000", "000"), -- XOR(15 ^ 7)
	("00000000000000000000000000010101", "00000000000000000000000000011011", ALU_XOR, "00000000000000000000000000001110", "000"), -- XOR(21 ^ 27)
	("10000000000000000000000000000000", "00000000000000000000000000000000", ALU_XOR, "10000000000000000000000000000000", "000"), -- XOR(-2147483648 ^ 0)
	("01111111111111111111111111111111", "11111111111111111111111111111111", ALU_XOR, "10000000000000000000000000000000", "000"), -- XOR(2147483647 ^ -1)
	("00000000000000000000000000000000", "11111111111111111111111111111111", ALU_XOR, "11111111111111111111111111111111", "000"), -- XOR(0 ^ -1)
	("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_XOR, "00000000000000000000000000000001", "000"), -- XOR(1 ^ 0)
	
	-- BEQ
    ("00000000000000000000000000000011", "00000000000000000000000000000011", ALU_BEQ, "00000000000000000000000000000000", "001"), 
	("00000000000000000000000000001111", "00000000000000000000000000001111", ALU_BEQ, "00000000000000000000000000000000", "001"), -- BEQ(15 == 15)
	("10000000000000000000000000000000", "10000000000000000000000000000000", ALU_BEQ, "00000000000000000000000000000000", "001"), -- BEQ(-2147483648 == -2147483648)
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_BEQ, "00000000000000000000000000000000", "000"), -- BEQ(15 != 7)
	("01111111111111111111111111111111", "11111111111111111111111111111111", ALU_BEQ, "00000000000000000000000000000000", "000"), -- BEQ(2147483647 != -1)
	
	-- BLT
    ("00000000000000000000000000000001", "00000000000000000000000000000010", ALU_BLT, "00000000000000000000000000000000", "000"), --		flag changed 010
	("11111111111111111111111111111111", "00000000000000000000000000000001", ALU_BLT, "00000000000000000000000000000000", "010"), -- BLT(-1 < 1)
	("00000011111111111111111111111111", "11111111111111111111111111111111", ALU_BLT, "00000000000000000000000000000000", "000"), -- BLT()
	--(std_logic_vector(to_signed(2147483647, 32)), std_logic_vector(to_signed(-2147483648, 32)), ALU_BLT, (others => '0'), "000"),
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_BLT, "00000000000000000000000000000000", "000"), -- BLT(15 >= 7)
	("11111111111111111111111111111110", "11111111111111111111111111111111", ALU_BLT, "00000000000000000000000000000000", "010"), -- BLT(-2 < -1)
	
	-- BLTU
	(std_logic_vector(to_unsigned(5, 32)), std_logic_vector(to_unsigned(9, 32)), ALU_BLTU, (others => '0'), "100"),
	("00000000000000000000000000000101", "00000000000000000000000000001001", ALU_BLTU, "00000000000000000000000000000000", "100"), -- BLTU(5 < 9)
	("00000000000000000000000000000001", "00000000000000000000000000001111", ALU_BLTU, "00000000000000000000000000000000", "100"), -- BLTU(1 < 15)
	("00000000000000000000000000001111", "00000000000000000000000000000111", ALU_BLTU, "00000000000000000000000000000000", "000"), -- BLTU(15 >= 7)
	("01111111111111111111111111111110", "01111111111111111111111111111111", ALU_BLTU, "00000000000000000000000000000000", "100"), -- BLTU()
	
	-- JAL
	("00000000000000000000000000000100", "00000000000000000000000000000010", ALU_JAL, "00000000000000000000000000000100", "000"), -- JAL(6) 
	("11111111111111111111111111111110", "00000000000000000000000000000010", ALU_JAL, "11111111111111111111111111111110", "000"), -- JAL(-2)
	("00000000000000000000000000000000", "11111111111111111111111111111110", ALU_JAL, "00000000000000000000000000000000", "000"), -- JAL(0)

	-- LUI
	("00000000000000000000000000000000", "00000000000000000000000000000010", ALU_LUI, "00000000000000000000000000000010", "000"), -- LUI(2)
	("00000000000000000000000000000000", "11111111111111111111111111111111", ALU_LUI, "11111111111111111111111111111111", "000"), -- LUI(-1)
	("00000000000000000000000000000000", "00000000000000000000000000000000", ALU_LUI, "00000000000000000000000000000000", "000")  -- LUI(0)

	
);
	
	
			
	--constant vectors : test_vectors_t := (										-- LTU  LT  EQ flags
	--(std_logic(unsigned(0)), std_logic(unsigned(0)), ALU_ADD, std_logic(unsigned(0)), " 0   0   0" ),
	--(std_logic(unsigned(1)), std_logic(unsigned(1)), "0001", std_logic(unsigned(1)),  " 0   0   0" ),
	--(std_logic(unsigned(2)), std_logic(unsigned(2)), "0010", std_logic(unsigned(2)),  " 0   0   0" )
	--); 
	


component alu is
	--generic(selopbits : positive := 4;flagbits : positive := 3);
	port(
	--INPUTS
	op1 : in std_logic_vector(31 downto 0);
	op2 : in std_logic_vector(31 downto 0);
	selop : in std_logic_vector(3 downto 0);
	--OUTPUTS
	res : out std_logic_vector(31 downto 0);
	flags : out std_logic_vector(2 downto 0)
	);
end component;


END PACKAGE alu_pkg;


PACKAGE BODY alu_pkg IS

	function change_to_string(data : std_logic_vector) return string is
	begin
		return integer'image(to_integer(unsigned(data)));
	end function change_to_string;

	function error_event (alu_code : std_logic_vector(3 downto 0) ) return string is
	begin
		case alu_code is
			when "0000" =>
				return string'("ALU_ADD");
			when "0001" =>
				return string'("ALU_SUB");
			when "0010" =>
				return string'("ALU_SLL");
			when "0011" =>
				return string'("ALU_SRL");
			when "0100" =>
				return string'("ALU_SRA");
			when "0101" =>
				return string'("ALU_AND");
			when "0110" =>
				return string'("ALU_OR");
			when "0111" =>
				return string'("ALU_XOR");
			when "1000" =>
				return string'("ALU_BEQ");
			when "1001" =>
				return string'("ALU_BLT");
			when "1010" =>
				return string'("ALU_BLTU");
			when "1011" =>
				return string'("ALU_JAL");
			when "1100" =>
				return string'("ALU_LUI");
			when others =>
				return string'("Wrong ALU code");
		end case;
	end function error_event;

END PACKAGE BODY alu_pkg;
