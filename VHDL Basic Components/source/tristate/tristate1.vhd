----------------------------------------------------------
--! @file tristate1
--! @Tristate 1
-- Filename: tristate1.vhd
-- Description: Tristate 1
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--! Tristate entity description

--! Detailed description of this
--! Tristate design element.
ENTITY tristate1 IS
	GENERIC	(
		prop_delay : time := 0 ns		--! prop delay
);
	PORT (
		din : IN std_logic;			--! Tristate data input
		ena :  IN  std_logic;		--! Tristate enable input
		dout : OUT std_logic		--! Tristate data output
);
END ENTITY tristate1;

--! @brief Architecture definition of Tristate
--! @details More details about this Tristate element.
ARCHITECTURE table OF tristate1 IS

BEGIN		
    process(din)
    Begin
	if prop_delay = 0 ns then
	    if ena = '0' then
		dout <= din;
	    else
		dout <= 'Z';
	    end if;
	else 
	    if ena='0' then
		dout <= din after prop_delay;
	    else
		dout <= 'Z' after prop_delay;
	    end if;
	end if;		
    end process;
END ARCHITECTURE table;
