
----------------------------------------------------------
--! @file
--! @Tristate generic
-- Filename: tristategen_tb.vhd
-- Description: Tristate generic testbench
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library	
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;

ENTITY tristategen_tb IS
END ENTITY tristategen_tb;

--! @brief Architecture definition of dec_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF tristategen_tb IS 
	CONSTANT TBWDITH : POSITIVE := 4;
   COMPONENT tristategen
   GENERIC (
			width : POSITIVE := TBWDITH
);
   PORT (
	din :  IN  std_logic_vector(width-1 downto 0);	--! Tristate input port 
	ena :  IN  std_logic; 	--! tristate enable
	dout : OUT std_logic_vector(width-1 downto 0)	--! Tristate output port
);
    END COMPONENT tristategen;
    
   --Inputs
   signal din : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal
   signal ena : std_logic;	--! enable input signal
 	--Outputs
   signal dout : std_logic_vector(TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: tristategen
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		ena  => ena,
		dout => dout
	);

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	
	din <= "1101";
	ena <= '0';
	WAIT FOR 10 ns;
	
	din <= "0101";
	ena <= '0';
	WAIT FOR 10 ns;

	ena <= '1';
	WAIT FOR 10 ns;
	
	din <= "0001";
	ena <= '0';
	WAIT FOR 10 ns;

	din <= "1001";
	ena <= '0';
	WAIT FOR 10 ns;
	
	ena <= '1';
	WAIT FOR 10 ns;


--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;