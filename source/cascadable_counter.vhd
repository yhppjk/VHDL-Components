----------------------------------------------------------
--! @file
--! @A cascadable_counter can combine multipal counter to count.
-- Filename: cascadable_counter.vhd
-- Description: A cascadable_counter can combine multipal counter to count.
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! simple_counter entity description

--! Detailed description of this
--! cascadable_counter design element.
ENTITY cascadable_counter IS
	GENERIC(
		MAX_COUNT: POSITIVE :=10	--! the limit of the counter
);
	PORT(
	rst: IN  std_logic :='0';		--! the reset signal input  
	clk: IN  std_logic ;			--! the clock signal input
	ena: IN  std_logic :='1'; 		--! the enable signal input
	cin: IN  std_logic :='1';		--! the counter Carry in signal input
	cout: OUT std_logic;			--! the counter Carry out signal output
	count: OUT integer range 0 to MAX_COUNT		--! the cout signal output
);
END ENTITY cascadable_counter;

--! @brief Architecture definition of cascadable_counter
--! @details More details about this cascadable_counter element.
ARCHITECTURE Behavioral OF cascadable_counter IS
	SIGNAL count_sig: integer range 0 to MAX_COUNT;		--! --! signal to transfer count number in the entity 
	SIGNAL cout_sig: std_logic :='0';		--! signal to transfer the counter carry signal
BEGIN
	count <= count_sig;
	cout <= cout_sig;

--! @brief cascadable_counter process
  --! @details with the clk and rst detected, the process will react in different ways
PROCESS(clk, rst)
BEGIN
	IF rst = '1' THEN
		count_sig <=0;
	ELSIF rising_edge(clk) THEN
	IF ena = '1' AND cin ='1' THEN
		IF count_sig =MAX_COUNT THEN
			count_sig <=0;
		ELSE 
			count_sig <= count_sig +1;
		END IF;
	END IF;
	END IF;
END PROCESS;

  --! @brief transfer counter number signal process
  --! @details transfer the counter number signal to output
PROCESS(count_sig)
BEGIN
	IF count_sig = MAX_COUNT THEN
		cout_sig <= '1';
	ELSE
		cout_sig<='0';
	END IF;
END PROCESS;

END ARCHITECTURE;
	