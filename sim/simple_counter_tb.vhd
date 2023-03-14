----------------------------------------------------------
--! @file
--! @A testbench of the simple_counter
-- Filename: simple_counter_tb.vhd
-- Description: A testbench of the simple_counter
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! simple_counter_tb entity description

--! Detailed description of this
--! simple_counter_tb design element.
ENTITY simple_counter_tb IS
END ENTITY simple_counter_tb;

--! @brief Architecture definition of start_stop
--! @details More details about this start_stop element
ARCHITECTURE behavior OF simple_counter_tb IS 

CONSTANT TB_MAX_COUNT : integer := 10;		
COMPONENT simple_counter
	GENERIC(
		MAX_COUNT : integer :=TB_MAX_COUNT	--! limit of count
);
	PORT(
		rst: IN std_logic := '1';		--! the reset input
		clk: IN std_logic;				--! the clock input
		mcount: OUT std_logic;			--! the limit figure output
		count: OUT integer range 0 to TB_MAX_COUNT	--! the count number output
);
END COMPONENT simple_counter;
	--INPUTS
	signal rst : std_logic := '1';
	signal clk : std_logic;
	--OUTPUTS
	signal mcount: std_logic;
	signal count: integer range 0 to TB_MAX_COUNT;

BEGIN
	-- Instantiate the Design Under Test (DUT) and map its ports
	dut: simple_counter
	PORT MAP (
		-- Mapping: component port (left) => this arch signal/port (right)
		rst  => open,
		clk => clk,
		mcount => mcount,
		count => count 
	);
clock_proc:PROCESS
BEGIN
	clk <= '0';
	WAIT FOR 10 ns;
 	clk <= '1';
	WAIT FOR 10 ns;
END PROCESS;

stimuli:PROCESS
BEGIN
	rst <= '0';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;
	
	rst <= '1';
	for i in 1 to TB_MAX_COUNT+3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;

	rst <= '0';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;

	rst <= '1';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;

	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
END PROCESS;





END ARCHITECTURE;