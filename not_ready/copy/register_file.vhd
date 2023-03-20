library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use work.generic_register_pkg.all;

entity register_file is
    generic (
        dataWidth : positive := 32;
        addressWidth : positive := 5;
        num_reg : positive := 32;
		combination_read : boolean := false
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        write_en   : in  std_logic;
        write_addr : in  std_logic_vector(addressWidth-1 downto 0);
        write_data : in  std_logic_vector(dataWidth-1 downto 0);
        read_addr1 : in  std_logic_vector(addressWidth-1 downto 0);
        read_addr2 : in  std_logic_vector(addressWidth-1 downto 0);
        read_data1 : out std_logic_vector(dataWidth-1 downto 0);
        read_data2 : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity register_file;

architecture behavior of register_file is
    signal write_enable_signals : std_logic_vector(num_reg-1 downto 0);
    signal read_enable_signals1 : std_logic_vector(num_reg-1 downto 0);
    signal read_enable_signals2 : std_logic_vector(num_reg-1 downto 0);
	
	type reg_file_t is array (0 to num_reg-1) of std_logic_vector(dataWidth-1 downto 0);
	signal reg_file : reg_file_t;
begin
    -- Instantiate the write decoder
    write_decoder: generic_decoder
        generic map (
            addressWidth => addressWidth
        )
        port map (
            addr   => write_addr,
            enable => write_en,
            selects => write_enable_signals
        );

    -- Instantiate the read decoder 1
    read_decoder1: generic_decoder
        generic map (
            addressWidth => addressWidth
        )
        port map (
            addr   => read_addr1,
            -- enable => open, -- '1',
            selects => read_enable_signals1
        );

    -- Instantiate the read decoder 2
    read_decoder2: generic_decoder
        generic map (
            addressWidth => addressWidth
        )
        port map (
            addr   => read_addr2,
            enable => '1',
            selects => read_enable_signals2
        );

    -- Instantiate the register_generic entities
    gen_registers: for i in 0 to num_reg-1 generate
        signal reg_output: std_logic_vector(dataWidth-1 downto 0);
        
        register_inst: generic_register
            generic map (
                dataWidth => dataWidth
            )	
            port map (
                clk       => clk,
                reset     => reset,
                write_en  => write_enable_signals(i),
                write_data => write_data,
                q         => reg_output
            );
    end generate gen_registers;

    -- Reading logic
    read_data1 <= "00000000"; -- Initialize to a default value
    read_data2 <= "00000000"; -- Initialize to a default value

    read_process: process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to num_reg-1 loop
                if read_enable_signals1(i) = '1' then
                    read_data1 <= reg_output;
                end if;
                if read_enable_signals2(i) = '1' then
                    read_data2 <= reg_output;
                end if;
            end loop;
        end if;
    end process;

    read1_process_synch: process(clk)
    begin
        if rising_edge(clk) then
			read_data1 <= reg_file(to_integer(unsigned(read_addr1)));
        end if;
    end process;

    read1_process_comb: process(read_addr1, reg_file)
    begin
		read_data1 <= reg_file(to_integer(unsigned(read_addr1)));
    end process;
	
	
	

end architecture behavior;


