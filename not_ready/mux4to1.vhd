----------------------------------------------------------
--! @file
--! @mux 4 to single 
-- Filename: mux4to1.vhd
-- Description: mux 4 to single  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! MUX 4 to 1 entity description

--! Detailed description of this
--! decoder design element.
ENTITY mux4to1 IS
	GENERIC (width: INTEGER :=5),
   PORT (
	din1 :  IN  std_logic_vector(width downto 0);	--! input 1 of mux
	din2 :  IN	std_logic_vector(width downto 0);	--! input 2 of mux
	din3 :  IN	std_logic_vector(width downto 0);	--! input 3 of mux
	din4 :  IN	std_logic_vector(width downto 0);	--! input 4 of mux
	sel1	:	IN std_logic;						--! selection 1 of mux
	sel2	:	IN std_logic;						--! selection 2 of mux
	dout : OUT std_logic_vector(width downto 0)		--! output of mux
);
END ENTITY mux4to1;

--! @brief Architecture definition of mux4to1
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux4to1 IS
BEGIN

PROCESS(din1,din2,din3,din4,sel1,sel2) is
BEGIN
	if(sel1='0' and sel2='0') then
		dout <= din1;
	elsif(sel1='1' and sel2='0') then
		dout <= din2;
	elsif(sel1='0' and sel2='1') then
		dout <= din3;	
	elsif(sel1='1' and sel2='1') then
		dout <= din4;	
	end if;
	
END PROCESS;	
END ARCHITECTURE Behavioral;