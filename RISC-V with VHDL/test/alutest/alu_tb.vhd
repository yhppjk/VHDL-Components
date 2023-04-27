--------------------------------------------------------
--! @file alu_tb.vhd
--! @Testbench for the alu
-- Filename: alu_tb.vhd
-- Description: Testbench for the alu.
-- Author: YIN Haoping
-- Date: April 19, 2023
--------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

library work;
USE work.alu_pkg.ALL;

ENTITY alu_tb IS
END ENTITY alu_tb;

architecture behavioral of alu_tb is
    SIGNAL op1: std_logic_vector(31 DOWNTO 0);
    SIGNAL op2: std_logic_vector(31 DOWNTO 0);
    SIGNAL selop: std_logic_vector(3 DOWNTO 0);
    SIGNAL res: std_logic_vector(31 DOWNTO 0);
    SIGNAL flags: std_logic_vector(2 DOWNTO 0);

begin
	uut: alu PORT MAP (
			op1 => op1,
			op2 => op2,
			selop => selop,
			res => res,
			flags => flags
		);
	process
	begin
		wait for 10 ns;
		for i in vectors'low to vectors'high loop
			op1 <= vectors(i).op1;
			op2 <= vectors(i).op2;
			selop <= vectors(i).selop;
			
			wait for 10 ns;

			assert res = vectors(i).exp_res report "res error, test failed, check "&INTEGER'image(i) &" loop " severity warning;
			assert flags = vectors(i).exp_flags report "flags error, test failed, check "&INTEGER'image(i) &" loop " severity warning;

		end loop;

		report "Test finished";
		wait;
	end process;

end architecture;