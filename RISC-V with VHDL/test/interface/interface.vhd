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
	
	signal first_cycle : std_logic;
	signal trigger : std_logic := '0';
	signal leftshift : integer;
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	
	TYPE state_type is(idle, op1B, op2A, op2B);
	signal current_state, next_state : state_type := idle;

BEGIN
	--divide the 2 data?
	
	
	--! clock and reset
	clock : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	--! FSM
	FSM : process(current_state, next_state, PREADY, )
	begin
	--default assignment
	case current_state is
		when idle =>
				first_cycle <= '1';
				trigger <= rd_i or wr_i;
				busy_o <= trigger;
		
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
					when others =>
				end case;	
				
				leftshift <= to_integer(unsigned(ALIGNMENT));
				if leftshift /= 0 then 
					BYTESTRB <= SIZESTRB(7 downto leftshift-1 ) & zeros8(leftshift-1 downto 0); 
				else
					BYTESTRB <= SIZESTRB;
				end if;

				if BYTESTRB(7 downto 4) /= "0000" then 
					SECOND_OP <= '1';
				else 
					SECOND_OP <= '0';
				end if;
	
				PWRITE <= '0';
				PENABLE <= '0';
				PADDR <= WORDADDR & ALIGNMENT;
				PSTRB <= "0000";
				
				if BYTESTRB(7 downto 6) /= "00" then
					PSTRB(3) <= '1'; 
				end if;
				if BYTESTRB(5 downto 4) /= "00" then
					PSTRB(2) <= '1'; 
				end if;
				if BYTESTRB(3 downto 2) /= "00" then
					PSTRB(1) <= '1'; 
				end if;
				if BYTESTRB(1 downto 0) /= "00" then
					PSTRB(0) <= '1';
				end if;
				
			if rd_i = '1'or wr_i = '1' then
				next_state <= op1B;
			end if;
			
		when op1B =>
			PWDATA <= wdata_i(31 downto 0);
			PWRITE <= wr_i;
			PENABLE <= '1';
			busy_o <= '1';
			
			--!!problem here!!
			if SECOND_OP = '1' then
				next_state <= op2A;
			elsif PREADY = '1' then 
				next_state <= idle;
			end if;		
			
		when op2A =>
			if rd_i = '1'or wr_i = '1' then
				next_state <= op2B;
			end if;
			
		when op2B =>
			if PREADY = '1' then 
				next_state <= idle;
			end if;		
		when others =>
	end case;
	end process;
	
	
	writeprocess : process(wdata_i, rd_i)
	begin
		case ALIGNMENT is
			when "00" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros16 & zeros8 & wdata_i ;
					when "01" =>
						WDATA64 <= zeros32 & zeros16 & wdata_i ;
					when "11" =>
						WDATA64 <= zeros32 & wdata_i ;
					when "10" =>
						WDATA64 <= zeros32 & wdata_i ;
				end case;
				
				--WDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & wdata_i ;
				--RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
			when "01" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros16 & wdata_i & zeros8 ;
					when "01" =>
						WDATA64 <= zeros32 & zeros8 & wdata_i & zeros8;
					when "11" =>
						WDATA64 <= zeros16 & zeros8 & wdata_i & zeros8;
					when "10" =>
						WDATA64 <= zeros16 & zeros8 & wdata_i & zeros8;
				end case;
				
			when "10" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros8 & wdata_i & zeros16 ;
					when "01" =>
						WDATA64 <= zeros32 & wdata_i & zeros16;
					when "11" =>
						WDATA64 <= zeros16 & wdata_i & zeros16;
					when "10" =>
						WDATA64 <= zeros16 & wdata_i & zeros16;
				end case;
				
			when "11" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & wdata_i & zeros16 & zeros8  ;
					when "01" =>
						WDATA64 <= zeros8 & zeros16 & wdata_i & zeros8 & zeros16;
					when "11" =>
						WDATA64 <= zeros8 & wdata_i & zeros8 & zeros16;
					when "10" =>
						WDATA64 <= zeros8 & wdata_i & zeros8 & zeros16;
				end case;	
		end case;
	
	end process;


	readprocess : process(PRDATA, rd_i, size_i, addr_i, ) 
	begin
	
		case ALIGNMENT is
			when "00" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros16 & zeros8 & wdata_i ;
						RDATA64 <= zeros32 & zeros16 & zeros8 & PRDATA0 ;
						RDATA64ALIGNED <= shift_right(RDATA64,0);
					when "01" =>
						WDATA64 <= zeros32 & zeros16 & wdata_i ;
						RDATA64 <= zeros32 & zeros16 & PRDATA0 ;
						RDATA64ALIGNED <= shift_right(RDATA64,0);
					when "11" =>
						WDATA64 <= zeros32 & wdata_i ;
						RDATA64 <= zeros32 & PRDATA0 ;
						RDATA64ALIGNED <= shift_right(RDATA64,0);
					when "10" =>
						WDATA64 <= zeros32 & wdata_i ;
						RDATA64 <= zeros32 & PRDATA0 ;
						RDATA64ALIGNED <= shift_right(RDATA64,0);
				end case;
				
				--WDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & wdata_i ;
				--RDATA64 <= zeros8 & zeros8 & zeros8 & zeros8 & PRDATA0 ; 
			when "01" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros16 & wdata_i & zeros8 ;
						RDATA64 <= zeros32 & zeros16 & PRDATA0 & zeros8 ;
						RDATA64ALIGNED <= shift_right(RDATA64,8);
					when "01" =>
						WDATA64 <= zeros32 & zeros8 & wdata_i & zeros8;
						RDATA64 <= zeros32 & zeros8 & PRDATA0 & zeros8;
						RDATA64ALIGNED <= shift_right(RDATA64,8);
					when "11" =>
						WDATA64 <= zeros16 & zeros8 & wdata_i & zeros8;
						RDATA64 <= zeros32 & zeros8 & PRDATA0 & zeros8;
						RDATA64ALIGNED <= shift_right(RDATA64,8);
					when "10" =>
						WDATA64 <= zeros16 & zeros8 & wdata_i & zeros8;
						RDATA64 <= zeros16 & zeros8 & PRDATA0 & zeros8;
						RDATA64ALIGNED <= shift_right(RDATA64,8);
				end case;
				
			when "10" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & zeros8 & wdata_i & zeros16 ;
						RDATA64 <= zeros32 & zeros8 & PRDATA0 & zeros16 ;
						RDATA64ALIGNED <= shift_right(RDATA64,16);
					when "01" =>
						WDATA64 <= zeros32 & wdata_i & zeros16;
						RDATA64 <= zeros32 & PRDATA0 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,16);
					when "11" =>
						WDATA64 <= zeros16 & wdata_i & zeros16;
						RDATA64 <= zeros16 & PRDATA0 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,16);
					when "10" =>
						WDATA64 <= zeros16 & wdata_i & zeros16;
						RDATA64 <= zeros16 & PRDATA0 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,16);
				end case;
				
			when "11" =>
				case size_i is 
					when "00" =>
						WDATA64 <= zeros32 & wdata_i & zeros16 & zeros8  ;
						RDATA64 <= zeros32 & PRDATA0 & zeros16 & zeros8  ;
						RDATA64ALIGNED <= shift_right(RDATA64,24);
						
						rdata_o <= 
					when "01" =>
						WDATA64 <= zeros8 & zeros16 & wdata_i & zeros8 & zeros16;
						RDATA64 <= zeros8 & zeros16 & PRDATA0 & zeros8 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,24);
					when "11" =>
						WDATA64 <= zeros8 & wdata_i & zeros8 & zeros16;
						RDATA64 <= zeros8 & PRDATA0 & zeros8 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,24);
					when "10" =>
						WDATA64 <= zeros8 & wdata_i & zeros8 & zeros16;
						RDATA64 <= zeros8 & PRDATA0 & zeros8 & zeros16;
						RDATA64ALIGNED <= shift_right(RDATA64,24);
				end case;	
		end case;	
		
		case size_i is 
			when "00" =>
				if unsigned_i = '0' then
					rdata_o(31 downto 8) <= (others => RDATA64ALIGNED(7));
					rdata_o(7 downto 0) <= RDATA64ALIGNED(7 downto 0);
				else
					rdata_o(31 downto 8) <= (others => '0');
					rdata_o(7 downto 0) <= RDATA64ALIGNED(7 downto 0);
				end if;
			when "01" =>
				if unsigned_i = '0' then
					rdata_o(31 downto 16) <= (others => RDATA64ALIGNED(15));
					rdata_o(15 downto 0) <= RDATA64ALIGNED(15 downto 0);
				else
					rdata_o(31 downto 16) <= (others => '0');
					rdata_o(15 downto 0) <= RDATA64ALIGNED(15 downto 0);
				end if;
				
			when "10" =>
				if unsigned_i = '0' then
					rdata_o(31 downto 0) <= RDATA64ALIGNED(31 downto 0);
				else
					rdata_o(31 downto 0) <= RDATA64ALIGNED(31 downto 0);
				end if;
			when "11" =>
				if unsigned_i = '0' then
					rdata_o(31 downto 0) <= RDATA64ALIGNED(31 downto 0);
				else
					rdata_o(31 downto 0) <= RDATA64ALIGNED(31 downto 0);
				end if;
		end case;
		
	end process;
	

	
	
end architecture;







