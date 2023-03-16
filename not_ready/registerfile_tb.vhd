----------------------------------------------------------
--! @file
--! @A flexible decoder testbench
-- Filename: registerfile_tb.vhd
-- Description: A flexible decoder testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! registerfile entity description
--! Detailed description of this
--! registerfile design element.
ENTITY registerfile_tb IS
END ENTITY registerfile_tb;

--! @brief Architecture definition of registerfile
--! @details Testbench implementation

ARCHITECTURE behavior OF registerfile_tb IS 
	CONSTANT TBWDITH : POSITIVE := 64;
	CONSTANT ADDWIDTH : POSITIVE := 4;
	CONSTANT NUM : POSITIVE := 16;
	CONSTANT COMB :boolean := True;
   COMPONENT registerfile
	GENERIC(
		dataWidth : POSITIVE := TBWDITH;
		addressWidth : POSITIVE :=ADDWIDTH;
		num_reg : POSITIVE := NUM;
		Combinational : boolean := COMB
	);
		
   PORT (
	 writeData : IN std_logic_vector (dataWidth-1 downto 0);	--! Write signal input
	 writeAddress : IN std_logic_vector (addressWidth-1 downto 0);
	 writeEna : IN std_logic;
	 
	 readAddress1 : IN std_logic_vector (addressWidth-1 downto 0);
	 readAddress2 : IN std_logic_vector (addressWidth-1 downto 0);
	 readData1: OUT std_logic_vector (dataWidth-1 downto 0); 	--Register data input
	 readData2: OUT std_logic_vector (dataWidth-1 downto 0); 	--Register data input 
	 mainRst :  IN std_logic;		--! Reset signal input
	 mainClk :  IN std_logic		--! clock signal input
);
    END COMPONENT registerfile;
	signal TestReadData1,TestReadData2, TestWriteData : std_logic_vector (TBWDITH-1 downto 0) :=(others => '0');
	signal TestWriteAddress, TestReadAddress1, TestReadAddress2 : std_logic_vector (ADDWIDTH-1 downto 0);
	signal TestWriteEna : std_logic :='0';
	signal Testclk, Testrst : std_logic := '0';
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: registerfile
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		readData1 => TestReadData1,
		readData2 => TestReadData2,
		writeAddress => TestWriteAddress,
		writeData => TestWriteData,
		writeEna => TestWriteEna,
		readAddress1 => TestReadAddress1,
		readAddress2 => TestReadAddress2,
		mainRst => Testrst,
		mainClk => Testclk
	);
  --! @brief Clock generate process
  --! @details generate a clock signalclock_proc:PROCESS
clock_proc:PROCESS
BEGIN
	Testclk <= '0';
	WAIT FOR 5 ns;
 	Testclk <= '1';
	WAIT FOR 5 ns;
END PROCESS;

--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	wait for 10 ns;
	TestWriteEna <= '1';
	TestWriteData <= x"0000AAAA0000AAAA";
	TestWriteAddress <= "0001";
	wait for 10 ns;
	TestWriteEna <= '0';
	TestWriteData <= x"0000000000000000";
	wait for 10 ns;
	
	TestWriteEna <= '1';
	TestWriteData <= x"0000BBBB0000BBBB";
	TestWriteAddress <= "0010";
	wait for 10 ns;
	TestWriteEna <= '0';
	TestWriteData <= x"0000000000000000";
	wait for 10 ns;
	
	
	TestReadAddress1 <= "0001";
	wait for 10 ns;
	TestReadAddress2 <= "0010";
	wait for 10 ns;

	wait for 30 ns;
	
	TestWriteEna <= '1';
	TestWriteData <= x"00000000FFFF1111";
	TestWriteAddress <= "0011";
	wait for 10 ns;
	TestWriteEna <='0';
	wait for 10 ns;
	
	Testrst <= '1';
	wait for 10 ns;
	
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;