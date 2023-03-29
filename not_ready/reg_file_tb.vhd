----------------------------------------------------------
--! @file reg_file_tb
--! @A reg_file_tb can combine multipal counter to count.
-- Filename: reg_file_tb.vhd
-- Description: A reg_file_tb can test the reaction of a register file.
-- Author: YIN Haoping
-- Date: March 27, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use work.reg_file_pkg.all;

--! reg_file_tb entity description

--! Detailed description of this
--! reg_file_tb design element.

entity reg_file_tb is
end entity reg_file_tb;

--! @brief Architecture definition of reg_file_tb
--! @details More details about this reg_file_tb element.

architecture sim of reg_file_tb is
    constant dataWidth : positive := 8;				--! Constant of datawidth
    constant addressWidth : positive := 5;			--! Constant of address width
    --constant num_reg : positive := 32;				--! Constant of size of register file
    constant combination_read : boolean := false;	--! Constant of Combination and sychrnonous selection
    constant reset_zero : boolean := false;			--! reset address 0 only
    constant ignore_zero : boolean := false;		--! ignore write address 0
    constant read_delay : time := 1 ns;

    signal clk        : std_logic := '0';		--! the signal of clock
    signal reset      : std_logic := '0';		--! the signal of reset
    signal writeEna   : std_logic := '0';		--! the signal of write enable
    signal writeAddress : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of wirte address
    signal writeData : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of write data
    signal readAddress1 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of read address1
    signal readAddress2 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of read address2
    signal readData1 : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of read data1
    signal readData2 : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of read data2


	constant address0: std_logic_vector(addressWidth-1 downto 0) := (others => '0');		--! signal of first address
	constant address1: std_logic_vector(addressWidth-1 downto 0) := (others =>'1');		--! signal of last address
	constant datazeros: std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! signal of data zeros
	constant dataones: std_logic_vector(dataWidth-1 downto 0) := (others =>'1');			--! signal of data ones
BEGIN

	
--! Instantiate the reg_file_tb entity
    DUT: reg_file
        generic map (
            dataWidth => dataWidth,
            addressWidth => addressWidth,
	    combination_read => combination_read,
	    reset_zero => reset_zero,
	    ignore_zero => ignore_zero,
	    read_delay => read_delay	
        )
        port map (
            clk        => clk,
            reset      => reset,
            writeEna   => writeEna,
            writeAddress => writeAddress,
            writeData => writeData,
            readAddress1 => readAddress1,
            readAddress2 => readAddress2,
            readData1 => readData1,
            readData2 => readData2
        );
	
--! @brief Clock generation process
--! @details generate a clock signal
    clk_process: process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;

--! @brief Test condition
--! @details To create different condition to test the code
    stimulus_process: process
    begin
	
	-- Test initialisation
	readAddress2 <= address1;
	reset <= '0';
	writeEna <='0';
	WAIT FOR 20 ns;
	
	--Test writeEna
	writeData <= dataones;
	writeAddress <= address1;
	WAIT FOR 20 ns;
	
	--Test write address 0
	writeEna <='1';
	writeAddress <= address0;
	writeData <= dataones;
	WAIT FOR 20 ns;
	
	--Test write other address
	writeAddress <= address1;
	writeData <= dataones;
	WAIT FOR 20 ns;
	
	--Test reset
	reset <= '1';
	WAIT FOR 20 ns;
	
	reset <='0';
	WAIT FOR 20 ns;

	--Test write address 0
	writeData <= dataones;
	writeAddress <= address0;
	WAIT FOR 20 ns;
	
	--Test write other address
	writeData <= dataones;
	writeAddress <= address1;
	WAIT FOR 20 ns;
	
        --! Done
	ASSERT false
		REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure;
	WAIT FOR 10 ns;
	end process;
end architecture;


