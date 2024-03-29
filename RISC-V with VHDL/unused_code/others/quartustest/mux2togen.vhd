----------------------------------------------------------
--! @file mux2togen
--! @mux 2 to generic 
-- Filename: mux2togen.vhd
-- Description: mux 2 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 2 to 1 entity description

--! Detailed description of this
--! mux 2 to generic design element.
ENTITY mux2togen IS
	GENERIC (
		width: INTEGER :=4;
		prop_delay : time := 0 ns		--! prop delay
);
	PORT (
		din0 :  IN  std_logic_vector(width-1 downto 0);	--! input 0 of mux
		din1 :  IN	std_logic_vector(width-1 downto 0);	--! input 1 of mux
		sel	:	IN std_logic;							--! selection of mux
		dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
);	
END ENTITY mux2togen;

--! @brief Architecture definition of mux2togen
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux2togen IS
BEGIN
	no_delay: if prop_delay = 0 ns generate
	dout <= din0 when sel = '0' else din1;
	end generate no_delay;

	with_delay:	if prop_delay /= 0 ns generate
	dout <= din0 after prop_delay when sel = '0' else din1 after prop_delay;
	end generate with_delay;
END ARCHITECTURE Behavioral;