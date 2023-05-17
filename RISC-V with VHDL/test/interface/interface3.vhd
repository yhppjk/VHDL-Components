----------------------------------------------------------
--! @file memory_interface3 
--! @A memory_interface3  for calculation 
-- Filename: memory_interface3 .vhd
-- Description: A memory_interface3  
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! memory_interface3  entity description

--! Detailed description of this
--! memory_interface3  design element.
entity memory_interface3  is
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

end entity;

architecture behavioral of memory_interface3  is
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
	signal reset : std_logic := '1';
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	
	TYPE state_type is(idle, op1B, op2A, op2B);
	signal current_state, next_state : state_type := idle;
	
	


	
	
BEGIN
	--logical blocks
	
	--first_cycle process
			
			--64 bit register RDATA
			--A combinational block to left-shift an 8 bit input by 0,1,2,3
			--A combinational block to left-shift a 64 bit input by 0,8,16,24
			--A combinational block to right-shift a 64 bit input by 0,8,16,24
			--A combinational block to zero/sign-extend a 32-bit value given a 2 bit size input (byte, halfword, word) and a 1 bit signed input(for rdata_o) 
			--FSM
			
			
	-- assuming wdata_i is a std_logic_vector signal
	



	
	
	--! clock and reset
	clock_and_reset : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
			first_cycle <= '1';
		elsif rising_edge(clk) then
			if first_cycle ='1' then 
				trigger <= rd_i or wr_i;
				busy_o <= not PREADY and trigger;

				WORDADDR <= addr_i(31 downto 2);
				ALIGNMENT <= addr_i(1 downto 0);
				
				case size_i is
					when "00" =>
						case addr_i(1 downto 0) is
							when "00" =>
								PSTRB <= "0001";
							when "01" =>
								PSTRB <= "0010";
							when "10" =>
								PSTRB <= "0100";
							when "11" =>
								PSTRB <= "1000";
							when others =>
								PSTRB <= "0000";
						end case;
						SIZESTRB <= "00000001";
					when "01" =>
						case addr_i(1 downto 0) is
							when "00" =>
								PSTRB <= "0011";
							when "01" =>
								PSTRB <= "0110";
							when "10" =>
								PSTRB <= "1100";
							when others =>
								PSTRB <= "0000";
						end case;
						SIZESTRB <= "00000011";
					when "10" =>
						PSTRB <= "1111";
						SIZESTRB <= "00001111";
					when "11" =>
						PSTRB <= "1111";
						SIZESTRB <= "00001111";
					when others =>
						PSTRB <= "0000";
						SIZESTRB <= "00000000";
				end case;
				
				leftshift <= to_integer(unsigned(ALIGNMENT));
				BYTESTRB <= SIZESTRB(7-leftshift downto 0) & zeros8(leftshift-1 downto 0);
				if (BYTESTRB(7) or BYTESTRB(6) or BYTESTRB(5) or BYTESTRB(4)) ='1' then
					SECOND_OP <= '1' ;
				else 
					SECOND_OP <= '0' ;
				end if;
				
				-- 1 bit combinational signal TRIGGER	√			
				-- 30 bit ADDR	√
				-- 2 bit ALIGNMENT	√
				-- 8 bit register BE	Is it BYTESTRB?
				-- 1 bit register UNALIGNMENT	
				-- 64 bit register WDATA

					
				first_cycle <= '0';
			end if;
			current_state <= next_state;
		end if;
	end process;
	
	--! FSM
	FSM : process(current_state, next_state, PREADY)
	begin
	--default assignment
	busy_o <= not(PREADY);
	case current_state is
		when idle =>
			if not(PREADY) = '1' then
				next_state <= idle;
			else 
				next_state <= op1B;
			end if;
		when op1B =>
			if not(PREADY) = '1' then
				next_state <= op1B;
			else 
				if SECOND_OP = '1' then
					next_state <= op2A;
				else 
					next_state <= idle;
				end if;
			end if;
		when op2A =>
			WORDADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(WORDADDR)) + 1, 30));
			if not(PREADY) = '1' then
				next_state <= op2A;
			else 
				next_state <= op2B;
			end if;
		when op2B =>	
			if not(PREADY) = '1' then
				next_state <= op2B;
			else 
				next_state <= idle;
			end if;
	end case;
	end process;
	
	
	write_process : process (wr_i, wdata_i, trigger)
	begin
		if trigger = '1' then 
			WDATA64(31 downto 0) <= wdata_i;
			if SECOND_OP ='0' then			

			else
				WDATA64(63 downto 32) <= wdata_i;
			end if;
		end if;
	end process;
	
	read_process : process (rd_i, rdata_o)
	begin
		if trigger = '1' then 
			RDATA64(31 downto 0) <= PRDATA0;
			
			if SECOND_OP ='1' then

				RDATA64(63 downto 32) <= PRDATA1;
			end if;
		end if;
	end process;	
	
	
end architecture;






