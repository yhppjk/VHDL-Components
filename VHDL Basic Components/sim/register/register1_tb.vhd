----------------------------------------------------------
--! @file register1_tb
--! @A flexible decoder testbench
-- Filename: register1_tb.vhd
-- Description: A flexible decoder testbench
-- Author: YIN Haoping
-- Date: March 21, 2023
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
	 writ : IN std_logic :='0';		--! Write signal input
	 rst :  IN std_logic :='0';		--! Reset signal input
	 clk :  IN std_logic :='0';		--! clock signal input
	 reg_out : OUT std_logic	--! Register data output
);
    END COMPONENT register1;
    
	 signal reg_in :  std_logic :='0'; 	--Register data input
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
	WAIT FOR 2 ns;
 	clk <= '1';
	WAIT FOR 2 ns;
END PROCESS;

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin


	
	rst <= '1';
	writ <= '0';
	WAIT FOR 20 ns;

	rst <= '0';
	writ <= '1';
	reg_in <= '1';
	WAIT FOR 20 ns;

	writ <= '1';
	reg_in <= '1';
	WAIT FOR 20 ns;

	writ <= '0';
	reg_in <= '0';
	WAIT FOR 20 ns;
	
	writ <= '1';
	reg_in <= '0';
	WAIT FOR 20 ns;

	rst <= '1';
	writ <= '1';
	WAIT FOR 20 ns;


	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;