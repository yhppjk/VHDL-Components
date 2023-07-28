----------------------------------------------------------
--! @file start_stop_tb
--! @ The testbench of FSM
-- Filename: start_stop_tb.vhd
-- Description: The testbench of FSM
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use start_stop_pkg
USE work.start_stop_pkg.ALL;

--! start_stop_tb entity description

--! Detailed description of this
--! start_stop_tb design element.
ENTITY start_stop_tb IS
END ENTITY start_stop_tb;

--! @brief Architecture definition of start_stop_tb
--! @details More details about this start_stop_tb element
ARCHITECTURE Behavioral OF start_stop_tb IS

CONSTANT MAKE_LEVEL_CONST : std_logic := '0'; --! Constant of make_level
CONSTANT prop_delay : time := 2 ns;
SIGNAL clk : std_logic := '0';		--! the signal transfer clock
SIGNAL rst : std_logic := '0';		--! the signal transfer reset
SIGNAL ena : std_logic := '0';		--! the signal transfer enable
SIGNAL pulse_in : std_logic := '0';	--! the signal of pulse_in

SIGNAL start_stop1 : std_logic;		--! the signal of output
BEGIN
	dut: start_stop GENERIC map(MAKE_LEVEL => MAKE_LEVEL_CONST)
	PORT map(
	ena => ena,
	rst => rst,
	clk => clk,
	pulse_in => pulse_in,
	start_stop =>start_stop1
	);
	
--! @brief Clock generation process
--! @details generate a clock signal
clock : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR 10 ns;
 	clk <= '1';
	WAIT FOR 10 ns;
END PROCESS;
--! @brief Test condition
--! @details To create different condition to test the code
proc2 : PROCESS
BEGIN
--! 1st 50clocks
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

--! 2nd 50clocks
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

--! 3rd 50clocks
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

--! 4th 50clocks
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



