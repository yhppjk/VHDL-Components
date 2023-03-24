----------------------------------------------------------
--! @file mux4togen
--! @mux 4 to generic 
-- Filename: mux4togen.vhd
-- Description: mux 4 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 4 to 1 entity description

--! Detailed description of this
--! mux 4 to generic design element.
ENTITY mux4togen IS
	GENERIC (width: INTEGER :=4);
   PORT (
   	din0 :  IN	std_logic_vector(width-1 downto 0);	--! input 0 of mux
	din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
	din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
	din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
	sel	:	IN std_logic_vector(1 downto 0);		--! selection of mux
	dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);
END ENTITY mux4togen;

--! @brief Architecture definition of mux4togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux4togen IS
BEGIN

PROCESS(din1,din2,din3,din0,sel) is
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
	end case;
END PROCESS;	
END ARCHITECTURE Behavioral;