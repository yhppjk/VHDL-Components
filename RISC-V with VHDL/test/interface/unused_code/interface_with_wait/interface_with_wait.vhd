----------------------------------------------------------
--! @file interface_with_wait 
--! @A interface_with_wait  for calculation 
-- Filename: interface_with_wait .vhd
-- Description: A interface_with_wait  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! interface_with_wait  entity description

--! Detailed description of this
--! interface_with_wait  design element.
entity interface_with_wait  is

	port (
		--memory side,AMBA APB master
	    PADDR: OUT std_logic_vector(29 DOWNTO 0) := (others => '0');		--32 bit address
        PSTRB: OUT std_logic_vector(3 DOWNTO 0);		--4 bit byte lane write strobe
        PWDATA: OUT std_logic_vector(31 DOWNTO 0);		--32 bit write data
        PWRITE: OUT std_logic;							--1 bit command; 0 = read, 1 = write
        PENABLE: OUT std_logic;							--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
        PREQ : OUT std_logic;
		PRDATA: IN std_logic_vector(31 DOWNTO 0);		--32 bit read data
        PREADY: IN std_logic;							--1 bit handshake signal from the slave to insert wait state; a wait state is inserted if PENABLE = 1 and PREADY = 0

		
        rd_i: IN std_logic;								--1 bit input CPU command to initiate a read operation (1)
        wr_i: IN std_logic;								--1 bit input CPU command to initiate a write operation(1)
        addr_i: IN std_logic_vector(31 DOWNTO 0);		--CPU address for the memory operation
        size_i: IN std_logic_vector(1 DOWNTO 0);		--2 bit code for the size of request
        unsigned_i: IN std_logic;						--1 bit code to indicate the signed/unsigned nature of the read request
        wdata_i: IN std_logic_vector(31 DOWNTO 0);		--32 bit data to be written into memory
        rdata_o: OUT std_logic_vector(31 DOWNTO 0);		--32bit data to be read from memory
        busy_o: OUT std_logic := '0';							--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.

        clk: IN std_logic;		--clock input
        rst: IN std_logic		--low level asynchronous reset
	);

end entity;

architecture behavioral of interface_with_wait  is
	signal WORDADDR : std_logic_vector(29 downto 0);	--high 30 bits of addr_i
	signal ALIGNMENT : std_logic_vector(1 downto 0);	--low 2 bits of addr_i
	signal SIZESTRB : std_logic_vector(7 downto 0);		--8 bits encoding of byte strobes in a word
	signal BYTESTRB : std_logic_vector(7 downto 0);		--8 bits left-shifted value of SIZESTRB
	signal SECOND_OP: std_logic;						--flag for second operation
	
	signal WDATA64 : std_logic_vector(63 downto 0); 	--
	signal RDATA64 : std_logic_vector(63 downto 0);		--
	signal PRDATA0 : std_logic_vector(31 downto 0);		--
	signal PRDATA1 : std_logic_vector(31 downto 0);		--
	signal RDATA64ALIGNED : std_logic_vector(63 downto 0);
	signal RDATA64A : std_logic_vector(63 downto 0);
	signal RDATA64B : std_logic_vector(63 downto 0);	
	
	signal first_cycle : std_logic;
	signal trigger : std_logic := '0';
	signal unaligned : std_logic := '0';
	signal reset : std_logic := '1';
	
	signal register_PSTRB : std_logic_vector(3 downto 0);
	signal register_unaligned : std_logic := '0';
	signal register_PWDATA : std_logic_vector(31 downto 0);
	signal register_PADDR : std_logic_vector(29 downto 0);
	signal register_PRDATA : std_logic_vector(31 downto 0) := (others => '0');
	signal op1 : std_logic;
	signal op2 : std_logic;
	
	signal busy_sel : std_logic_vector(1 downto 0);
	signal preq_sel : std_logic_vector(1 downto 0);
	
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	constant one30: std_logic_vector(29 downto 0) := "000000000000000000000000000001";
	
	TYPE state_type is(idle, op1B, op2A, op2B);
	signal current_state, next_state : state_type := idle;
	

