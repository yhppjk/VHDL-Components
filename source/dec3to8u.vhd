----------------------------------------------------------
--! @file
--! @decoder 3 to 8 unsigned
-- Filename: dec3to8u.vhd
-- Description: decoder 3 to 8 unsigned
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! Decoder entity description

--! Detailed description of this
--! decoder design element.
ENTITY dec3to8u IS
	generic(
		prop_delay : time := 0 ns		--! prop delay
);
    PORT (
	din :  IN  unsigned(2 downto 0);	--! dec3to8u data input
	dout : OUT std_logic_vector(7 downto 0)		--! dec3to8u data output
);
END ENTITY dec3to8u;

--! @brief Architecture definition of dec3to8u
--! @details More details about this decoder element.
ARCHITECTURE table OF dec3to8u IS
BEGIN
	List: PROCESS (din) IS --! inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
	BEGIN
		loop1 : FOR i IN 0 to 7 LOOP
			dout(i) <= '0';
		END LOOP loop1;
		if prop_delay = 0 ns then
			dout(to_integer(din)) <= '1';
		else
			dout(to_integer(din)) <= '1' after prop_delay;
		end if;   
    END PROCESS List;
END ARCHITECTURE table;