----------------------------------------------------------
--! @file cascadable_counter
--! @Tristate generic
-- Filename: cascadable_counter.vhd
-- Description: Cascadable counter vhdl code
-- Author: YIN Haoping
-- Date: March 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--read risc-V standard
-- get a list of operations in calculation units
--rv32I chapter 2






--! cascadable_counter entity description

--! Detailed description of this
--! cascadable_counter design element.
--! running by clock, with reset and enable port,
--! cout and cin to send and receive a signal to run the other level counter.
ENTITY cascadable_counter IS
	GENERIC(
		MAX_COUNT: POSITIVE :=10;	--! generic limit of counter
		prop_delay : time := 0 ns
);
	PORT(
	rst: IN  std_logic ;		--! reset input port 
	clk: IN  std_logic ;		--! clock input port
	ena: IN  std_logic ; 		--! enable input port
	cin: IN  std_logic ;		--! count start signal input
	cout: OUT std_logic;		--! count start signal output
	count: OUT integer range 0 to MAX_COUNT		--! the result of counter
);
END ENTITY cascadable_counter;


--! @brief Architecture definition of cascadable_counter
--! @details More details about this cascadable_counter element.
ARCHITECTURE Behavioral OF cascadable_counter IS
	SIGNAL count_sig: integer range 0 to MAX_COUNT;
	SIGNAL cout_sig: std_logic :='0';
BEGIN
	count <= count_sig;
	cout <= cout_sig;
	
	
--! @brief cascadable_counter process
--! @details Cascadable counter will count by rising clock,
--! @details and send the result and signal to next counter.
--! @details when reset receive, it turns to 0.
PROCESS(clk, rst)
BEGIN
	IF rst = '1' THEN
		count_sig <=0;
	ELSIF rising_edge(clk) THEN
		IF ena = '1' AND cin ='1' THEN
			IF count_sig =MAX_COUNT THEN
				if prop_delay = 0 ns then
					count_sig <=0;
				else 
					count_sig <=0 after prop_delay;
				end if;	
			ELSE 
				if prop_delay = 0 ns then
					count_sig <= count_sig +1;
				else 
					count_sig <= count_sig +1 after prop_delay;
				end if;
			END IF;
		END IF;
	END IF;
END PROCESS;

--! @brief cout process
--! @details cout will be '1' when count reach the MAX_COUNT
PROCESS(count_sig)
BEGIN
	IF count_sig = MAX_COUNT THEN
		cout_sig <= '1';
	ELSE
		cout_sig<='0';
	END IF;
END PROCESS;

END ARCHITECTURE;
	