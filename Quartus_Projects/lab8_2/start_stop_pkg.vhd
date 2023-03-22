--YIN Haoping
--Start_stop_pkg

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE start_stop_pkg IS
COMPONENT start_stop IS
	GENERIC (
	MAKE_LEVEL : std_logic := '0'
);
	PORT(
		rst: IN std_logic;
		clk: IN std_logic;
		ena: IN std_logic := '0';
		pulse_in : IN std_logic;
		start_stop: OUT std_logic;
		stateMake:  OUT std_logic
);
END COMPONENT start_stop;
END PACKAGE start_stop_pkg;
