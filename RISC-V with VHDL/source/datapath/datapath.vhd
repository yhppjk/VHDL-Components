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
		
		--interface in
		PRDATA : in std_logic_vector(31 downto 0);
		PREADY : in std_logic;
		--interface out
		PADDR : out std_logic_vector(31 downto 0);
		PSTRB : out std_logic_vector(3 downto 0);
		PWDATA : out std_logic_vector(31 downto 0);
		PWRITE : out std_logic;
		PENABLE : out std_logic;
		PREQ : out std_logic;
		
		port_Membusy : out std_logic := '0';
		
		--these ports are Control Unit part, for testing
		port_fetching : in std_logic;
		port_sel1pc : in std_logic;
		port_sel2pc : in std_logic_vector(1 downto 0);
		port_ipc : in std_logic;
		port_JB : in std_logic;
		port_XZ : in std_logic;
		port_XN : in std_logic;
		port_XF : in std_logic;
		port_wRD : in std_logic;
		port_selRD : in std_logic;
		port_sel1alu : in std_logic;
		port_sel2alu : in std_logic_vector(1 downto 0);
		port_selopalu : in std_logic_vector(3 downto 0);
		port_wIR : in std_logic;
		port_RD : in std_logic;
		port_WR : in std_logic;
		port_IDMEM : in std_logic;
		
		port_ALU_res : out std_logic_vector(31 downto 0);
		port_ALU_flag : out std_logic_vector(2 downto 0)
		
	);

end entity;

architecture behavioral of datapath  is

--only create input signals
	--Control Unit
	signal Membusy : std_logic := '0';

	--MUX1PC
	signal PC_value : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_value : std_logic_vector(31 downto 0);
	signal sel1PC : std_logic;
	
	--MUX2PC
	signal B_immediate : std_logic_vector(31 downto 0):= (others => '0');
	signal J_immediate : std_logic_vector(31 downto 0):= (others => '0');
	signal sel2PC : std_logic_vector(1 downto 0);
	
	--targetPC
	signal MUX1PC_out : std_logic_vector(31 downto 0):= (others => '0');
	signal MUX2PC_out : std_logic_vector(31 downto 0):= (others => '0');
	
	--wrpc
	signal pc_JB : std_logic;
	signal pc_XZ : std_logic;
	signal pc_XN : std_logic;
	signal pc_XF : std_logic;
	signal ALU_flag :std_logic_vector(2 downto 0);

	
	--PC
	signal targetPC : std_logic_vector(31 downto 0) := (others => '0');
	--signal wPC_out : std_logic;
	signal wPC : std_logic;
	signal iPC_out : std_logic;
	
	--muxAddress
	signal Address_to_IMEM : std_logic_vector(31 downto 0);
	signal Address_to_DMEM : std_logic_vector(31 downto 0);
	signal IDMEM : std_logic;
	--signal Address_to_MEM : std_logic_vector(31 downto 0);
	
	--IR
	signal LoadIR : std_logic := '0';
	--signal Value_from_IMEM : std_logic_vector(31 downto 0);
	
	--RI
	signal RI_value: std_logic_vector(31 downto 0);
	--signal rs1 : std_logic_vector(4 downto 0); 
	--signal rs2 : std_logic_vector(4 downto 0);
	--signal rd : std_logic_vector(4 downto 0);
	signal funct3 : std_logic_vector(2 downto 0) := "010";
	
	--MUX1ALU
	--signal rs1_value
	--signal PC_value
	signal sel1ALU :std_logic;
	
	--MUX2ALU
	signal rs2_value : std_logic_vector(31 downto 0);
	signal I_immediate : std_logic_vector(31 downto 0):= (others => '0');
	signal U_immediate : std_logic_vector(31 downto 0):= (others => '0');
	signal S_immediate : std_logic_vector(31 downto 0):= (others => '0');
	signal sel2ALU : std_logic_vector(1 downto 0);
	
	--alu
	signal mux1ALU_out : std_logic_vector(31 downto 0);
	signal mux2ALU_out : std_logic_vector(31 downto 0);
	--signal selopALU : std_logic_vector(3 downto 0); 
	
	--Memory Interface
	--signal PRDATA : std_logic_vector(31 downto 0);
	--signal PREADY : std_logic;
	--signal RDMEM : std_logic;
	--signal WRMEM : std_logic;
	signal Address_to_MEM : std_logic_vector(31 downto 0);
	signal funct3_1_0 : std_logic_vector(1 downto 0);
	signal funct3_2 : std_logic;
	--signal Value_to_DMEM :std_logic_vector(31 downto 0);		--rs2 value
	
	--muxRD
	signal ALU_value : std_logic_vector(31 downto 0) := (others => '0');
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
	
	--funct3 mux
	--signal sel_fetching : std_logic;
	signal funct3_actual : std_logic_vector(2 downto 0);
	
		--control unit output signals
	signal cu_sel1PC : std_logic;
	signal cu_sel2PC : std_logic_vector(1 downto 0);
	signal cu_iPC : std_logic;
	signal cu_JB : std_logic;
	signal cu_XZ : std_logic;
	signal cu_XN : std_logic;
	signal cu_XF : std_logic;
	signal cu_wRD : std_logic;
	signal cu_selRD : std_logic;
	signal cu_sel1ALU : std_logic;
	signal cu_sel2ALU : std_logic_vector(1 downto 0);
	--signal cu_selopALU : std_logic_vector(3 downto 0);
	signal cu_wIR : std_logic;
	signal cu_RDMEM : std_logic := '0';
	signal cu_WRMEM : std_logic := '0';
	signal cu_IDMEM : std_logic;
	
	--memory interface input signals
	-- signal ram_PRDATA : std_logic_vector(31 downto 0);
	-- signal ram_PREADY : std_logic;
	
	--memory interface output signals
	-- signal ram_PADDR : std_logic_vector(31 downto 0);
	-- signal ram_PSTRB : std_logic_vector(3 downto 0);
	-- signal ram_PWDATA : std_logic_vector(31 downto 0);
	-- signal ram_PWRITE : std_logic;
	-- signal ram_PENABLE : std_logic;
	-- signal ram_PREQ : std_logic;
	
	
	
