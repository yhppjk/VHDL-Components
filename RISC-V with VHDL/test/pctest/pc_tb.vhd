----------------------------------------------------------
--! @file pc
--! @A pc for calculation 
-- Filename: pc.vhd
-- Description: A pc 
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pc_tb IS
END ENTITY;

ARCHITECTURE behavior OF pc_tb IS
    COMPONENT pc
        GENERIC(
            datawidth : INTEGER := 32
        );
        PORT(
			clk		  : IN  std_logic;
            reset     : IN  std_logic;
            ena_in    : IN  std_logic;
            data_in   : IN  std_logic_vector(31 DOWNTO 0);
            ena_pc    : IN  std_logic;
            current_pc: OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;
	signal clk : std_logic := '0';
    SIGNAL reset     : std_logic;
    SIGNAL ena_in    : std_logic;
    SIGNAL data_in   : std_logic_vector(31 DOWNTO 0);
    SIGNAL ena_pc    : std_logic;
    SIGNAL current_pc: std_logic_vector(31 DOWNTO 0);

BEGIN
    UUT: pc
        GENERIC MAP (
            datawidth => 32
        )
        PORT MAP (
			clk => clk,
            reset     => reset,
            ena_in    => ena_in,
            data_in   => data_in,
            ena_pc    => ena_pc,
            current_pc=> current_pc
        );
	clk_process: process
    begin
        clk <= not clk;
        wait for 5 ns;

    END PROCESS clk_process;


    PROCESS
    BEGIN
        reset <= '1';
        ena_in <= '0';
        ena_pc <= '0';
        wait for 10 ns;
        reset <= '0';
        ena_in <= '1';
        data_in <= "00000000000000000000000000001010";
        wait for 10 ns;
        ena_in <= '0';
        ena_pc <= '1';
        wait for 50 ns;
        ena_pc <= '0';
        wait for 10 ns;
        ena_pc <= '1';
        wait for 10 ns;
        ena_pc <= '0';
		
        ASSERT false
		REPORT "Simulation ended ( not a failure actually ) "
			SEVERITY failure;
		WAIT FOR 10 ns;
    END PROCESS;

END ARCHITECTURE behavior;