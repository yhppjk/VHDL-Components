----------------------------------------------------------
--! @file
--! @decoder to any
-- Filename: dec.vhd
-- Description: decoder any
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
ENTITY dec IS
   GENERIC	(
	width : POSITIVE := 3
);
   PORT (
	din :  IN  std_logic_vector(width-1 downto 0);		--! dec data input
	dout : OUT std_logic_vector(2**width-1 downto 0)	--! dec data output
);
END ENTITY dec;

--! @brief Architecture definition of dec
--! @details More details about this decoder element.
ARCHITECTURE table OF dec IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 2**width-1 LOOP
	dout(i) <= '0';
	END LOOP loop1;
	dout(to_integer(unsigned(din))) <= '1';
   END PROCESS List;
END ARCHITECTURE table;
