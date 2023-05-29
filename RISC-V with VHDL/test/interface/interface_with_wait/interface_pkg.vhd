----------------------------------------------------------
--! @file interface_pkg
--! @A interface_pkg can combine multipal counter to count.
-- Filename: interface_pkg.vhd
-- Description: A interface_pkg can test the reaction of a register file.
-- Author: YIN Haoping
-- Date: March 27, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

--! interface_pkg package description

--! Detailed description of this
--! interface_pkg design element.
PACKAGE interface_pkg IS
--! interface_pkg package description

--! Detailed description of this
--! interface_pkg design element.
	constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
	constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
	constant ALU_SLL : std_logic_vector(3 downto 0) := "0010";
	constant ALU_SRL : std_logic_vector(3 downto 0) := "0011";
	constant ALU_SRA : std_logic_vector(3 downto 0) := "0100";
	constant ALU_AND : std_logic_vector(3 downto 0) := "0101";
	constant ALU_OR  : std_logic_vector(3 downto 0) := "0110";
	constant ALU_XOR : std_logic_vector(3 downto 0) := "0111";
	constant ALU_BEQ : std_logic_vector(3 downto 0) := "1000";
	constant ALU_BLT : std_logic_vector(3 downto 0) := "1001";
	constant ALU_BLTU : std_logic_vector(3 downto 0) := "1010";
	constant ALU_JAL : std_logic_vector(3 downto 0) := "1011";
	constant ALU_LUI : std_logic_vector(3 downto 0) := "1100";
	
	function error_event (alu_code : std_logic_vector(3 downto 0) ) return string;
	
	function change_to_string(data : std_logic_vector) return string;
	
	function to_binary_string(slv : std_logic_vector) return string; 
	
	function get_sizestrb(size_i : std_logic_vector(1 downto 0) ) return std_logic_vector(7 downto 0);
	

END PACKAGE interface_pkg;


PACKAGE BODY interface_pkg IS

	function get_sizestrb(size_i : std_logic_vector(1 downto 0) ) return std_logic_vector(7 downto 0) is
		return size_i;
	end function get_sizestrb;
	
	function change_to_string(data : std_logic_vector) return string is
	begin
		return integer'image(to_integer(unsigned(data)));
	end function change_to_string;

	function error_event (alu_code : std_logic_vector(3 downto 0) ) return string is
	begin
		case alu_code is
			when "0000" =>
				return string'("ALU_ADD");
			when "0001" =>
				return string'("ALU_SUB");
			when "0010" =>
				return string'("ALU_SLL");
			when "0011" =>
				return string'("ALU_SRL");
			when "0100" =>
				return string'("ALU_SRA");
			when "0101" =>
				return string'("ALU_AND");
			when "0110" =>
				return string'("ALU_OR");
			when "0111" =>
				return string'("ALU_XOR");
			when "1000" =>
				return string'("ALU_BEQ");
			when "1001" =>
				return string'("ALU_BLT");
			when "1010" =>
				return string'("ALU_BLTU");
			when "1011" =>
				return string'("ALU_JAL");
			when "1100" =>
				return string'("ALU_LUI");
			when others =>
				return string'("Wrong ALU code");
		end case;
	end function error_event;
	
	
	function to_binary_string(slv : std_logic_vector) return string is
		variable result : string (1 to 32);
	begin
		for i in slv'range loop
			result(i + 1) := std_logic'image(slv(i))(2);
		end loop;
		return result;
	end function to_binary_string;
	
	
END PACKAGE BODY interface_pkg;
