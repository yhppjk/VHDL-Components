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
use work.apb_slavedec_pkg.all;
use work.datapath_pkg.all;

ENTITY datapath_tb IS
END ENTITY;

ARCHITECTURE behavior OF datapath_tb IS
    COMPONENT datapath
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
    END COMPONENT;
	
	component apb_init_mem is
		generic (ADDR_BITS: natural := 16);  -- Number of address bits
		port (
			PCLK    : in  std_logic;
			PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
			PSEL    : in  std_logic;
			PENABLE : in  std_logic;
			PWRITE  : in  std_logic;
			PWDATA  : in  std_logic_vector(31 downto 0);
			PSTRB   : in  std_logic_vector( 3 downto 0);
			PREADY  : out std_logic;
			PRDATA  : out std_logic_vector(31 downto 0) := (others => '0')
		);
	end component apb_init_mem;

	component apb_mem is
		generic (ADDR_BITS: natural := 16);  -- Number of address bits
		port (
			PCLK    : in  std_logic;
			PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
			PSEL    : in  std_logic;
			PENABLE : in  std_logic;
			PWRITE  : in  std_logic;
			PWDATA  : in  std_logic_vector(31 downto 0);
			PSTRB   : in  std_logic_vector( 3 downto 0);
			PREADY  : out std_logic;
			PRDATA  : out std_logic_vector(31 downto 0) := (others => '0')
		);
	end component apb_mem;
	
	component apb_slavedec is
		port (
			ADDRESS   : in  std_logic_vector(SLAVE_DECODER_A-1 downto 0);
			ENABLE    : in  std_logic;
			SEL       : out std_logic_vector(SLAVE_DECODER_S-1 downto 0);
			NUM_SLAVE : out SLAVE_NUMBER_TYPE
		);
	end component apb_slavedec;
	
	
	--clock signal definition
	signal tb_clk:  std_logic := '1';		--clock input
	signal tb_rst:  std_logic;		--low level asynchronous reset
	constant clk_period : time := 10 ns;
	
	--instruction part
	
	
	--control unit output signals
	signal cu_fetching : std_logic := '0';
	signal cu_sel1PC : std_logic;
	signal cu_sel2PC : std_logic_vector(1 downto 0);
	signal cu_iPC : std_logic;
	signal cu_JB : std_logic;
	signal cu_XZ : std_logic;
	signal cu_XN : std_logic;
	signal cu_XF : std_logic;
	signal cu_wRD : std_logic := '0';
	signal cu_selRD : std_logic;
	signal cu_sel1ALU : std_logic;
	signal cu_sel2ALU : std_logic_vector(1 downto 0);
	signal cu_selopALU : std_logic_vector(3 downto 0);
	signal cu_wIR : std_logic := '0';
	signal cu_RDMEM : std_logic := '0';
	signal cu_WRMEM : std_logic := '0';
	signal cu_IDMEM : std_logic := '0';
	
	--memory interface input signals
	signal ram_PRDATA : std_logic_vector(31 downto 0);
	signal ram_PREADY : std_logic;
	
	--memory interface output signals
	signal ram_PADDR : std_logic_vector(31 downto 0) := (others => '0');
	signal ram_PSTRB : std_logic_vector(3 downto 0);
	signal ram_PWDATA : std_logic_vector(31 downto 0);
	signal ram_PWRITE : std_logic := '0';
	signal ram_PENABLE : std_logic := '0';
	signal ram_PREQ : std_logic := '0';
	signal slave_addr_error : std_logic := '0';
	signal ram_PSEL :std_logic_vector(2 downto 0) := (others => '0');
	signal ram_NUM_SLAVE : SLAVE_NUMBER_TYPE;
	
	signal tb_Membusy : std_logic := '0';
	
		-- From master to slave decoder
	-- From slave decoder to PSELx of each slave
	signal PSELs      : std_logic_vector(SLAVE_DECODER_S-1 downto 0) := (others => '0');
	-- From slave decoder to MUXes
	signal SLAVE_NUM  : SLAVE_NUMBER_TYPE;
	-- From slaves to MUXes
	type type_PRDATA_OUT is array (0 to SLAVE_DECODER_S-1) of std_logic_vector(31 downto 0);

	signal PREADYs : std_logic_vector(SLAVE_DECODER_S-1 downto 0) := (others => '0');
	signal PRDATAs : type_PRDATA_OUT;
	--signal PRDATAs : type_PRDATA_OUT := ((others => '0'), (others => '0'), (others => '0'));

	--ALU output
	signal tb_alu_res : std_logic_vector(31 downto 0);
	signal tb_alu_flag : std_logic_vector(2 downto 0);

	-- From MUX to master

	constant t0 : integer  := 5;
	constant t1 : integer  := 6;
	constant t2 : integer  := 7;
	
	
	constant IMEM_ADDR_BITS: natural := 10; -- Instruction memories have 1024 positions (x 32 bits each)
	constant DMEM_ADDR_BITS: natural :=  8; -- Data memory has 256 positions (x 32 bits each)
	subtype SLAVE_NUMBER_TYPE is integer range 0 to SLAVE_DECODER_S-1;
