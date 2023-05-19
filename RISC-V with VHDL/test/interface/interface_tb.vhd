----------------------------------------------------------
--! @file pc
--! @A pc for calculation 
-- Filename: pc.vhd
-- Description: A pc 
-- Author: YIN Haoping
-- Date: May 15, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY interface_tb IS
END ENTITY;

ARCHITECTURE behavior OF interface_tb IS
    COMPONENT memory_interface3
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
		--memory side,AMBA APB master
	    PADDR: OUT std_logic_vector(31 DOWNTO 0);		--32 bit address
        PSTRB: OUT std_logic_vector(3 DOWNTO 0);		--4 bit byte lane write strobe
        PWDATA: OUT std_logic_vector(31 DOWNTO 0);		--32 bit write data
        PWRITE: OUT std_logic;							--1 bit command; 0 = read, 1 = write
        PENABLE: OUT std_logic;							--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
        PRDATA: IN std_logic_vector(31 DOWNTO 0);		--32 bit read data
        PREADY: IN std_logic;							--1 bit handshake signal from the slave to insert wait state; a wait state is inserted if PENABLE = 1 and PREADY = 0
        
        rd_i: IN std_logic;								--1 bit input CPU command to initiate a read operation (1)
        wr_i: IN std_logic;								--1 bit input CPU command to initiate a write operation(1)
        addr_i: IN std_logic_vector(31 DOWNTO 0);		--CPU address for the memory operation
        size_i: IN std_logic_vector(1 DOWNTO 0);		--2 bit code for the size of request
        unsigned_i: IN std_logic;						--1 bit code to indicate the signed/unsigened nature of the read request
        wdata_i: IN std_logic_vector(31 DOWNTO 0);		--32 bit data to be written into memory
        rdata_o: OUT std_logic_vector(31 DOWNTO 0);		--32bit data to be read from memory
        busy_o: OUT std_logic := '0';							--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.

        clk: IN std_logic;		--clock input
        rst: IN std_logic		--low level asynchronous reset
	);
    END COMPONENT;
	
	signal PADDR:  std_logic_vector(31 DOWNTO 0);		--32 bit address
	signal PSTRB:  std_logic_vector(3 DOWNTO 0);		--4 bit byte lane write strobe
	signal PWDATA:  std_logic_vector(31 DOWNTO 0);		--32 bit write data
	signal PWRITE:  std_logic;							--1 bit command; 0 = read, 1 = write
	signal PENABLE:  std_logic;							--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
	signal PRDATA:  std_logic_vector(31 DOWNTO 0);		--32 bit read data
	signal PREADY:  std_logic;							--1 bit handshake signal from the slave to insert wait state; a wait state is inserted if PENABLE = 1 and PREADY = 0
	
	signal rd_i: std_logic;								--1 bit input CPU command to initiate a read operation (1)
	signal wr_i:  std_logic;								--1 bit input CPU command to initiate a write operation(1)
	signal addr_i:  std_logic_vector(31 DOWNTO 0);		--CPU address for the memory operation
	signal size_i:  std_logic_vector(1 DOWNTO 0);		--2 bit code for the size of request
	signal unsigned_i:  std_logic;						--1 bit code to indicate the signed/unsigened nature of the read request
	signal wdata_i:  std_logic_vector(31 DOWNTO 0);		--32 bit data to be written into memory
	signal rdata_o:  std_logic_vector(31 DOWNTO 0);		--32bit data to be read from memory
	signal busy_o:  std_logic := '0';							--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.

	signal clk:  std_logic := '1';		--clock input
	signal rst:  std_logic;		--low level asynchronous reset
	constant clk_period : time := 10 ns;

