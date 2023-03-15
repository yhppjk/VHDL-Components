----------------------------------------------------------
--! @file
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

--! dec_tb entity description
--! Detailed description of this
--! dec_tb design element.
ENTITY mux2to1_tb IS
END ENTITY mux2to1_tb;

--! @brief Architecture definition of mux2to1_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux2to1_tb IS 
 
   CONSTANT TBWDITH : POSITIVE := 4;	--! Component declaration for the Design Under Test (DUT
   COMPONENT mux2to1
   GENERIC	(
	width : POSITIVE := TBWDITH --! constant to describe the width of decoder
);
   PORT (
	din1 :  IN std_logic_vector(width-1 downto 0);		--! data input port
	din2 : 	IN std_logic_vector(width-1 downto 0);
	sel : IN std_logic;
	dout : OUT std_logic_vector(width-1 downto 0)	--! data output port
);
    END COMPONENT mux2to1;
    
   --Inputs
   signal din1 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal
   signal din2 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal
   signal sel  : std_logic :='0';
 	--Outputs
   signal dout : std_logic_vector(TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux2to1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din1  => din1,
		din2  => din2,
		sel => sel,
		dout => dout
	);
	




--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin

	din1 <= "1100";
	din2 <= "0011";
	sel <= '0';
	wait for 10 ns;

	sel <= '1';
	
	wait for 10 ns;
	
	din2 <= "1010";
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