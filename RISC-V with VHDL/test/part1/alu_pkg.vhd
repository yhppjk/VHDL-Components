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


-! alu_pkg package description

--! Detailed description of this
--! alu_pkg design element.
PACKAGE alu_pkg IS
--! alu_pkg package description

--! Detailed description of this
--! alu_pkg design element.

--! component alu description
COMPONENT decoder IS
    generic (	
			read_delay: time := 0 ns;				--! generic of read delay time
			selpbits : positive := 4
    );
    port (
	--inputs		
	commande : in std_logic_vector(31 downto 0);		--! origin commande of RV32I, length of 32 bits
	clk : in std_logic;										--! clock input
	ena_dec : in std_logic;									--! decoder enable
	--outputs
	
	selop : out std_logic_vector(selpbits-1 downto 0);	--! selection operation for ALU

	mux1 : out std_logic;									--! mux1 selection
	mux2 : out std_logic_vector(1 downto 0);			--! mux2 selection
	
	immediate : out std_logic_vector(31 downto 0);	--! immediate output
	ena_write : out std_logic								--! write enable
	
	--op1 : out std_logic_vector(31 downto 0);
	--op2 : out std_logic_vector(31 downto 0);
	);
END COMPONENT decoder;



component alu is 
end component;

component mux1alu is
end component;

END PACKAGE alu_pkg;
