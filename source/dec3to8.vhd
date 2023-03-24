----------------------------------------------------------
--! @file dec3to8
--! @decoder 3 to 8 
-- Filename: dec3to8.vhd
-- Description: decoder 3 to 8 
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! Decoder entity description

--! Detailed description of this
--! decoder design element.
ENTITY dec3to8 IS
   PORT (
	din :  IN  std_logic_vector(2 downto 0);	--! dec3to8 data input.
	dout : OUT std_logic_vector(7 downto 0)		--! dec3to8 data output.
);
END ENTITY dec3to8;


--! @brief Architecture definition of dec3to8i
--! @details More details about this decoder element.
ARCHITECTURE table OF dec3to8 IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 7 LOOP
	dout(i) <= '0';
	END LOOP loop1;
	dout(to_integer(unsigned(din))) <= '1';
   END PROCESS List;
END ARCHITECTURE table;
