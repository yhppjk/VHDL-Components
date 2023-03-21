----------------------------------------------------------
--! @file generic_decoder
--! @A generic_decoder can combine multipal counter to count.
-- Filename: generic_decoder.vhd
-- Description: A generic_decoder can combine multipal counter to count.
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! generic_decoder entity description

--! Detailed description of this
--! generic_decoder design element.
entity generic_decoder is
    generic (
		addressWidth : positive := 5;		--! generic of address width    
		);
	port (
		address : in  std_logic_vector(addressWidth-1 downto 0);  	--！the input port of address
		enable : in  std_logic := '1';								--! the input port of enable 
        selects : out std_logic_vector(2**addressWidth-1 downto 0)	--! the output port of selects
	);
end entity generic_decoder;

--! @brief Architecture definition of generic_decoder
--! @details More details about this generic_decoder element.
architecture behavior of generic_decoder is
begin
	decoder: process(enable,address)
		begin
		selects <= (others => '0');
		if enable ='1' then
			selects(to_integer(unsigned(address))) <= '1';
		end if;
	end process;
end architecture behavior;