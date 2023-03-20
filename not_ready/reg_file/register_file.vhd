library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


entity register_file is
    generic (
        dataWidth : positive := 32;
        addressWidth : positive := 5;
        num_reg : positive := 32;
	combination_read : boolean := true
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        writeEna   : in  std_logic;
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');
        writeData : in  std_logic_vector(dataWidth-1 downto 0):= (others => '0');
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0):= (others => '0');
        readData1 : out std_logic_vector(dataWidth-1 downto 0) := (others => '0');
        readData2 : out std_logic_vector(dataWidth-1 downto 0) := (others => '0')
    );
end entity register_file;


architecture behavior of register_file is


--! reset signal


--! a  type of register file 2d array
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0) ;
	signal reg_file : reg_file_t := (0=>"00", 1=>"10", 2=>x"fe", others =>(others =>'0'));
	
begin	
--! reset & write_process
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
	
	
--generate read1 process
read1_gen: if combination_read generate
--! read1_process_comb
	read1_process_comb: process (readAddress1, reg_file)
    begin
		readData1 <= reg_file(to_integer(unsigned(readAddress1)));
    end process;
else generate
--! read1_process_synch
	read1_process_synch: process(clk)
    begin
       		if rising_edge(clk) then
			readData1 <= reg_file(to_integer(unsigned(readAddress1)));
       		end if;
    end process;
end generate;

--generate read2 process
read2_gen: if not(combination_read) generate
--！ read2_process_comb
    read2_process_comb: process(readAddress2, reg_file)
    begin
		readData2 <= reg_file(to_integer(unsigned(readAddress2)));
	end process;
else generate 
--! read2_process_synch
	read2_process_synch: process(clk)
    begin
        	if rising_edge(clk) then
			readData2 <= reg_file(to_integer(unsigned(readAddress2)));
	end if;
    end process;
end generate;

	
end architecture behavior;