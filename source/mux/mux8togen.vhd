----------------------------------------------------------
--! @file
--! @mux 4 to single 
-- Filename: mux8togen.vhd
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
ENTITY mux8togen IS
	GENERIC (width: INTEGER :=4);
   PORT (
	din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
	din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
	din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
	din4 :  IN	std_logic_vector(width-1 downto 0);	--! input 4 of mux
	din5 :  IN  std_logic_vector(width-1 downto 0);	--! input 5 of mux
	din6 :  IN	std_logic_vector(width-1 downto 0);	--! input 6 of mux
	din7 :  IN	std_logic_vector(width-1 downto 0);	--! input 7 of mux
	din8 :  IN	std_logic_vector(width-1 downto 0);	--! input 8 of mux
	sel1	:	IN std_logic;						--! selection 1 of mux
	sel2	:	IN std_logic;						--! selection 2 of mux
	sel3	:	IN std_logic;						--! selection 3 of mux
	dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);
END ENTITY mux8togen;

--! @brief Architecture definition of mux8togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux8togen IS
BEGIN

PROCESS(din1,din2,din3,din4,sel1,sel2) is
BEGIN
	if(sel1='0' and sel2='0' and sel3 = '0') then
		dout <= din1;
	elsif(sel1='1' and sel2='0' and sel3 = '0') then
		dout <= din2;
	elsif(sel1='0' and sel2='1' and sel3 = '0') then
		dout <= din3;	
	elsif(sel1='1' and sel2='1' and sel3 = '0') then
		dout <= din4;	
	elsif(sel1='0' and sel2='0' and sel3 = '1') then
		dout <= din5;
	elsif(sel1='1' and sel2='0' and sel3 = '1') then
		dout <= din6;
	elsif(sel1='0' and sel2='1' and sel3 = '1') then
		dout <= din7;
	elsif(sel1='1' and sel2='1' and sel3 = '1') then	
		dout <= din8;
	end if;
	
END PROCESS;	
END ARCHITECTURE Behavioral;