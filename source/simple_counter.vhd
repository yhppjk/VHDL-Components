----------------------------------------------------------
--! @file simple_counter
--! @A simple counter can count till a certain limit with reset
-- Filename: simple_counter.vhd
-- Description: A simple counter can count till a certain limit with reset
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! simple_counter entity description

--! Detailed description of this
--! simple_counter design element.
entity simple_counter is
	GENERIC(
	MAX_COUNT : integer :=31;
	prop_delay : time := 0 ns
);
  port (
    clk : in std_logic;
    rst: IN std_logic := '1';
    count : out integer range 0 to MAX_COUNT;
    mcount: OUT std_logic :='0'
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
    --! @details the step is 1 second
    process(clk, rst)
    variable temp : natural :=0;
		begin
		if rst = '0' then
			count_sig <= 0;
			mcount_sig <= '0';
		elsif rising_edge(clk) then
			if count_sig = MAX_COUNT then
				if prop_delay = 0 ns then
					mcount_sig <= '1';
				else 
					mcount_sig <= '1' after prop_delay;
				end if;		
			else
				if prop_delay = 0 ns then
					count_sig <= count_sig + 1;
				else 
					count_sig <= count_sig + 1 after prop_delay;
				end if;	
				mcount_sig <= '0';
			end if;
		end if;
	
	end process;
	
	mcount <= mcount_sig;
	count <= count_sig;
end architecture;


