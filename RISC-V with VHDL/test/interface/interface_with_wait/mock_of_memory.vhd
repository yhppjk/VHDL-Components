----------------------------------------------------------
--! @file mock_of_memory 
--! @A mock_of_memory  for calculation 
-- Filename: mock_of_memory   
-- Description: A mock_of_memory   
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! mock_of_memory  entity description

--! Detailed description of this
--! mock_of_memory  design element.
entity mock_of_memory is
	generic(num_wait : integer := 0)
	port(
		PADDR: IN std_logic_vector(31 downto 0);
		PWDATA : IN std_logic_vector(31 downto 0);
		PSEL : IN std_logic;
		clk : IN std_logic;

		PREADY : OUT std_logic;
		PRDATA : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavioral of mock_of_memory is
begin
	PREADY <= '0';
	wait until rising_edge(clk);
	for i in 0 to num_wait-1 loop
		wait until rising_edge(clk);
	end loop;
	PREADY <= '1';
end architecture; -- behavioral