BEGIN
    UUT: memory_interface3

        PORT MAP (
	    PADDR => PADDR,		--32 bit address
        PSTRB=> PSTRB,		--4 bit byte lane write strobe
        PWDATA =>PWDATA, 	--32 bit write data
        PWRITE => PWRITE,						--1 bit command; 0 = read, 1 = write
        PENABLE => PENABLE,						--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
        PRDATA => PRDATA,		--32 bit read data
        PREADY => 	PREADY,						--1 bit handshake signal from the slave to insert wait state; a wait state is inserted if PENABLE = 1 and PREADY = 0
        
        rd_i=> rd_i,								--1 bit input CPU command to initiate a read operation (1)
        wr_i=> wr_i,							--1 bit input CPU command to initiate a write operation(1)
        addr_i=>addr_i, 		--CPU address for the memory operation
        size_i=>size_i, 		--2 bit code for the size of request
        unsigned_i=> 	unsigned_i,				--1 bit code to indicate the signed/unsigened nature of the read request
        wdata_i=> 	wdata_i,	--32 bit data to be written into memory
        rdata_o=> 	rdata_o,	--32bit data to be read from memory
        busy_o=> busy_o,						--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.

        clk=> clk,
        rst=> rst
        );
	clk_process: process
    begin
        clk <= not clk;
        wait for 5 ns;

    END PROCESS clk_process;

	simulation: process
	begin
		    -- Hold reset state during initialization
		--rst <= '1';
		--wait for clk_period;
		--rst <= '0';
		
		--test1 : read test
		
		--rd_i <= '1';
		--wr_i <= '0'
		
		-- wr_i <= '1';
		-- addr_i <= "00000000000000000000000000000001";
		-- wdata_i <= "00000000000000000000000000000001";
		-- wait for clk_period;
		-- wr_i <= '0';
		-- wait for clk_period;
		-- rd_i <= '1';
		-- addr_i <= "00000000000000000000000000000001";
		-- wait for clk_period;
		-- rd_i <= '0';
		-- wait for clk_period;

		-- wr_i <= '1';
		-- addr_i <= "00000000000000000000000000000010"; -- new address
		-- wdata_i <= "00000000000000000000000000000010"; -- new data
		-- wait for clk_period;
		-- wr_i <= '0';
		-- wait for clk_period;

		--Read from the new address
		-- rd_i <= '1';
		-- addr_i <= "00000000000000000000000000000010"; -- new address
		-- wait for clk_period;
		-- rd_i <= '0';
		-- wait for clk_period;

		--Try read without write
		-- rd_i <= '1';
		-- addr_i <= "00000000000000000000000000000011"; -- new address
		-- wait for clk_period;
		-- rd_i <= '0';
		-- wait for clk_period;
		
		
		
		
		-- hold reset state
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		
		wait for clk_period;
		
		-- Single write operation
		wr_i <= '1';
		addr_i <= "00000000000000000000000000000001";
		wdata_i <= "00000000111111110000000011111111";
		size_i <= "10";
		unsigned_i <= '1';
		wait for clk_period*2;
		wr_i <= '0';

		wait for clk_period;

		-- Double write operation
		wr_i <= '1';
		addr_i  <= "00000000000000000000000000000010";
		wdata_i <= "11111111000000001111111100000000";
		wait for clk_period*2;
		wr_i <= '0';
		addr_i  <= "00000000000000000000000000000011";
		wdata_i <= "11110000111100001111000011110000";
		wait for clk_period*2;

		-- Single read operation
		rd_i <= '1';
		addr_i <= "00000000000000000000000000000001";
		wait for clk_period*2;
		rd_i <= '0';

		wait for clk_period;

		-- Double read operation
		rd_i <= '1';
		addr_i <= "00000000000000000000000000000010";
		wait for clk_period*2;
		rd_i <= '0';
		addr_i <= "00000000000000000000000000000011";
		wait for clk_period*2;
	
		
	
        ASSERT false
		REPORT "Simulation ended ( not a failure actually ) "
			SEVERITY failure;
		WAIT FOR 10 ns;
	end process;


END ARCHITECTURE behavior;