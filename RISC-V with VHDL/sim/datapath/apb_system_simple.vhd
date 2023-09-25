--!
--! File apb_system_simple.vhd
--! \brief APB system with one master and three slaves
--! \author Esquirol Charlotte
--! \author Paco Rodríguez
--! \version 0.2
--! \date July 2023
--!
--! The master is a single-core RV32I RISC-V (Von-Neumann architecture, component name RV_1_1).
--! The two first slaves are the instruction memory blocks (components apb_init_mem, 
--! mapped to addresses 0x00000000 and 0x00000400),
--! the thrid one is the data memory (component apb_mem, mapped to address 0x08000000)
--!
--! Changelog: entity renamed, comments and code improved, 
--!            removed dependency from math_real package
--!
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--library work;
--use work.muxs_pkg.all;

entity apb_system_simple is
	port (
		PCLK  : in std_logic;
		PRSTn : in std_logic
	);
end apb_system_simple;


use work.apb_slavedec_pkg.all;
architecture structural of apb_system_simple is

	constant IMEM_ADDR_BITS: natural := 10; -- Instruction memories have 1024 positions (x 32 bits each)
	constant DMEM_ADDR_BITS: natural :=  8; -- Data memory has 256 positions (x 32 bits each)
	
	component RV_1_1
		port (
			PCLK    : in  std_logic;
			PRSTn   : in  std_logic;
			PRDATA  : in  std_logic_vector(31 downto 0);
			PREADY  : in  std_logic;
			PADDR   : out std_logic_vector(31 downto 0);
			PSTRB   : out std_logic_vector( 3 downto 0);
			PWDATA  : out std_logic_vector(31 downto 0);
			PWRITE  : out std_logic;
			PENABLE : out std_logic;
			PREQ    : out std_logic
		);
	end component RV_1_1;

	component apb_slavedec is
		port (
			ADDRESS   : in  std_logic_vector(SLAVE_DECODER_A-1 downto 0);
			ENABLE    : in  std_logic;
			SEL       : out std_logic_vector(SLAVE_DECODER_S-1 downto 0);
			NUM_SLAVE : out SLAVE_NUMBER_TYPE
		);
	end component apb_slavedec;

	component apb_init_mem is
		generic (ADDR_BITS: natural := 16);  -- Number of address bits
		port (
			PCLK    : in  std_logic;
			PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
			PSEL    : in  std_logic;
			PENABLE : in  std_logic;
			PWRITE  : in  std_logic;
			PWDATA  : in  std_logic_vector(31 downto 0);
			PSTRB   : in  std_logic_vector( 3 downto 0);
			PREADY  : out std_logic;
			PRDATA  : out std_logic_vector(31 downto 0)
		);
	end component apb_init_mem;

	component apb_mem is
		generic (ADDR_BITS: natural := 16);  -- Number of address bits
		port (
			PCLK    : in  std_logic;
			PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
			PSEL    : in  std_logic;
			PENABLE : in  std_logic;
			PWRITE  : in  std_logic;
			PWDATA  : in  std_logic_vector(31 downto 0);
			PSTRB   : in  std_logic_vector( 3 downto 0);
			PREADY  : out std_logic;
			PRDATA  : out std_logic_vector(31 downto 0)
		);
	end component apb_mem;

	-- From master to slave decoder
	signal PREQ       : std_logic;
	alias  PADDR_HIGH : std_logic_vector(SLAVE_DECODER_A-1 downto 0) is PADDR(SLAVE_DECODER_A-1 downto 0);
	-- From slave decoder to PSELx of each slave
	signal PSELs      : std_logic_vector(SLAVE_DECODER_S-1 downto 0);
	-- From slave decoder to MUXes
	signal SLAVE_NUM  : SLAVE_NUMBER_TYPE;
	-- From slaves to MUXes
	signal PREADYs : std_logic_vector(SLAVE_DECODER_S-1 downto 0);
	signal PRDATAs : array (0 to SLAVE_DECODER_S-1) of std_logic_vector(31 downto 0);
	-- From MUX to master
	signal PREADY  : std_logic;
	signal PRDATA  : std_logic_vector(31 downto 0);

	-- Other signals connecting master and slaves
	signal PADDR   : std_logic_vector(31 downto 0);
	signal PSTRB   : std_logic_vector( 3 downto 0);
	signal PWDATA  : std_logic_vector(31 downto 0);
	signal PWRITE  : std_logic;
	signal PENABLE : std_logic;

begin

	PREADY <= PREADYs(0) when (NUM_SLAVE = 0) else PREADYs(1);
	PRDATA <= PRDATAs(0) when (NUM_SLAVE = 0) else PRDATAs(1);

	RV32i_core: RV_1_1 port map (
		PCLK    => PCLK, 
		PRSTn   => PRSTn, 
		PRDATA  => PRDATA, 
		PREADY  => PREADY, 
		PADDR   => PADDR, 
		PSTRB   => PSTRB, 
		PWDATA  => PWDATA, 
		PWRITE  => PWRITE, 
		PENABLE => PENABLE, 
		PREQ    => PREQ );
		
	slave_dec: apb_slavedec port map (
		ADDRESS   => PADDR_HIGH, 
		ENABLE    => PREQ, 
		SEL       => PSELs, 
		NUM_SLAVE => NUM_SLAVE );

	imem1: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS) port map (
		PCLK    => PCLK, 
		PRDATA  => PRDATAs(0), 
		PREADY  => PREADYs(0), 
		PADDR   => PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => PSTRB,
		PENABLE => PENABLE,
		PSEL    => PSELs(0) ); 

	imem2: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS) port map (
		PCLK    => PCLK, 
		PRDATA  => PRDATAs(1), 
		PREADY  => PREADYs(1), 
		PADDR   => PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => PSTRB,
		PENABLE => PENABLE,
		PSEL    => PSELs(1) ); 

	dmem: apb_mem generic map (ADDR_BITS => DMEM_ADDR_BITS) port map (
		PCLK    => PCLK, 
		PRDATA  => PRDATAs(2), 
		PREADY  => PREADYs(2), 
		PADDR   => PADDR(DMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => PSTRB,
		PENABLE => PENABLE,
		PSEL    => PSELs(2) ); 

end architecture Behavioral;

