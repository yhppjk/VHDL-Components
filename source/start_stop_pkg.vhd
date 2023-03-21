----------------------------------------------------------
--! @file start_stop_pkg
--! @A start_stop_pkg contains the component of start_stop
-- Filename: start_stop_pkg.vhd
-- Description: A start_stop_pkg contains the component of start_stop
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! start_stop_pkg package description

--! Detailed description of this
--! start_stop_pkg design element.
PACKAGE start_stop_pkg IS
COMPONENT start_stop IS
	GENERIC (
	MAKE_LEVEL : std_logic := '0'		--! A condition to judge the output of the system
);
	PORT(
		rst: IN std_logic;			--! the reset signal input
		clk: IN std_logic;			--! the clock signal input, high-level active
		ena: IN std_logic := '0';	--! the enable signal input, high-level active
		pulse_in : IN std_logic;	--! pulse input
		start_stop: OUT std_logic	--! the relay output of FSM
);
END COMPONENT start_stop;
END PACKAGE start_stop_pkg;
