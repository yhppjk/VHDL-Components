----------------------------------------------------------
--! @file
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
 
    -- Component declaration for the Design Under Test (DUT)
   CONSTANT TBWDITH : POSITIVE := 4;	
   COMPONENT dec
   GENERIC	(
	width : POSITIVE := TBWDITH --! constant to describe the width of decoder
);
   PORT (
	din :  IN  std_logic_vector(width-1 downto 0);
	dout : OUT std_logic_vector(2**width-1 downto 0)
);
    END COMPONENT dec;
    
   --Inputs
   signal din : std_logic_vector(TBWDITH-1 downto 0);
 	--Outputs
   signal dout : std_logic_vector(2**TBWDITH-1 downto 0);
 
BEGIN
 
	-- Instantiate the Design Under Test (DUT) and map its ports
	dut: dec
	PORT MAP (
		-- Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		dout => dout
	);

	-- Stimulus process
	stim_proc: process
	begin
		-- PUT YOUR CODE HERE TO ASSIGN ALL POSSIBLE VALUES TO din
		-- Remember to wait 100 ns before changing the value of din
	loop2 : FOR i IN 0 to 2**TBWDITH-1 LOOP
	din <= std_logic_vector(to_unsigned(i,TBWDITH));
	WAIT FOR 20 ns;
	END LOOP loop2;
	
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;


		for i in 0 to 2**TBWDITH-1 loop
			din <= std_logic_vector(to_unsigned(i,TBWDITH));
			wait for 20 ns;
		end loop;
		assert false report "Simulation finished (not a failure actually)" severity failure;
		wait;   -- Input data exhausted. Simulation ended.
	end process;

END ARCHITECTURE behavior;