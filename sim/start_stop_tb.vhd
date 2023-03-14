
--!YIN Haoping
--start_stop_tb
library ieee;
use ieee.std_logic_1164.all;
USE work.start_stop_pkg.ALL;
ENTITY start_stop_tb IS
END ENTITY start_stop_tb;



ARCHITECTURE Behavioral OF start_stop_tb IS


CONSTANT MAKE_LEVEL_CONST : std_logic := '0';
--INPUTS
SIGNAL clk : std_logic := '0';
SIGNAL rst : std_logic := '0';
SIGNAL ena : std_logic := '0';
SIGNAL pulse_in : std_logic := '0';
--output
SIGNAL start_stop1 : std_logic;

BEGIN
	dut: start_stop GENERIC map(MAKE_LEVEL => MAKE_LEVEL_CONST)
	PORT map(
	ena => ena,
	rst => rst,
	clk => clk,
	pulse_in => pulse_in,
	start_stop =>start_stop1
	);

clock : PROCESS
BEGIN
	
	clk <= '0';
	WAIT FOR 10 ns;
 	clk <= '1';
	WAIT FOR 10 ns;
END PROCESS;

proc2 : PROCESS
BEGIN
--1st 50clocks
	FOR i in 1 to 5 LOOP
	rst <= '0';
	ena <= '0';
		FOR j in 1 to 2 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
		
		FOR j in 1 to 3 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 3 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 2 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
	END LOOP;

--2nd 50clocks
	FOR i in 1 to 5 LOOP
	rst <= '0';
	ena <= '1';
		FOR j in 1 to 2 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
		
		FOR j in 1 to 3 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 3 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 2 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
	END LOOP;

--3rd 50clocks
	FOR i in 1 to 5 LOOP
	rst <= '1';
	ena <= '0';
		FOR j in 1 to 2 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
		
		FOR j in 1 to 3 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 3 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 2 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
	END LOOP;

--4th 50clocks
	FOR i in 1 to 5 LOOP
	rst <= '1';
	ena <= '1';
		FOR j in 1 to 2 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
		
		FOR j in 1 to 3 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 3 LOOP
		pulse_in <= not(MAKE_LEVEL_CONST);
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;

		FOR j in 1 to 2 LOOP
		pulse_in <= MAKE_LEVEL_CONST;
		wait until rising_edge(clk);
		END LOOP;
		WAIT FOR 2 ns;
	END LOOP;

	ASSERT false
		  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure;
	WAIT FOR 10 ns;
END PROCESS;



END ARCHITECTURE;



