----------------------------------------------------------
--! @file mux2togen_tb
--! @A a 2 to 1 mux testbench
-- Filename: mux2togen_tb.vhd
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

--! mux2togen_tb entity description
--! Detailed description of this
--! mux2togen_tb design element.
ENTITY mux2togen_tb IS
END ENTITY mux2togen_tb;

--! @brief Architecture definition of mux2togen_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux2togen_tb IS 
 
   CONSTANT TBWDITH : POSITIVE := 4;	--! Component declaration for the Design Under Test (DUT
   COMPONENT mux2togen
   GENERIC	(
	width : POSITIVE := TBWDITH --! constant to describe the width of decoder
);
   PORT (
	din1 :  IN std_logic_vector(width-1 downto 0);		--! data input port1
	din2 : 	IN std_logic_vector(width-1 downto 0);		--! data input port2
	sel : IN std_logic;									--! selection of mux
	dout : OUT std_logic_vector(width-1 downto 0)	--! data output port
);
    END COMPONENT mux2togen;
    
   --Inputs
   signal din1 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal1
   signal din2 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal2
   signal sel  : std_logic :='0';						--! selection of mux
 	--Outputs
   signal dout : std_logic_vector(TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux2togen
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