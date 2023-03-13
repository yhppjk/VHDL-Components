--YIN Haoping
-- Simple counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_counter is
	GENERIC(
	MAX_COUNT : integer :=5
);
  port (
    clk : in std_logic;
    rst: IN std_logic := '1';
    count : out integer range 0 to MAX_COUNT;
    mcount: OUT std_logic :='0'
  );
end entity;

architecture Behavioral of simple_counter is

  signal count_sig : integer range 0 to MAX_COUNT := 0;
  signal mcount_sig : std_logic := '0';
  
begin

  count <= count_sig;
  mcount <= mcount_sig;

  -- counter
  process(clk, rst)
  begin
    if rst = '0' then
      count_sig <= 0;
      mcount_sig <= '0';
    elsif rising_edge(clk) then
      if count_sig > MAX_COUNT then
        mcount_sig <= '1';
		count_sig <= '0'
      else
        count_sig <= count_sig + 1;
		mcount_sig <= '0';
      end if;
    end if;
  end process;

end architecture;

