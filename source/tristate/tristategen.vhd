----------------------------------------------------------
--! @file
--! @Tristate generic
-- Filename: tristategen.vhd
-- Description: Tristate generic
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
USE ieee.std_logic_1164.ALL;
--! Tristate entity description

--! Detailed description of this
--! Tristate design element.
ENTITY tristategen IS
   GENERIC	(
	width : POSITIVE := 3
);
   PORT (
	din : IN std_logic_vector(width-1 downto 0);	--! Tristate data input
	ena :  IN  std_logic;							--! Tristate enable input
	dout : OUT std_logic_vector(width-1 downto 0)	--! Tristate data output
);
END ENTITY tristategen;

--! @brief Architecture definition of Tristate
--! @details More details about this Tristate element.
ARCHITECTURE table OF tristategen IS

BEGIN
	dout <= din when (ena = '0') else "ZZZZ";
END ARCHITECTURE table;
