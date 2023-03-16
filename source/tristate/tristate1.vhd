----------------------------------------------------------
--! @file
--! @Tristate 1
-- Filename: tristate1.vhd
-- Description: Tristate 1
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
ENTITY tristate1 IS

   PORT (
	din : IN std_logic;			--! Tristate data input
	ena :  IN  std_logic;		--! Tristate enable input
	dout : OUT std_logic		--! Tristate data output
);
END ENTITY tristate1;

--! @brief Architecture definition of Tristate
--! @details More details about this Tristate element.
ARCHITECTURE table OF tristate1 IS

BEGIN
	dout <= din when (ena = '0') else 'Z';
END ARCHITECTURE table;
