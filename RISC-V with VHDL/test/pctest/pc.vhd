----------------------------------------------------------
--! @file pc
--! @A pc for calculation 
-- Filename: pc.vhd
-- Description: A pc 
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! pc entity description

--! Detailed description of this
--! pc design element.
entity pc is
	generic(
		datawidth : integer :=32
	);
	port (
		clk: IN  std_logic;
		reset : in std_logic;
		ena_in: in std_logic;
		data_in : in std_logic_vector(datawidth-1 downto 0);
		ena_pc : in std_logic;
		current_pc : out std_logic_vector(datawidth-1 downto 0)
	);

end entity;

architecture behavioral of pc is

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