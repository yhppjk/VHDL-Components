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
	--! clock and reset
	clock_and_reset : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
			first_cycle <= '1';
		elsif rising_edge(clk) then
				-- 1 bit combinational signal TRIGGER	√			
				-- 30 bit ADDR	√
				-- 2 bit ALIGNMENT	√
				-- 8 bit register BE	Is it BYTESTRB?
				-- 1 bit register UNALIGNMENT	
				-- 64 bit register WDATA
			current_state <= next_state;
		end if;
	end process clock_and_reset;
	
	
	FSM : process(PREADY, PSELx, PENABLE)
	begin
		case current_state is 
			when idle =>
			
				if PSELx = '1' then
					next_state <= op1A;
				else 
					next_state <= idle;
				end if;	
					 
			when op1A =>
				ADDR <= addr_i(31 downto 2);
				ALIGNMENT <= addr_i(1 downto 0);
				
				if PWRITE = '1' then
					
					
				
				elsif PWRITE = '0' then
				
				
				
				end if;
				
				
				next_state <= op2A;
				
			when op2A =>
			
				if PENABLE = '1' and PREADY = '1' then
					next_state <= op1A;
				elsif PENABLE = '0' and PREADY = '1' then
					next_state <= idle;
				elsif PREADY = '0' then
					next_state <= op2A;				
				end if;	
				
			
		end case;
		
		
	end process FSM;
	
	
	
end architecture;





