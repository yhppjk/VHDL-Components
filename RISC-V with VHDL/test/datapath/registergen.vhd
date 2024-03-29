----------------------------------------------------------
--! @file registergen
--! @A register single bit
-- Filename: registergen.vhd
-- Description: A register single bit
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;



--! Detailed description of this
--! register design element.
ENTITY registergen IS
	GENERIC(
		width : POSITIVE := 4;
		prop_delay : time := 0 ns		--! prop delay
	);	
    PORT (
		reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
		writ : IN std_logic;		--! Write signal input
		rst :  IN std_logic;		--! Reset signal input
		clk :  IN std_logic;		--! clock signal input
		reg_out : OUT std_logic_vector (width-1 downto 0) := (others => '0')	--! Register data output
);
END ENTITY registergen;

--! @brief Architecture definition of register
--! @details More details about this register element.
ARCHITECTURE behavioral OF registergen IS

BEGIN
	process(clk,rst) is
	BEGIN
	if rst ='1' then
		reg_out <= (others =>'0');
	elsif rising_edge(clk) then
		if writ ='1' then 
			if prop_delay = 0 ns then
				reg_out <= reg_in;
			else
				reg_out <= reg_in after prop_delay;
			end if;
		end if;
	end if;
	end  process;

END ARCHITECTURE behavioral;