BEGIN	
	
	trigger <= rd_i or wr_i;
	PWRITE <= '1' when (rd_i ='0' and wr_i = '1')
		else '0' when (rd_i = '1' and wr_i = '0');

	WORDADDR <= addr_i(31 downto 2);
	ALIGNMENT <= addr_i(1 downto 0);
	busy_o <= trigger when busy_sel = "00" else
		 (unaligned or not(PREADY)) when busy_sel = "01"  else
		 '1' when busy_sel = "10" else
		 not(PREADY);
		
	PREQ <= trigger when preq_sel = "00" else
			'1' when preq_sel = "01" else
			'0';
	--! clock and reset
	clock_and_reset : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
			first_cycle <= '1';
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;

	init_data: process(clk) 
		variable var_sizestrb : std_logic_vector(7 downto 0);
	begin
		case size_i is
			when "00" =>
				SIZESTRB <= "00000001";
			when "01" =>
				SIZESTRB <= "00000011";
			when "10" => 
				SIZESTRB <= "00001111";
			when "11" => 
				SIZESTRB <= "00001111";
			when others =>
				SIZESTRB <= (others =>'0');
		end case;
		
		case ALIGNMENT is
			when "00" =>
				BYTESTRB <= SIZESTRB;
			when "01" =>
				BYTESTRB <= SIZESTRB(6 downto 0) & '0';
			when "10" =>
				BYTESTRB <= SIZESTRB(5 downto 0) & "00";
			when "11" =>
				BYTESTRB <= SIZESTRB(4 downto 0) & "000";
			when others =>
				BYTESTRB <= (others => '0');
		end case;
		
		if rising_edge(clk) and first_cycle ='1' then
			register_PSTRB <= BYTESTRB (7 downto 4);
			register_unaligned <= (BYTESTRB(7) or BYTESTRB(6) or BYTESTRB(5) or BYTESTRB(4));
		end if;
		
		if op2 = '1' then
			PSTRB <= register_PSTRB;
		elsif op2 = '1' then 
			PSTRB <= BYTESTRB(3 downto 0);
		else 
			PSTRB <= (others => '0');
		end if;
		unaligned <= register_unaligned;

	end process init_data;
	
	write_data : process(clk) 
	begin
		case ALIGNMENT is
			when "00" =>
				WDATA64 <= zeros32 & wdata_i;
			when "01" =>
				WDATA64 <= zeros16 & zeros8 & wdata_i & zeros8;
			when "10" =>
				WDATA64 <= zeros16 & wdata_i & zeros16;
			when "11" =>
				WDATA64 <= zeros8 & wdata_i & zeros16 & zeros8;
			when others =>
				WDATA64 <= (others => '0');
		end case;	
		if rising_edge(clk) and first_cycle ='1' and wr_i = '1' then
			register_PWDATA <= WDATA64(63 downto 32);
		end if;
		if op2 = '0' then
			PWDATA <= WDATA64(31 downto 0);
		elsif op2 = '1' then 
			PWDATA <= register_PWDATA;
		end if;
	end process write_data;
	
	
	addr_process : process(clk)
	begin
		WORDADDR <= addr_i(31 downto 2);
		ALIGNMENT <= addr_i(1 downto 0);
		
		if rising_edge(clk) and first_cycle = '1' then
			register_PADDR <= std_logic_vector(unsigned(WORDADDR)+unsigned(one30));
		end if;
		
		if op2 ='0' then
			PADDR <= WORDADDR;	
		elsif op2 = '1' then 
			PADDR <= register_PADDR;
		else 
			PADDR <= (others => '0');
		end if;
		
	
	
	end process addr_process;
	
	
	rdata_process: process(clk)
	begin
		if op1='1' and PREADY='1' and rising_edge(clk) and rd_i = '1' then
			register_PRDATA <= PRDATA;
		end if;
		RDATA64A <= zeros32 & PRDATA;
		RDATA64B <= register_PRDATA & PRDATA;
		if op2 = '0' then
			RDATA64 <= RDATA64A;
		elsif op2 = '1' then
			RDATA64 <= RDATA64B;
		end if;
		
		case ALIGNMENT is
			when "00" =>
				PRDATA0 <= RDATA64(31 downto 0);
			when "01" =>
				PRDATA0 <= RDATA64(31 downto 8) & zeros8;
			when "10" =>
				PRDATA0 <= RDATA64(31 downto 16) & zeros16;

			when "11" =>
				PRDATA0 <= RDATA64(31 downto 24) & zeros8 & zeros16;

			when others =>
				PRDATA0 <= (others =>'0');
		end case;
		
		case size_i is 
			when "00" =>
				if unsigned_i = '1' then
					rdata_o <= (23 downto 0=>'0') & PRDATA0(7 downto 0);
				elsif unsigned_i = '0' then
					if	PRDATA0(7) = '1' then
						rdata_o <= (23 downto 0=>'1') & PRDATA0(7 downto 0);
					elsif PRDATA0(7) = '0' then
						rdata_o <= (23 downto 0=>'0') & PRDATA0(7 downto 0);
					end if;
				end if;
			when "01" =>
				if unsigned_i = '1' then
					rdata_o <= (15 downto 0=>'0') & PRDATA0(15 downto 0);
				elsif unsigned_i = '0' then
					if	PRDATA0(7) = '1' then
						rdata_o <= (15 downto 0=>'1') & PRDATA0(15 downto 0);
					elsif PRDATA0(7) = '0' then
						rdata_o <= (15 downto 0=>'0') & PRDATA0(15 downto 0);
					end if;
				end if;
			when "10" =>
				rdata_o <= PRDATA0;
			when "11" =>
				rdata_o <= PRDATA0;
			when others =>
				rdata_o <= (others => '0');
		end case;
		
	end process rdata_process;
	
	
	FSM : process (clk)
	begin
		case current_state is
			when idle =>
				op1 <= '1';
				op2 <= '0';
				first_cycle <= '1';
				busy_sel <= "00";
				preq_sel <= "00";
				PENABLE <= '0';
				if trigger = '1' then
					next_state <= op1B;
				end if;
				
			when op1B =>
				op1 <= '1';
				op2 <= '0';
				first_cycle <= '0';
				busy_sel <= "01";
				preq_sel <= "01";
				PENABLE <= '1';
				if PREADY = '1' and unaligned = '0' then
					next_state <= idle;
				elsif PREADY = '1' and unaligned = '1'then 
					next_state <= op2A;
				end if;

			when op2A =>
				op1 <= '0';
				op2 <= '1';
				first_cycle <= '0';
				busy_sel <= "10";
				preq_sel <= "01";
				PENABLE <= '0';
				next_state <= op2B;			
			
			when op2B =>
				op1 <= '0';
				op2 <= '0';
				first_cycle <= '0';
				busy_sel <= "11";
				preq_sel <= "01";
				PENABLE <= '1';
				if PREADY = '1' then
					next_state <= idle;
				end if;		
		end case;		
	end process FSM;
	

	
end architecture;






