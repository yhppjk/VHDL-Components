--------------------------------------------------------
--! @file decoder_tb.vhd
--! @Testbench for the decoder
-- Filename: decoder_tb.vhd
-- Description: Testbench for the decoder.
-- Author: YIN Haoping
-- Date: April 19, 2023
--------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder_tb IS
END ENTITY decoder_tb;

ARCHITECTURE behavior OF decoder_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decoder
    PORT(
         commande : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         ena_dec : IN  std_logic;
         selop : OUT  std_logic_vector(3 downto 0);
         mux1 : OUT  std_logic;
         mux2 : OUT  std_logic_vector(1 downto 0);
         outputs : OUT  std_logic_vector(31 downto 0);
         ena_write : OUT  std_logic
        );
    END COMPONENT;

    -- Test signals
    SIGNAL tb_commande : std_logic_vector(31 downto 0);
    SIGNAL clk : std_logic := '0';
    SIGNAL tb_ena_dec : std_logic := '1';

    -- Output signals
    SIGNAL tb_selop : std_logic_vector(3 downto 0) := (others =>'0');
    SIGNAL tb_mux1 : std_logic:= '0';
    SIGNAL tb_mux2 : std_logic_vector(1 downto 0):= (others =>'0');
    SIGNAL tb_outputs : std_logic_vector(31 downto 0):= (others =>'0');
    SIGNAL tb_ena_write : std_logic := '1';

    -- Clock period
    constant clk_period : time := 10 ns;

BEGIN
    -- Instantiate the decoder
    UUT: decoder
        PORT MAP (
            commande => tb_commande,
            clk => clk,
            ena_dec => tb_ena_dec,
            selop => tb_selop,
            mux1 => tb_mux1,
            mux2 => tb_mux2,
            outputs => tb_outputs,
            ena_write => tb_ena_write
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= not clk;
        wait for 10 ns;

    END PROCESS clk_process;	

    -- Test stimulus process
    stimulus_process : PROCESS
    BEGIN

	
		tb_commande <= x"0000_00_00";
		wait for 100 ns;

        -- Test case: ADDI instruction
        tb_commande <= x"0020_83_93";
        WAIT FOR 100 ns;
        
        tb_commande <= x"4bca_aa_93";
        WAIT FOR 100 ns;
        
        -- Test case: SLTIU instruction
        -- Add your test cases here

        -- Test case: XORI instruction
        -- Add your test cases here
        
        -- Test case: ORI instruction
        -- Add your test cases here
        
        -- Test case: ANDI instruction
        -- Add your test cases here
        
        -- Test case: SLLI instruction
        -- Add your test cases here
        
        -- Test case: SRLI & SRAI instruction
        -- Add your test cases here
        
        -- Test cases for other instruction types (R, S, U, J)
        -- Add your test cases here


		ASSERT false
		REPORT "Simulation ended ( not a failure actually ) "
			SEVERITY failure;
		WAIT FOR 10 ns;

    END PROCESS stimulus_process;

END ARCHITECTURE behavior;
