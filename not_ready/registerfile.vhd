
----------------------------------------------------------
--! @file
--! @A registerfile generic to set the number of bits & number of register, 
--! combinational read & synchronous read with generic select,1write 2read
-- Filename: registerfile.vhd
-- Description: A registerfile
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;



--! Detailed description of this
--! registerfile design element.
ENTITY registerfile IS
	GENERIC (
		dataWidth : POSITIVE := 64;
		addressWidth : POSITIVE := 4;
		num_reg : POSITIVE := 16;
		Combinational : boolean := True
	);
   PORT (

	 writeData : IN std_logic_vector (dataWidth-1 downto 0);	--! Write signal input
	 writeAddress : IN std_logic_vector (addressWidth-1 downto 0);
	 writeEna : IN std_logic;
	 
	readEna1 : IN std_logic;
	readEna2 : IN std_logic; 
	 readAddress1 : IN std_logic_vector (addressWidth-1 downto 0);
	 readAddress2 : IN std_logic_vector (addressWidth-1 downto 0);
	 readData1: OUT std_logic_vector (dataWidth-1 downto 0); 	--Register data input
	 readData2: OUT std_logic_vector (dataWidth-1 downto 0); 	--Register data input 
	 mainRst :  IN std_logic;		--! Reset signal input
	 mainClk :  IN std_logic		--! clock signal input
);
END ENTITY registerfile;

--! @brief Architecture definition of register
--! @details More details about this register element.
ARCHITECTURE behavioral OF registerfile IS

component registergen is
	GENERIC(
		dataWidth : POSITIVE := 64;
		addressWidth : POSITIVE :=4;
		num_reg : POSITIVE := 16;
		Combinational : boolean := True
	);
	port(
		reg_in : in std_logic_vector(dataWidth-1 downto 0);
		reg_out : out std_logic_vector(dataWidth-1 downto 0);
		rst, clk, writ : in std_logic
);
end component registergen;

component dec is
	GENERIC(
		wdith_in : POSITIVE := addressWidth;
		
		wdith_out : POSITIVE := num_reg;
		Combinational : boolean := True
	);
	port(
	din :  IN  std_logic_vector(wdith_in-1 downto 0);		--! dec data input
	ena : IN std_logic := '0';
	dout : OUT std_logic_vector(wdith_out-1 downto 0)	--! dec data output
);
end component dec ;

signal enableWriteArray : std_logic_vector(num_reg-1 downto 0);
signal enableReadArray1 : std_logic_vector(num_reg-1 downto 0);
signal enableReadArray2 : std_logic_vector(num_reg-1 downto 0);
signal signal_readData1 : std_logic_vector (dataWidth-1 downto 0); 
signal signal_readData2 : std_logic_vector (dataWidth-1 downto 0); 


BEGIN
decoder_read_address1 : dec port map(	
	din => readAddress1,
	--ena => readEna1,
	dout => enableReadArray1	
);
decoder_read_address2 : dec port map(
	din => readAddress2,
	--ena => readEna2,
	dout => enableReadArray2	
);

decoder_write_address : dec port map(
	din => writeAddress,
	ena => writeEna,
	dout => enableWriteArray		
);
gen_register: for i in 0 to num_reg-1 GENERATE
	registergenx : registergen port map(
	reg_in => writeData,
	reg_out => signal_readData1,
	rst => mainRst,
	clk => mainClk,
	writ => enableWriteArray(i)
	);
end GENERATE gen_register;

read1:process
begin


end process;

--read_data1 <= signal_readData1;
--read_data2 <= signal_readData2;




END ARCHITECTURE behavioral;