----------------------------------------------------------
--! @file tristategen
--! @Tristate generic
-- Filename: tristategen.vhd
-- Description: Tristate generic
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--! Tristate entity description

--! Detailed description of this
--! Tristate design element.
ENTITY tristategen IS
   GENERIC	(
	width : POSITIVE := 4;			--! generaic data width 
	prop_delay : time := 0 ns		--! prop delay
);
   PORT (
	din : IN std_logic_vector(width-1 downto 0);	--! Tristate data input
	ena :  IN  std_logic;							--! Tristate enable input
	dout : OUT std_logic_vector(width-1 downto 0)	--! Tristate data output
);
END ENTITY tristategen;

--! @brief Architecture definition of Tristate
--! @details More details about this Tristate element.
ARCHITECTURE table OF tristategen IS
	constant stateZ : std_logic_vector(width-1 downto 0)  := (others => 'Z');
BEGIN	
    process(din)
    Begin
	if prop_delay = 0 ns then
	    if ena = '0' then
		dout <= din;
	    else
		dout <= stateZ;
	    end if;
	else 
	    if ena='0' then
		dout <= din after prop_delay;
	    else
		dout <= stateZ after prop_delay;
	    end if;
	end if;		
    end process;
END ARCHITECTURE table;
