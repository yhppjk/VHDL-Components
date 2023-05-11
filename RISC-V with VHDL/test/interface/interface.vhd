----------------------------------------------------------
--! @file memory_interface 
--! @A memory_interface  for calculation 
-- Filename: memory_interface .vhd
-- Description: A memory_interface  
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! memory_interface  entity description

--! Detailed description of this
--! memory_interface  design element.
entity memory_interface  is
	generic(
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
        busy_o: OUT std_logic;							--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.

        clk: IN std_logic;		--clock input
        rst: IN std_logic		--low level asynchronous reset
	);

end entity;

architecture behavioral of memory_interface  is
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
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	
	TYPE state_type is(idle, setup_transfer, release_enable, return_data);
	signal current_state, next_state : state_type := idle;

BEGIN
--divide the 2 data?
	--clock and reset
	
	
	process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process(current_state,next_state, rd_i, wr_i, addr_i, size_i, unsigned_i, wdata_i, PRDATA, PREADY, PENABLE)
	begin
	--default assignment
	

	
	case current_state is
		when idle =>
				WORDADDR <= addr_i(31 downto 2);
				ALIGNMENT <= addr_i(1 downto 0);
				case size_i is 
					when "00" =>
						SIZESTRB <= "00000001";
					when "01" =>
						SIZESTRB <= "00000011";
					when "11" =>
						SIZESTRB <= "00001111";
					when "10" =>
						SIZESTRB <= "00001111";
				end case;	
				
				BYTESTRB <= shift_left(SIZESTRB, to_integer(unsigned(ALIGNMENT)));	
				if BYTESTRB(7 downto 4) != "0000" then
					SECOND_OP <= '1';
				else 
					SECOND_OP <= '0';
				end if;
				
				case ALIGNMENT is
					when "00" =>
						WDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & wdata_i ;
						RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
					when "01" =>
						WDATA64 <= zeros8 & zeros8 & zeros8 & wdata_i & zeros8 ;
						if size_i = "00" then
							RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
						elsif size_i = "01" then 
							RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ;
						else 
							RDATA64 <= PRDATA1 & PRDATA0 ;
						end if; 
					when "10" =>
						WDATA64 <= zeros8 & zeros8 & wdata_i & zeros8 & zeros8 ;
						if size_i = "00" then
							RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
						elsif size_i = "01" then 
							RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ;
						else 
							RDATA64 <= PRDATA1 & PRDATA0 ;
						end if; 
					when "11" =>
						WDATA64 <= zeros8 & wdata_i & zeros8 & zeros8 & zeros8 ;
						if size_i = "00" then
							RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
						elsif size_i = "01" then 
							RDATA64 <= PRDATA1 & PRDATA0 ;
							RDATA64ALIGNED <=  shift_right(RDATA64, 24);
						else 
							RDATA64 <= PRDATA1 & PRDATA0 ;
							RDATA64ALIGNED <=  shift_right(RDATA64, 24);
						end if; 
				end case;	
				
				PWRITE <= '0';
				PENABLE <= '0';
				PADDR <= WORDADDR & ALIGNMENT;
				PSTRB <= "0000";
				
			if rd_i = '1'or wr_i = '1' then
				next_state <= setup_transfer;
			--elsif rd_i = '0' and wr_i = '1' then
			--	next_state <= setup_transfer;
			end if;
			
		when setup_transfer =>
			PWDATA <= wdata_i(31 downto 0);
			PWRITE <= wr_i;
			PENABLE <= '1';
			busy_o <= '1';
			
			if PREADY = '1' then 
				next_state <= wait_ready;
			end if;				
		when release_enable =>
		
		when return_data =>
		
	end case;
	
	end process;
end architecture;