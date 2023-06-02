----------------------------------------------------------
--! @file interface_1 
--! @A interface_1  for calculation 
-- Filename: interface_1 .vhd
-- Description: A interface_1  
-- Author: YIN Haoping
-- Date: May 9, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE work.interface_1_pkg.ALL;

--! interface_1  entity description

--! Detailed description of this
--! interface_1  design element.
entity interface_1  is

	port (
		clk: IN std_logic;		--clock input
        rst: IN std_logic;		--low level asynchronous reset
		
		--memory side,AMBA APB master
	    PADDR: OUT std_logic_vector(29 DOWNTO 0);		--32 bit address
        PSTRB: OUT std_logic_vector(3 DOWNTO 0);		--4 bit byte lane write strobe
        PWDATA: OUT std_logic_vector(31 DOWNTO 0);		--32 bit write data
        PWRITE: OUT std_logic := '0';							--1 bit command; 0 = read, 1 = write
        PENABLE: OUT std_logic;							--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
        PREQ : OUT std_logic;
				
		
		PRDATA: IN std_logic_vector(31 DOWNTO 0);		--32 bit read data
        PREADY: IN std_logic;							--1 bit handshake signal from the slave to insert wait state; a wait state is inserted if PENABLE = 1 and PREADY = 0
        
        rd_i: IN std_logic;								--1 bit input CPU command to initiate a read operation (1)
        wr_i: IN std_logic;								--1 bit input CPU command to initiate a write operation(1)
        addr_i: IN std_logic_vector(31 DOWNTO 0);		--CPU address for the memory operation
        size_i: IN std_logic_vector(1 DOWNTO 0);		--2 bit code for the size of request
        unsigned_i: IN std_logic;						--1 bit code to indicate the signed/unsigened nature of the read request
        wdata_i: IN std_logic_vector(31 DOWNTO 0);		--32 bit data to be written into memory
        
		rdata_o: OUT std_logic_vector(31 DOWNTO 0);		--32bit data to be read from memory
        busy_o: OUT std_logic := '0'					--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.
		
	);

end entity;

