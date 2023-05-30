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
	generic(num_wait : integer := 2
);
	port(
		PADDR: IN std_logic_vector(29 downto 0);
		PWDATA : IN std_logic_vector(31 downto 0);
		PSEL : IN std_logic;
		clk : IN std_logic;

		PREADY : OUT std_logic;
		PRDATA : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavioral of mock_of_memory is
	type reg_file_t is array (0 to 63) of std_logic_vector(31 downto 0) ;
	signal memory : reg_file_t := (0 =>"01010101010101010101010101010101",others =>(others =>'0'));
    signal count : integer range 0 to num_wait;
begin
	PREADY <= '0' when count < num_wait else '1';
	
	main_process : process(clk)
	begin

		if PSEL = '0' then
			memory(to_integer(unsigned(PADDR))) <= PWDATA;
		elsif PSEL = '1' then
			PRDATA <= memory(to_integer(unsigned(PADDR)));
		end if;
		
		if count < num_wait then
			count <= count + 1;
		else
			count <= 0;
		end if;
	end process main_process;
	

	
end architecture; -- behavioral