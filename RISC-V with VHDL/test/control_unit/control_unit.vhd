----------------------------------------------------------
--! @file control_unit 
--! @A control_unit  
-- Filename: control_unit .vhd
-- Description: A control_unit  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! control_unit  entity description

--! Detailed description of this
--! control_unit  design element.
entity control_unit  is
    generic (
        dataWidth : positive := 32;			--! generic of datawidth
		addressWidth : positive := 5;		--! generic of address width
		sychro_reset : boolean := false; 	--! sychronous reset
		reset_zero : boolean := false;		--! reset address 0 only
		ignore_zero : boolean := false;		--! ignore write address 0
		combination_read : boolean := false;	--! generic of Combination and sychrnonous selection
		read_delay: time := 0 ns			--! generic of read delay time
    );
	port (
        clk: IN std_logic;					--clock input
        rst: IN std_logic;					--low level asynchronous reset
		instruction: IN std_logic_vector(31 downto 0);		--32 bit  instruction from memory
		membusy: IN std_logic;				--1 bit used to indicate a memory operation is ongoing and that execution can't proceed
		
		sel1PC : OUT std_logic;				--control signals required by the datapath and memory interface
		sel2PC : OUT std_logic				--control signals required by the datapath and memory interface
	);	

end entity;

architecture behavioral of control_unit  is

signal opcode_6_2 : std_logic_vector(4 downto 0);
signal funct3 : std_logic_vector(2 downto 0);
signal funct7_5 : std_logic;
signal funct12_0 : std_logic;

signal INUM : unsigned;



BEGIN	

process(clk, rst)
begin

	if rst = '1' then
		INUM <= (others => '0');
		opcode_6_2 <= (others => '0');
		funct3 <= (others => '0');
		funct7_5 <= (others => '0');
		funct12_0 <=  (others => '0');
	elsif rising_edge(clk) then
		opcode_6_2 <= instruction(6 downto 2);
		funct3  <= instruction(14 downto 12);
		funct7_5 <= instruction(29);
		funct12_0 <= instruction(20);
		case opcode_6_2 is 
			when "00011" =>					--! FENCE
				INUM <= x"04";
			when "00000" =>					--! LOAD
				INUM <= x"08";
			when "01000" =>					--! STORE
				INUM <= x"0C";
			when "00101" =>					--! AUIPC
				INUM <= x"10";	
			when "01101" =>					--! LUI
				INUM <= x"14";
			when "11001" =>					--! JALR
				INUM <= x"18";
			when "11011" =>					--! JAL
				INUM <= x"1C";				
			when "11000" =>					--! BRANCH
				case funct3 is 
					when "000" =>				--! BEQ
						INUM <= x"20";
					when "001" =>				--! BNE
						INUM <= x"24";
					when "100" =>				--! BLT
						INUM <= x"28";
					when "101" =>				--! BGE
						INUM <= x"2C";
					when "110" =>				--! BLTU
						INUM <= x"30";
					when "111" =>				--! BGEU
						INUM <= x"34";
					when others =>
				end case;
			when "11100" =>					--! SYSTEM
				if funct3 = "000" then
					if funct12_0 = '0' then
						INUM <= x"38";			--! ECALL
					elsif funct12_0 = '1' then
						INUM <= x"3C";			--! EBREAK
					end if;
				end if;
			when "00100" =>					--! OP-IMM
				case funct3 is	
					when "000" =>
						INUM <= x"40";			--! ADDI
					when "001" =>
						INUM <= x"44";			--! SLLI
					when "010" =>	
						INUM <= x"48"; 			--! SLTI
					when "011" =>
						INUM <= x"4C";			--! SLTIU
					when "100" =>
						INUM <= x"50";			--! XORI
					when "101" =>
						if funct7_5 = '0' then
							INUM <= x"54";		--! SRLI
						elsif funct7_5 = '1' then
							INUM <= x"58";		--! SRAI
						end if
					when "110" =>
						INUM <= x"5C";			--! ORI
					when "111" =>
						INUM <= x"60";			--! ANDI
					when others =>
				end case;
				
			when "01100" =>					--! OP
				case funct3 is 
					when "000" =>	
						if funct7_5 ='0' then
							INUM <= x"64";		--! ADD
						elsif funct7_5 = '1' then
							INUM <= x"68";		--! SUB
						end if;
					when "001" =>
						INUM <= x"6C";			--! SLL
					when "010" =>
						INUM <= x"70";			--! SLT
					when "011" =>
						INUM <= x"74";			--! SLTU
					when "100" =>
						INUM <= x"78";			--! XOR
					when "101" =>
						if funct7_5 ='0' then
							INUM <= x"7C";		--! SRL
						elsif funct7_5 = '1' then
							INUM <= x"80";		--! SRA
						end if;
					when "110" =>
						INUM <= x"84";			--! OR
					when "111" =>
						INUM <= x"88";			--! AND
					when others =>
				end case;
			when "00010" =>					--! CUSTOM-0
				case funct3 is
					when "000" =>
						INUM <= x"90";
					when "001" =>
						INUM <= x"94";
					when "010" =>
						INUM <= x"98";
					when "011" =>
						INUM <= x"9C";
					when "100" =>
						INUM <= x"A0";
					when "101" =>
						INUM <= x"A4";
					when "110" =>
						INUM <= x"A8";
					when "111" =>
						INUM <= x"AC";
					when others =>
				end case;
			when "01010" =>					--! CUSTOM-1
				INUM <= x"B0";
			when "10110" =>					--! CUSTOM-2
				INUM <= x"C0";
			when "11110" =>					--! CUSTOM-3
				INUM <= x"D0";
			when others =>
		end case;
						
						
						
						
						
						
						
						
						
						
						
						
	end if;



end process;




	
end architecture;






