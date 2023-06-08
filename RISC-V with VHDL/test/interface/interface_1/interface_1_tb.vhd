----------------------------------------------------------
--! @file interface_1_tb.vhd
--! @Testbench for interface_1
-- Filename: interface_1_tb.vhd
-- Description: Testbench for interface_1
-- Author: YIN Haoping
-- Date: May 19, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE work.interface_1_pkg.ALL;

--! Testbench entity description
entity interface_1_tb is
end entity;

architecture tb_behavior of interface_1_tb is
    -- Declare the component to be tested
    component interface_1 is
        port (
            PADDR: OUT std_logic_vector(29 DOWNTO 0);       
            PSTRB: OUT std_logic_vector(3 DOWNTO 0);       
            PWDATA: OUT std_logic_vector(31 DOWNTO 0);       
            PWRITE: OUT std_logic;           
            PENABLE: OUT std_logic;       
            PREQ : OUT std_logic;
            PRDATA: IN std_logic_vector(31 DOWNTO 0);       
            PREADY: IN std_logic;       
            rd_i: IN std_logic;       
            wr_i: IN std_logic;       
            addr_i: IN std_logic_vector(31 DOWNTO 0);       
            size_i: IN std_logic_vector(1 DOWNTO 0);       
            unsigned_i: IN std_logic;       
            wdata_i: IN std_logic_vector(31 DOWNTO 0);       
            rdata_o: OUT std_logic_vector(31 DOWNTO 0);       
            busy_o: OUT std_logic;       
            clk: IN std_logic;       
            rst: IN std_logic       
        );
    end component;
    
	component mock_of_memory is
		port(
			num_wait : IN integer := 2;
			dataread : IN std_logic_vector(31 downto 0);
			testing : out std_logic;
			
			clk : IN std_logic;
			PADDR : IN std_logic_vector(29 downto 0);
			PWDATA : IN std_logic_vector(31 downto 0);
			PSEL : IN std_logic;
			PWRITE : IN std_logic;
			PENABLE : IN std_logic;
			
			PREADY : OUT std_logic;
			PRDATA : OUT std_logic_vector(31 downto 0):= (others => '0')
		);
	
	end component;
	
    -- Testbench signals
    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '1';

	signal rd_i : std_logic := '0';
	signal wr_i : std_logic := '0';
	signal addr_i : std_logic_vector(31 downto 0) := (others => '0');
	signal size_i : std_logic_vector(1 downto 0) := (others => '0');
	signal unsigned_i : std_logic := '0';
	signal wdata_i : std_logic_vector(31 downto 0) := (others => '0');
	signal rdata_o : std_logic_vector(31 downto 0) := (others => '0');
	signal busy_o : std_logic;
	
	signal dataread : std_logic_vector(31 downto 0);
	signal num_wait : integer := 2;
	signal testing : std_logic;
	
	--internal signals
	signal mem_PADDR: std_logic_vector(29 downto 0);
    signal mem_PWDATA: std_logic_vector(31 downto 0);
    signal mem_PSEL: std_logic;
    signal mem_PREADY: std_logic;
    signal mem_PRDATA: std_logic_vector(31 downto 0) := (others => '0');
    -- Add the other signals here like rd_i, wr_i etc.
    -- Initialize these signals with random or specific values for testing
    -- ...

	--output signals
	signal PSTRB_out : std_logic_vector(3 downto 0);
	signal PWRITE_out :std_logic;
	signal PENABLE_out : std_logic;

    -- 50MHz clock period is 20ns
    constant tb_clk_period : time := 10 ns;

begin
    -- Instantiate the interface_1 component	
    UUT: interface_1
        port map (
            clk => tb_clk,
            rst => tb_rst, 
            PSTRB => PSTRB_out,    
            PWRITE => PWRITE_out,			
            PENABLE => PENABLE_out,          
            rd_i => rd_i,       
            wr_i => wr_i,       
            addr_i => addr_i,      
            size_i => size_i,      
            unsigned_i => unsigned_i,       
            wdata_i => wdata_i,    
            rdata_o => rdata_o,     
            busy_o => busy_o,
            PADDR => mem_PADDR,
            PWDATA => mem_PWDATA,
            PREQ => mem_PSEL,
            PRDATA => mem_PRDATA,
            PREADY => mem_PREADY			
        );
		
    memory: mock_of_memory
        port map (
			clk => tb_clk,
            PADDR => mem_PADDR,
            PWDATA => mem_PWDATA,
            PSEL => mem_PSEL,
            PREADY => mem_PREADY,
            PRDATA => mem_PRDATA,
			PENABLE =>PENABLE_out,
			PWRITE => PWRITE_out,
			dataread => dataread,
			num_wait => num_wait,
			testing => testing
        );

	
	
    -- Clock process
    clk_process : process
    begin
        tb_clk <= not tb_clk;
        wait for tb_clk_period / 2;
    end process;
		

		
    -- Stimulus process
    stim_proc: process
		
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

    begin


		
		for i in list32'low to list32'high loop
			test_rd32_transfer(list32(i).addr_val, list32(i).size_val, list32(i).unsigned_i_val, list32(i).num_wait_val, list32(i).wdata_i_val, list32(i).dataread_val, list32(i).rd_i_val,list32(i).wr_i_val,list32(i).tb_rst_val);
		end loop;
		REPORT "32-bit test finished";
		
		for i in list16'low to list16'high loop
			test_rd32_transfer(list16(i).addr_val, list16(i).size_val, list16(i).unsigned_i_val, list16(i).num_wait_val, list16(i).wdata_i_val, list16(i).dataread_val, list16(i).rd_i_val,list16(i).wr_i_val,list16(i).tb_rst_val);		end loop;
		REPORT "16-bit test finished";
		
		for i in list8'low to list8'high loop
			test_rd32_transfer(list8(i).addr_val, list8(i).size_val, list8(i).unsigned_i_val, list8(i).num_wait_val, list8(i).wdata_i_val, list8(i).dataread_val, list8(i).rd_i_val,list8(i).wr_i_val,list8(i).tb_rst_val);
		end loop;
		REPORT "8-bit test finished";
		
	
		ASSERT false
			REPORT "Simulation ended ( not a failure actually ) "
		SEVERITY failure;
    end process;

end architecture tb_behavior;
