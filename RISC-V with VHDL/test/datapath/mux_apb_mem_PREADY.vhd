----------------------------------------------------------
--! @file mux_apb_mem_PREADY
--! @mux PRDATA to generic 
-- Filename: mux_apb_mem_PREADY.vhd
-- Description: mux 4 to generic  
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.apb_slavedec_pkg.all;
--! MUX 4 to 1 entity description

--! Detailed description of this
--! mux 4 to generic design element.
ENTITY mux_apb_mem_PREADY IS
	GENERIC (
		prop_delay : time := 0 ns		--! prop delay
);
	
	PORT (
		din0 :  IN	std_logic;	--! input 0 of mux
		din1 :  IN  std_logic;	--! input 1 of mux
		din2 :  IN	std_logic;	--! input 2 of mux
		--din3 :  IN	std_logic(width-1 downto 0);	--! input 3 of mux
		sel	:	IN  integer ;	--! selection of mux
		dout : OUT std_logic	--! output of mux
);
END ENTITY mux_apb_mem_PREADY;

--! @brief Architecture definition of mux_apb_mem_PREADY
--! @details More details about this multiplexer.
ARCHITECTURE Behavioral OF mux_apb_mem_PREADY IS
BEGIN
	no_delay: if prop_delay = 0 ns generate
		PROCESS(din1,din2,din0,sel) is
		BEGIN
			case(sel) is 
			when 0 =>
				dout <= din0;
			when 1 =>
				dout <= din1;
			when 2 =>
				dout <= din2;
			when others =>
				dout <= 'X';
			end case;
		END PROCESS;
	end generate no_delay;

	with_delay:	if prop_delay /= 0 ns generate
		PROCESS(din1,din2,din0,sel) is
		BEGIN
			case(sel) is 
			when 0 =>
				dout <= din0 after prop_delay;
			when 1 =>
				dout <= din1 after prop_delay;
			when 2 =>
				dout <= din2 after prop_delay;
			when others =>
				dout <= 'X' after prop_delay;
			end case;
		END PROCESS;
	end generate with_delay;
END ARCHITECTURE Behavioral;