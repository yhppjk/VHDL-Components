----------------------------------------------------------
--! @file generic_register_pkg
--! @A generic_register_pkg contains the component of start_stop
-- Filename: generic_register_pkg.vhd
-- Description: A generic_register_pkg contains the component of start_stop
-- Author: YIN Haoping
-- Date: March 21, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;

--! generic_register_pkg package description

--! Detailed description of this
--! generic_register_pkg design element.
PACKAGE generic_register_pkg IS
--! generic_register_pkg package description

--! Detailed description of this
--! generic_register_pkg design element.

--! component generic_register description
COMPONENT generic_register IS
    generic (
        dataWidth : positive := 32	--! generic of datawidth
    );
	    port (	
        clk         : in  std_logic;	--! the input port of clock
        reset       : in  std_logic;	--! the input port of reset
        enable  	: in  std_logic;	--! the input port of enable
        reg_in		: in  std_logic_vector(dataWidth-1 downto 0);	--! the input port of register
        reg_out     : out std_logic_vector(dataWidth-1 downto 0)	--! the output port of register
    );
END COMPONENT generic_register;


--! component register_file description
COMPONENT register_file IS
    generic (	
        dataWidth : positive := 32;				--! generic of datawidth
        addressWidth : positive := 5;			--! generic of address width
        num_reg : positive := 32;				--! generic of size of register file
		combination_read : boolean := false		--! generic of Combination and sychrnonous selection
    );
    port (
        clk        : in  std_logic;		--! the input port of clock
        reset      : in  std_logic;		--! the input port of reset
        writeEna   : in  std_logic;		--! the input port of write enable
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of wirte address
        writeData : in  std_logic_vector(dataWidth-1 downto 0);			--! the input port of write data
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address1
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address2
        readData1 : out std_logic_vector(dataWidth-1 downto 0);			--! the output port of read data1
        readData2 : out std_logic_vector(dataWidth-1 downto 0)			--! the output port of read data2
    );
END COMPONENT register_file;
END PACKAGE generic_register_pkg;