BEGIN
	
	MUX1PC : mux2togen												--PC mux block1
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => PC_value,
			din1 => rs1_value,
			sel => port_sel1pc,
			dout => MUX1PC_out
		);

	MUX2PC : mux4togen												--PC mux block2
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => B_immediate,
			din1 => J_immediate,
			din2 => I_immediate,
			din3 => (others => '0'),
			sel => port_sel2pc,
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
			ena_pc => port_ipc,
			current_pc => PC_value
		);
	
	wrpc_datapath : wrpc
		port map(
			input_JB => port_JB,	--! The instruction is a jump or branch
			input_XZ => port_XZ,	--! Use nothing, Z or C to decide
			input_XN => port_XN,	--! Use nothing, N or C to decide
			input_XF => port_XF,	--! The selected ALU flag must match this value to take the branch
			alu_z => ALU_flag(0),		--! ALU flag Z
			alu_n => ALU_flag(1),		--! ALU flag N	
			alu_c => ALU_flag(2),		--! ALU flag C
			--OUTPUTS
			wrpc_out => wPC	--! wrpc output
		
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
			writeEna => port_wRD,  			--! the input port of write enable
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
			sel => port_sel1alu,
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
			sel => port_sel2alu,
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
			selop => port_selopalu,
		--OUTPUTS
			res => ALU_value,
			flags => ALU_flag
		);
	
	MUX_RD : mux2togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => ALU_value,
			din1 => Value_from_DMEM,
			sel => port_selRD,
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
			rd_i => port_RD,
			wr_i => port_WR,
			addr_i => Address_to_MEM,
			size_i => funct3_actual(1 downto 0),
			unsigned_i => funct3_actual(2),
			wdata_i => rs2_value
		);	
		
	mux_address : mux2togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			--din0 => PC_value,
			din0 => Address_to_IMEM,
			din1 => ALU_value,
			sel => port_IDMEM,
			dout => Address_to_MEM
		);
		
	mux_funct3 : mux2togen
		GENERIC map(
			width => 3,
			prop_delay => 0 ns
		)
		port map(
			din1 => "010",
			din0 => funct3,
			sel => port_fetching,
			dout => funct3_actual
		);	
		
	I_immediate <= x"00000" & RI_value(31 downto 20) when RI_value(31) = '0'
				else x"FFFFF" & RI_value(31 downto 20) when RI_value(31) = '1';
				
	S_immediate <= x"00000" & RI_value(31 downto 25) & RI_value(11 downto 7) when RI_value(31) ='0'
				else x"FFFFF" & RI_value(31 downto 25) & RI_value(11 downto 7) when RI_value(31) = '1';
				
	U_immediate <= x"000" & RI_value(31 downto 12) when RI_value(31) ='0'
				else x"FFF" & RI_value(31 downto 12) when RI_value(31) ='1';
				
	B_immediate <= "0000000000000000000" & RI_value(31) & RI_value(7) & RI_value(30 downto 25) & RI_value(11 downto 8) & '0' when RI_value(31) = '0'	
				else "1111111111111111111" & RI_value(31) & RI_value(7) & RI_value(30 downto 25) & RI_value(11 downto 8) & '0' when RI_value(31) = '1';
	
	J_immediate <= "00000000000" & RI_value(31) & RI_value(19 downto 12) & RI_value(20) & RI_value(30 downto 21) & '0' when RI_value(31) = '0'
				else "11111111111" & RI_value(31) & RI_value(19 downto 12) & RI_value(20) & RI_value(30 downto 21) & '0' when RI_value(31) = '1';
	
	funct3 <= RI_value(14 downto 12) when RI_value /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
	rs1 <= RI_value(19 downto 15);
	rs2 <= RI_value(24 downto 20);
	rd <= RI_value(11 downto 7);
		
	LoadIR <= port_wIR and not(Membusy);	
	targetPC <= std_logic_vector(unsigned(MUX1PC_out) + unsigned(MUX2PC_out));

	Address_to_IMEM <= PC_value;
	Address_to_DMEM <= rs2_value;
	
	port_Membusy <= Membusy;
	port_ALU_res <= ALU_value;
	port_ALU_flag <= ALU_flag;
	
end architecture;



