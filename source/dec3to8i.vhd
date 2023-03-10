
--YIN Haoping
--declaration
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dec3to8i IS
   PORT (
	din : IN integer range 0 to 7;
	dout : OUT std_logic_vector(7 downto 0)
);
END ENTITY dec3to8i;
--Architecture of dec3to8i
ARCHITECTURE table OF dec3to8i IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 7 LOOP
	dout(i) <= '0';
	END LOOP loop1;

	dout(din) <= '1';
	--dout <= (others =>'0');

   END PROCESS List;
END ARCHITECTURE table;
