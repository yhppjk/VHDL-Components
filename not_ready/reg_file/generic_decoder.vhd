LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity generic_decoder is
    generic (
        addressWidth : positive
    );
	port (
		address : in  std_logic_vector(addressWidth-1 downto 0);
		enable : in  std_logic := '1';
        selects : out std_logic_vector(2**addressWidth-1 downto 0)
	);
end entity generic_decoder;

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