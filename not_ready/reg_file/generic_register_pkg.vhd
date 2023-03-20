----------------------------------------------------------
--! @file generic_register_pkg
--! @A generic_register_pkg contains the component of start_stop
-- Filename: generic_register_pkg.vhd
-- Description: A generic_register_pkg contains the component of start_stop
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! generic_register_pkg package description

--! Detailed description of this
--! generic_register_pkg design element.
PACKAGE generic_register_pkg IS
COMPONENT generic_register IS
    generic (
        dataWidth : positive := 32
    );
	    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        enable  	: in  std_logic;
        reg_in		: in  std_logic_vector(dataWidth-1 downto 0);
        reg_out     : out std_logic_vector(dataWidth-1 downto 0)
    );
END COMPONENT generic_register;

COMPONENT register_file IS
    generic (
        dataWidth : positive := 32;
        addressWidth : positive := 5;
        num_reg : positive := 32;
	combination_read : boolean := false
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        writeEna   : in  std_logic;
        writeAddress : in  std_logic_vector(addressWidth-1 downto 0);
        writeData : in  std_logic_vector(dataWidth-1 downto 0);
        readAddress1 : in  std_logic_vector(addressWidth-1 downto 0);
        readAddress2 : in  std_logic_vector(addressWidth-1 downto 0);
        readData1 : out std_logic_vector(dataWidth-1 downto 0);
        readData2 : out std_logic_vector(dataWidth-1 downto 0)
    );
END COMPONENT register_file;
END PACKAGE generic_register_pkg;