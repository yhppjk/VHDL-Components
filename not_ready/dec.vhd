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
	wdith_in : POSITIVE := 3;
	wdith_out : POSITIVE := 3
);
   PORT (
	din :  IN  std_logic_vector(wdith_in-1 downto 0);		--! dec data input
	ena : IN std_logic := '0';
	dout : OUT std_logic_vector(wdith_out-1 downto 0)	--! dec data output
);
END ENTITY dec;

--! @brief Architecture definition of dec
--! @details More details about this decoder element.
ARCHITECTURE table OF dec IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	if ena = '1' then
	loop1 : FOR i IN 0 to wdith_in-1 LOOP
	dout(i) <= '0';
	END LOOP loop1;
	dout(to_integer(unsigned(din))) <= '1';
	end if;
   END PROCESS List;
END ARCHITECTURE table;
