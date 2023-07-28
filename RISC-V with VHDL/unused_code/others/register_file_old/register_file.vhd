----------------------------------------------------------
--! @file register_file
--! @A register_file can combine multipal counter to count.
-- Filename: register_file.vhd
-- Description: A register_file can combine multipal counter to count.
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
--! register_file entity description

--! Detailed description of this
--! register_file design element.
entity register_file is
    generic (
        dataWidth : positive := 32;			--! generic of datawidth
        addressWidth : positive := 5;		--! generic of address width
        --num_reg : positive := 32;			--! generic of size of register file
		combination_read : boolean := false	--! generic of Combination and sychrnonous selection
    );
    port (
        clk        : in  std_logic;			--! the input port of clock
        reset      : in  std_logic;			--! the input port of reset
        writeEna   : in  std_logic;			--! the input port of write enable
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');		--! the input port of wirte address
        writeData : in  std_logic_vector(dataWidth-1 downto 0):= (others => '0');			--! the input port of write data
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');		--! the input port of read address1
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');		--! the input port of read address2
        readData1 : out std_logic_vector(dataWidth-1 downto 0) := (others => '0');			--! the output port of read data1
        readData2 : out std_logic_vector(dataWidth-1 downto 0) := (others => '0')			--! the output port of read data2
    );
end entity register_file;

--! @brief Architecture definition of register_file
--! @details More details about this register_file element.
architecture behavior of register_file is

	constant  num_reg : positive := 2**addressWidth;				--! generic of size of register file
--! a  type of register file 2d array
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0) ;
	signal reg_file : reg_file_t := (others =>(others =>'0'));
	
begin	
--! @brief reset & write_process
--! @details reset & write_process
	write_process : process(reset,clk)
	begin
	    if reset = '1' then
			for i in 0 to num_reg-1 loop
				reg_file(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
		    if(writeEna = '1') then
				reg_file(to_integer(unsigned(writeAddress))) <= writeData;
		    end if;
		end if;
	end process;
	
--! @brief generate read1 process
--! @details generate read1 process
read1_gen1: if combination_read generate
--! read1_process_comb
	read1_process_comb: process (readAddress1, reg_file)
    begin
		readData1 <= reg_file(to_integer(unsigned(readAddress1)));
    end process;
end generate;
read1_gen2: if not(combination_read) generate
--! read1_process_synch
	read1_process_synch: process(clk)
    begin
       		if rising_edge(clk) then
			readData1 <= reg_file(to_integer(unsigned(readAddress1)));
       		end if;
    end process;
end generate;
--! @brief generate read2 process
--! @details generate read2 process
read2_gen1: if combination_read generate
--！ read2_process_comb
    read2_process_comb: process(readAddress2, reg_file)
    begin
		readData2 <= reg_file(to_integer(unsigned(readAddress2)));
	end process;
end generate;
read2_gen2:if not(combination_read) generate 
--! read2_process_synch
	read2_process_synch: process(clk)
    begin
        	if rising_edge(clk) then
			readData2 <= reg_file(to_integer(unsigned(readAddress2)));
	end if;
    end process;
end generate read2_gen2;

	
end architecture behavior;