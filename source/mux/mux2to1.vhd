----------------------------------------------------------
--! @file
--! @mux 2 to single 
-- Filename: mux2to1.vhd
-- Description: mux 2 to single  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! MUX 2 to 1 entity description

--! Detailed description of this
--! mux 2 to single design element.	
ENTITY mux2to1 IS
   PORT (
	din1 :  IN  std_logic;	--! input 1 of mux
	din2 :  IN	std_logic;	--! input 2 of mux
	sel	:	IN std_logic;							--! selection of mux
	dout : OUT std_logic		--! output of mux
);
END ENTITY mux2to1;

--! @brief Architecture definition of mux2to1
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux2to1 IS
BEGIN
	dout <= din1 when (sel ='1') else din2;
END ARCHITECTURE Behavioral;