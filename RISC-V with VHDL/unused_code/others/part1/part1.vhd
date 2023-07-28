----------------------------------------------------------
--! @file part1
--! @A part1 can combine multipal counter to count.
-- Filename: part1.vhd
-- Description: A part1 can save some data in different address.
-- Author: YIN Haoping
-- Date: March 27, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

--! part1 entity description

--! Detailed description of this
--! part1 design element.
entity part1 is
    generic (
        dataWidth : positive := 32;			--! generic of datawidth
		addressWidth : positive := 5;		--! generic of address width
		sychro_reset : boolean := false; 	--! sychronous reset
		reset_zero : boolean := false;		--! reset address 0 only
		ignore_zero : boolean := false;		--! ignore write address 0
		combination_read : boolean := false;	--! generic of Combination and sychrnonous selection
		read_delay: time := 0 ns			--! generic of read delay time
    );
    port (
        clk        	: in  std_logic;				--! the input port of clock
		commande : in std_logic_vector(dataWidth-1 downto 0);
		
    );
end entity part1;
