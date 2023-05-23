----------------------------------------------------------
--! @file mux1pc
--! @mux 2 to single 
-- Filename: mux1pc.vhd
-- Description: mux 2 to single  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! MUX 2 to 1 entity description

--! Detailed description of this
--! mux 2 to single design element.	
ENTITY mux1pc IS
	GENERIC	(
		prop_delay : time := 0 ns		--! prop delay
);
	PORT (
		din0 :  IN  std_logic;	--! input 0 of mux (rs1)
		din1 :  IN	std_logic;	--! input 1 of mux	(PC)
		sel	:	IN std_logic;							--! selection of mux
		dout : OUT std_logic		--! output of mux
);
END ENTITY mux1pc;

--! @brief Architecture definition of mux1pc
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux1pc IS
BEGIN    
	no_delay: if prop_delay = 0 ns generate
	dout <= din0 when sel = '0' else din1;
	end generate no_delay;

	with_delay: if prop_delay /= 0 ns generate
	dout <= din0 after prop_delay when sel = '0' else din1 after prop_delay;
	end generate with_delay;
END ARCHITECTURE Behavioral;