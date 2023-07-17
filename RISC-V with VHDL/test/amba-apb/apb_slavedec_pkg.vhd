--! \file apb_slavedec_pkg.vhd
--! \brief APB bus slave decoder package
--! \author Esquirol Charlotte
--! \author Paco Rodríguez
--! \version 0.2
--! \date July 2023
--!
--! VHDL package with constants and data types required by the slave decoder
--!
--! Changelog: package renamed, package body removed, comments updated, 
--!            removed dependency from numeric_std package and work library
--!
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--library work;

package apb_slavedec_pkg is

	-- Number of high-order bits of the master address used to select a slave (must be >= 1 and <= 32)
	constant SLAVE_DECODER_A: natural := 24;
	
	-- Number of slaves in the system
	constant SLAVE_DECODER_S: natural := 3;
	
	-- Data type to hold and array of the high-order bits of the master address used to select each slave (one entry per slave)
	type SLAVE_DECODER_SAX_TYPE is array (0 to SLAVE_DECODER_S-1) of std_logic_vector(SLAVE_DECODER_A-1 downto 0);
	
	-- Constant holding the fixed part of the master address used to select each slave
	-- This relates to the linker command file used to separate the different sectins of the executable;
	-- with a linker file like
	--   SECTIONS {
	--     . = 0x00000000;
	--     .text : { *(.text) }
	--     . = 0x08000000;
	--     .data : { *(.data) }
	--     .bss : { *(.bss) }
	--   }
	-- All text sections (code) is stored from address 0, 
	-- while all data and constant sections are stored starting at address 0x08000000	
	constant SLAVE_DECODER_SAX: SLAVE_DECODER_SAX_TYPE := (
	
		"0000 0000 0000 0000 0000 00--", -- First slave selected for all addresses in the range  0000 0000 0000 0000 0000 00xx xxxx xxxx
		                                 -- = 0x00000000 to 0x000003FF =
		                                 -- 1024 x 32 positions starting at 0x00000000 (arbitrarily chosen size of instruction memory)

		"0000 0000 0000 0000 0000 01--", -- Second slave selected for all addresses in the range  0000 0000 0000 0000 0000 01xx xxxx xxxx
		                                 -- = 0x00000400 to 0x000007FF =
		                                 -- 1024 x 32 positions starting at 0x00000400 (arbitrarily chosen size of 2nd instruction memory)
										 
		"0000 1000 0000 0000 0000 0000"  -- Second slave selected for all addresses in the range 0000 1000 0000 0000 0000 0000 xxxx xxxx
		                                 -- = 0x08000000 to 0x080000FF =
										 -- 256x32 position starting at 0x08000000 (arbitrarily chosen size of data memory)
	);

	-- Data type to hold a slave number
	subtype SLAVE_NUMBER_TYPE is integer range 0 to SLAVE_DECODER_S-1;

end package apb_slavedec_pkg;
