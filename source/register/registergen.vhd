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
--! Use logic elements
use ieee.std_logic_1164.all;



--! Detailed description of this
--! register design element.
ENTITY registergen IS
	GENERIC(
		width : POSITIVE := 4
	);
	
		
   PORT (
	 reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
	 writ : IN std_logic;		--! Write signal input
	 rst :  IN std_logic;		--! Reset signal input
	 clk :  IN std_logic;		--! clock signal input
	 reg_out : OUT std_logic_vector (width-1 downto 0)	--! Register data output
);
END ENTITY registergen;

--! @brief Architecture definition of register
--! @details More details about this register element.
ARCHITECTURE behavioral OF registergen IS

BEGIN
	process(clk,rst) is
	BEGIN
	if rst ='1' then
		reg_out <= "0000";
	elsif rising_edge(clk) then
		if writ ='1' then 
			reg_out <= reg_in;
		end if;
	end if;
	end  process;

END ARCHITECTURE behavioral;