BEGIN

--datapath without CU
	UUT : datapath
	port map(
        clk => tb_clk,
        rst => tb_rst,
		
		--interface in
		PRDATA => ram_PRDATA,
		PREADY => ram_PREADY,
		--interface out
		PADDR => ram_PADDR,
		PSTRB => ram_PSTRB,
		PWDATA => ram_PWDATA,
		PWRITE => ram_PWRITE,
		PENABLE => ram_PENABLE,
		PREQ => ram_PREQ,
		port_Membusy => tb_Membusy, 
		
		-- cu part
		port_fetching => cu_fetching,
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
		port_IDMEM => cu_IDMEM,
		
		port_ALU_res => tb_alu_res,
		port_ALU_flag =>tb_alu_flag
	);
	
--slave decoder
	slave_decoder : apb_slavedec
	port map (
		-- Higher bits of the master address
		ADDRESS => ram_PADDR(31 downto 8),
		-- PREQ of master
        ENABLE => ram_PREQ,
		-- SELx outputs, one per slave
    	SEL => PSELs,
		-- Number of selected slave, for the MUXes that forward PREADY and PRDATA from the slaves to the master
		NUM_SLAVE => ram_NUM_SLAVE
	
	);

	imem1: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(0), 
		PREADY  => PREADYs(0), 
		PADDR   => ram_PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(0),
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA
		); 
		

	imem2: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(1), 
		PREADY  => PREADYs(1), 
		PADDR   => ram_PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(1),
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA		
		); 
		
	dmem: apb_mem generic map (ADDR_BITS => DMEM_ADDR_BITS) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(2), 
		PREADY  => PREADYs(2), 
		PADDR   => ram_PADDR(DMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(2),		
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA
		); 
		
	muxPRDATA : mux_apb_mem_PRDATA
		generic map (
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => PRDATAs(0),
			din1 => PRDATAs(1),
			din2 => PRDATAs(2),
			sel => ram_NUM_SLAVE,
			dout => ram_PRDATA
		);
		
	muxPREADY : mux_apb_mem_PREADY
		generic map (
			prop_delay => 0 ns
		)
		port map(
			din0 => PREADYs(0),
			din1 => PREADYs(1),
			din2 => PREADYs(2),
			sel => ram_NUM_SLAVE,
			dout => ram_PREADY
		);


	
	clk_process: process
    begin
        tb_clk <= not tb_clk;
        wait for clk_period;

    END PROCESS clk_process;

	simulation : PROCESS
		-- Procedure for giving values to signal
		procedure fetch_clock1(
			constant fetching_val : in std_logic;
			constant sel1PC_val : in std_logic;
			constant sel2PC_val : in std_logic_vector(1 downto 0);
			constant iPC_val : in std_logic;
			constant JB_val : in std_logic;
			constant XZ_val : in std_logic;
			constant XN_val : in std_logic;
			constant XF_val : in std_logic;
			constant wRD_val : in std_logic;
			constant selRD_val : in std_logic;
			constant sel1ALU_val : in std_logic;
			constant sel2ALU_val : in std_logic_vector(1 downto 0);
			constant selopALU_val : in std_logic_vector(3 downto 0);
			constant wIR_val : in std_logic;
			constant RDMEM_val : in std_logic;
			constant WRMEM_val : in std_logic;
			constant IDMEM_val : in std_logic
		) is
		begin
			cu_fetching <= fetching_val;
			cu_sel1PC 	<= sel1PC_val;
			cu_sel2PC 	<= sel2PC_val;
			cu_iPC 		<= iPC_val;
			cu_JB 		<= JB_val;
			cu_XZ 		<= XZ_val;
			cu_XN 		<= XN_val;
			cu_XF 		<= XF_val;
			cu_wRD 		<= wRD_val;
			cu_selRD 	<= selRD_val;
			cu_sel1ALU	<= sel1ALU_val;
			cu_sel2ALU	<= sel2ALU_val;
			cu_selopALU	<= selopALU_val;
			cu_wIR		<= wIR_val;
			cu_RDMEM	<= RDMEM_val;
			cu_WRMEM	<= WRMEM_val;
			cu_IDMEM	<= IDMEM_val;
			REPORT "clock 1, write CU value";
		wait until rising_edge(tb_clk);
			cu_wIR <= '1';
			REPORT "clock 2, wIR = '1' and change when Membusy = 0";
		wait until falling_edge(tb_clk);
		wait until rising_edge(tb_clk) and tb_Membusy = '0';
			cu_wRD <= '1';
			cu_iPC <= '1';
			REPORT "clock 3, using ALU";
		wait until falling_edge(tb_clk);
		wait until rising_edge(tb_clk);
			-- wait until rising_edge(tb_clk) and ram_PREADY = '1';
			-- while Membusy
			-- for i in 0 to num_wait loop
				-- wait until rising_edge(tb_clk);
			-- end loop;  
		wait until falling_edge(tb_clk);
			REPORT "end of one operation";
		end procedure fetch_clock1;
		
		
		-- Procedure for giving values to signal
		procedure fetch_clocks(constant first_entry: in integer) is
			variable idx : integer := first_entry;
		begin
			for idx in first_entry to first_entry+100 loop
				cu_fetching <= list_1(idx).fetching;
				cu_sel1PC <= list_1(idx).sel1PC;
				cu_sel2PC <= list_1(idx).sel2PC;
				cu_iPC <= list_1(idx).iPC;
				cu_JB <= list_1(idx).JB;
				cu_XZ <= list_1(idx).XZ;
				cu_XN <= list_1(idx).XN;
				cu_XF <= list_1(idx).XF;
				cu_wRD <= list_1(idx).wRD;
				cu_selRD <= list_1(idx).selRD;
				cu_sel1ALU <= list_1(idx).sel1ALU;
				cu_sel2ALU <= list_1(idx).sel2ALU;
				cu_selopALU <= list_1(idx).selopALU;
				cu_wIR <= list_1(idx).wIR;
				cu_RDMEM <= list_1(idx).RDMEM;
				cu_WRMEM <=list_1(idx).WRMEM;
				cu_IDMEM <= list_1(idx).IDMEM;

				for i in 0 to 100 loop
					wait until rising_edge(tb_clk);
					if ((list_1(idx).WaitMEM = '0') or (tb_Membusy = '0')) then
						exit;
					end if;	
				end loop;
				
				if (list_1(idx).EOF = '1') then
					exit;
				end if;
			end loop;
			
			REPORT "fetch finished";
		end procedure fetch_clocks;
		
		-- Procedure for giving values to signal
		procedure exec_clocks(constant first_entry: in integer) is
			variable idx : integer := first_entry;
		begin
			for idx in first_entry to first_entry+100 loop
				cu_fetching <= list_1(idx).fetching;
				cu_sel1PC <= list_1(idx).sel1PC;
				cu_sel2PC <= list_1(idx).sel2PC;
				cu_iPC <= list_1(idx).iPC;
				cu_JB <= list_1(idx).JB;
				cu_XZ <= list_1(idx).XZ;
				cu_XN <= list_1(idx).XN;
				cu_XF <= list_1(idx).XF;
				cu_wRD <= list_1(idx).wRD;
				cu_selRD <= list_1(idx).selRD;
				cu_sel1ALU <= list_1(idx).sel1ALU;
				cu_sel2ALU <= list_1(idx).sel2ALU;
				cu_selopALU <= list_1(idx).selopALU;
				cu_wIR <= list_1(idx).wIR;
				cu_RDMEM <= list_1(idx).RDMEM;
				cu_WRMEM <=list_1(idx).WRMEM;
				cu_IDMEM <= list_1(idx).IDMEM;

				for i in 0 to 100 loop
					wait until rising_edge(tb_clk);
					if ((list_1(idx).WaitMEM = '0') or (tb_Membusy = '0')) then
						exit;
					end if;	
				end loop;
				
				if (list_1(idx).EOI = '1') then
					exit;
				end if;
			end loop;
			
			REPORT "exec finished";
		end procedure exec_clocks;

		procedure exec_addi(constant expected_results: in integer   ) is
			--variable actual_results : integer := to_integer(signed(tb_alu_res));
			variable actual_results : std_logic_vector(31 downto 0) ;
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_addi);
			actual_results := tb_alu_res;
			assert to_integer(signed(actual_results)) = expected_results report "addi Execcution failed! expected_results is " &integer'image(expected_results) & " The actual result is"& to_binary_string(actual_results) &"" severity failure;
			REPORT "addi finished expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"";
		end procedure exec_addi;

		procedure exec_add(expected_results: in integer ) is
			variable actual_results : std_logic_vector(31 downto 0);
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_add);
			actual_results := tb_alu_res;
			assert to_integer(signed(actual_results)) = expected_results report " add Execcution failed! expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"" severity failure;
			REPORT "add finished expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"";
		end procedure exec_add;
		
		procedure exec_beq(expected_flags: std_logic_vector(2 downto 0) ) is
			variable actual_flags : std_logic_vector(2 downto 0);
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_beq);
			actual_flags := tb_alu_flag;
			assert actual_flags = expected_flags report " beq Execcution failed! expected_results is " &to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"" severity failure;
			REPORT "beq finished expected_results is " & to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"";
		end procedure exec_beq;
		
		procedure exec_j(expected_results: in integer) is
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_j);
			REPORT "jump finished";
		end procedure exec_j;
	
	BEGIN
		tb_rst <= '1';
		wait for 10 ns;
		tb_rst <= '0';
		
		wait for 10 ns;
		wait until rising_edge(tb_clk);
		
		exec_addi(1);
		exec_addi(-1);
		exec_add(2);	
		exec_add(-2);
		exec_add(0);
		exec_beq("001");
		exec_beq("001");
		exec_j(0);
		
		--exec_addi(-1);
		
		-- exec_addi(t0, 1); -- reg dst =5, value + 1, wRD = 1
		-- exec_addi(t1, -1);
		-- exec_add(t0, 2);
		-- exec_add(t1, -2);
		-- exec_add(t2, 0);
		-- exec_beq(true, pass); -- branch to pass taken
		-- exec_beq(false, failed); -- brach to failed not taken
		-- exec_j(failed2); -- jump to failed2
		
		ASSERT false
			REPORT "Simulation ended ( not a failure actually ) "
		SEVERITY failure;



		
		
		-- for i in 0 to 7 loop
			-- fetch_clock1(list_1(i).fetching, list_1(i).sel1PC,list_1(i).sel2PC, list_1(i).iPC, list_1(i).JB, list_1(i).XZ, list_1(i).XN, list_1(i).XF, list_1(i).wRD, list_1(i).selRD, list_1(i).sel1ALU, list_1(i).sel2ALU, list_1(i).selopALU, list_1(i).wIR, list_1(i).RDMEM, list_1(i).WRMEM, list_1(i).IDMEM);
			
			-- wait until rising_edge(tb_clk);
		-- end loop;
		-- REPORT "addi 1 test finished";		
		-- wait for 20 ns;
		
	end process simulation;



end ARCHITECTURE;