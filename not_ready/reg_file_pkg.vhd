----------------------------------------------------------
--! @file reg_file_pkg
--! @A reg_file_pkg contains the component of start_stop
-- Filename: reg_file_pkg.vhd
-- Description: A reg_file_pkg contains the component of start_stop
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;


--! reg_file_pkg package description

--! Detailed description of this
--! reg_file_pkg design element.
PACKAGE reg_file_pkg IS
--! reg_file_pkg package description

--! Detailed description of this
--! reg_file_pkg design element.

--! component generic_register description


--! component reg_file description
COMPONENT reg_file IS
    generic (	
        dataWidth : positive := 32;				--! generic of datawidth
        addressWidth : positive := 5;			--! generic of address width
        --num_reg : positive := 32;				--! generic of size of register file
		reset_zero : boolean := false;		--! reset address 0 only
		ignore_zero : boolean := false;		--! ignore write address 0
		combination_read : boolean := false		--! generic of Combination and sychrnonous selection
    );
    port (
        clk        : in  std_logic;		--! the input port of clock
        reset      : in  std_logic;		--! the input port of reset
        writeEna   : in  std_logic;		--! the input port of write enable
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of wirte address
        writeData : in  std_logic_vector(dataWidth-1 downto 0);		--! the input port of write data
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address1
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address2
        readData1 : out std_logic_vector(dataWidth-1 downto 0);		--! the output port of read data1
        readData2 : out std_logic_vector(dataWidth-1 downto 0);		--! the output port of read data2
	full		: out std_logic := '0'				--! full save flag	    
	);
END COMPONENT reg_file;
END PACKAGE reg_file_pkg;