----------------------------------------------------------
--! @file
--! @A flexible decoder testbench
-- Filename: registergen_tb.vhd
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

--! registergen entity description
--! Detailed description of this
--! registergen design element.
ENTITY registergen_tb IS
END ENTITY registergen_tb;

--! @brief Architecture definition of registergen
--! @details Testbench implementation

ARCHITECTURE behavior OF registergen_tb IS 
	CONSTANT TBWDITH : POSITIVE := 4;
   COMPONENT registergen
   	GENERIC(
		width : POSITIVE := TBWDITH
	);
	
   PORT (
	 reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
	 writ : IN std_logic :='0';		--! Write signal input
	 rst :  IN std_logic :='0';		--! Reset signal input
	 clk :  IN std_logic :='0';		--! clock signal input
	 reg_out : OUT std_logic_vector (width-1 downto 0)	--! Register data output
);
    END COMPONENT registergen;
    
	 signal reg_in :  std_logic_vector (TBWDITH-1 downto 0) :="0000"; 	--Register data input
	 signal writ :  std_logic;		--! Write signal input
	 signal rst :   std_logic;		--! Reset signal input
	 signal clk :   std_logic;		--! clock signal input
	 signal reg_out :  std_logic_vector (TBWDITH-1 downto 0);	--! Register data output
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: registergen
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
	reg_in <= "1101";
	WAIT FOR 20 ns;

	writ <= '1';
	reg_in <= "0001";
	WAIT FOR 20 ns;

	writ <= '0';
	reg_in <= "0101";
	WAIT FOR 20 ns;
	
	writ <= '1';
	reg_in <= "1001";
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