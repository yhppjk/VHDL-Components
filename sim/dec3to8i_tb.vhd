----------------------------------------------------------
--! @file dec3to8i_tb
--! @decoder 3 to 8 testbench
-- Filename: dec3to8i_tb.vhd
-- Description: decoder 3 to 8 integer testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! dec3to8i_tb entity description
--! Detailed description of this
--! dec3to8i_tb design element.
ENTITY dec3to8i_tb IS
END ENTITY dec3to8i_tb;



--! @brief Architecture definition of dec3to8i_tb, testbench implementation
--! @details More details about this start_stop element
ARCHITECTURE behavior OF dec3to8i_tb IS 
 

    COMPONENT dec3to8i     --! Component declaration for the Design Under Test (DUT)
	generic(	prop_delay : time := 0 ns);
    PORT(
         din :  IN  integer range 0 to 7;	--! data input port 
         dout : OUT std_logic_vector(7 downto 0)	--! data output port
);
    END COMPONENT dec3to8i;
	
   signal din : integer range 0 to 7 := 0;	--! data input signal
   signal dout : std_logic_vector(7 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: dec3to8i
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		dout => dout
	);

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	loop2 : FOR i IN 0 to 7 LOOP
	din <= i;
	WAIT FOR 20 ns;
	END LOOP loop2;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;