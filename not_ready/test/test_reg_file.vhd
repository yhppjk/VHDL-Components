----------------------------------------------------------
--! @file reg_file
--! @A reg_file can combine multipal counter to count.
-- Filename: reg_file.vhd
-- Description: A reg_file can save some data in different address.
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

--! reg_file entity description

--! Detailed description of this
--! reg_file design element.
entity test_reg_file is
    generic (
      dataWidth : positive := 8;			--! generic of datawidth
		addressWidth : positive := 2;		--! generic of address width
		sychro_reset : boolean := false; 	--! sychronous reset
		reset_zero : boolean := true;		--! reset address 0 only
		ignore_zero : boolean := true;		--! ignore write address 0
		combination_read : boolean := false	--! generic of Combination and sychrnonous selection
		--      num_reg : positive := 4;				--! generic of size of register file
    );
    port (
        clk        	: in  std_logic;				--! the input port of clock
        reset      	: in  std_logic := '0';			--! the input port of reset
        writeEna   	: in  std_logic := '0';			--! the input port of write enable
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0);		--! the input port of wirte address
        writeData 	: in  std_logic_vector(dataWidth-1 downto 0);			--! the input port of write data
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0);		--! the input port of read address1
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0);		--! the input port of read address2
        readData1 	: out std_logic_vector(dataWidth-1 downto 0);			--! the output port of read data1
        readData2 	: out std_logic_vector(dataWidth-1 downto 0);				--! the output port of read data2
	full		: out std_logic := '0'			--! full save flag	
    );
end entity test_reg_file;

--! @brief Architecture definition of reg_file
--! @details More details about this reg_file element.
architecture behavior of test_reg_file is
  constant  num_reg : positive := 2**addressWidth;				--! generic of size of register file


--! a  type of register file 2d array
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0) ;
	signal reg_file : reg_file_t := (0 =>"01010101",others =>(others =>'0'));
	signal zeros : std_logic_vector(addressWidth-1 downto 0) := (others =>'0');
	signal zeros_data : std_logic_vector(dataWidth-1 downto 0) := (others =>'0');
begin	

write_original: if reset_zero = false and ignore_zero = false generate
--! @brief reset & write_process
--! @details reset & write_process without reset zero and ignore zero.
	write_process1 : process(reset, clk)
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
end generate write_original;
	
--! @brief reset & write_process
--! @details reset & write_process with reset zero without ignore zero
write_reset_zero : if reset_zero = true and ignore_zero = false generate
	write_process2 : process(reset, clk)
	begin
	    if reset = '1' then
			reg_file(0) <= (others => '0');
		elsif rising_edge(clk) then
		    if(writeEna = '1') then
				reg_file(to_integer(unsigned(writeAddress))) <= writeData;
		    end if;
		end if;
	end process;
end generate write_reset_zero;
	
write_ignore_zero: if reset_zero = false and ignore_zero = true generate
--! @brief reset & write_process
--! @details reset & write_process without reset zero, with ignore zero.
	write_process3 : process(reset, clk)
	begin
	    if reset = '1' then
			for i in 0 to num_reg-1 loop
				reg_file(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
		    if(writeEna = '1') and writeAddress /= zeros then
			reg_file(to_integer(unsigned(writeAddress))) <= writeData;
		    end if;
		end if;
	end process;
end generate write_ignore_zero;
	
write_ignore_reset_zero: if reset_zero = true and ignore_zero = true generate
--! @brief reset & write_process
--! @details reset & write_process with reset zero and ignore zero.
	write_process4 : process(reset, clk)
	begin
	    if reset = '1' then
			reg_file(0) <= (others => '0');
		elsif rising_edge(clk) then
		    if(writeEna = '1') and writeAddress /= zeros then
			reg_file(to_integer(unsigned(writeAddress))) <= writeData;
		    end if;
		end if;
	end process;
end generate write_ignore_reset_zero;


	
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

--! save_flag process
	save_flag : process(reg_file)
	variable count: integer :=0;
	begin
	count :=0;
	for i in 0 to num_reg-1 loop
		if reg_file(i) /= zeros_data then
			count := count +1;
		end if;
	end loop;
	
	if count = num_reg then
		full <= '1';
	else
		full <= '0';
	end if;
	end process;
end architecture behavior;