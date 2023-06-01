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
	signal num_wait : integer;
	
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
			num_wait => num_wait
        );

	
    -- Clock process
    clk_process : process
    begin
        tb_clk <= not tb_clk;
        wait for tb_clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset pulse
        tb_rst <= '0';
        wait for tb_clk_period * 2;
	
		rd_i <= '1';
		wr_i <= '0';
		size_i <= "10";
		addr_i <= "00000000000000000000000000000011";
		unsigned_i <= '1';
		
		num_wait <= 0;
		dataread <= x"0A0A0A0A";
		
		wait for 50 ns;



        -- Add your test cases here
		-- num_wait <= 0; dataread <= x"00000000";
		
		-- rd_i <= '0';
		-- wr_i <= '1';
		
		-- size_i <= "10";
		-- addr_i <= "00000000000000000000000000000011";
		-- unsigned_i <= '1';
		-- wdata_i <= "01010101010101010101010101010101";
		
		-- wait for 50 ns;
		
		-- addr_i <= "00000000000000000000000000000111";
		-- wait for 50 ns;
		
		-- addr_i <= "00000000000000000000000000001011";
		-- wdata_i <= "11111111111111110101010101010101";
		-- wait for 50 ns;
		
		-- rd_i <= '1';
		-- wr_i <= '0';
		-- addr_i <= "00000000000000000000000000000011";

		-- wait for 50 ns;
		-- addr_i <= "00000000000000000000000000001011";
		-- wait for 50 ns;


		ASSERT false
			REPORT "Simulation ended ( not a failure actually ) "
		SEVERITY failure;
    end process;

end architecture tb_behavior;
