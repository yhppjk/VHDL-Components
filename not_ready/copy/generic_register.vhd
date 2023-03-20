
library ieee;
use ieee.std_logic_1164.all;

entity generic_register is
    generic (
        dataWidth : positive := 32
    );
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        write_en  : in  std_logic;
        write_data: in  std_logic_vector(dataWidth-1 downto 0);
        q         : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity generic_register;

architecture behavior of generic_register is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if write_en = '1' then
                q <= write_data;
            end if;
        end if;
    end process;
end architecture behavior;
