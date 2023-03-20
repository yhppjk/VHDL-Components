----------------------------------------------------------
--! @file mux4to1
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
--! mux 4 to 1 design element.
ENTITY mux4to1 IS
   PORT (
	din1 :  IN  std_logic;	--! input 1 of mux
	din2 :  IN	std_logic;	--! input 2 of mux
	din3 :  IN	std_logic;	--! input 3 of mux
	din4 :  IN	std_logic;	--! input 4 of mux
	sel	:	IN std_logic_vector(1 downto 0);		--! selection of mux
	dout : OUT std_logic		--! output of mux
);
END ENTITY mux4to1;

--! @brief Architecture definition of mux4to1
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux4to1 IS
BEGIN

PROCESS(din1,din2,din3,din4,sel) is
BEGIN
	case(sel) is 
	when "00" =>
		dout <= din0;
	when "01" =>
		dout <= din1;
	when "10" =>
		dout <= din2;
	when "11" =>
		dout <= din3;
	
END PROCESS;	
END ARCHITECTURE Behavioral;