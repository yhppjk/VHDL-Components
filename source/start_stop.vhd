----------------------------------------------------------
--! @file start_stop
--! @A FSM contains 5 different stats
-- Filename: start_stop.vhd
-- Description: A FSM contains 5 different stats
-- Author: YIN Haoping
-- Date: March 24, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY start_stop IS
	GENERIC(
	MAKE_LEVEL: std_logic :='0';
	prop_delay : time := 0 ns
);
	PORT(
	rst: IN  std_logic ;
	clk: IN  std_logic ;
	ena: IN  std_logic ;
	pulse_in: IN std_logic;
	start_stop: OUT std_logic;
	stateMake:  OUT std_logic
);
END ENTITY start_stop;

ARCHITECTURE Behavioral OF start_stop IS
	TYPE state_type is(start, makeA, makeB, brakeA, brakeB);
	signal current_state, next_state : state_type := start;
	signal start_stop_output : std_logic := '0';


BEGIN
	start_stop<=start_stop_output;

--State Machine 
PROCESS(clk,rst,ena)
	--variable next_state : state_type := start;
BEGIN
	IF rst ='1' THEN
	current_state <= start;
	ELSIF rising_edge(clk) THEN
		IF ena='1' THEN
			if prop_delay = 0 ns then
				current_state <= next_state;
			else
				current_state <= next_state after prop_delay;
			end if;
		END IF;
	END IF;	
END PROCESS;


--Storage state
PROCESS(current_state,pulse_in)
BEGIN
	CASE current_state IS
	WHEN start=>
		REPORT" stStart, output 0 ";
		start_stop_output <= '0';
		stateMake <= '0';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeA;
		ELSIF	pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeA;
		END IF;
	WHEN makeA=>
		REPORT" stMakeA, output 0 ";
		start_stop_output <='0';
		stateMake <= '1';
		IF pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeA;
		ELSE
			next_state <= makeA;
		END IF;
	WHEN brakeA=>
		REPORT" stBrakeA, output 0 ";
		start_stop_output <='0';
		stateMake <= '0';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeB;
		ELSE
			next_state <= brakeA;
		END IF;
	WHEN makeB=>
		REPORT" stMakeB, output 1 ";
		start_stop_output <='1';
		stateMake <= '1';
		IF pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeB;
		ELSE
			next_state <= makeB;
		END IF;
	WHEN brakeB=>
		REPORT" stBrakeB, output 1 ";
		start_stop_output <='1';
		stateMake <= '0';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeA;
		ELSE
			next_state <= brakeB;
		END IF;
	END CASE;

END PROCESS;
END ARCHITECTURE;
	