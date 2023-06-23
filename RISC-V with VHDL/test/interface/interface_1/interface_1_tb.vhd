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
			PSTRB : IN std_logic_vector(3 downto 0);
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
	signal tb_PSTRB : std_logic_vector(3 downto 0);
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
	signal PWRITE_out :std_logic;
	signal PENABLE_out : std_logic;

	--test cached signals
		signal cached_PENABLE : std_logic;
		signal cached_PSTRB : std_logic_vector(3 downto 0);
		signal cached_PWRITE : std_logic;
		signal cached_mem_PRDATA : std_logic_vector(31 downto 0);
		signal cached_busy_o : std_logic;
    -- 50MHz clock period is 20ns
    constant tb_clk_period : time := 10 ns;

begin
    -- Instantiate the interface_1 component	
    UUT: interface_1
        port map (
            clk => tb_clk,
            rst => tb_rst, 
            PSTRB => tb_PSTRB,    
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
			testing => testing,
			PSTRB => tb_PSTRB
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
		--Initialization for seveval cycles
		rd_i <= '0';
		wr_i <= '0';
		tb_rst <= '1';
		wait until falling_edge(tb_clk);
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
	-- 32bit test
		for i in list32_one_read'low to list32_one_read'high loop
			test_rd32_transfer(list32_one_read(i).addr_val, list32_one_read(i).size_val, list32_one_read(i).unsigned_i_val, list32_one_read(i).num_wait_val, list32_one_read(i).wdata_i_val, list32_one_read(i).dataread_val, list32_one_read(i).rd_i_val,list32_one_read(i).wr_i_val,list32_one_read(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "32-bit read test finished";
		
		for i in list32_one_write'low to list32_one_write'high loop
			test_rd32_transfer(list32_one_write(i).addr_val, list32_one_write(i).size_val, list32_one_write(i).unsigned_i_val, list32_one_write(i).num_wait_val, list32_one_write(i).wdata_i_val, list32_one_write(i).dataread_val, list32_one_write(i).rd_i_val,list32_one_write(i).wr_i_val,list32_one_write(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "32-bit write test finished";
		
	-- 16bit test
		for i in list16_one_read'low to list16_one_read'high loop
			test_rd32_transfer(list16_one_read(i).addr_val, list16_one_read(i).size_val, list16_one_read(i).unsigned_i_val, list16_one_read(i).num_wait_val, list16_one_read(i).wdata_i_val, list16_one_read(i).dataread_val, list16_one_read(i).rd_i_val,list16_one_read(i).wr_i_val,list16_one_read(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "16-bit read test finished";
		
		for i in list16_one_write'low to list16_one_write'high loop
			test_rd32_transfer(list16_one_write(i).addr_val, list16_one_write(i).size_val, list16_one_write(i).unsigned_i_val, list16_one_write(i).num_wait_val, list16_one_write(i).wdata_i_val, list16_one_write(i).dataread_val, list16_one_write(i).rd_i_val,list16_one_write(i).wr_i_val,list16_one_write(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';
			--addr_i <= (others => '0');

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;			
		REPORT "16-bit write test finished";
		
	-- 8bit test
		for i in list8_one_read'low to list8_one_read'high loop
			test_rd32_transfer(list8_one_read(i).addr_val, list8_one_read(i).size_val, list8_one_read(i).unsigned_i_val, list8_one_read(i).num_wait_val, list8_one_read(i).wdata_i_val, list8_one_read(i).dataread_val, list8_one_read(i).rd_i_val,list8_one_read(i).wr_i_val,list8_one_read(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "8-bit read test finished";
		
		for i in list8_one_write'low to list8_one_write'high loop
			test_rd32_transfer(list8_one_write(i).addr_val, list8_one_write(i).size_val, list8_one_write(i).unsigned_i_val, list8_one_write(i).num_wait_val, list8_one_write(i).wdata_i_val, list8_one_write(i).dataread_val, list8_one_write(i).rd_i_val,list8_one_write(i).wr_i_val,list8_one_write(i).tb_rst_val);
			rd_i <= '0';
			wr_i <= '0';
			tb_rst <= '1';
			--addr_i <= (others => '0');

			wait until rising_edge(tb_clk);
		end loop;
	
		REPORT "8-bit write test finished";		
		wait for 20 ns;
		
	
		ASSERT false
			REPORT "Simulation ended ( not a failure actually ) "
		SEVERITY failure;
    end process;
	
	
    -- Checking process
    check_proc: process
		
		-- Procedure for giving values to signal
		procedure check_rd32_transfer(
			constant addr_i_val : in std_logic_vector(31 DOWNTO 0);
			constant size_i_val : in std_logic_vector(1 DOWNTO 0);
			constant unsigned_i_val : in std_logic;
			constant num_wait_val: in integer;
			constant wdata_i_val : in std_logic_vector(31 DOWNTO 0);
			constant dataread_val: in std_logic_vector(31 downto 0);
			constant rd_i_val : in std_logic;
			constant wr_i_val : in std_logic;
			constant tb_rst_val : in std_logic;
			constant PSTRB_val : in std_logic_vector(3 DOWNTO 0);
			constant result_val : in std_logic_vector(31 downto 0)
		) is
		
		variable res_PSTRB : std_logic_vector(3 downto 0);
		variable res_PWRITE : std_logic;
		

		
		begin
			

			wait for 1 ns;
			assert PENABLE_out = '0' report "PENABLE beginning1 = 0" severity warning;
			cached_PENABLE <= PENABLE_out;
			wait until falling_edge(tb_clk);wait for 1 ns;
			assert PENABLE_out = cached_PENABLE report "PENABLE after falling edge!" severity warning;
			
			wait until rising_edge(tb_clk) and testing = '1';wait for 1 ns;
			assert tb_PSTRB = PSTRB_val report "PSTRB beginning" severity warning;
			assert PWRITE_out = wr_i report "PWRITE beginning" severity warning;
			assert PENABLE_out = '1' report "PENABLE beginning2 = 1" severity warning;			--PENABLE, It is determined by FSM, is a internal signal 
			assert mem_PRDATA = x"00000000" report "PRDATA beginning" severity warning;
			assert busy_o = '1' report "busy_o beginning" severity warning;
			
			cached_PENABLE  <= PENABLE_out;
			cached_PSTRB	<= tb_PSTRB;
			cached_PWRITE	<= PWRITE_out;
			cached_mem_PRDATA <=mem_PRDATA;
			cached_busy_o	<= busy_o;
			
			wait until falling_edge(tb_clk) and testing = '1';wait for 1 ns;
			assert tb_PSTRB = cached_PSTRB report "PSTRB beginning after falling_edge" severity warning;
			assert PWRITE_out = cached_PWRITE report "PWRITE beginning after falling_edge" severity warning;
			assert PENABLE_out = cached_PENABLE report "PENABLE beginning2 = 1 after falling_edge" severity warning;			--PENABLE, It is determined by FSM, is a internal signal 
			assert mem_PRDATA = cached_mem_PRDATA report "PRDATA beginning after falling_edge" severity warning;
			assert busy_o = cached_busy_o report "busy_o beginning after falling_edge" severity warning;
			
			
			
			if 	num_wait > 0 then
				for i in 0 to num_wait-1 loop
					wait until rising_edge(tb_clk); wait for 1 ns;
					assert tb_PSTRB = PSTRB_val report "PSTRB middle " severity warning;
					assert PWRITE_out = wr_i report "PWRITE middle " severity warning;
					assert PENABLE_out = '1' report "PENABLE middle = 1 " severity warning;
					assert mem_PRDATA = x"00000000" report "PRDATA middle " severity warning;
					assert busy_o = '1' report "busy_o middle " severity warning;
					
					cached_PENABLE  <= PENABLE_out;
					cached_PSTRB	<= tb_PSTRB;
					cached_PWRITE	<= PWRITE_out;
					cached_mem_PRDATA <=mem_PRDATA;
					cached_busy_o	<= busy_o;
					
					wait until falling_edge(tb_clk);wait for 1 ns;
					assert tb_PSTRB = cached_PSTRB report "PSTRB middle after falling_edge" severity warning;
					assert PWRITE_out = cached_PWRITE report "PWRITE middle after falling_edge" severity warning;
					assert PENABLE_out = cached_PENABLE report "PENABLE middle = 1 after falling_edge" severity warning;			--PENABLE, It is determined by FSM, is a internal signal 
					assert mem_PRDATA = cached_mem_PRDATA report "PRDATA middle after falling_edge" severity warning;
					assert busy_o = cached_busy_o report "busy_o middle after falling_edge" severity warning;
					
				end loop;  
			end if;
			wait until rising_edge(tb_clk); wait for 1 ns;
			assert PENABLE_out = '0' report "PENABLE end = 0 " severity warning;
			assert busy_o = '0' report "busy_o end = 0" severity warning;
			if (wr_i = '0' and rd_i = '1') then 
				assert rdata_o = result_val report "rdata_o end = value" severity warning;
			elsif (wr_i = '1' and rd_i = '0') then
				assert mem_PRDATA = result_val report "mem_PRDATA end = value" severity warning;
			end if;
			--assert rdata_o = dataread_val report "rdata_o end = value" severity warning;
			
			
		end procedure check_rd32_transfer;

    begin
	
		wait until falling_edge(tb_clk);
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		
		for i in list32_one_read'low to list32_one_read'high loop
			check_rd32_transfer(list32_one_read(i).addr_val, list32_one_read(i).size_val, list32_one_read(i).unsigned_i_val, list32_one_read(i).num_wait_val, list32_one_read(i).wdata_i_val, list32_one_read(i).dataread_val, list32_one_read(i).rd_i_val,list32_one_read(i).wr_i_val,list32_one_read(i).tb_rst_val, list32_one_read(i).PSTRB_val, list32_one_read(i).result_val);

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "32-bit read check finished";		

		
		
		for i in list32_one_write'low to list32_one_write'high loop
			check_rd32_transfer(list32_one_write(i).addr_val, list32_one_write(i).size_val, list32_one_write(i).unsigned_i_val, list32_one_write(i).num_wait_val, list32_one_write(i).wdata_i_val, list32_one_write(i).dataread_val, list32_one_write(i).rd_i_val,list32_one_write(i).wr_i_val,list32_one_write(i).tb_rst_val, list32_one_write(i).PSTRB_val, list32_one_write(i).result_val);
		
			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;		
		REPORT "32-bit write check finished" & lf;
	
		

		
		for i in list16_one_read'low to list16_one_read'high loop
			check_rd32_transfer(list16_one_read(i).addr_val, list16_one_read(i).size_val, list16_one_read(i).unsigned_i_val, list16_one_read(i).num_wait_val, list16_one_read(i).wdata_i_val, list16_one_read(i).dataread_val, list16_one_read(i).rd_i_val,list16_one_read(i).wr_i_val,list16_one_read(i).tb_rst_val, list16_one_read(i).PSTRB_val, list16_one_read(i).result_val);

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;		
		REPORT "16-bit read check finished";
		
		for i in list16_one_write'low to list16_one_write'high loop
			check_rd32_transfer(list16_one_write(i).addr_val, list16_one_write(i).size_val, list16_one_write(i).unsigned_i_val, list16_one_write(i).num_wait_val, list16_one_write(i).wdata_i_val, list16_one_write(i).dataread_val, list16_one_write(i).rd_i_val,list16_one_write(i).wr_i_val,list16_one_write(i).tb_rst_val, list16_one_write(i).PSTRB_val, list16_one_write(i).result_val);
		
			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;				
		REPORT "16-bit write check finished" & lf;
		
		for i in list8_one_read'low to list8_one_read'high loop
			check_rd32_transfer(list8_one_read(i).addr_val, list8_one_read(i).size_val, list8_one_read(i).unsigned_i_val, list8_one_read(i).num_wait_val, list8_one_read(i).wdata_i_val, list8_one_read(i).dataread_val, list8_one_read(i).rd_i_val,list8_one_read(i).wr_i_val,list8_one_read(i).tb_rst_val, list8_one_read(i).PSTRB_val, list8_one_read(i).result_val);

			wait until rising_edge(tb_clk);
		end loop;
		for i in 0 to 3 loop
			wait until rising_edge(tb_clk);
		end loop;		
		REPORT "8-bit read check finished" ;
		
		for i in list8_one_write'low to list8_one_write'high loop
			check_rd32_transfer(list8_one_write(i).addr_val, list8_one_write(i).size_val, list8_one_write(i).unsigned_i_val, list8_one_write(i).num_wait_val, list8_one_write(i).wdata_i_val, list8_one_write(i).dataread_val, list8_one_write(i).rd_i_val,list8_one_write(i).wr_i_val,list8_one_write(i).tb_rst_val, list8_one_write(i).PSTRB_val, list8_one_write(i).result_val);
		
			wait until rising_edge(tb_clk);
		end loop;
		REPORT "8-bit write check finished" & lf;
		
		
		wait;


    end process;

end architecture tb_behavior;




