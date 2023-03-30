----------------------------------------------------------
--! @file dec_tb
--! @A flexible decoder testbench
-- Filename: dec_tb.vhd
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

--! dec_tb entity description
--! Detailed description of this
--! dec_tb design element.
ENTITY dec_tb IS
END ENTITY dec_tb;

--! @brief Architecture definition of dec_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF dec_tb IS 
 
   CONSTANT TBWDITH : POSITIVE := 5;	--! Component declaration for the Design Under Test (DUT
   COMPONENT dec
   GENERIC	(
	width : POSITIVE := TBWDITH; --! constant to describe the width of decoder
	prop_delay : time := 2 ns
);
   PORT (
	din :  IN  std_logic_vector(width-1 downto 0);		--! data input port 
	dout : OUT std_logic_vector(2**width-1 downto 0)	--! data output port
);
    END COMPONENT dec;
    
   --Inputs
   signal din : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal
 	--Outputs
   signal dout : std_logic_vector(2**TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: dec
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		dout => dout
	);

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin

	loop2 : FOR i IN 0 to 2**TBWDITH-1 LOOP
	din <= std_logic_vector(to_unsigned(i,TBWDITH));
	WAIT FOR 20 ns;
	END LOOP loop2;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;