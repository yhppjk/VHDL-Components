--! \file apb_init_mem.vhd
--! \brief APB-compliant 32-bit memory block with initialization values
--! \author Paco Rodríguez
--! \version 0.1
--! \date July 2023
--!
--! Quite similar to \sa apb_mem except this memory have initial values extracted
--! from a constant array (imported from the \sa apb_init_mem_contents package). 
--! To this extent the mem32_init_f() impure function is used
--! (imported from the \sa mem32_init_pkg package)
--!
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apb_init_mem is
	generic (ADDR_BITS: natural := 16; offset : integer := 0);  -- Number of address bits
	port (
		PCLK    : in  std_logic;
		-- PRESETn : in STD_LOGIC; -- Not needed here
		PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
		PSEL    : in  std_logic;
		PENABLE : in  std_logic;
		PWRITE  : in  std_logic;
		PWDATA  : in  std_logic_vector(31 downto 0);
		PSTRB   : in  std_logic_vector( 3 downto 0);
		PREADY  : out std_logic;
		PRDATA  : out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity apb_init_mem;


use work.mem32_init_pkg.all;   -- For the mem32_t data type and the mem32_init_f() function
use work.apb_init_mem_pkg.all; -- For the apb_init_mem_contents constant array of initial memory values
architecture Behavioral of apb_init_mem is 
	constant mem_size : natural := 2**ADDR_BITS - 1;
	signal mem_contents : mem32_t(0 to mem_size-1) := mem32_init_f(apb_init_mem_contents, mem_size, offset);

begin 

	PREADY <= PENABLE and PSEL; 
	
    react: process (PCLK) is
    begin
		if rising_edge(PCLK) then
			if (PSEL = '1' and PENABLE = '0') then
				-- First clock of a transfer: 
				-- React now, PREADY will end the transfer on the next rising edge of PCLK
				
				if (PWRITE = '1') then
					-- Write transfer, check PSTRB(i) to write byte lane i
					if (PSTRB(0) = '1') then
						-- Byte lane 0 write
						mem_contents(to_integer(unsigned(PADDR)))( 7 downto  0) <= PWDATA ( 7 downto  0);
					end if;
					if (PSTRB(1) = '1') then
						-- Byte lane 1 write
						mem_contents(to_integer(unsigned(PADDR)))(15 downto  8) <= PWDATA (15 downto  8);
					end if;
					if (PSTRB(2) = '1') then
						-- Byte lane 2 write
						mem_contents(to_integer(unsigned(PADDR)))(23 downto 16) <= PWDATA (23 downto 16);
					end if;
					if (PSTRB(3) = '1') then
						-- Byte lane 3 write
						mem_contents(to_integer(unsigned(PADDR)))(31 downto 24) <= PWDATA (31 downto 24);
					end if;
				end if;
				
				if (PWRITE = '0') then
					-- Read transfer
					PRDATA <= mem_contents(to_integer(unsigned(PADDR)));
				end if;
			end if;
		end if;
    end process react;

end Behavioral;