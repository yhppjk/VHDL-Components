--YIN Haoping
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cascadable_counter IS
	GENERIC(
		MAX_COUNT: POSITIVE :=10
);
	PORT(
	rst: IN  std_logic :='0';
	clk: IN  std_logic ;
	ena: IN  std_logic :='1'; 
	cin: IN  std_logic :='1';
	cout: OUT std_logic;
	count: OUT integer range 0 to MAX_COUNT
);

END ENTITY cascadable_counter;

ARCHITECTURE Behavioral OF cascadable_counter IS
	SIGNAL count_sig: integer range 0 to MAX_COUNT;
	SIGNAL cout_sig: std_logic :='0';
BEGIN
	count <= count_sig;
	cout <= cout_sig;

--counter
PROCESS(clk, rst)
BEGIN
	IF rst = '1' THEN
		count_sig <=0;
	ELSIF rising_edge(clk) THEN
	IF ena = '1' AND cin ='1' THEN
		IF count_sig =MAX_COUNT THEN
			count_sig <=0;
			
		ELSE 
			count_sig <= count_sig +1;
			
		END IF;
	END IF;
	END IF;
END PROCESS;

PROCESS(count_sig)
BEGIN
	IF count_sig = MAX_COUNT THEN
		cout_sig <= '1';
	ELSE
		cout_sig<='0';
	END IF;
END PROCESS;

END ARCHITECTURE;
	