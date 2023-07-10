----------------------------------------------------------
--! @file amba
--! @A program counter  
-- Filename: amba.vhd
-- Description: A program counter 
-- Author: YIN Haoping
-- Date: May 4, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;



--! amba entity description

--! Detailed description of this
--! amba design element.

entity amba is
	port(
		clk: IN  std_logic;
		reset : in std_logic;
	
	)
end entity;

architecture behavioral of amba is

    SIGNAL internal_pc : unsigned(datawidth-1 DOWNTO 0);
BEGIN
    PROCESS (clk)
    BEGIN
	
        IF reset = '1' THEN
            internal_pc <= (others => '0');
		elsif rising_edge(clk) then
			IF ena_pc = '1' THEN
				internal_pc <= internal_pc + 4;
			ELSIF ena_in = '1' THEN
				internal_pc <= unsigned(data_in);
			END IF;    
		end if;
    END PROCESS;
	current_pc <= std_logic_vector(internal_pc);

end architecture;