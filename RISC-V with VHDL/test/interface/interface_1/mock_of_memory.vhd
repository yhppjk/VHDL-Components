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
		PSTRB : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		
		--unaligned : IN std_logic;
		
		PREADY : OUT std_logic := '1';
		PRDATA : OUT std_logic_vector(31 downto 0)
	);
end entity;

architecture behavioral of mock_of_memory is

	signal cache_addr : std_logic_vector(29 downto 0);
	signal write_or_read : std_logic;
	signal cache_PSTRB : std_logic_vector(3 downto 0);
begin

	
	
	mainp: process is
	begin
		PREADY <= '0'; 
		PRDATA <= x"00000000"; 
		
		
		while true loop
		
		
			testing <= '0';
			-- Wait for the test to start
			assert PENABLE = '0' report "mock PENABLE = '1' in the very first cycle of a transfer" severity warning;			
			wait until falling_edge(clk) and PSEL = '1';
			testing <= '1';
			--Capture for PADDR, PWRITE
			cache_addr <= PADDR;
			write_or_read <= PWRITE;
			cache_PSTRB <= PSTRB;
			
			assert PWRITE = '1' or PSTRB = "0000" report "mock PSTRB should be ""0000"" in a read transfer " severity warning;
			--check PENABLE is 0 

			assert PSEL = '1' report "mock PSEL = '0'  in the very first cycle of a transfer" severity warning;


			if num_wait >  0 then
				for i in 0 to num_wait - 1 loop
					wait until rising_edge(clk); wait for 1 ns;
					assert PADDR = cache_addr report "mock PADDR changed in the middle of a transfer" severity warning;
					assert PSTRB = cache_PSTRB report "mock PSTRB changed in the middle of a transfer" severity warning;
					assert PWRITE = write_or_read report "mock PWRITE changed in the middle of a transfer" severity warning;
					assert PSEL = '1' report "mock PSEL = '0'  in the middle of a transfer" severity warning;
					assert PENABLE = '1' report "mock PENABLE = '0' in the middle of a transfer" severity warning;			
				end loop;
			end if;

			wait until rising_edge(clk); wait for 1 ns;
			assert PADDR = cache_addr report "mock PADDR changed in the middle of a transfer" severity warning;
			assert PSTRB = cache_PSTRB report "mock PSTRB changed in the middle of a transfer" severity warning;
			assert PSEL = '1' report "mock PSEL deactivated too early!" severity warning;
			assert PENABLE = '1' report "mock PENABLE = '0' before the end of a transfer" severity warning;	
			
			
			wait until falling_edge(clk); wait for 1 ns;		
			PREADY <= '1'; 
			if (PWRITE= '0') then 
				PRDATA <= dataread;
			end if;
			
			assert PADDR = cache_addr report "PADDR changed in the end of a transfer" severity warning;
			assert PSTRB = cache_PSTRB report "PSTRB changed in the end of a transfer" severity warning;
			assert PSEL = '1' report "PSEL deactivated too early!" severity warning;
			assert PENABLE = '1' report "PENABLE = '0' before the end of a transfer" severity warning;		
			
			wait until rising_edge(clk); wait for 1 ns;
			assert PENABLE = '0' report "PENABLE = '1' in the end of a transfer" severity warning;
			
			wait for 1 ns;
			PREADY <= '0'; PRDATA <= x"00000000";
			assert PENABLE = '0' report "PENABLE = '1' in the end of a transfer" severity warning;
			
		end loop;
	end process;
	

	
end architecture; -- behavioral



-- check PSTRB as how to check PADDR 
-- able to check if the operation need 2 step or 1 step
-- check PREQ / PSEL
-- check byte lane(if the PSTRB will change this byte lane)
-- when the interface is doing a read transfer, the PSTRB must be low