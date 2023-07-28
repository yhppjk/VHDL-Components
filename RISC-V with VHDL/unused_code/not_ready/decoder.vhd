----------------------------------------------------------
--! @file decoder
--! @A decoder can sort out the code.
-- Filename: decoder.vhd
-- Description: A decoder can sort out the code.
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! decoder entity description

--! Detailed description of this
--! decoder design element.

entity decoder is 
	generic(
			read_delay: time := 0 ns;				--! generic of read delay time
			selpbits : positive := 4
	);
	port(
	--inputs		
	commande : in std_logic_vector(31 downto 0);		--! origin commande of RV32I, length of 32 bits
	clk : in std_logic;										--! clock input
	ena_dec : in std_logic;									--! decoder enable
	--outputs
	
	selop : out std_logic_vector(selpbits-1 downto 0);	--! selection operation for ALU

	mux1 : out std_logic;									--! mux1 selection
	mux2 : out std_logic_vector(1 downto 0);			--! mux2 selection
	
	immediate : out std_logic_vector(31 downto 0);	--! immediate output
	ena_write : out std_logic								--! write enable
	
	--op1 : out std_logic_vector(31 downto 0);
	--op2 : out std_logic_vector(31 downto 0);
	);

end entity decoder;


architecture behavioral of decoder is
	signal opcode: std_logic_vector(6 downto 0);		--! signal of opcode
	
	signal rs1  :  std_logic_vector(4 downto 0);		--! signal of rs1
	signal rs2  :  std_logic_vector(4 downto 0);		--! signal of rs2
	signal rd 	:  std_logic_vector(4 downto 0);		--! signal of rd
	signal funct3 : std_logic_vector(2 downto 0);	--! signal of funct3
	
	signal outputs	:  std_logic_vector(31 downto 0);	--! signal of output
	
	constant MUX1_PC : std_logic :='1';					--! constant of mux1 selection pc
	constant MUX1_rs1 : std_logic := '0';				--! constant of mux1 selection rs1
	constant MUX2_I : std_logic_vector(1 downto 0) := "01";	--! constant of mux2 selection I-immediate
	constant MUX2_U : std_logic_vector(1 downto 0) := "11";	--! constant of mux2 selection U-immediate
	constant MUX2_J : std_logic_vector(1 downto 0) := "10";	--! constant of mux2 selection S-immediate
	constant MUX2_rs2 : std_logic_vector(1 downto 0) := "00";	--! constant of mux2 selection rs2
begin

process(clk)
begin	
	outputs <= (others => '0');
	if rising_edge(clk) then
		opcode <= commande(6 downto 0);		
		case opcode is
			--I-type instruction
			when "0010011" =>
				rd <= commande(11 downto 7);
				rs1 <= commande(19 downto 15);
				funct3 <= commande(14 downto 12);
				outputs(31 downto 20) <= commande(31 downto 20);
				--ADDI
				case funct3 is
					when "000" =>

						mux1 <= MUX1_rs1;
						mux2 <= MUX2_I;
						immediate <= outputs;
						selop <= "0000";
						ena_write <= '1';
						
				--SLTI	
					when "010" =>	
						mux1 <= MUX1_rs1;
						mux2 <= MUX2_I;
						immediate <= outputs;
						selop <= "0000";
						ena_write <= '1';
				--SLTIU
					when "011" =>	
				--XORI
					when "100" =>
				--ORI
					when "110" =>
				--ANDI
					when "111" =>
				--SLLI
					when "001" =>
				--SRLI & SRAI
					when "101" =>	
					
				end case;	
					
					
					
					
					
					
			when "0110011" =>
			
			when others =>	
			
		end case;
	end if;

	

end process;

end architecture behavioral;


