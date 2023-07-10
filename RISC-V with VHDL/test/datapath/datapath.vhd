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
use work.datapath_pkg.all;

--! datapath  entity description

--! Detailed description of this
--! datapath  design element.
entity datapath  is

	port (
        clk: IN std_logic;		--clock input
        rst: IN std_logic;		--low level asynchronous reset
		
		PRDATA : in std_logic_vector(31 downto 0);
		PREADY : in std_logic;
		
		PADDR : out std_logic_vector(31 downto 0);
		PSTRB : out std_logic_vector(3 downto 0);
		PWDATA : out std_logic_vector(31 downto 0);
		PWRITE : out std_logic;
		PENABLE : out std_logic;
		PREQ : out std_logic
		
	);

end entity;

architecture behavioral of datapath  is

--only create input signals
	--Control Unit
	signal Membusy : std_logic;

	--MUX1PC
	signal PC_value : std_logic_vector(31 downto 0) := (others => '0');
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
	signal pc_JB : std_logic;
	signal pc_XZ : std_logic;
	signal pc_XN : std_logic;
	signal pc_XF : std_logic;
	signal PC_flag :std_logic_vector(2 downto 0);
	signal pc_Z  : std_logic;
	signal pc_N  : std_logic;
	signal pc_C  : std_logic;
	
	--PC
	signal targetPC : std_logic_vector(63 downto 0);
	signal wPC_out : std_logic;
	signal wPC : std_logic;
	signal iPC_out : std_logic;
	
	--muxAddress
	signal Address_to_IMEM : std_logic_vector(31 downto 0);
	signal Address_to_DMEM : std_logic_vector(31 downto 0);
	signal IDMEM : std_logic;
	--signal Address_to_MEM : std_logic_vector(31 downto 0);
	
	--IR
	signal LoadIR : std_logic;
	--signal Value_from_IMEM : std_logic_vector(31 downto 0);
	
	--RI
	signal RI_value: std_logic_vector(31 downto 0);
	--signal rs1 : std_logic_vector(4 downto 0); 
	--signal rs2 : std_logic_vector(4 downto 0);
	--signal rd : std_logic_vector(4 downto 0);
	signal funct3 : std_logic_vector(2 downto 0);
	
	--MUX1ALU
	--signal rs1_value
	--signal PC_value
	signal sel1ALU :std_logic;
	
	--MUX2ALU
	signal rs2_value : std_logic_vector(31 downto 0);
	signal I_immediate : std_logic_vector(31 downto 0);
	signal U_immediate : std_logic_vector(31 downto 0);
	signal S_immediate : std_logic_vector(31 downto 0);
	signal sel2ALU : std_logic_vector(1 downto 0);
	
	--alu
	signal mux1ALU_out : std_logic_vector(31 downto 0);
	signal mux2ALU_out : std_logic_vector(31 downto 0);
	signal selopALU : std_logic_vector(3 downto 0); 
	
	--Memory Interface
	--signal PRDATA : std_logic_vector(31 downto 0);
	--signal PREADY : std_logic;
	signal RDMEM : std_logic;
	signal WRMEM : std_logic;
	signal Address_to_MEM : std_logic_vector(31 downto 0);
	signal funct3_1_0 : std_logic_vector(1 downto 0);
	signal funct3_2 : std_logic;
	--signal Value_to_DMEM :std_logic_vector(31 downto 0);		--rs2 value
	
	--muxRD
	signal ALU_value : std_logic_vector(31 downto 0);
	signal Value_from_DMEM : std_logic_vector(31 downto 0);
	signal selRD : std_logic;

	--regfile
	signal rs1 : std_logic_vector(4 downto 0); 
	signal rs2 : std_logic_vector(4 downto 0);
	signal rd : std_logic_vector(4 downto 0);
	signal rd_value : std_logic_vector(31 downto 0);
	signal wRD : std_logic;
	--signal rs1_value : std_logic_vector(31 downto 0);
	--signal rs2_value : std_logic_vector(31 downto 0);
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
	
	instruction_register : registergen							--register of IR
		generic map (
			width => 32,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => Value_from_DMEM,
			writ => LoadIR,
			clk => clk,
			reg_out => RI_value,
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
		generic map (	
			dataWidth => 32,				--! generic of datawidth
			addressWidth => 5,				--! generic of address width
			--num_reg : positive := 32;				--! generic of size of register file
			reset_zero => false,			--! reset address 0 only
			ignore_zero => false,			--! ignore write address 0
			combination_read => false,		--! generic of Combination and sychrnonous selection
			read_delay => 0 ns
		)
		port map (
			clk => clk,       			--! the input port of clock
			reset => rst,				--! the input port of reset
			writeEna => wRD,  			--! the input port of write enable
			writeAddress => rd,		--! the input port of wirte address
			writeData => rd_value,			--! the input port of write data
			readAddress1 => rs1,		--! the input port of read address1
			readAddress2 => rs2,		--! the input port of read address2
			readData1 => rs1_value,		--! the output port of read data1
			readData2 => rs2_value		--! the output port of read data2
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
			dout => mux1ALU_out
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
			sel => sel2ALU,
			dout => mux2ALU_out
		);		
	ALU_part : alu
		GENERIC map(
			selopbits => 4,
			flagbits => 3
		)
		port map(
			op1 => mux1ALU_out,
			op2 => mux2ALU_out,
			selop => selopALU,
		--OUTPUTS
			res => ALU_value,
			flags => PC_flag
		);
	
	MUX_RD : mux2togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => ALU_value,
			din1 => Value_from_DMEM,
			sel => selRD,
			dout => rd_value
		);	
	
	memory_interface : interface_1 
		port map(
			clk => clk,
			rst	=> rst,	
			--memory side,AMBA APB master
			PADDR => PADDR,
			PSTRB => PSTRB,
			PWDATA => PWDATA,
			PWRITE => PWRITE,
			PENABLE	=> PENABLE,		
			PREQ => PREQ,
			
			rdata_o => Value_from_DMEM,
			busy_o	=> Membusy,	
			
			PRDATA => PRDATA,
			PREADY => PREADY,			
			rd_i => RDMEM,
			wr_i => WRMEM,
			addr_i => Address_to_MEM,
			size_i => funct3_1_0,
			unsigned_i => funct3_2,
			wdata_i => rs2_value
		);	
		

		funct3 <= RI_value(13 downto 11);
		rs1 <= RI_value(18 downto 14);
		rs2 <= RI_value(23 downto 19);
		rd <= RI_value(10 downto 6);
		
end architecture;



