library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity generic_decoder is
    generic (
        addressWidth : positive
    );
    port (
        addr   : in  std_logic_vector(addressWidth-1 downto 0);
        enable : in  std_logic;
        selects : out std_logic_vector(2**addressWidth-1 downto 0)
    );
end entity generic_decoder;

architecture behavior of generic_decoder is
begin
    process(enable, addr)
    begin
        if enable = '1' then
            selects <= (others => '0');
            selects(to_integer(unsigned(addr))) <= '1';
        else
            selects <= (others => '0');
        end if;
    end process;
end architecture behavior;

