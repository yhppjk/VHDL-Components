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

        );
        PORT(

        );
    END COMPONENT;


BEGIN
    UUT: pc
        GENERIC MAP (

        )
        PORT MAP (

        );
	clk_process: process
    begin
        clk <= not clk;
        wait for 5 ns;

    END PROCESS clk_process;




END ARCHITECTURE behavior;