LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


PACKAGE interface_1_pkg IS

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
	end component;
	
	component size_interface is
	port (
		size_i : IN std_logic_vector(1 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		
		BYTESTRB_3_0 : OUT std_logic_vector(3 downto 0);
		BYTESTRB_7_4: OUT std_logic_vector(3 downto 0);
		or_output : OUT std_logic
	);
	end component;
	
	component registergen_interface is
		GENERIC(
		width : POSITIVE := 4;
		prop_delay : time := 0 ns		--! prop delay
	);	
    PORT (
		reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
		writ : IN std_logic;		--! Write signal input
		rst :  IN std_logic;		--! Reset signal input
		clk :  IN std_logic;		--! clock signal input
		reg_out : OUT std_logic_vector (width-1 downto 0)	--! Register data output
	);
	end component;

	component register1_interface is 
	GENERIC(

		prop_delay : time := 0 ns		--! prop delay
	);	
	PORT (
		reg_in : IN std_logic; 		--! Register data input
		writ : IN std_logic;		--! Write signal input
		rst :  IN std_logic;		--! Reset signal input
		clk :  IN std_logic;		--! clock signal input
		reg_out : OUT std_logic		--! Register data output
	);
	end component;

	component wdata_interface is
	port (
		wdata_i : IN std_logic_vector(31 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		WDATA64_31_0 : OUT std_logic_vector(31 downto 0); 
		WDATA64_64_32 : OUT std_logic_vector(31 downto 0)
	);
	end component;

	component addr_interface  is
	port (
		clk : in std_logic;
		addr_i : in std_logic_vector(31 downto 0);
		WORDADDR_plus1 : out std_logic_vector(29 downto 0);
		WORDADDR : out std_logic_vector(29 downto 0);
		ALIGNMENT : out std_logic_vector(1 downto 0)
	);
	end component;

	component registergen_PRDATA IS
	GENERIC(
		width : POSITIVE := 4;
		prop_delay : time := 0 ns		--! prop delay
	);	
    PORT (
		reg_in : IN std_logic_vector (width-1 downto 0); 	--Register data input
		op1 : IN std_logic;		--! Write signal input
		PREADY: IN std_logic;
		rst :  IN std_logic;		--! Reset signal input
		clk :  IN std_logic;		--! clock signal input
		reg_out : OUT std_logic_vector (width-1 downto 0)	--! Register data output
	);
	END component registergen_PRDATA;

	component rdata_interface1  is

	port (
		PRDATA : IN std_logic_vector(31 downto 0);
		register_RDATA : IN std_logic_vector(31 downto 0);
		RDATA64A : out std_logic_vector(63 downto 0);
		RDATA64B : out std_logic_vector(63 downto 0);
		RDATA_reg :out std_logic_vector(31 downto 0)
	);

	end component;
	
	component rdata_interface2  is
	port (
		RDATA64 : IN std_logic_vector(63 downto 0);
		ALIGNMENT : IN std_logic_vector(1 downto 0);
		unsigned_i : IN std_logic;		
		size_i : IN std_logic_vector(1 downto 0);
		rdata_o : OUT std_logic_vector(31 downto 0)
	);
	end component;

	type test_transfer is
	record
		addr_val:  std_logic_vector(31 downto 0);
		size_val:  std_logic_vector(1 downto 0);
		unsigned_i_val :  std_logic;
		num_wait_val :  integer;
		wdata_i_val :  std_logic_vector(31 downto 0);
		dataread_val :  std_logic_vector(31 downto 0);
		rd_i_val :  std_logic;
		wr_i_val :  std_logic;
		tb_rst_val :  std_logic;
	end record;
	
	type test_transfer32 is array (0 to 5)of test_transfer;
	type test_transfer16 is array (0 to 2)of test_transfer;
	type test_transfer8 is array (0 to 2)of test_transfer;
	
	
		--addr_i, size_i, unsigned_i, numwait, wdata_i, dataread, rd_i, wr_i, rst
	CONSTANT list32 : test_transfer32 :=(
		(x"0000002C", "10", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002D", "10", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002E", "10", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002F", "10", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "10", '1', 2, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "10", '1', 1, x"000000EE", x"AEAEEAEA", '1', '0', '0'));
	CONSTANT list16 : test_transfer16 :=(
		(x"0000002C", "01", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "01", '1', 2, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "01", '1', 1, x"000000EE", x"AEAEEAEA", '1', '0', '0'));
	CONSTANT list8 : test_transfer8 :=(
		(x"0000002C", "00", '1', 0, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "00", '1', 2, x"000000EE", x"AEAEEAEA", '1', '0', '0'),
		(x"0000002C", "00", '1', 1, x"000000EE", x"AEAEEAEA", '1', '0', '0'));
		
	--questions:	
	--	how to test a unaligned value?
	--	how many case should I create?
		
	--type test_vectors_t is array (0 to 200) of test_t;
	--CONSTANT vectors: test_vectors_t := (
	


END PACKAGE interface_1_pkg;






PACKAGE BODY interface_1_pkg IS



END PACKAGE BODY interface_1_pkg;