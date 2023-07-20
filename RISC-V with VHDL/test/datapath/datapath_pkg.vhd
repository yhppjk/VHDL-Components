----------------------------------------------------------
--! @file datapath_pkg
--! @ datapath_pkg 
-- Filename: datapath_pkg.vhd
-- Description:  datapath_pkg 
-- Author: YIN Haoping
-- Date: july 7, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--! datapath_pkg package description

--! Detailed description of this
--! datapath_pkg design element.



PACKAGE datapath_pkg IS

	component mux2togen is
	GENERIC (
		width: INTEGER :=32;
		prop_delay : time := 0 ns		--! prop delay
	);
	PORT (
		din0 :  IN  std_logic_vector(width-1 downto 0);	--! input 0 of mux
		din1 :  IN	std_logic_vector(width-1 downto 0);	--! input 1 of mux
		sel	:	IN std_logic;							--! selection of mux
		dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
	);	
	end component mux2togen;
	
	component mux4togen IS
	GENERIC (
		width: INTEGER :=32;
		prop_delay : time := 0 ns		--! prop delay
	);
	
	PORT (
		din0 :  IN	std_logic_vector(width-1 downto 0);	--! input 0 of mux
		din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
		din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
		din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
		sel	:	IN std_logic_vector(1 downto 0);		--! selection of mux
		dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
	);
	end component mux4togen;
	
	
	COMPONENT reg_file IS
		generic (	
			dataWidth : positive := 32;				--! generic of datawidth
			addressWidth : positive := 5;			--! generic of address width
			--num_reg : positive := 32;				--! generic of size of register file
			reset_zero : boolean := false;		--! reset address 0 only
			ignore_zero : boolean := false;		--! ignore write address 0
			combination_read : boolean := false;		--! generic of Combination and sychrnonous selection
			read_delay : time := 0 ns
		);
		port (
			clk        : in  std_logic;		--! the input port of clock
			reset      : in  std_logic;		--! the input port of reset
			writeEna   : in  std_logic;		--! the input port of write enable
			writeAddress : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of wirte address
			writeData : in  std_logic_vector(dataWidth-1 downto 0);		--! the input port of write data
			readAddress1 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address1
			readAddress2 : in  std_logic_vector(addressWidth-1 downto 0);	--! the input port of read address2
			readData1 : out std_logic_vector(dataWidth-1 downto 0);		--! the output port of read data1
			readData2 : out std_logic_vector(dataWidth-1 downto 0)		--! the output port of read data2
		);
	END COMPONENT reg_file;
	
	component registergen is
		GENERIC(
		width : POSITIVE := 32;
		prop_delay : time := 0 ns		--! prop delay
	);	
    PORT (
		reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
		writ : IN std_logic;		--! Write signal input
		rst :  IN std_logic;		--! Reset signal input
		clk :  IN std_logic;		--! clock signal input
		reg_out : OUT std_logic_vector (width-1 downto 0)	--! Register data output
	);
	end component registergen;

	component pc IS
		generic(
			datawidth : integer :=32
		);
		port (
			clk: IN  std_logic;
			reset : in std_logic;
			ena_in: in std_logic;
			data_in : in std_logic_vector(datawidth-1 downto 0);
			ena_pc : in std_logic;
			current_pc : out std_logic_vector(datawidth-1 downto 0)
		);
	end component pc;
	
	
	component wrpc is
		port(
		--INPUTS
		input_JB : in std_logic;	--! The instruction is a jump or branch
		input_XZ : in std_logic;	--! Use nothing, Z or C to decide
		input_XN : in std_logic;	--! Use nothing, N or C to decide
		input_XF : in std_logic;	--! The selected ALU flag must match this value to take the branch
		alu_z : in std_logic;		--! ALU flag Z
		alu_n : in std_logic;		--! ALU flag N	
		alu_c : in std_logic;		--! ALU flag C
		--OUTPUTS
		wrpc_out : out std_logic	--! wrpc output
		);

	end component;
	
	
	COMPONENT interface_1	is
		port (
			clk: IN std_logic;		--clock input
			rst: IN std_logic;		--low level asynchronous reset
			
			--memory side,AMBA APB master
			PADDR: OUT std_logic_vector(31 DOWNTO 0);		--32 bit address
			PSTRB: OUT std_logic_vector(3 DOWNTO 0);		--4 bit byte lane write strobe
			PWDATA: OUT std_logic_vector(31 DOWNTO 0);		--32 bit write data
			PWRITE: OUT std_logic := '0';							--1 bit command; 0 = read, 1 = write
			PENABLE: OUT std_logic := '0';							--1 bit signal used to signal the 2nd and subsequent cycles of an APB transfer (1)
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
			busy_o: OUT std_logic 							--1 bit used to indicate the CPU has a memory operation is ongoing and that it must wait.
			
		);
	end COMPONENT interface_1;

	component alu IS
	
	generic(
		selopbits : positive := 4;		--! selop bit
		flagbits : positive := 3		--! flags bit
	);
	port(
		--INPUTS
		op1 : in std_logic_vector(31 downto 0);		--! 32-bit operand1
		op2 : in std_logic_vector(31 downto 0);		--! 32-bit operand2
		selop : in std_logic_vector(3 downto 0);	--! X-bit operation selection
		--OUTPUTS
		res : out std_logic_vector(31 downto 0);	--! 32-bit result
		flags : out std_logic_vector(flagbits-1 downto 0)	--! F-bit result of comparison for branch
	);
	end COMPONENT alu;

	component mux_apb_mem_PRDATA IS
		GENERIC (
			width: INTEGER :=32;
			prop_delay : time := 0 ns		--! prop delay
	);
		
		PORT (
			din0 :  IN	std_logic_vector(width-1 downto 0);	--! input 0 of mux
			din1 :  IN  std_logic_vector(width-1 downto 0);	--! input 1 of mux
			din2 :  IN	std_logic_vector(width-1 downto 0);	--! input 2 of mux
			--din3 :  IN	std_logic_vector(width-1 downto 0);	--! input 3 of mux
			sel	:	IN  integer ;	--! selection of mux
			dout : OUT std_logic_vector(width-1 downto 0)		--! output of mux
	);
	END component mux_apb_mem_PRDATA;

	component mux_apb_mem_PREADY IS
		GENERIC (
			prop_delay : time := 0 ns		--! prop delay
	);
		
		PORT (
			din0 :  IN	std_logic;	--! input 0 of mux
			din1 :  IN  std_logic;	--! input 1 of mux
			din2 :  IN	std_logic;	--! input 2 of mux
			--din3 :  IN	std_logic(width-1 downto 0);	--! input 3 of mux
			sel	:	IN  integer ;	--! selection of mux
			dout : OUT std_logic	--! output of mux
	);
	END component mux_apb_mem_PREADY;


	type test_datapath is
	record
		--control unit output signals
		fetching : std_logic;
		sel1PC : std_logic;
		sel2PC : std_logic_vector(1 downto 0);
		iPC : std_logic;
		JB : std_logic;
		XZ : std_logic;
		XN : std_logic;
		XF : std_logic;
		wRD : std_logic;
		selRD : std_logic;
		sel1ALU : std_logic;
		sel2ALU : std_logic_vector(1 downto 0);
		selopALU : std_logic_vector(3 downto 0);
		wIR : std_logic;
		RDMEM : std_logic;
		WRMEM : std_logic;
		IDMEM : std_logic;
		
	end record;
	
	type list_test_datapath is array (0 to 7)of test_datapath;

	CONSTANT list_1 : list_test_datapath :=(
	--list of datapath test 
	-- fetching, sel1PC, sel2PC, iPC, JB, XZ, XN, XF, wRD, selRD, sel1ALU, sel2ALU, selopALU, wIR, RD, WR, IDMEM
		
		
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"01","0000",  '0','1','0','1' ),			--addi t0, zero, 1	# t0 = 1
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"01","0000",  '0','1','0','1' ),			--addi t1, zero, -1	# t1 = -1
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"00","0000",  '0','1','0','1' ),			--add  t0, t0, t0		# t0 = 2
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"00","0000",  '0','1','0','1' ),			--add  t1, t1, t1		# t1 = -2
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"00","0000",  '0','1','0','1' ),			--add t2, t1, t0		# t2 = 0
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"01","1000",  '0','1','0','0' ),			--beq t2, zero, pass
		('1','0',"00",'0',  '0','0','0','0',  '0','0', '0',"01","1000",  '0','1','0','0' ),			--bne t2, zero, failed
		('1','1',"01",'0',  '0','0','0','0',  '0','0', '1',"01","1011",  '0','1','0','0' ) 			--j failed2
		
	);



END PACKAGE datapath_pkg;






PACKAGE BODY datapath_pkg IS



END PACKAGE BODY datapath_pkg;