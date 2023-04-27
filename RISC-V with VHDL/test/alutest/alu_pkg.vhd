----------------------------------------------------------
--! @file alu_tb
--! @A alu_tb can combine multipal counter to count.
-- Filename: alu_tb.vhd
-- Description: A alu_tb can test the reaction of a register file.
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

	type test_t is
	record
	  op1                         : std_logic_vector(31 downto 0);
	  op2                         : std_logic_vector(31 downto 0);
	  selop                       : std_logic_vector(3 downto 0);
	  exp_res                     : std_logic_vector(31 downto 0);
	  exp_flags                   : std_logic_vector(2 downto 0); -- (0) is EQ flag, (1) is LT flag, (2) is the LTU flag
	end record;
	type test_vectors_t is array (0 to 10) of test_t;

	CONSTANT vectors: test_vectors_t := (
    -- 							op1                 op2                 		selop    			exp_res             exp_flags											                  
    ("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_ADD, "00000000000000000000000000000010", "000"), -- ADD
    ("00000000000000000000000000000011", "00000000000000000000000000000001", ALU_SUB, "00000000000000000000000000000010", "000"), -- SUB
    ("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_SLL, "00000000000000000000000000000010", "000"), -- SLL
    ("00000000000000000000000000000010", "00000000000000000000000000000001", ALU_SRL, "00000000000000000000000000000001", "000"), -- SRL
    ("11111111111111111111111111111110", "00000000000000000000000000000001", ALU_SRA, "11111111111111111111111111111111", "000"), -- SRA
    ("00000000000000000000000000000001", "00000000000000000000000000000000", ALU_AND, "00000000000000000000000000000000", "000"), -- AND
    ("00000000000000000000000000000011", "00000000000000000000000000000101", ALU_OR,  "00000000000000000000000000000111", "000"), -- OR
    ("00000000000000000000000000000001", "00000000000000000000000000000001", ALU_XOR, "00000000000000000000000000000000", "000"), -- XOR
    ("00000000000000000000000000000011", "00000000000000000000000000000011", ALU_BEQ, "00000000000000000000000000000000", "001"), -- BEQ
    ("00000000000000000000000000000001", "00000000000000000000000000000010", ALU_BLT, "00000000000000000000000000000000", "010"), -- BLT
	(std_logic_vector(to_unsigned(5, 32)), std_logic_vector(to_unsigned(9, 32)), ALU_BLTU, (others => '0'), "100")
    --("00000000000000000000000000000001", "00000000000000000000000000000010", ALU_BLTU,"00000000000000000000000000000000", "100")  -- BLTU
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
