
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file_tb is
end entity register_file_tb;

architecture sim of register_file_tb is
    constant dataWidth : positive := 32;
    constant addressWidth : positive := 5;
    constant num_reg : positive := 32;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal write_en   : std_logic := '0';
    signal write_addr : std_logic_vector(addressWidth-1 downto 0) := (others => '0');
    signal write_data : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
    signal read_addr1 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');
    signal read_addr2 : std_logic_vector(addressWidth-1 downto 0) := (others => '0');
    signal read_data1 : std_logic_vector(dataWidth-1 downto 0);
    signal read_data2 : std_logic_vector(dataWidth-1 downto 0);

BEGIN
    -- Instantiate the register_file entity
    UUT: register_file
        generic map (
            dataWidth => dataWidth,
            addressWidth => addressWidth,
            num_reg => num_reg
        )
        port map (
            clk        => clk,
            reset      => reset,
            write_en   => write_en,
            write_addr => write_addr,
            write_data => write_data,
            read_addr1 => read_addr1,
            read_addr2 => read_addr2,
            read_data1 => read_data1,
            read_data2 => read_data2
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;
    -- Testbench stimulus process
    stimulus_process: process
    begin
        -- Apply a reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Write data to register 1
        write_en   <= '1';
        write_addr <= "00001";
        write_data <= x"0000000A";
        wait for 20 ns;

        -- Disable write
        write_en   <= '0';
        wait for 20 ns;

        -- Read from register 1 and register 2
        read_addr1 <= "00001";
        read_addr2 <= "00010";
        wait for 20 ns;

        -- Write data to register 2
        write_en   <= '1';
        write_addr <= "00010";
        write_data <= x"0000000B";
		wait for 20 ns;
		
		-- Stop writing
        write_en <= '0';
        wait for 20 ns;

        -- Read back the data from the register file
        read_addr1 <= "00000";
        read_addr2 <= "00001";
        wait for 20 ns;

        -- Done

		wait;

	end process;
end architecture;