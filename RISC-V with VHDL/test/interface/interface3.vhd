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
	signal reset : std_logic := '1';
	
	constant zeros8 : std_logic_vector(7 downto 0) := (others => '0');
	constant zeros16 : std_logic_vector(15 downto 0) := (others => '0');
	constant zeros32: std_logic_vector(31 downto 0) := (others => '0');
	
	TYPE state_type is(idle, op1B, op2A, op2B);
	signal current_state, next_state : state_type := idle;
	
	
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0) ;
	signal reg_file : reg_file_t := (0 =>"01010101",others =>(others =>'0'));
	
	
	-- Function to perform left shift on a 64-bit std_logic_vector
	function left_shift(input_vector : std_logic_vector; shift_amt : integer) return std_logic_vector is
		variable result_vector : std_logic_vector(input_vector'range);
	begin
		result_vector := (input_vector(input_vector'high-shift_amt downto 0) & (others => '0'));
		return result_vector;
	end function left_shift;

	-- Function to perform right shift on a 64-bit std_logic_vector
	function right_shift(input_vector : std_logic_vector; shift_amt : integer) return std_logic_vector is
		variable result_vector : std_logic_vector(input_vector'range);
	begin
		result_vector := ((others => '0') & input_vector(input_vector'high downto shift_amt));
		return result_vector;
	end function right_shift;
	
	
BEGIN
	--logical blocks
	
	--first_cycle process
	first_cycle : process(rd_i, wr_i, PREADY, addr_i, size_i) 
	begin
		if first_cycle ='1' then 
			trigger <= rd_i or wr_i;
			busy_o <= not PREADY and trigger;

			WORDADDR <= addr_i(31 downto 2);
			ALIGNMENT <= addr_i(1 downto 0);
			PSTRB <="0001" when size_i = "00" and addr_i(1 downto 0) = "00" else  -- byte at position 0
				"0010" when size_i = "00" and addr_i(1 downto 0) = "01" else  -- byte at position 1
				"0100" when size_i = "00" and addr_i(1 downto 0) = "10" else  -- byte at position 2
				"1000" when size_i = "00" and addr_i(1 downto 0) = "11" else  -- byte at position 3
				"0011" when size_i = "01" and addr_i(1 downto 0) = "00" else  -- halfword at position 0
				"0110" when size_i = "01" and addr_i(1 downto 0) = "01" else  -- halfword at position 1
				"1100" when size_i = "01" and addr_i(1 downto 0) = "10" else  -- halfword at position 2
				"1111" when size_i >= "10" else  -- word
				(others => '0');  -- default case
				
			SIZESTRB <= "00000001" when size_i = "00" else
						"00000011" when size_i = "01" else
						"00001111" ;
			BYTESTRB <= left_shift(WORDADDR, unsigned(ALIGNMENT));
			SECOND_OP <= '1' when BYTESTRB(7) or BYTESTRB(6) or BYTESTRB(5) or BYTESTRB(4) ='1' else
						'0';
						
			-- 1 bit combinational signal TRIGGER	√			
			-- 30 bit ADDR	√
			-- 2 bit ALIGNMENT	√
			-- 8 bit register BE	Is it BYTESTRB?
			-- 1 bit register UNALIGNMENT	
			-- 64 bit register WDATA

				
			first_cycle <= '0';
	end process;
			
			--64 bit register RDATA
			--A combinational block to left-shift an 8 bit input by 0,1,2,3
			--A combinational block to left-shift a 64 bit input by 0,8,16,24
			--A combinational block to right-shift a 64 bit input by 0,8,16,24
			--A combinational block to zero/sign-extend a 32-bit value given a 2 bit size input (byte, halfword, word) and a 1 bit signed input(for rdata_o) 
			--FSM
			
			
	-- assuming wdata_i is a std_logic_vector signal
	




	--! clock and reset
	clock : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= idle;
			first_cycle <= '1';
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	--! FSM
	FSM : process(current_state, next_state, PREADY, )
	begin
	--default assignment
	busy_o <= not(PREADY);
	case current_state is
		when idle =>
			reset <= '1';
			if busy_o = '1' then
				next_state <= idle;
			else 
				next_state <= op1B;
			end if;
		when op1B =>
			if busy_o = '1' then
				next_state <= op1B;
			else 
				if SECOND_OP = '1' then
					next_state <= op2A;
				else 
					next_state <= idle;
				end if;
			end if;
		when op2A =>
			WORDADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(WORDADDR)) + 1, 8));
			if busy_o = '1' then
				next_state <= op2A;
			else 
				next_state <= op2B;
			end if;
		when op2B =>	
			if busy_o = '1' then
				next_state <= op2B;
			else 
				next_state <= idle;
			end if;
	end case;
	end process;
	
	reset : process(reset)
	begin
		reset <= '0';

		
	end process;
	writeprocess : process(wdata_i, rd_i)
	begin

	end process;


	readprocess : process(PRDATA, rd_i, size_i, addr_i, ) 
	begin

	end process;
	
end architecture;







