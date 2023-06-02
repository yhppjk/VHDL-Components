----------------------------------------------------------
--! @file mock_of_memory 
--! @A mock_of_memory  for calculation 
-- Filename: mock_of_memory   
-- Description: A mock_of_memory   
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! mock_of_memory  entity description

--! Detailed description of this
--! mock_of_memory  design element.
entity mock_of_memory is
	-- generic(num_wait : integer := 2
-- );
	port(
		-- from the testbench to control the slave
	    num_wait : IN integer := 2;
		dataread : IN std_logic_vector(31 downto 0);
		testing : out std_logic;
		
		--actual signals to the memory interface
		PADDR: IN std_logic_vector(29 downto 0);
		PWDATA : IN std_logic_vector(31 downto 0);
		PSEL : IN std_logic;
		PWRITE : IN std_logic;
		PENABLE : IN std_logic := '0';
		clk : IN std_logic;
		
		PREADY : OUT std_logic := '1';
		PRDATA : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavioral of mock_of_memory is
	-- type reg_file_t is array (0 to 63) of std_logic_vector(31 downto 0) ;
	-- signal memory : reg_file_t := (0 =>"01010101010101010101010101010101", 1 =>"01010101010101010101010101010101", 2 =>"01010101010101010101010101010101", 3 =>"01010101010101010101010101010101",others =>(others =>'0'));
    -- signal count : integer range 0 to num_wait;
	signal cache_addr : std_logic_vector(29 downto 0);
	signal write_or_read : std_logic;
begin

	-- PREADY <= '0' when count < num_wait else '1';
	
	-- main_process : process(clk)
	-- begin

		-- if PSEL = '0' then
			-- memory(to_integer(unsigned(PADDR))) <= PWDATA;
		-- elsif PSEL = '1' then
			-- PRDATA <= memory(to_integer(unsigned(PADDR)));
		-- end if;
		
		-- if count < num_wait then
			-- count <= count + 1;
		-- else
			-- count <= 0;
		-- end if;
	-- end process main_process;
	
	
	mainp: process is
	begin
		PREADY <= '0'; 
		PRDATA <= x"00000000"; 
		
		while true loop
			testing <= '0';
			-- Wait for the test to start
			wait until rising_edge(clk) and PSEL = '1';
			testing <= '1';
			--Capture for PADDR, PWRITE
			cache_addr <= PADDR;
			write_or_read <= PWRITE;
			
			--check PENABLE is 0 
			assert PENABLE = '0' report "PENABLE = '1' in the very first cycle of a transfer" severity warning;
			
			if num_wait >  0 then
				for i in 0 to num_wait - 1 loop
					wait until rising_edge(clk); wait for 1 ns;
					assert PADDR = cache_addr report "PADDR changed in the middle of a transfer" severity warning;
					assert PWRITE = write_or_read report "PWRITE changed in the middle of a transfer" severity warning;
					assert PENABLE = '0' report "PENABLE = '1' in the middle of a transfer" severity warning;			
				end loop;
			end if;

			wait until rising_edge(clk); wait for 1 ns;
			assert PADDR = cache_addr report "PADDR changed in the middle of a transfer" severity warning;
			assert PSEL = '1' report "PSEL deactivated too early!" severity warning;

			wait until falling_edge(clk); wait for 1 ns;
			PREADY <= '1'; 
			if (PWRITE= '0') then 
				PRDATA <= dataread;
			end if;
			
			assert PADDR = cache_addr report "PADDR changed in the end of a transfer" severity warning;
			
			wait until falling_edge(clk); wait for 1 ns;
			PREADY <= '0'; PRDATA <= x"00000000";
				
			
		end loop;
	end process;
	

	
end architecture; -- behavioral