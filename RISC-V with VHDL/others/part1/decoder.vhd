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
			selopbits : positive := 4			
	);
	port(
	--inputs		
	commande : in std_logic_vector(31 downto 0);		--! origin commande of RV32I, length of 32 bits
	clk : in std_logic;										--! clock input
	ena_dec : in std_logic := '1';									--! decoder enable
	--outputs
	
	selop : out std_logic_vector(selopbits-1 downto 0);	--! selection operation for ALU

	mux1 : out std_logic;									--! mux1 selection
	mux2 : out std_logic_vector(1 downto 0);			--! mux2 selection
	
	outputs : out std_logic_vector(31 downto 0);	--! immediate output
	ena_write : out std_logic								--! write enable
	);

end entity decoder;


architecture behavioral of decoder is
	signal opcode: std_logic_vector(6 downto 0);		--! signal of opcode
	
	signal rs1  :  std_logic_vector(4 downto 0);		--! signal of rs1
	signal rs2  :  std_logic_vector(4 downto 0);		--! signal of rs2
	signal rd 	:  std_logic_vector(4 downto 0);		--! signal of rd
	signal funct3 : std_logic_vector(2 downto 0);	--! signal of funct3
	signal funct7 : std_logic_vector(6 downto 0);	--! signal of funct7
	signal immediate	:  std_logic_vector(31 downto 0);	--! signal of output
	
--mux	
	constant MUX1_PC : std_logic :='1';					--! constant of mux1 selection pc
	constant MUX1_rs1 : std_logic := '0';				--! constant of mux1 selection rs1
	constant MUX2_I : std_logic_vector(1 downto 0) := "01";	--! constant of mux2 selection I-immediate
	constant MUX2_U : std_logic_vector(1 downto 0) := "11";	--! constant of mux2 selection U-immediate
	constant MUX2_J : std_logic_vector(1 downto 0) := "10";	--! constant of mux2 selection S-immediate
	constant MUX2_rs2 : std_logic_vector(1 downto 0) := "00";	--! constant of mux2 selection rs2
--opcode
	constant OPCODE_LOAD : std_logic_vector(6 downto 0) := "0000011";
	constant OPCODE_MISC_MEM : std_logic_vector(6 downto 0) := "0001111";
	constant OPCODE_OP_IMM : std_logic_vector(6 downto 0) := "0010011";
	constant OPCODE_AUIPC : std_logic_vector(6 downto 0) := "0010111";
	constant OPCODE_STORE : std_logic_vector(6 downto 0) := "0100011";
	constant OPCODE_OP : std_logic_vector(6 downto 0) := "0110011";
	constant OPCODE_LUI : std_logic_vector(6 downto 0) := "0110111";
	constant OPCODE_BRANCH : std_logic_vector(6 downto 0) := "1100011";
	constant OPCODE_JALR : std_logic_vector(6 downto 0) := "1100111";
	constant OPCODE_JAL : std_logic_vector(6 downto 0) := "1101111";
	constant OPCODE_SYSTEM : std_logic_vector(6 downto 0) := "1110011";
	
--funct3
	constant funct3_ADDI : std_logic_vector(2 downto 0) := "000";
	constant funct3_SLTI : std_logic_vector(2 downto 0) := "010";
	constant funct3_SLTIU : std_logic_vector(2 downto 0) := "011";
	constant funct3_ANDI : std_logic_vector(2 downto 0) := "111";
	constant funct3_ORI : std_logic_vector(2 downto 0) := "110";
	constant funct3_XORI : std_logic_vector(2 downto 0) := "100";
	constant funct3_SLLI : std_logic_vector(2 downto 0) := "001";
	constant funct3_SRLI : std_logic_vector(2 downto 0) := "101";
	constant funct3_SRAI : std_logic_vector(2 downto 0) := "101";
	---
	constant funct3_LB : std_logic_vector(2 downto 0) := "000";
	constant funct3_LH : std_logic_vector(2 downto 0) := "001";
	constant funct3_LW : std_logic_vector(2 downto 0) := "010";
	constant funct3_LBU : std_logic_vector(2 downto 0) := "100";
	constant funct3_LHU : std_logic_vector(2 downto 0) := "101";
	---
	constant funct3_ADD : std_logic_vector(2 downto 0) := "000";
	constant funct3_SLT : std_logic_vector(2 downto 0) := "010";
	constant funct3_SLTU : std_logic_vector(2 downto 0) := "011";
	constant funct3_AND : std_logic_vector(2 downto 0) := "111";
	constant funct3_OR : std_logic_vector(2 downto 0) := "110";
	constant funct3_XOR : std_logic_vector(2 downto 0) := "100";
	constant funct3_SLL : std_logic_vector(2 downto 0) := "001";
	constant funct3_SRL : std_logic_vector(2 downto 0) := "101";
	constant funct3_SRA : std_logic_vector(2 downto 0) := "101";
	---
	constant funct3_SB : std_logic_vector(2 downto 0) := "000";
	constant funct3_SH : std_logic_vector(2 downto 0) := "001";
	constant funct3_SW : std_logic_vector(2 downto 0) := "010";
	constant funct3_FENCE : std_logic_vector(2 downto 0) := "000";
	constant funct3_SYSTEM : std_logic_vector(2 downto 0) := "000";
	
--funct7
	constant funct7_ADD : std_logic_vector(6 downto 0) := "0000000";
	---
	constant funct7_SRL : std_logic_vector(6 downto 0) := "0000000";
	constant funct7_SRA : std_logic_vector(6 downto 0) := "0100000";
	constant funct7_SUB : std_logic_vector(6 downto 0) := "0100000";
	constant funct7_SRLI : std_logic_vector(6 downto 0) := "0000000";
	constant funct7_SRAI : std_logic_vector(6 downto 0) := "0100000";
	
