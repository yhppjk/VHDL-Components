----------------------------------------------------------
--! @file mux4togen_tb
--! @A 4 to 1 mux testbench
-- Filename: mux4togen_tb.vhd
-- Description: a 4 to 1 mux testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! mux4togen_tb entity description
--! Detailed description of this
--! mux4togen_tb design element.
ENTITY mux4togen_tb IS
END ENTITY mux4togen_tb;

--! @brief Architecture definition of mux4togen_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux4togen_tb IS 
 
	CONSTANT TBWDITH : POSITIVE := 4;	--! Component declaration for the Design Under Test (DUT
	COMPONENT mux4togen
	GENERIC	(
		width : POSITIVE := TBWDITH; --! constant to describe the width of decoder
		prop_delay : time := 2 ns		--! prop delay
);
   PORT (
  	din0 : 	IN std_logic_vector(width-1 downto 0);		--! data input port0
	din1 :  IN std_logic_vector(width-1 downto 0);		--! data input port1
	din2 : 	IN std_logic_vector(width-1 downto 0);		--! data input port2
	din3 :  IN std_logic_vector(width-1 downto 0);		--! data input port3

	sel	:	IN std_logic_vector(1 downto 0);		--! selection of mux
	dout : OUT std_logic_vector(width-1 downto 0)	--! data output port
);
    END COMPONENT mux4togen;
    
   --Inputs
	signal din0 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal0 
	signal din1 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal1
	signal din2 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal2
	signal din3 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal3
	signal sel  : std_logic_vector(1 downto 0);			--! selection of mux
	--Outputs
	signal dout : std_logic_vector(TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux4togen
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din1  => din1,
		din2  => din2,
		din3  => din3,
		din0  => din0,		
		sel => sel,
		dout => dout
	);


--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	din1 <= "0001";
	din2 <= "0010";
	din3 <= "0100";
	din0 <= "1000";
	sel <= "00";
	wait FOR 10 ns;

	sel <= "10";
	wait FOR 10 ns;

	sel <= "01";
	wait FOR 10 ns;

	sel <= "11";
	WAIT FOR 10 ns;

	din1 <= "1111";
	sel <= "00";
	WAIT FOR 10 ns;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;