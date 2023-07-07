----------------------------------------------------------
--! @file datapath 
--! @A datapath  for calculation 
-- Filename: datapath .vhd
-- Description: A datapath  
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! datapath  entity description

--! Detailed description of this
--! datapath  design element.
entity datapath  is

	port (
        clk: IN std_logic;		--clock input
        rst: IN std_logic		--low level asynchronous reset
		
		
	);

end entity;

architecture behavioral of datapath  is

--only create input signals
	--MUX1PC
	signal PC_value : std_logic_vector(31 downto 0);
	signal rs1_value : std_logic_vector(31 downto 0);
	signal sel1PC : std_logic;
	
	--MUX2PC
	signal B_immediate : std_logic_vector(31 downto 0);
	signal J_immediate : std_logic_vector(31 downto 0);
	signal sel2PC : std_logic;
	
	--targetPC
	signal MUX1PC_out : std_logic_vector(31 downto 0);
	signal MUX2PC_out : std_logic_vector(31 downto 0);
	
	--wrpc
	
	
	--PC
	signal targetPC : std_logic_vector(63 downto 0);
	signal wPC_out : std_logic;
	signal wPC : std_logic;
	signal iPC_out : std_logic;
	

	
	--muxAddress
	signal Address_to_IMEM : std_logic_vector(31 downto 0);
	signal Address_to_DMEM : std_logic_vector(31 downto 0);
	signal IDMEM : std_logic;
	signal Address_to_MEM : std_logic_vector(31 downto 0);
	
	--IR
	signal LoadIR : std_logic;
	signal rdata_out : std_logic_vector(31 downto 0);
	
	--RI
	signal rs1 : std_logic_vector(4 downto 0); 
	signal rs2 : std_logic_vector(4 downto 0);
	signal rd : std_logic_vector(4 downto 0);
	signal funct3 : std_logic_vector(4 downto 0);
	
	
	
	
	

BEGIN
	
	MUX1PC : mux2togen												--PC mux block1
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => PC_value,
			din1 => rs1_value,
			sel => sel1PC,
			dout => MUX1PC_out
		);

	MUX2PC : mux2togen												--PC mux block2
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => B_immediate,
			din1 => J_immediate,
			sel => sel2PC,
			dout => MUX2PC_out
		);
	
	MUX1ALU : mux2togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => rs1_value,
			din1 => PC_value,
			sel => sel1ALU,
			dout => op1
		);	
	
	MUX2ALU : mux4togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => rs2_value,
			din1 => I_immediate,
			din2 => U_immediate,
			din3 => S_immediate,
			sel => sel1ALU,
			dout => op1
		);		
	
	
	
	
	
	instruction_register : registergen							--register of IR
		generic map (
			width => 32,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => rdata_out,
			writ => LoadIR,
			clk => clk,
			reg_out => register_out_PWDATA,
			rst => '0'
		);
	
	pc_datapath : pc
		generic map( datawidth => 32)
		port map(
			clk => clk,
			reset => rst,
			ena_in => wPC,
			data_in => targetPC,
			ena_pc => iPC_out,
			current_pc => PC_value
		);
	
	register_file : reg_file    
		generic (	
			dataWidth => 32,				--! generic of datawidth
			addressWidth => 5,				--! generic of address width
			--num_reg : positive := 32;				--! generic of size of register file
			reset_zero => false,			--! reset address 0 only
			ignore_zero => false,			--! ignore write address 0
			combination_read => false,		--! generic of Combination and sychrnonous selection
			read_delay => 0 ns
		);
		port (
			clk => clk,       			--! the input port of clock
			reset => rst,				--! the input port of reset
			writeEna => WCmd,  			--! the input port of write enable
			writeAddress => WAdd,		--! the input port of wirte address
			writeData => WVal,			--! the input port of write data
			readAddress1 => rs1,		--! the input port of read address1
			readAddress2 => rs2,		--! the input port of read address2
			readData1 => rs1_value,		--! the output port of read data1
			readData2 => rs2_value,		--! the output port of read data2
		);
	
	
	
end architecture;



