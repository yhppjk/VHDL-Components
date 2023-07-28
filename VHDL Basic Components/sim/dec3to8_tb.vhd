----------------------------------------------------------
--! @file dec3to8_tb
--! @decoder 3 to 8 testbench
-- Filename: dec3to8_tb.vhd
-- Description: decoder 3 to 8 testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! dec3to8_tb entity description
--! Detailed description of this
--! dec3to8_tb design element.
ENTITY dec3to8_tb IS
END ENTITY dec3to8_tb;

--! @brief Architecture definition of dec3to8_tb, testbench implementation
--! @details More details about this start_stop element
ARCHITECTURE behavior OF dec3to8_tb IS 
 
    
    COMPONENT dec3to8 --! Component declaration for the Design Under Test (DUT)
	generic(	prop_delay : time := 2 ns);
    PORT(
         din :  IN  std_logic_vector(2 downto 0);	--! The input of decoder
         dout : OUT std_logic_vector(7 downto 0)	--! The output of decoder
        );
    END COMPONENT dec3to8;

    signal din : std_logic_vector(2 downto 0);		--! The signal to transfer decoder input
    signal dout : std_logic_vector(7 downto 0);		--! The signal to transfer decoder output
 
BEGIN

	--! @brief Instantiate the Design Under Test (DUT) and map its ports
	dut: dec3to8
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		dout => dout
	);

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	loop2 : FOR i IN 0 to 7 LOOP
	din <= std_logic_vector(to_unsigned(i,3));
	WAIT FOR 20 ns;
	END LOOP loop2;

--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;

	end process;

END ARCHITECTURE behavior;