----------------------------------------------------------
--! @file memory_interface2 
--! @A memory_interface2  for calculation 
-- Filename: memory_interface2 .vhd
-- Description: A memory_interface2  
-- Author: YIN Haoping
-- Date: April 19, 2023
----------------------------------------------------------
--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! memory_interface2  entity description

--! Detailed description of this
--! memory_interface2  design element.
entity memory_interface22  is
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

architecture behavioral of memory_interface2  is
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
	
	
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0) ;
	signal reg_file : reg_file_t := (0 =>"01010101",others =>(others =>'0'));
BEGIN
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
		when- idle =>
		--in T0	:
			-- Combine internal signals
			-- trigger = rd_i or wr_i = 1
			-- busy_o = trigger = 1
			-- strobes, wdata aligned, ...
			-- PREQ, PADDR, PSTRB, PWDATA, PWRITE, PENABLE (0)
			first_cycle <= 1;
				
			end if;
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
			--first requirement 
			PSTRB <= BYTESTRB(3 downto 0);
			PWDATA <= WDATA64(31 downto 0);

			busy_o <= not(PREADY);
			if busy_o = '0' then 
					next_state <= op1B;
				end if;		
			end if;	


		when op1B =>
		--in T1, T2:
			-- FSM sets the internal signal first_cycle = 0
			-- PENABLE = 1
			-- busy_o = not(PREADY) = 1
		-- cycle TK:
			-- busy_o = not(PREADY) = 0, indicating the CPU the transfer will end at the end of this cycle
			first_cycle <= 0;
			
			
			
			
			PWDATA <= wdata_i(31 downto 0);
			PWRITE <= wr_i;
			PENABLE <= '1';
			

			PRDATA0 <= PRDATA;
			if()
			busy_o <= not(PREADY);

			if busy_o = '0' then 
				if SECOND_OP = '1' then
					next_state <= op2A;
				else 
					next_state <= idle;
				end if;		
			end if;	
		when op2A =>
		-- WORDADDR+1 as the address, the upper half of BYTESTRB and WDATA64.
			-- busy_o = 1
			-- PENABLE = 0
			
			WORDADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(WORDADDR)) + 1, 8));
			first_cycle <= 0;
			PSTRB <= BYTESTRB(7 downto 4);
			PWDATA <= WDATA64(63 downto 32);
			
			if rd_i = '1'or wr_i = '1' then
				next_state <= op2B;
			end if;
			
		when op2B =>
		--in TK+1, TK+2 ：
			-- FSM sets the internal signal first_cycle = 0, op2 = 1
			-- PENABLE = 1
			-- busy_o = not(PREADY) = 1
			
		--in Tw.
			-- busy_o = not(PREADY) = 0
			first_cycle <= 0;
			
			
			
			PRDATA1 <= PRDATA;
			--connect PRDATA0 and PRDATA1
			RDATA64 <= PRDATA1 & PRDATA0;
			if PREADY = '1' then 
				next_state <= idle;
			end if;		
		when others =>
	end case;
	end process;
	
	
	writeprocess : process(wdata_i, rd_i)
	begin

	end process;


	readprocess : process(PRDATA, rd_i, size_i, addr_i, ) 
	begin

	end process;
	

	
	
end architecture;







