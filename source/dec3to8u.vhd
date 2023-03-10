
--YIN Haoping
--declaration
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY dec3to8u IS
   PORT (
	din :  IN  unsigned(2 downto 0);
	dout : OUT std_logic_vector(7 downto 0)
);
END ENTITY dec3to8u;
--Architecture of dec3to8u
ARCHITECTURE table OF dec3to8u IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 7 LOOP
	dout(i) <= '0';
	END LOOP loop1;

	dout(to_integer(din)) <= '1';
	--dout <= (others =>'0');

   END PROCESS List;
END ARCHITECTURE table;
