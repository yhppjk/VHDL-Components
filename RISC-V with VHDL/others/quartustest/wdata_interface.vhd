----------------------------------------------------------
--! @file wdata_interface 
--! @A wdata_interface  for calculation 
-- Filename: wdata_interface .vhd
-- Description: A wdata_interface  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! wdata_interface  entity description

--! Detailed description of this
--! wdata_interface  design element.
entity wdata_interface  is

	port (
		wdata_i : IN std_logic_vector(31 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		WDATA64_31_0 : OUT std_logic_vector(31 downto 0); 
		WDATA64_64_32 : OUT std_logic_vector(31 downto 0)
	);

end entity;

architecture behavioral of wdata_interface  is
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32 : std_logic_vector(31 downto 0) := (others => '0');
BEGIN	
	process(wdata_i, ALIGNMENT)
		variable var_wdata64 : std_logic_vector(63 downto 0) := (others => '0');
	begin
	
		var_wdata64 := zeros32 & wdata_i;
		case ALIGNMENT is 
			when "00" =>
				
			when "01" =>
				var_wdata64 := var_wdata64(55 downto 0)& zeros8;
			when "10" =>
				var_wdata64 := var_wdata64(47 downto 0)& zeros16;
			when "11" =>
				var_wdata64 := var_wdata64(39 downto 0)& zeros16 & zeros8;
			when others=>
				var_wdata64 := (others => '0');
		end case;
		WDATA64_31_0 <= var_wdata64(31 downto 0);
		WDATA64_64_32 <= var_wdata64(63 downto 32);
	end process;
end architecture;






