--YIN Haoping
-- Testbench interface (no ports)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY dec3to8_tb IS
END ENTITY dec3to8_tb;


-- Testbench implementation
ARCHITECTURE behavior OF dec3to8_tb IS 
 
    -- Component declaration for the Design Under Test (DUT)
    COMPONENT dec3to8
    PORT(
         din :  IN  std_logic_vector(2 downto 0);
         dout : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT dec3to8;

   --Inputs
   signal din : std_logic_vector(2 downto 0);
 	--Outputs
   signal dout : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Design Under Test (DUT) and map its ports
	dut: dec3to8
	PORT MAP (
		-- Mapping: component port (left) => this arch signal/port (right)
		din  => din,
		dout => dout
	);

	-- Stimulus process
	stim_proc: process
	begin
		-- PUT YOUR CODE HERE TO ASSIGN ALL POSSIBLE VALUES TO din
		-- Remember to wait 100 ns before changing the value of din
	loop2 : FOR i IN 0 to 7 LOOP
	din <= std_logic_vector(to_unsigned(i,3));
	WAIT FOR 20 ns;
	END LOOP loop2;
	
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10 ns;


		for i in 0 to 7 loop
			din <= std_logic_vector(to_unsigned(i,3));
			wait for 20 ns;
		end loop;
		assert false report "Simulation finished (not a failure actually)" severity failure;
		wait;   -- Input data exhausted. Simulation ended.
	end process;

END ARCHITECTURE behavior;