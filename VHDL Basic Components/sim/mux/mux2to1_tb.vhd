----------------------------------------------------------
--! @file mux2to1_tb
--! @A a 2 to 1 mux testbench
-- Filename: mux2to1_tb.vhd
-- Description: a 2 to 1 mux testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! mux2to1_tb entity description
--! Detailed description of this
--! mux2to1_tb design element.
ENTITY mux2to1_tb IS
END ENTITY mux2to1_tb;

--! @brief Architecture definition of mux2to1_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux2to1_tb IS 
 

    COMPONENT mux2to1
   	GENERIC	(
		prop_delay : time := 1 ns		--! prop delay
);
    PORT (
		din0 :  IN std_logic;		--! data input port0
		din1 : 	IN std_logic;		--! data input port1
		sel : IN std_logic;		--! selection of mux
		dout : OUT std_logic	--! data output port
);
    END COMPONENT mux2to1;
    
   --Inputs
	signal din0 : std_logic;	--! data input signal
	signal din1 : std_logic;	--! data input signal
	signal sel  : std_logic :='0';	--! selection of mux
	--Outputs
	signal dout : std_logic;	--! data output signal

BEGIN

	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux2to1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din0  => din0,		
		din1  => din1,
		sel => sel,
		dout => dout
	);
	




--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin

	din1 <= '1';
	din0 <= '0';
	sel <= '0';
	wait for 10 ns;

	sel <= '1';
	
	wait for 10 ns;
	
	din0 <= '1';
	sel <= '0';
	wait for 10 ns;

	wait;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;