----------------------------------------------------------
--! @file
--! @A FSM contains 5 different stats
-- Filename: start_stop.vhd
-- Description: A FSM contains 5 different stats
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! start_stop entity description

--! Detailed description of this
--! start_stop design element.
ENTITY start_stop IS
	GENERIC(
	MAKE_LEVEL: std_logic :='0'		--! A condition to juge the output of the system
);
	PORT(
	rst: IN  std_logic ;		--! the reset signal input
	clk: IN  std_logic ;		--! the clock signal input, high-level active
	ena: IN  std_logic :='1';	--! the enable signal input, high-level active
	pulse_in: IN std_logic;		--! pulse input
	start_stop: OUT std_logic 	--! the relay output of FSM
);
END ENTITY start_stop;

--! @brief Architecture definition of start_stop
--! @details More details about this start_stop element
ARCHITECTURE Behavioral OF start_stop IS
	TYPE state_type is(start, makeA, makeB, brakeA, brakeB); 	--! The different conditions' definition 
	signal current_state, next_state : state_type := start;		--! 2 state signal in default condition
	signal start_stop_output : std_logic := '0';				--! the output signal
BEGIN
	start_stop<=start_stop_output;


--! @brief Condition process
--! @details with the clk and rst detected, the process will react in different ways
  
PROCESS(clk,rst,ena)
	--variable next_state : state_type := start;
BEGIN
	IF rst ='1' THEN
	current_state <= start;
	ELSIF rising_edge(clk) THEN
		IF ena='1' THEN
		current_state <= next_state;
		END IF;
	END IF;
END PROCESS;

--! @brief  process
--! @details with the different current_state and pulse_in, the FSM will transfer to different states
PROCESS(current_state,pulse_in)
BEGIN
	CASE current_state IS
	WHEN start=>
		REPORT" stStart, output 0 ";
		start_stop_output <= '0';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeA;
		ELSIF	pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeA;
		END IF;
	WHEN makeA=>
		REPORT" stMakeA, output 0 ";
		start_stop_output <='0';
		IF pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeA;
		ELSE
			next_state <= makeA;
		END IF;
	WHEN brakeA=>
		REPORT" stBrakeA, output 0 ";
		start_stop_output <='0';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeB;
		ELSE
			next_state <= brakeA;
		END IF;
	WHEN makeB=>
		REPORT" stMakeB, output 1 ";
		start_stop_output <='1';
		IF pulse_in = not(MAKE_LEVEL) THEN
			next_state <= brakeB;
		ELSE
			next_state <= makeB;
		END IF;
	WHEN brakeB=>
		REPORT" stBrakeB, output 1 ";
		start_stop_output <='1';
		IF pulse_in = MAKE_LEVEL THEN
			next_state <= makeA;
		ELSE
			next_state <= brakeB;
		END IF;
	END CASE;

END PROCESS;

END ARCHITECTURE;
	