----------------------------------------------------------
--! @file addr_interface 
--! @A addr_interface  for calculation 
-- Filename: addr_interface .vhd
-- Description: A addr_interface  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! addr_interface  entity description

--! Detailed description of this
--! addr_interface  design element.
entity addr_interface  is

	port (
		clk :in std_logic;
		addr_i : in std_logic_vector(31 downto 0);
		WORDADDR_plus1 : out std_logic_vector(31 downto 0);
		WORDADDR : out std_logic_vector(31 downto 0);
		ALIGNMENT : out std_logic_vector(1 downto 0)
	);

end entity;

architecture behavioral of addr_interface  is
	constant addr_one : std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
BEGIN	
	process(addr_i)
		variable var_WORDADDR : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	begin
		var_WORDADDR := "00" & addr_i(31 downto 2);
		ALIGNMENT <= addr_i(1 downto 0);
		
		WORDADDR <= var_WORDADDR;
		WORDADDR_plus1 <= std_logic_vector(unsigned(var_WORDADDR)+ unsigned(addr_one));
	end process;
	
end architecture;






