----------------------------------------------------------
--! @file mux8to1
--! @mux 8 to single 
-- Filename: mux8to1.vhd
-- Description: mux 8 to single  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 8 to 1 entity description

--! Detailed description of this
--! mux 8 to single design element.
ENTITY mux8to1 IS
	PORT (
		din0 :  IN	std_logic;	--! input 0 of mux
		din1 :  IN  std_logic;	--! input 1 of mux
		din2 :  IN	std_logic;	--! input 2 of mux
		din3 :  IN	std_logic;	--! input 3 of mux
		din4 :  IN	std_logic;	--! input 4 of mux
		din5 :  IN  std_logic;	--! input 5 of mux
		din6 :  IN	std_logic;	--! input 6 of mux
		din7 :  IN	std_logic;	--! input 7 of mux
		sel	:	IN std_logic_vector(2 downto 0);		--! selection of mux
		dout : OUT std_logic		--! output of mux
);
END ENTITY mux8to1;

--! @brief Architecture definition of mux8to1
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux8to1 IS
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