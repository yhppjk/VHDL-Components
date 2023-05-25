LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


PACKAGE interface_with_wait_pkg IS
	
	function error_event (alu_code : std_logic_vector(3 downto 0) ) return string;
	
	function change_to_string(data : std_logic_vector) return string;


END PACKAGE interface_with_wait_pkg;






PACKAGE BODY interface_with_wait_pkg IS

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

END PACKAGE BODY interface_with_wait_pkg;