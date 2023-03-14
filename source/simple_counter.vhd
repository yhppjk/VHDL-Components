----------------------------------------------------------
--! @file
--! @A simple counter can count till a certain limit with reset
-- Filename: simple_counter.vhd
-- Description: A simple counter can count till a certain limit with reset
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;


--! simple_counter entity description

--! Detailed description of this
--! simple_counter design element.
entity simple_counter is
	GENERIC(
	MAX_COUNT : integer :=5		--! the limit of simple_counter
);
  port (
    clk : in std_logic;		--! the clock signal input
    rst: IN std_logic := '1';	--! the reset signal input
    count : out integer range 0 to MAX_COUNT;	--! the count number output
    mcount: OUT std_logic :='0'		--! Output to figure if the counter reach the limit
  );
end entity;

--! @brief Architecture definition of simple_counter
--! @details More details about this simple_counter element.
architecture Behavioral of simple_counter is

  signal count_sig : integer range 0 to MAX_COUNT := 0;		--! signal to transfer count number in the entity
  signal mcount_sig : std_logic := '0';		--! signal to transfer if counter reach limit in the entity
  
begin
	
  --! @brief counter process
  --! @details with the clk and rst detected, the process will react in different ways
  process(clk, rst)
  begin
    if rst = '0' then	--! an asynchrony reset
      count_sig <= 0;
      mcount_sig <= '0';
    elsif rising_edge(clk) then
	
      if count_sig = MAX_COUNT then
        mcount_sig <= '1';
      else
        count_sig <= count_sig + 1;
	mcount_sig <= '0';
      end if;
    end if;
	
  end process;
  
  --! @brief transfer mcount process
  --! @details transfer the mcount signal to output
  process(mcount_sig)
begin
	mcount <= mcount_sig;
  end process;
  
  --! @brief transfer count process
  --! @details transfer the count signal to output
  process(count_sig)
begin
	count <= count_sig;
  end process;
end architecture;

