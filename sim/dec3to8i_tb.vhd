--YIN Haoping
-- Testbench interface (no ports)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dec3to8i_tb IS
END ENTITY dec3to8i_tb;


-- Testbench implementation
ARCHITECTURE behavior OF dec3to8i_tb IS 
 
    -- Component declaration for the Design Under Test (DUT)
    COMPONENT dec3to8i
    PORT(
         din :  IN  integer range 0 to 7;
         dout : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT dec3to8i;

   --Inputs
   signal din : integer range 0 to 7 := 0;
 	--Outputs
   signal dout : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Design Under Test (DUT) and map its ports
	dut: dec3to8i
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
	din <= i;
	WAIT FOR 20ns;
	END LOOP loop2;
	
	ASSERT false
	  REPORT "Simulation ended ( not a failure actually ) "
	  SEVERITY failure ;
	WAIT FOR 10ns;


		for i in 0 to 7 loop
			din <= i;
			wait for 20 ns;
		end loop;
		assert false report "Simulation finished (not a failure actually)" severity failure;
		wait;   -- Input data exhausted. Simulation ended.
	end process;

END ARCHITECTURE behavior;