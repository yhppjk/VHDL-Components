----------------------------------------------------------
--! @file mux8togen
--! @mux 8 to generic  
-- Filename: mux8togen.vhd
-- Description: mux 8 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! Mux 8 to generic entity description

--! Detailed description of this
--! mux 8 to generic design element.
ENTITY mux8togen IS
	GENERIC (width: INTEGER :=4);
   PORT (
	din0 :  IN	std_logic_vector(width-1 downto 0);	--! input 0 of mux
	din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
	din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
	din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
	din4 :  IN	std_logic_vector(width-1 downto 0);	--! input 4 of mux
	din5 :  IN  std_logic_vector(width-1 downto 0);	--! input 5 of mux
	din6 :  IN	std_logic_vector(width-1 downto 0);	--! input 6 of mux
	din7 :  IN	std_logic_vector(width-1 downto 0);	--! input 7 of mux
	sel	:	IN std_logic_vector(2 downto 0);		--! selection of mux
	dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);
END ENTITY mux8togen;

--! @brief Architecture definition of mux8togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux8togen IS
BEGIN

PROCESS(din0,din1,din2,din3,din4,din5,din6,din7,sel) is
BEGIN
	case (sel) is
		when "000" => 
			dout <= din0;
		when "001" => 
			dout <= din1;
		when "010" => 
			dout <= din2;
		when "011" => 
			dout <= din3;
		when "100" => 
			dout <= din4;
		when "101" => 
			dout <= din5;
		when "110" => 
			dout <= din6;
		when "111" => 
			dout <= din7;
	end case;
END PROCESS;	
END ARCHITECTURE Behavioral;