----------------------------------------------------------
--! @file
--! @decoder 3 to 8 interger
-- Filename: dec3to8i.vhd
-- Description: decoder 3 to 8 interger
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;

--! Decoder entity description

--! Detailed description of this
--! decoder design element.
ENTITY dec3to8i IS
   PORT (
	din : IN integer range 0 to 7;	--! dec3to8i data input.
	dout : OUT std_logic_vector(7 downto 0)	--! dec3to8i data output.
);
END ENTITY dec3to8i;

--! @brief Architecture definition of dec3to8i
--! @details More details about this decoder element.
ARCHITECTURE table OF dec3to8i IS
BEGIN
   List: PROCESS (din) IS 
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 7 LOOP
	dout(i) <= '0';
	END LOOP loop1;
	dout(din) <= '1';
   END PROCESS List;
END ARCHITECTURE table;
