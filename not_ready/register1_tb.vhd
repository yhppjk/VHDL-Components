----------------------------------------------------------
--! @file
--! @A flexible decoder testbench
-- Filename: register1_tb.vhd
-- Description: A flexible decoder testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! register1 entity description
--! Detailed description of this
--! register1 design element.
ENTITY register1_tb IS
END ENTITY register1_tb;

--! @brief Architecture definition of register1
--! @details Testbench implementation
ARCHITECTURE behavior OF register1_tb IS 
   COMPONENT register1
   PORT (
	 reg_in : IN std_logic; 	--Register data input
	 writ : IN std_logic;		--! Write signal input
	 rst :  IN std_logic;		--! Reset signal input
	 clk :  IN std_logic;		--! clock signal input
	 reg_out : OUT std_logic := '0'	--! Register data output
);
    END COMPONENT register1;
    
	 signal reg_in :  std_logic; 	--Register data input
	 signal writ :  std_logic;		--! Write signal input
	 signal rst :   std_logic;		--! Reset signal input
	 signal clk :   std_logic;		--! clock signal input
	 signal reg_out :  std_logic;	--! Register data output
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: register1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		reg_in => reg_in,
		writ => writ,
		rst => rst,
		clk => clk,
		reg_out => reg_out
	);
  --! @brief Clock generate process
  --! @details generate a clock signalclock_proc:PROCESS
clock_proc:PROCESS
BEGIN
	clk <= '0';
	WAIT FOR 10 ns;
 	clk <= '1';
	WAIT FOR 10 ns;
END PROCESS;

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	reg_in <= '1';
	reg_out <= '0';
	
	rst <= '0';
	writ <= '0';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;

	rst <= '1';
	writ <= '0';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;
	
	rst <= '1';
	writ <= '1';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;
	
	rst <= '0';
	writ <= '1';
	for i in 1 to 3 loop
		wait until rising_edge(clk);
	end loop;
	WAIT FOR 2 ns;


	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;