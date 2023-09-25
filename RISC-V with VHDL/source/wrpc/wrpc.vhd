----------------------------------------------------------
--! @file wrpc
--! @A write to pc
-- Filename: wrpc.vhd
-- Description: A write to pc
-- Author: YIN Haoping
-- Date: May 4, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! wrpc entity description

--! Detailed description of this
--! wrpc design element.
entity wrpc is
	port(
	--INPUTS
	input_JB : in std_logic;	--! The instruction is a jump or branch
	input_XZ : in std_logic;	--! Use nothing, Z or C to decide
	input_XN : in std_logic;	--! Use nothing, N or C to decide
	input_XF : in std_logic;	--! The selected ALU flag must match this value to take the branch
	alu_z : in std_logic;		--! ALU flag Z
	alu_n : in std_logic;		--! ALU flag N	
	alu_c : in std_logic;		--! ALU flag C
	--OUTPUTS
	wrpc_out : out std_logic	--! wrpc output
	);

end entity;

architecture behavioral of wrpc is
	signal control_signal : std_logic_vector(3 downto 0);

begin
	control_signal <= input_JB & input_XZ & input_XN & input_XF;		--! Connect control signal

	process(input_JB,input_XZ,input_XN,input_XF,alu_z,alu_n,alu_c)
	begin
		wrpc_out <= '0';
		case control_signal is
		--! JAL&JALR
			when "1000" | "1001"=>
				wrpc_out <= '1';
		--! BEQ&BNE
			when "1101" =>
                if alu_z = '1' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;
			when "1100" =>
                if alu_z = '0' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;
		--! BLT&BGE
			when "1011"	 =>
                if alu_n = '1' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;			
			when "1010" =>
                if alu_n = '0' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;
		--! BLTU&BGEU
			when "1111" =>
                if alu_c = '1' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;
			when "1110" =>
                if alu_c = '0' then
                    wrpc_out <= '1';
                else
                    wrpc_out <= '0';
                end if;
			when others =>
				wrpc_out <= 'X';		
		end case;
	end process;

end architecture;