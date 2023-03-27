----------------------------------------------------------
--! @file register_file_tb
--! @Register file testbench file
-- Filename: register_file_tb.vhd
-- Description: Register file testbench file
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use work.generic_register_pkg.all;

--! register_file_tb entity description

--! Detailed description of this
--! register_file_tb design element.
entity register_file_tb is
end entity register_file_tb;


--! @brief Architecture definition of register_file_tb
--! @details More details about this register_file_tb element.
architecture sim of register_file_tb is
    constant dataWidth : positive := 8;				--! Constant of datawidth
    constant addressWidth : positive := 5;			--! Constant of address width
    constant num_reg : positive := 32;				--! Constant of size of register file
	constant combination_read : boolean := false	--! Constant of Combination and sychrnonous selection


    signal clk        : std_logic := '0';		--! the signal of clock
    signal reset      : std_logic := '0';		--! the signal of reset
    signal write_en   : std_logic := '0';		--! the signal of write enable
    signal write_addr : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of wirte address
    signal write_data : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of write data
    signal read_addr1 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of read address1
    signal read_addr2 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');	--! the signal of read address2
    signal read_data1 : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of read data1
    signal read_data2 : std_logic_vector(dataWidth-1 downto 0) := (others => '0');		--! the signal of read data2
	
BEGIN

	
--! Instantiate the register_file entity
    DUT: register_file
        generic map (
            dataWidth => dataWidth,
            addressWidth => addressWidth,
            num_reg => num_reg,
			combination_read => combination_read
        )
        port map (
            clk        => clk,
            reset      => reset,
            writeEna   => write_en,
            writeAddress => write_addr,
            writeData => write_data,
            readAddress1 => read_addr1,
            readAddress2 => read_addr2,
            readData1 => read_data1,
            readData2 => read_data2
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

        wait for 20 ns;
        --! Write data to register 1
        write_en   <= '1';
        write_addr <= "00001";
        write_data <= X"0B";
        wait for 20 ns;

        --! Disable write
        write_en   <= '0';
        wait for 20 ns;

        --! Read from register 1 and register 2
        read_addr1 <= "00001";
        read_addr2 <= "01010";
        wait for 20 ns;

        --! Write data to register 2
        write_en  <= '1';
        write_addr <= "01010";
        write_data <= X"0A";
		wait for 20 ns;
		
		--! Stop writing
        write_en <= '0';
        wait for 20 ns;

        --! Read back the data from the register file
        read_addr1 <= "01010";
        read_addr2 <= "00000";
        wait for 20 ns;
		
		--! Reset all data
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        --! Done
	ASSERT false
		REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure;
	WAIT FOR 10 ns;
	end process;
end architecture;