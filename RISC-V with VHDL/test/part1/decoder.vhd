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
	ena_dec : in std_logic := '1';									--! decoder enable
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
	signal funct7 : std_logic_vector(6 downto 0);	--! signal of funct7
	signal outputs	:  std_logic_vector(31 downto 0);	--! signal of output
	
	constant MUX1_PC : std_logic :='1';					--! constant of mux1 selection pc
	constant MUX1_rs1 : std_logic := '0';				--! constant of mux1 selection rs1
	constant MUX2_I : std_logic_vector(1 downto 0) := "01";	--! constant of mux2 selection I-immediate
	constant MUX2_U : std_logic_vector(1 downto 0) := "11";	--! constant of mux2 selection U-immediate
	constant MUX2_J : std_logic_vector(1 downto 0) := "10";	--! constant of mux2 selection S-immediate
	constant MUX2_rs2 : std_logic_vector(1 downto 0) := "00";	--! constant of mux2 selection rs2
	
	constant OPCODE_OP : std_logic_vector(6 downto 0) := "0110011";
	constant OPCODE_OPIMM : std_logic_vector(6 downto 0) := "0010011";
	constant OPCODE_LOAD : std_logic_vector(6 downto 0) := "0000011";	
	constant OPCODE_STORE : std_logic_vector(6 downto 0) := "0100011";
	constant OPCODE_BRANCH : std_logic_vector(6 downto 0) := "1100011";
	constant OPCODE_JAL : std_logic_vector(6 downto 0) := "1101111";
	constant OPCODE_JALR : std_logic_vector(6 downto 0) := "1100111";
	constant OPCODE_LUI : std_logic_vector(6 downto 0) := "0110111";
	constant OPCODE_AUIPC : std_logic_vector(6 downto 0) := "0010111";
	--constant OPCODE_MEM : std_logic_vector(6 downto 0) := "1100011";
	constant OPCODE_SYSTEM : std_logic_vector(6 downto 0) := "1110011";
	
begin

process(clk)
begin	

	if rising_edge(clk) then
		if ena_dec = '1' then
			outputs <= (others => '0');
			rs1<= (others =>'0');
			rs2<= (others =>'0');
			rd <= (others =>'0');
			funct3<= (others =>'0');
			funct7<= (others =>'0');
			opcode <= commande(6 downto 0);		
			case opcode is
				--I-type instruction
				when "0010011" =>
					rd <= commande(11 downto 7);
					rs1 <= commande(19 downto 15);
					funct3 <= commande(14 downto 12);
					outputs(11 downto 0) <= commande(31 downto 20);
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
							selop <= "1000";
							ena_write <= '1';
					--SLTIU
						when "011" =>	
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "1001";
							ena_write <= '1';
					--XORI
						when "100" =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "0100";
							ena_write <= '1';
					--ORI
						when "110" =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "0011";
							ena_write <= '1';
					--ANDI
						when "111" =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "0010";
							ena_write <= '1';
					--SLLI
						when "001" =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "0101";
							ena_write <= '1';
					--SRLI & SRAI
						when "101" =>	
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							immediate <= outputs;
							selop <= "0110";
							ena_write <= '1';
						when others =>	
					end case;	
				--R-type instructions
				when "0110011" =>
					rd <= commande(11 downto 7);
					rs1 <= commande(19 downto 15);
					funct3 <= commande(14 downto 12);
					funct7 <= commande(31 downto 25);
					rs2 <= commande(24 downto 20);
					outputs(4 downto 0)<= rs2;
					case funct3 is
					--ADD & SUB
						when "000" =>
							if funct7 ="0000000" then
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_rs2;
							immediate <= outputs;
							selop <= "0110";
							ena_write <= '1';
							elsif funct7 = "0100000" then
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_rs2;
							immediate <= outputs;
							selop <= "0110";
							ena_write <= '1';
							end if;
						when "001" =>
					--
						when "010" =>
						
						when "011" =>
						
						when "100" =>
						
						when "101" =>
						
						when "110" =>
						
						when "111" =>
						
						when others =>
				--J-type instructions
					end case;
				when others =>	
				
			end case;
		end if;
	end if;

	

end process;

end architecture behavioral;


