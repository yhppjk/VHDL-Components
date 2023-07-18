--! \file apb_slavedec.vhd
--! \brief APB bus slave decoder
--! \author Esquirol Charlotte
--! \author Paco Rodríguez
--! \version 0.2
--! \date July 2023
--!
--! Changelog: entity renamed, comments and code improved, 
--!            removed dependency from math_real package
--!
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real.all;
use work.apb_slavedec_pkg.all;

entity apb_slavedec is
	port (
		-- Higher bits of the master address
		ADDRESS :  in STD_LOGIC_VECTOR (SLAVE_DECODER_A-1 downto 0);
		-- PREQ of master
        ENABLE : in STD_LOGIC;
		-- ADDRESS error: no slave selected
        ADDRERR : out STD_LOGIC;
		-- SELx outputs, one per slave
    	SEL : out STD_LOGIC_VECTOR (SLAVE_DECODER_S-1 downto 0);
		-- Number of selected slave, for the MUXes that forward PREADY and PRDATA from the slaves to the master
		NUM_SLAVE : out SLAVE_NUMBER_TYPE
	);
end entity apb_slavedec;


architecture Behavioral of apb_slavedec is
begin
	combinational: process (ADDRESS, ENABLE)
	begin
		-- Default values, overwritten if ENABLE = '1' and the ADDRESS matches one of the patterns
		SEL       <= (others => '0');
		NUM_SLAVE <= 0;
		ADDRERR   <= '1';
		if (ENABLE = '1') then
			-- Loop over the array of patterns to check if the ADDRESS matches any of them
			for i in 0 to SLAVE_DECODER_S-1 loop
				if (std_match(ADDRESS, SLAVE_DECODER_SAX(i))) then
					-- Match found. Select i-th slave
					SEL(i)    <= '1';
					NUM_SLAVE <= i;
					ADDRERR   <= '0';
				end if;
			end loop;
		end if;
	end process combinational;
end Behavioral;
