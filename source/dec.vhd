
--YIN Haoping
--declaration
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY dec IS
   GENERIC	(
	width : POSITIVE := 3
);
   PORT (
	din :  IN  std_logic_vector(width-1 downto 0);
	dout : OUT std_logic_vector(2**width-1 downto 0)
);
END ENTITY dec;
--Architecture of dec
ARCHITECTURE table OF dec IS

BEGIN
   List: PROCESS (din) IS -- inside the brackets is the sensitivity list
	VARIABLE i: NATURAL :=0;
   BEGIN
	loop1 : FOR i IN 0 to 2**width-1 LOOP
	dout(i) <= '0';
	END LOOP loop1;

	dout(to_integer(unsigned(din))) <= '1';
	--dout <= (others =>'0');

   END PROCESS List;
END ARCHITECTURE table;
