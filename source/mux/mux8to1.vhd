----------------------------------------------------------
--! @file
--! @mux 8 to single 
-- Filename: mux8to1.vhd
-- Description: mux 8 to single  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! MUX 8 to 1 entity description

--! Detailed description of this
--! mux 8 to single design element.
ENTITY mux8to1 IS
   PORT (
	din1 :  IN  std_logic;	--! input 1 of mux
	din2 :  IN	std_logic;	--! input 2 of mux
	din3 :  IN	std_logic;	--! input 3 of mux
	din4 :  IN	std_logic;	--! input 4 of mux
	din5 :  IN  std_logic;	--! input 5 of mux
	din6 :  IN	std_logic;	--! input 6 of mux
	din7 :  IN	std_logic;	--! input 7 of mux
	din8 :  IN	std_logic;	--! input 8 of mux
	sel1	:	IN std_logic;						--! selection 1 of mux
	sel2	:	IN std_logic;						--! selection 2 of mux
	sel3	:	IN std_logic;						--! selection 3 of mux
	dout : OUT std_logic		--! output of mux
);
END ENTITY mux8to1;

--! @brief Architecture definition of mux8to1
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux8to1 IS
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