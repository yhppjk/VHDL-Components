
----------------------------------------------------------
--! @file tristate1_tb
--! @Tristate 1
-- Filename: tristate1_tb.vhd
-- Description: Tristate 1 testbench
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;

ENTITY tristate1_tb IS
END ENTITY tristate1_tb;

--! @brief Architecture definition of dec_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF tristate1_tb IS 
 
   COMPONENT tristate1
   PORT (
	din :  IN  std_logic;	--! Tristate input port 
	ena :  IN  std_logic; 	--! tristate enable
	dout : OUT std_logic	--! Tristate output port
);
    END COMPONENT tristate1;
    
   --Inputs
   signal din : std_logic;	--! data input signal
   signal ena : std_logic;	--! enable input signal
 	--Outputs
   signal dout : std_logic;	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: tristate1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		ena  => ena,
		dout => dout
	);

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin

	din <= '1';
	ena <= '0';
	WAIT FOR 10 ns;
	
	din <= '1';
	ena <= '1';
	WAIT FOR 10 ns;
	
	din <= '0';
	ena <= '0';
	WAIT FOR 10 ns;
	din <= '0';
	ena <= '1';
	WAIT FOR 10 ns;


--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;