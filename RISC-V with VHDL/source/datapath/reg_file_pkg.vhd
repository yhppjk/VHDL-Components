----------------------------------------------------------
--! @file reg_file_pkg
--! @A reg_file_pkg contains the component of start_stop
-- Filename: reg_file_pkg.vhd
-- Description: A reg_file_pkg contains the component of start_stop
-- Author: YIN Haoping
-- Date: March 27, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;


--! reg_file_pkg package description

--! Detailed description of this
--! reg_file_pkg design element.
PACKAGE reg_file_pkg IS
--! reg_file_pkg package description

	--this is for simulation only
	-- one simulation is finished, comment these and remove comments from reg_file.vhd about num_reg and reg_file_t
	constant addressWidth: positive := 5;
	constant dataWidth : positive := 32;
	constant  num_reg : positive := 2**addressWidth;				--! generic of size of register file	
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0);
	
	
--! Detailed description of this
--! reg_file_pkg design element.

--! component reg_file description
COMPONENT reg_file IS
    generic (	
        dataWidth : positive := 32;				--! generic of datawidth
        addressWidth : positive := 5;			--! generic of address width
        --num_reg : positive := 32;				--! generic of size of register file
		reset_zero : boolean := false;		--! reset address 0 only
		ignore_zero : boolean := false;		--! ignore write address 0
		combination_read : boolean := false;		--! generic of Combination and sychrnonous selection
		read_delay : time := 0 ns
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
        readData2 : out std_logic_vector(dataWidth-1 downto 0)		--! the output port of read data2
	);
END COMPONENT reg_file;
END PACKAGE reg_file_pkg;