--funct12
	constant funct12_ECALL : std_logic_vector(11 downto 0) := "000000000000";
	constant funct12_EBREAK : std_logic_vector(11 downto 0) := "000000000001";
	
--selop alternative 4
	constant ALU_ADD : std_logic_vector(selopbits-1 downto 0) := "0000";
	constant ALU_SUB : std_logic_vector(selopbits-1 downto 0) := "0001";
	constant ALU_SLL : std_logic_vector(selopbits-1 downto 0) := "0010";
	constant ALU_SRL : std_logic_vector(selopbits-1 downto 0) := "0011";
	constant ALU_SRA : std_logic_vector(selopbits-1 downto 0) := "0100";
	constant ALU_AND : std_logic_vector(selopbits-1 downto 0) := "0101";
	constant ALU_OR  : std_logic_vector(selopbits-1 downto 0) := "0110";
	constant ALU_XOR : std_logic_vector(selopbits-1 downto 0) := "0111";
	constant ALU_BEQ : std_logic_vector(selopbits-1 downto 0) := "1000";
	constant ALU_BLT : std_logic_vector(selopbits-1 downto 0) := "1001";
	constant ALU_BLTU : std_logic_vector(selopbits-1 downto 0) := "1010";
	constant ALU_LOAD: std_logic_vector(selopbits-1 downto 0) := "1011";
	constant ALU_STORE : std_logic_vector(selopbits-1 downto 0) :="1100";
	constant ALU_JAL : std_logic_vector(selopbits-1 downto 0) := "1101";
	constant ALU_LUI : std_logic_vector(selopbits-1 downto 0) := "1110";
	--constant ALU_JAL : std_logic_vector(selopbits-1 downto 0) :="1111";
	

begin

process(clk)
begin	

	if ena_dec = '1' then
		if rising_edge(clk) then
			immediate <= (others => '0');
			rs1<= (others =>'0');
			rs2<= (others =>'0');
			rd <= (others =>'0');
			funct3<= (others =>'0');
			funct7<= (others =>'0');
			opcode <= commande(6 downto 0);		
			case opcode is
				--Immediate-Register instruction
				when OPCODE_OP_IMM =>
					rd <= commande(11 downto 7);
					rs1 <= commande(19 downto 15);
					funct3 <= commande(14 downto 12);
					funct7 <= commande(31 downto 25);
					immediate(11 downto 0) <= commande(31 downto 20);
					--ADDI
					case funct3 is
						when funct3_ADDI =>
							mux1 <= MUX1_rs1;	
							mux2 <= MUX2_I;
							outputs <= immediate;
							selop <= ALU_ADD;
							ena_write <= '1';
					--SLTI	
						when funct3_SLTI =>	
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_BLT;
							ena_write <= '1';
					--SLTIU
						when funct3_SLTIU =>	
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_BLTU;
							ena_write <= '1';
					--XORI
						when funct3_XORI =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_XOR;
							ena_write <= '1';
					--ORI
						when funct3_ORI =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_OR;
							ena_write <= '1';
					--ANDI
						when funct3_ANDI =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_AND;
							ena_write <= '1';
					--SLLI
						when funct3_SLLI =>
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_I;
							outputs <= immediate ;
							selop <= ALU_SLL;
							ena_write <= '1';
					--SRLI & SRAI
						when funct3_SRLI =>	
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_rs2;
							outputs <= immediate ;
							if(funct7 = funct7_SRAI) then 
								selop <= ALU_SRA;
							else	
								selop <= ALU_SRL;
							end if;
							ena_write <= '1';
						when others =>	
					end case;	
					
				--Upper immediate instructions
				when OPCODE_AUIPC =>
					
				when OPCODE_LUI =>

				--Register-Register instructions
				when OPCODE_OP =>
					rd <= commande(11 downto 7);
					rs1 <= commande(19 downto 15);
					funct3 <= commande(14 downto 12);
					funct7 <= commande(31 downto 25);
					rs2 <= commande(24 downto 20);
					case funct3 is
					--ADD & SUB
						when funct3_ADD =>
							if funct7 = funct7_ADD then
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_rs2;
							outputs <= rs2 ;
							selop <= ALU_ADD;
							ena_write <= '1';
							elsif funct7 = funct7_SUB then
							mux1 <= MUX1_rs1;
							mux2 <= MUX2_rs2;
							outputs <= rs2 ;
							selop <= ALU_SUB;
							ena_write <= '1';
							end if;
						when funct3_SLT =>
						
						when funct3_SLTU =>
						
						when funct3_AND =>
						
						when funct3_OR =>
						
						when funct3_XOR =>
						
						when funct3_SLL =>
						
					--SRL & SRA	
						when funct3_SRL =>
						
						when others =>
				
					end case;
				
				--Unconditional Jump instructions
				when OPCODE_JAL =>
				
				when OPCODE_JALR =>
				
				
				--Conditional Branches instructions
				
				when  OPCODE_BRANCH =>
				
				--Load and Store instructions
				
				when OPCODE_LOAD =>
				
				when  OPCODE_STORE =>
				
				--Memory Ordering instructions
								
				when  OPCODE_MISC_MEM =>
				
				--Environment Call and Breakpoints instructions
								
				when  OPCODE_SYSTEM =>				
				
				-- Initialization
				when "0000000" =>
					outputs <= (others => '0');
					mux1 <= '0';
					mux2 <= "00";
					selop <= "0000";
					ena_write <= '0';
				when others =>	
				
			end case;
		end if;
	end if;

	

end process;

end architecture behavioral;


