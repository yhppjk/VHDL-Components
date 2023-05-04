----------------------------------------------------------
--! @file wrpc1
--! @A wrpc1 for calculation 
-- Filename: wrpc1.vhd
-- Description: A wrpc1 
-- Author: YIN Haoping
-- Date: May 4, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! wrpc1 entity description

--! Detailed description of this
--! wrpc1 design element.
entity wrpc1 is
	port(
	--INPUTS
	input_JB : in std_logic;
	input_XZ : in std_logic;
	input_XN : in std_logic;
	input_XF : in std_logic;
	alu_z : in std_logic;
	alu_n : in std_logic;
	alu_c : in std_logic;
	--OUTPUTS
	wrpc_out : out std_logic
	);

end entity;

architecture behavioral of wrpc1 is
	signal control_signal : std_logic_vector(3 downto 0);

begin
	control_signal <= input_JB & input_XZ & input_XN & input_XF;

	process(input_JB,input_XZ,input_XN,input_XF,alu_z,alu_n,alu_c)
	begin
		wrpc_out <= '0';
		
		--JAL
		if input_JB ='1' and input_XZ = '0' and input_XN = '0' then
			wrpc_out <= '1';
			
		--BEQ	
		elsif input_JB ='1' and input_XZ = '1' and input_XN = '0' and input_XF = '1' then
			if alu_z = '1' then
				wrpc_out <= '1';
			end if;
		elsif input_JB ='1' and input_XZ = '1' and input_XN = '0' and input_XF = '0' then
			if alu_z = '0' then
				wrpc_out <= '1';
			end if;
		--BLT
		elsif input_JB ='1' and input_XZ = '0' and input_XN = '1' and input_XF = '1' then
			if alu_n = '1' then
				wrpc_out <= '1';
			end if;
		elsif input_JB ='1' and input_XZ = '0' and input_XN = '1' and input_XF = '0' then
			if alu_n = '0' then
				wrpc_out <= '1';
			end if;
		--BLTU
		elsif input_JB ='1' and input_XZ = '1' and input_XN = '1' and input_XF = '1' then
			if alu_c = '1' then
				wrpc_out <= '1';
			end if;
		elsif input_JB ='1' and input_XZ = '1' and input_XN = '1' and input_XF = '0' then
			if alu_c = '0' then
				wrpc_out <= '1';
			end if;
		end if;
		
			
	end process;

end architecture;