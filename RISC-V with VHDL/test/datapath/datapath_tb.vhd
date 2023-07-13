----------------------------------------------------------
--! @file datapath_tb.vhd
--! @A program counter  
-- Filename: datapath_tb.vhd
-- Description: testbench datapath
-- Author: YIN Haoping
-- Date: july 13, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY interface_tb IS
END ENTITY;

ARCHITECTURE behavior OF interface_tb IS
    COMPONENT datapath
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
		PREQ : out std_logic;
		
		--these ports are Control Unit part, for testing
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
		port_IDMEM : in std_logic
		
		
		
	);
    END COMPONENT;
	
	--clock signal definition
	signal tb_clk:  std_logic := '1';		--clock input
	signal tb_rst:  std_logic;		--low level asynchronous reset
	constant clk_period : time := 10 ns;
	
	--instruction part
	
	
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
	signal cu_selopALU : std_logic_vector(3 downto 0);
	signal cu_wIR : std_logic;
	signal cu_RDMEM : std_logic;
	signal cu_WRMEM : std_logic;
	signal cu_IDMEM : std_logic;
	
	--memory interface input signals
	signal ram_PRDATA : std_logic_vector(31 downto 0);
	signal ram_PREADY : std_logic;
	
	--memory interface output signals
	signal ram_PADDR : std_logic_vector(31 downto 0);
	signal ram_PSTRB : std_logic_vector(3 downto 0);
	signal ram_PWDATA : std_logic_vector(31 downto 0);
	signal ram_PWRITE : std_logic;
	signal ram_PENABLE : std_logic;
	signal ram_PREQ : std_logic;





BEGIN
	UUT : datapath
	port map(
        clk => tb_clk,
        rst => tb_rst,
		
		PRDATA => ram_PRDATA,
		PREADY => ram_PREADY,
		
		PADDR => ram_PADDR,
		PSTRB => ram_PSTRB,
		PWDATA => ram_PWDATA,
		PWRITE => ram_PWRITE,
		PENABLE => ram_PENABLE,
		PREQ => ram_PREQ,
		
		--test cu
		port_sel1pc => cu_sel1PC,
		port_sel2pc => cu_sel2PC,
		port_ipc => cu_iPC,
		port_JB => cu_JB,
		port_XZ => cu_XZ,
		port_XN => cu_XN,
		port_XF => cu_XF,
		port_wRD => cu_wRD,
		port_selRD => cu_selRD,
		port_sel1alu => cu_sel1ALU,
		port_sel2alu => cu_sel2ALU,
		port_selopalu => cu_selopALU,
		port_wIR => cu_wIR,
		port_RD => cu_RDMEM,
		port_WR => cu_WRMEM,
		port_IDMEM => cu_IDMEM
	);

	clk_process: process
    begin
        tb_clk <= not tb_clk;
        wait for clk_period;

    END PROCESS clk_process;

	simulation : PROCESS
		-- Procedure for giving values to signal
		procedure test_rd32_transfer(
		constant addr_i_val : in std_logic_vector(31 DOWNTO 0);
		constant size_i_val : in std_logic_vector(1 DOWNTO 0);
		constant unsigned_i_val : in std_logic;
		constant num_wait_val: in integer;
		constant wdata_i_val : in std_logic_vector(31 DOWNTO 0);
		constant dataread_val: in std_logic_vector(31 downto 0);
		constant rd_i_val : in std_logic;
		constant wr_i_val : in std_logic;
		constant tb_rst_val : in std_logic
		) is
		begin
			addr_i <= addr_i_val;
			size_i <= size_i_val;
			unsigned_i <= unsigned_i_val;
			num_wait <= num_wait_val;
			wdata_i <= wdata_i_val;
			dataread <= dataread_val;
			rd_i <= rd_i_val;
			wr_i <= wr_i_val;
			tb_rst <= tb_rst_val;
			wait until rising_edge(tb_clk) and testing = '1';
			for i in 0 to num_wait loop
				wait until rising_edge(tb_clk);
			end loop;  
		end procedure test_rd32_transfer;
	
	
	BEGIN
	
		tb_rst <= '1';
		wait until falling_edge(tb_clk);
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;

	
	
	
	
	
	
	end process simulation;



end ARCHITECTURE;