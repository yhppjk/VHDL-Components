----------------------------------------------------------
--! @file rdata_interface1 
--! @A rdata_interface1  for calculation 
-- Filename: rdata_interface1 .vhd
-- Description: A rdata_interface1  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! rdata_interface1  entity description

--! Detailed description of this
--! rdata_interface1  design element.
entity rdata_interface1  is

	port (
		PRDATA : IN std_logic_vector(31 downto 0);
		register_RDATA : IN std_logic_vector(31 downto 0);
		RDATA64A : out std_logic_vector(63 downto 0);
		RDATA64B : out std_logic_vector(63 downto 0);
		RDATA_reg :out std_logic_vector(31 downto 0)
	);

end entity;

architecture behavioral of rdata_interface1  is
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32 : std_logic_vector(31 downto 0) := (others => '0');
BEGIN	
	
	RDATA64A <= zeros32 & PRDATA;
	RDATA64B(31 downto 0) <= register_RDATA;
	RDATA64B(63 downto 32) <= PRDATA;
	RDATA_reg <= PRDATA;
end architecture;






