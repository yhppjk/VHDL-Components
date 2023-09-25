----------------------------------------------------------
--! @file wrpc_tb
--! @A write to pc testbench
-- Filename: wrpc.vhd
-- Description: A write to pc testbench
-- Author: YIN Haoping
-- Date: May 4, 2023
----------------------------------------------------------
--! Use standard libraryLIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY wrpc_tb IS
END ENTITY;

ARCHITECTURE behavior OF wrpc_tb IS
    -- Component declaration
    COMPONENT wrpc1
        PORT(
            input_JB : IN std_logic;
            input_XZ : IN std_logic;
            input_XN : IN std_logic;
            input_XF : IN std_logic;
            alu_z    : IN std_logic;
            alu_n    : IN std_logic;
            alu_c    : IN std_logic;
            wrpc_out : OUT std_logic
        );
    END COMPONENT;
	
    COMPONENT wrpc
        PORT(
            input_JB : IN std_logic;
            input_XZ : IN std_logic;
            input_XN : IN std_logic;
            input_XF : IN std_logic;
            alu_z    : IN std_logic;
            alu_n    : IN std_logic;
            alu_c    : IN std_logic;
            wrpc_out : OUT std_logic
        );
    END COMPONENT;
    -- Signals
    SIGNAL input_JB : std_logic;
    SIGNAL input_XZ : std_logic;
    SIGNAL input_XN : std_logic;
    SIGNAL input_XF : std_logic;
    SIGNAL alu_z    : std_logic;
    SIGNAL alu_n    : std_logic;
    SIGNAL alu_c    : std_logic;
    SIGNAL wrpc_out : std_logic;

BEGIN
    -- Component instantiation
    UUT: wrpc1
        PORT MAP (
            input_JB => input_JB,
            input_XZ => input_XZ,
            input_XN => input_XN,
            input_XF => input_XF,
            alu_z    => alu_z,
            alu_n    => alu_n,
            alu_c    => alu_c,
            wrpc_out => wrpc_out
        );

    -- Testbench process
    PROCESS
    BEGIN
		
        -- Test cases
		--JAL
		input_JB <= '1'; input_XZ <= '0'; input_XN <= '0'; input_XF <= '1'; alu_z <= '1'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '0'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '0'; input_XF <= '1'; alu_z <= '0'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
		--BEQ&BNE
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '1'; alu_z <= '1'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '1'; alu_z <= '0'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
		input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '1'; alu_z <= '1'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
		
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
		input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '0'; alu_z <= '0'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
		input_JB <= '1'; input_XZ <= '1'; input_XN <= '0'; input_XF <= '0'; alu_z <= '1'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;		
		
		--BLT&BGE
		input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '1'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '1'; alu_z <= '0'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '1'; alu_z <= '1'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;		
		
		input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '0'; alu_z <= '1'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '0'; input_XN <= '1'; input_XF <= '0'; alu_z <= '0'; alu_n <= '1'; alu_c <= '0'; wait for 10 ns;
		
		--BLTU&BGEU
		input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '1'; alu_z <= '0'; alu_n <= '0'; alu_c <= '1'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '1'; alu_z <= '1'; alu_n <= '0'; alu_c <= '1'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '1'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
		
		input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '1'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        input_JB <= '1'; input_XZ <= '1'; input_XN <= '1'; input_XF <= '0'; alu_z <= '1'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
		
		--others
        input_JB <= '0'; input_XZ <= '0'; input_XN <= '0'; input_XF <= '0'; alu_z <= '0'; alu_n <= '0'; alu_c <= '0'; wait for 10 ns;
        -- Indicate the end of the test
        wait;
    END PROCESS;

END ARCHITECTURE;