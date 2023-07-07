----------------------------------------------------------
--! @file size_interface 
--! @A size_interface  for calculation 
-- Filename: size_interface .vhd
-- Description: A size_interface  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! size_interface  entity description

--! Detailed description of this
--! size_interface  design element.
entity size_interface  is

	port (
		size_i : IN std_logic_vector(1 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		
		BYTESTRB_3_0 : OUT std_logic_vector(3 downto 0);
		BYTESTRB_7_4: OUT std_logic_vector(3 downto 0);
		or_output : OUT std_logic
	);

end entity;

architecture behavioral of size_interface  is

BEGIN	
	process (size_i, ALIGNMENT)
		variable var_SIZESTRB : std_logic_vector(7 downto 0);
		variable var_BYTESTRB : std_logic_vector(7 downto 0);		
	begin
		case size_i is
			when "00" =>
				var_SIZESTRB := "00000001";
			when "01" =>
				var_SIZESTRB := "00000011";
			when "10" => 
				var_SIZESTRB := "00001111";
			when "11" => 
				var_SIZESTRB := "00001111";
			when others =>
				var_SIZESTRB := (others =>'0');
		end case;
		
		case ALIGNMENT is
			when "00" =>
				var_BYTESTRB := var_SIZESTRB;
			when "01" =>
				var_BYTESTRB := var_SIZESTRB(6 downto 0) & '0';
			when "10" =>
				var_BYTESTRB := var_SIZESTRB(5 downto 0) & "00";
			when "11" =>
				var_BYTESTRB := var_SIZESTRB(4 downto 0) & "000";
			when others =>
				var_BYTESTRB := (others => '0');
		end case;

		BYTESTRB_3_0 <= var_BYTESTRB(3 downto 0);
		BYTESTRB_7_4 <= var_BYTESTRB(7 downto 4);
		or_output <= var_BYTESTRB(7) or var_BYTESTRB(6) or var_BYTESTRB(5) or var_BYTESTRB(4);
	end process;

end architecture;
