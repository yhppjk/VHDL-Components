----------------------------------------------------------
--! @file rdata_interface2 
--! @A rdata_interface2  for calculation 
-- Filename: rdata_interface2 .vhd
-- Description: A rdata_interface2  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! rdata_interface2  entity description

--! Detailed description of this
--! rdata_interface2  design element.
entity rdata_interface2  is

	port (
		RDATA64 : IN std_logic_vector(63 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		unsigned_i : IN std_logic;		
		size_i : IN std_logic_vector(1 downto 0);
		rdata_o : OUT std_logic_vector(31 downto 0)


	);

end entity;

architecture behavioral of rdata_interface2  is

	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32 : std_logic_vector(31 downto 0) := (others => '0');
	constant ones8 : std_logic_vector(7 downto 0) := (others => '1');
	constant ones16 : std_logic_vector(15 downto 0) := (others => '1');
	
	signal signal_rdata : std_logic_vector(31 downto 0) := (others => '0');
	
BEGIN	
	process(RDATA64, ALIGNMENT, unsigned_i, size_i)
		variable var_rdata : std_logic_vector(31 downto 0) := (others => '0');
	begin
		case ALIGNMENT is
			when "00" =>						
				var_rdata := RDATA64(31 downto 0);
			when "01" =>
				var_rdata := RDATA64(39 downto 8);
			when "10" =>
				var_rdata := RDATA64(47 downto 16);
			when "11" =>
				var_rdata := RDATA64(55 downto 24);
			when others =>
				var_rdata := (others => '0');
		end case;
		signal_rdata <= var_rdata;
		case size_i is
			when "00" =>
				if unsigned_i = '1' then
					rdata_o <= zeros16 & zeros8 & var_rdata(7 downto 0);
				elsif unsigned_i = '0' then
					if var_rdata(7) = '1' then
						rdata_o <= ones16 & ones8 & var_rdata(7 downto 0);
					else
						rdata_o <= zeros16 & zeros8 & var_rdata(7 downto 0);
					end if;
				end if;
			when "01" =>
				if unsigned_i = '1' then
					rdata_o <= zeros16 & var_rdata(15 downto 0);
				elsif unsigned_i = '0' then
					if var_rdata(15) = '1' then
						rdata_o <= ones16 & var_rdata(15 downto 0);
					else
						rdata_o <= zeros16 & var_rdata(15 downto 0);
					end if;
				end if;
			when "10" =>
					rdata_o <= var_rdata(31 downto 0);
			when "11" =>
					rdata_o <= var_rdata(31 downto 0);
			when others =>
				rdata_o <= (others =>'0');
		end case;
		
		
	end process;
end architecture;






