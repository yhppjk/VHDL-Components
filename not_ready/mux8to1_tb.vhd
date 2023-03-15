----------------------------------------------------------
--! @file
--! @A 8 to 1 mux testbench
-- Filename: mux8to1_tb.vhd
-- Description: a 8 to 1 mux testbench
-- Author: YIN Haoping
-- Date: March 13, 2023
----------------------------------------------------------

--! Use standard library
LIBRARY ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
USE ieee.numeric_std.ALL;

--! dec_tb entity description
--! Detailed description of this
--! dec_tb design element.
ENTITY mux8to1_tb IS
END ENTITY mux8to1_tb;

--! @brief Architecture definition of mux8to1_tb
--! @details Testbench implementation
ARCHITECTURE behavior OF mux8to1_tb IS 
 
   CONSTANT TBWDITH : POSITIVE := 4;	--! Component declaration for the Design Under Test (DUT
   COMPONENT mux8to1
   GENERIC	(
	width : POSITIVE := TBWDITH --! constant to describe the width of decoder
);
   PORT (
	din1 :  IN std_logic_vector(width-1 downto 0);		--! data input port1
	din2 : 	IN std_logic_vector(width-1 downto 0);		--! data input port2
	din3 :  IN std_logic_vector(width-1 downto 0);		--! data input port3
	din4 : 	IN std_logic_vector(width-1 downto 0);		--! data input port4
	din5 :  IN std_logic_vector(width-1 downto 0);		--! data input port5
	din6 : 	IN std_logic_vector(width-1 downto 0);		--! data input port6
	din7 :  IN std_logic_vector(width-1 downto 0);		--! data input port7
	din8 : 	IN std_logic_vector(width-1 downto 0);		--! data input port8
	sel1 : IN std_logic;								--! selection 1 of mux
	sel2 : IN std_logic;								--! selection 2 of mux
	sel3 : IN std_logic;								--! selection 3 of mux
	dout : OUT std_logic_vector(width-1 downto 0)	--! data output port
);
    END COMPONENT mux8to1;
    
   --Inputs
   signal din1 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal1
   signal din2 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal2
   signal din3 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal3
   signal din4 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal4
   signal din5 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal5
   signal din6 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal6
   signal din7 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal7
   signal din8 : std_logic_vector(TBWDITH-1 downto 0);	--! data input signal8
   signal sel1  : std_logic :='0';						--! selection signal 1 of mux
   signal sel2  : std_logic :='0';						--! selection signal 2 of mux
   signal sel3  : std_logic :='0';						--! selection signal 2 of mux
 	--Outputs
   signal dout : std_logic_vector(TBWDITH-1 downto 0);	--! data output signal
 
BEGIN
 
	--! Instantiate the Design Under Test (DUT) and map its ports
	dut: mux8to1
	PORT MAP ( --! Mapping: component port (left) => this arch signal/port (right)
		din1  => din1,
		din2  => din2,
		din3  => din3,
		din4  => din4,	
		din5  => din5,
		din6  => din6,
		din7  => din7,
		din8  => din8,			
		sel1 => sel1,
		sel2 => sel2,
		sel3 => sel3,		
		dout => dout
	);


--! @brief process test all values to decoder 
--! @details process test all values to decoder, with an assert statement to stop the simulation  
	stim_proc: process
	begin
	din1 <= "0001";
	din2 <= "0010";
	din3 <= "0011";
	din4 <= "0100";
	din5 <= "0101";
	din6 <= "0110";
	din7 <= "0111";
	din8 <= "1000";
	
	sel1 <= '0';
	sel2 <= '0';
	sel3 <= '0';
	wait FOR 10 ns;

	sel1 <= '1';
	sel2 <= '0';
	sel3 <= '0';
	wait FOR 10 ns;

	sel1 <= '0';
	sel2 <= '1';
	sel3 <= '0';
	wait FOR 10 ns;

	sel1 <= '1';
	sel2 <= '1';
	sel3 <= '0';
	WAIT FOR 10 ns;
	
	sel1 <= '0';
	sel2 <= '0';
	sel3 <= '1';
	wait FOR 10 ns;

	sel1 <= '1';
	sel2 <= '0';
	sel3 <= '1';
	wait FOR 10 ns;

	sel1 <= '0';
	sel2 <= '1';
	sel3 <= '1';
	wait FOR 10 ns;

	sel1 <= '1';
	sel2 <= '1';
	sel3 <= '1';
	WAIT FOR 10 ns;

	din1 <= "1111";
	sel1 <= '0';
	sel2 <= '0';
	sel3 <= '0';
	WAIT FOR 10 ns;
--! an assert statement to stop the simulation
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;
	END PROCESS;
END ARCHITECTURE behavior;