----------------------------------------------------------
--! @file mux4to1_tb
--! @A 4 to 1 mux testbench
-- Filename: mux4to1_tb.vhd
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

--! mux4to1_tb entity description
--! Detailed description of this
--! mux4to1_tb design element.
ENTITY mux4to1_tb IS
END ENTITY mux4to1_tb;

--! @brief Architecture definition of mux4to1_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux4to1_tb IS 

    COMPONENT mux4to1
	GENERIC(
	prop_delay : time := 2 ns		--! prop delay
);
	PORT (
		din0 : 	IN std_logic;		--! data input port0
		din1 :  IN std_logic;		--! data input port1
		din2 : 	IN std_logic;		--! data input port2
		din3 :  IN std_logic;		--! data input port3
		sel	:	IN std_logic_vector(1 downto 0);		--! selection of mux
		dout : OUT std_logic	--! data output port
);
    END COMPONENT mux4to1;
    
   --Inputs
	signal din0 : std_logic;	--! data input signal0
	signal din1 : std_logic;	--! data input signal1
	signal din2 : std_logic;	--! data input signal2
	signal din3 : std_logic;	--! data input signal3

	signal sel  : std_logic_vector(1 downto 0);			--! selection of mux
	--Outputs
	signal dout : std_logic;	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux4to1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din0  => din0,		
		din1  => din1,
		din2  => din2,
		din3  => din3,
		sel => sel,
		dout => dout
	);


--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	din0 <= '1';
	din1 <= '0';
	din2 <= '1';
	din3 <= '0';
	sel <= "00";
	wait FOR 10 ns;

	sel <= "10";
	wait FOR 10 ns;

	sel <= "01";
	wait FOR 10 ns;

	sel <= "11";
	WAIT FOR 10 ns;

	din1 <= '1';
	sel <= "00";
	WAIT FOR 10 ns;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;