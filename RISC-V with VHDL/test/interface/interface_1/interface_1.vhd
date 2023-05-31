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
        rst: IN std_logic		--low level asynchronous reset
		
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
        busy_o: OUT std_logic := '0';					--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.
	);

end entity;

architecture behavioral of interface_1  is




	signal WORDADDR : std_logic_vector(29 downto 0);	--high 30 bits of addr_i
	signal ALIGNMENT : std_logic_vector(1 downto 0);	--low 2 bits of addr_i
	signal SIZESTRB : std_logic_vector(7 downto 0);		--8 bits encoding of byte strobes in a word
	signal BYTESTRB_3_0 : std_logic_vector(3 downto 0);		--8 bits left-shifted value of SIZESTRB
	signal BYTESTRB_7_4 : std_logic_vector(3 downto 0);		--8 bits left-shifted value of SIZESTRB

	signal SECOND_OP: std_logic;						--flag for second operation
	
	signal WDATA64 : std_logic_vector(63 downto 0); 	--
	signal RDATA64 : std_logic_vector(63 downto 0);		--
	signal PRDATA0 : std_logic_vector(31 downto 0);		--
	signal PRDATA1 : std_logic_vector(31 downto 0);		--
	signal RDATA64ALIGNED : std_logic_vector(63 downto 0);
	
	signal first_cycle : std_logic;
	signal trigger : std_logic := '0';
	signal shift_count : integer;
	signal reset : std_logic := '1';
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	
	TYPE state_type is(idle, op1B, op2A, op2B);
	signal current_state, next_state : state_type := idle;

BEGIN	
	
	size_operation : size_interface
		port map (
			size_i => size_i,
			ALIGNMENT => ALIGNMENT,
			BYTESTRB_3_0 => BYTESTRB_3_0,
			BYTESTRB_7_4 => BYTESTRB_7_4
		);
	mux_PSTRB : mux2togen
		GENERIC map(
			
		)
	
		port map(
			din0 => BYTESTRB_3_0,
			din1 => reg_out,
			sel => op2，
			dout => PSTRB
		);
	
	
	
	
	
	
	
	
	
	
	
	FSM : process (trigger, rst, PREADY, unaligned)
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






