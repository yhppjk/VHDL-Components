----------------------------------------------------------
--! @file generic_register
--! @Register file testbench file
-- Filename: generic_register.vhd
-- Description: Register file testbench file
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;

--! Detailed description of this
--! generic_register design element.
entity generic_register is
    generic (
        dataWidth : positive := 32		--! generic of datawidth
    );
	    port (
        clk         : in  std_logic;	--! the input port of clock
        reset       : in  std_logic;	--! the input port of reset
        enable  	: in  std_logic;	--! the input port of enable
        reg_in		: in  std_logic_vector(dataWidth-1 downto 0);	--! the input port of register
        reg_out     : out std_logic_vector(dataWidth-1 downto 0)	--! the output port of register
    );
	
end entity generic_register;

--! @brief Architecture definition of generic_register
--! @details More details about this generic_register element.
architecture behavior of generic_register is
begin
--! @brief reset & write_process
--! @details reset & write_process
    process(clk, reset)
    begin
		if reset = '1' then	
			reg_out <= (others => '0');
		elsif rising_edge(clk) then
			if enable ='1' then
				reg_out <= reg_in;
			end if;
		end if;
    end process;
end architecture behavior;