architecture behavioral of interface_1  is




	signal WORDADDR : std_logic_vector(29 downto 0);	--high 30 bits of addr_i
	signal WORDADDR_plus1 : std_logic_vector(29 downto 0);
	signal ALIGNMENT : std_logic_vector(1 downto 0);	--low 2 bits of addr_i
	signal SIZESTRB : std_logic_vector(7 downto 0);		--8 bits encoding of byte strobes in a word
	signal BYTESTRB_3_0 : std_logic_vector(3 downto 0);		--8 bits left-shifted value of SIZESTRB
	signal BYTESTRB_7_4 : std_logic_vector(3 downto 0);		--8 bits left-shifted value of SIZESTRB
	
	signal register_in_PSTRB : std_logic_vector(3 downto 0); 
	signal register_out_PSTRB : std_logic_vector(3 downto 0); 
	signal register_in_PWDATA : std_logic_vector(31 downto 0);
	signal register_out_PWDATA : std_logic_vector(31 downto 0);
	signal wdata64_31_0 : std_logic_vector(31 downto 0);
	signal register_out_addr : std_logic_vector(29 downto 0);
	signal register_in_PRDATA : std_logic_vector(31 downto 0);
	signal register_out_PRDATA : std_logic_vector(31 downto 0);
	
	
	signal size_or_output : std_logic := '0';
	signal op1 : std_logic := '1';
	signal op2 : std_logic := '0';
	signal trigger : std_logic := '0';
	signal first_cycle : std_logic := '1';
	signal unaligned : std_logic := '0';
	
	signal busy_sel : std_logic_vector(1 downto 0);
	signal preq_sel : std_logic_vector(1 downto 0);
	
	signal WDATA64 : std_logic_vector(63 downto 0); 	--
	signal RDATA64 : std_logic_vector(63 downto 0);		--
	signal RDATA64A : std_logic_vector(63 downto 0);	
	signal RDATA64B : std_logic_vector(63 downto 0);	
	signal PRDATA0 : std_logic_vector(31 downto 0);		--
	signal PRDATA1 : std_logic_vector(31 downto 0);		--
	signal RDATA64ALIGNED : std_logic_vector(63 downto 0);
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	
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
		

	
	size_operation : size_interface
		port map (
			size_i => size_i,
			ALIGNMENT => ALIGNMENT,
			BYTESTRB_3_0 => BYTESTRB_3_0,
			BYTESTRB_7_4 => BYTESTRB_7_4,
			or_output => size_or_output
		);
	mux_PSTRB : mux2togen
		GENERIC map(
			width => 4,
			prop_delay => 0 ns
		)
		port map(
			din0 => BYTESTRB_3_0,
			din1 => register_out_PSTRB,
			sel => op2,
			dout => PSTRB
		);
	
	registergen_PSTRB : registergen_interface 
		generic map (
			width => 4,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => BYTESTRB_7_4,
			writ => first_cycle,
			clk => clk,
			reg_out => register_out_PSTRB,
			rst => rst
		);
	
	register1_PSTRB : register1_interface
		generic map (
			prop_delay => 0 ns
		)
		port map (
			reg_in => size_or_output,
			writ => first_cycle,
			rst => rst,
			clk => clk,
			reg_out => unaligned
		);
	
	wdata_operation : wdata_interface
		port map(
			wdata_i => wdata_i,
			ALIGNMENT => ALIGNMENT,
			WDATA64_31_0 => wdata64_31_0,
			WDATA64_64_32 => register_in_PWDATA
		);
		
	registergen_PWDATA : registergen_interface 
		generic map (
			width => 32,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => register_in_PWDATA,
			writ => first_cycle,
			clk => clk,
			reg_out => register_out_PWDATA,
			rst => rst
		);
		
	mux_PWDATA : mux2togen
		GENERIC map(
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => wdata64_31_0,
			din1 => register_out_PWDATA,
			sel => op2,
			dout => PWDATA
		);
	
	addr_operation: addr_interface
		port map (
			clk => clk,
			addr_i => addr_i,
			WORDADDR_plus1 => WORDADDR_plus1,
			WORDADDR => WORDADDR,
			ALIGNMENT => ALIGNMENT
		);
	
	registergen_addr : registergen_interface
		generic map (
			width => 30,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => WORDADDR_plus1,
			writ => first_cycle,
			clk => clk,
			reg_out => register_out_addr,
			rst => rst
		);
	mux_addr : mux2togen
		GENERIC map(
			width => 30,
			prop_delay => 0 ns
		)
		port map(
			din0 => WORDADDR,
			din1 => register_out_addr,
			sel => op2,
			dout => PADDR
		);	
	rdata_operation1 : rdata_interface1
		port map (
			PRDATA => PRDATA,
			register_RDATA => register_out_PRDATA,
			RDATA64A => RDATA64A,
			RDATA64B => RDATA64B,
			RDATA_reg => register_in_PRDATA
		);
	register_PRDATA : registergen_PRDATA
		generic map (
			width => 32,
			prop_delay => 0 ns	
		)
		port map (
			reg_in => register_in_PRDATA,
			op1 => op1,
			PREADY => PREADY,
			clk => clk,
			reg_out => register_out_PRDATA,
			rst => rst
		);
	
	mux1_PRDATA : mux2togen
		GENERIC map(
			width => 64,
			prop_delay => 0 ns
		)
		port map(
			din0 => RDATA64A,
			din1 => RDATA64B,
			sel => op2,
			dout => RDATA64
		);
	
	rdata_operation2 :rdata_interface2
		port map(
			RDATA64 => RDATA64,
			ALIGNMENT => ALIGNMENT,
			unsigned_i => unsigned_i,
			size_i 	=> size_i,
			rdata_o => rdata_o
		);
	
	

	state_change : process (rst, clk)
	begin
		if rst = '1' then 
			current_state <= idle;
		elsif rising_edge(clk) then
			current_state <= next_state;	
		end if;
	end process;
	
	
	state_value : process(current_state)  
	begin
	case current_state is
		when idle =>
			op1 <= '1';
			op2 <= '0';
			first_cycle <= '1';
			busy_sel <= "00";
			preq_sel <= "00";
			PENABLE <= '0';
			
		when op1B =>
			op1 <= '1';
			op2 <= '0';
			first_cycle <= '0';
			busy_sel <= "01";
			preq_sel <= "01";
			PENABLE <= '1';

		when op2A =>
			op1 <= '0';
			op2 <= '1';
			first_cycle <= '0';
			busy_sel <= "10";
			preq_sel <= "01";
			PENABLE <= '0';		
		
		when op2B =>
			op1 <= '0';
			op2 <= '0';
			first_cycle <= '0';
			busy_sel <= "11";
			preq_sel <= "01";
			PENABLE <= '1';
	end case;


	end process state_value;
	
	
	FSM : process(trigger, PREADY, unaligned, current_state)  
	begin
		
		case current_state is
			when idle =>
				if trigger = '1' then
					next_state <= op1B;
				end if;
				
			when op1B =>
				if PREADY = '1' and unaligned = '0' then
					next_state <= idle;
				elsif PREADY = '1' and unaligned = '1'then 
					next_state <= op2A;
				end if;

			when op2A =>
				next_state <= op2B;			
			
			when op2B =>
				if PREADY = '1' then
					next_state <= idle;
				end if;		
		end case;
		

	end process FSM;
	
end architecture;






