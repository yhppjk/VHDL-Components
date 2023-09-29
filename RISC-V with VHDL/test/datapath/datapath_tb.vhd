----------------------------------------------------------
--! @file datapath_tb.vhd
--! @Testbench datapath
-- Filename: datapath_tb.vhd
-- Description: testbench datapath
-- Author: YIN Haoping
-- Date: july 13, 2023
----------------------------------------------------------
--! Use standard library
--! Use textio library
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use STD.textio.all; 

--! Import packages
use work.apb_slavedec_pkg.all;
use work.datapath_pkg.all;
use work.reg_file_pkg.all;

ENTITY datapath_tb IS
--! parts for using Textio, this will make filename be defined by Modelsim
generic(
	filename : string:= ""
);

END ENTITY;

ARCHITECTURE behavior OF datapath_tb IS
    COMPONENT datapath
    	port (
        clk: IN std_logic;		--clock input
        rst: IN std_logic;		--low level asynchronous reset
		
		--interface in
		PRDATA : in std_logic_vector(31 downto 0);
		PREADY : in std_logic;
		--interface out
		PADDR : out std_logic_vector(31 downto 0);
		PSTRB : out std_logic_vector(3 downto 0);
		PWDATA : out std_logic_vector(31 downto 0);
		PWRITE : out std_logic;
		PENABLE : out std_logic;
		PREQ : out std_logic;
		port_Membusy : out std_logic := '0';
		
		--these ports are Control Unit part, for testing
		port_fetching : in std_logic;
		port_sel1pc : in std_logic;
		port_sel2pc : in std_logic_vector(1 downto 0);
		port_ipc : in std_logic;
		port_JB : in std_logic;
		port_XZ : in std_logic;
		port_XN : in std_logic;
		port_XF : in std_logic;
		port_wRD : in std_logic;
		port_selRD : in std_logic;
		port_sel1alu : in std_logic;
		port_sel2alu : in std_logic_vector(1 downto 0);
		port_selopalu : in std_logic_vector(3 downto 0);
		port_wIR : in std_logic;
		port_RD : in std_logic;
		port_WR : in std_logic;
		port_IDMEM : in std_logic;
		
		port_ALU_res : out std_logic_vector(31 downto 0);
		port_ALU_flag : out std_logic_vector(2 downto 0)
		
	);
    END COMPONENT;
	
	--memory part with init value
	component apb_init_mem is
		generic (ADDR_BITS: natural := 16; offset : integer := 0);  -- Number of address bits
		port (
			PCLK    : in  std_logic;
			PADDR   : in  std_logic_vector(ADDR_BITS-1 downto 0);
			PSEL    : in  std_logic;
			PENABLE : in  std_logic;
			PWRITE  : in  std_logic;
			PWDATA  : in  std_logic_vector(31 downto 0);
			PSTRB   : in  std_logic_vector( 3 downto 0);
			PREADY  : out std_logic;
			PRDATA  : out std_logic_vector(31 downto 0) := (others => '0')
		);
	end component apb_init_mem;

	--memory part without init value
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
			PRDATA  : out std_logic_vector(31 downto 0) := (others => '0')
		);
	end component apb_mem;
	
	--memory slave decoder
	component apb_slavedec is
		port (
			ADDRESS   : in  std_logic_vector(SLAVE_DECODER_A-1 downto 0);
			ENABLE    : in  std_logic;
			SEL       : out std_logic_vector(SLAVE_DECODER_S-1 downto 0);
			NUM_SLAVE : out SLAVE_NUMBER_TYPE
		);
	end component apb_slavedec;
	
	
	--clock signal definition
	signal tb_clk:  std_logic := '1';		--clock input
	signal tb_rst:  std_logic;		--low level asynchronous reset
	constant clk_period : time := 10 ns;
	
	
	--control unit output signals
	signal cu_fetching : std_logic := '0';
	signal cu_sel1PC : std_logic;
	signal cu_sel2PC : std_logic_vector(1 downto 0);
	signal cu_iPC : std_logic;
	signal cu_JB : std_logic;
	signal cu_XZ : std_logic;
	signal cu_XN : std_logic;
	signal cu_XF : std_logic;
	signal cu_wRD : std_logic := '0';
	signal cu_selRD : std_logic;
	signal cu_sel1ALU : std_logic;
	signal cu_sel2ALU : std_logic_vector(1 downto 0);
	signal cu_selopALU : std_logic_vector(3 downto 0);
	signal cu_wIR : std_logic := '0';
	signal cu_RDMEM : std_logic := '0';
	signal cu_WRMEM : std_logic := '0';
	signal cu_IDMEM : std_logic := '0';
	
	--memory interface input signals
	signal ram_PRDATA : std_logic_vector(31 downto 0);
	signal ram_PREADY : std_logic;
	
	--memory interface output signals
	signal ram_PADDR : std_logic_vector(31 downto 0) := (others => '0');
	signal ram_PSTRB : std_logic_vector(3 downto 0);
	signal ram_PWDATA : std_logic_vector(31 downto 0);
	signal ram_PWRITE : std_logic := '0';
	signal ram_PENABLE : std_logic := '0';
	signal ram_PREQ : std_logic := '0';
	signal slave_addr_error : std_logic := '0';
	signal ram_PSEL :std_logic_vector(2 downto 0) := (others => '0');
	signal ram_NUM_SLAVE : SLAVE_NUMBER_TYPE;
	signal tb_Membusy : std_logic := '0';
	
	-- From slave decoder to PSELx of each slave
	signal PSELs      : std_logic_vector(SLAVE_DECODER_S-1 downto 0) := (others => '0');
	-- From slave decoder to MUXes
	signal SLAVE_NUM  : SLAVE_NUMBER_TYPE;
	-- From slaves to MUXes
	type type_PRDATA_OUT is array (0 to SLAVE_DECODER_S-1) of std_logic_vector(31 downto 0);

	signal PREADYs : std_logic_vector(SLAVE_DECODER_S-1 downto 0) := (others => '0');
	signal PRDATAs : type_PRDATA_OUT;

	--ALU output
	signal tb_alu_res : std_logic_vector(31 downto 0);
	signal tb_alu_flag : std_logic_vector(2 downto 0);

	
	--signal for testing 
	signal dotest 						: boolean := false;
	signal test_name 					: string(1 to 4);
	signal test_expected_value 			: integer;
	signal test_expected_destination_reg : integer := 1;
	
	type type_list is (t_regfile, t_pc);
	signal op_type: type_list;

	-- From MUX to master

	constant t0 : integer  := 5;
	constant t1 : integer  := 6;
	constant t2 : integer  := 7;
	
	-- Textio testing signals init
	signal mnemonic_out : string(1 to 7);
	signal dest_out :std_logic_vector(4 downto 0);
	signal flag_out : std_logic_vector(2 downto 0);
	signal success: boolean;
	signal vGoodRead_out : boolean;
	
	constant IMEM_ADDR_BITS: natural := 10; -- Instruction memories have 1024 positions (x 32 bits each)
	constant DMEM_ADDR_BITS: natural :=  8; -- Data memory has 256 positions (x 32 bits each)
	subtype SLAVE_NUMBER_TYPE is integer range 0 to SLAVE_DECODER_S-1;
BEGIN

--datapath without CU
	UUT : datapath
	port map(
        clk => tb_clk,
        rst => tb_rst,
		
		--interface in
		PRDATA => ram_PRDATA,
		PREADY => ram_PREADY,
		--interface out
		PADDR => ram_PADDR,
		PSTRB => ram_PSTRB,
		PWDATA => ram_PWDATA,
		PWRITE => ram_PWRITE,
		PENABLE => ram_PENABLE,
		PREQ => ram_PREQ,
		port_Membusy => tb_Membusy, 
		
		-- cu part
		port_fetching => cu_fetching,
		port_sel1pc => cu_sel1PC,
		port_sel2pc => cu_sel2PC,
		port_ipc => cu_iPC,
		port_JB => cu_JB,
		port_XZ => cu_XZ,
		port_XN => cu_XN,
		port_XF => cu_XF,
		port_wRD => cu_wRD,
		port_selRD => cu_selRD,
		port_sel1alu => cu_sel1ALU,
		port_sel2alu => cu_sel2ALU,
		port_selopalu => cu_selopALU,
		port_wIR => cu_wIR,
		port_RD => cu_RDMEM,
		port_WR => cu_WRMEM,
		port_IDMEM => cu_IDMEM,
		
		port_ALU_res => tb_alu_res,
		port_ALU_flag =>tb_alu_flag
	);
	
	-- memory slave decoder
	slave_decoder : apb_slavedec
	port map (
		-- Higher bits of the master address
		ADDRESS => ram_PADDR(31 downto 8),
		-- PREQ of master
        ENABLE => ram_PREQ,
		-- SELx outputs, one per slave
    	SEL => PSELs,
		-- Number of selected slave, for the MUXes that forward PREADY and PRDATA from the slaves to the master
		NUM_SLAVE => ram_NUM_SLAVE
	
	);
	-- memory part1, init value of 0 ~ 1023
	imem1: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS, offset => 0) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(0), 
		PREADY  => PREADYs(0), 
		PADDR   => ram_PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(0),
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA
		); 
		
	-- memory part2, init value of 1024 ~ 2047
	imem2: apb_init_mem generic map (ADDR_BITS => IMEM_ADDR_BITS, offset => 1024) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(1), 
		PREADY  => PREADYs(1), 
		PADDR   => ram_PADDR(IMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(1),
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA		
		); 
	
	-- empty memory part3
	dmem: apb_mem generic map (ADDR_BITS => DMEM_ADDR_BITS) port map (
		PCLK    => tb_clk, 
		PRDATA  => PRDATAs(2), 
		PREADY  => PREADYs(2), 
		PADDR   => ram_PADDR(DMEM_ADDR_BITS-1 downto 0), 
		PSTRB   => ram_PSTRB,
		PENABLE => ram_PENABLE,
		PSEL    => PSELs(2),		
		PWRITE  => ram_PWRITE,
		PWDATA  => ram_PWDATA
		); 
		
	-- Memory PRDATA mux
	muxPRDATA : mux_apb_mem_PRDATA
		generic map (
			width => 32,
			prop_delay => 0 ns
		)
		port map(
			din0 => PRDATAs(0),
			din1 => PRDATAs(1),
			din2 => PRDATAs(2),
			sel => ram_NUM_SLAVE,
			dout => ram_PRDATA
		);
		
	-- Memory PREADY mux		
	muxPREADY : mux_apb_mem_PREADY
		generic map (
			prop_delay => 0 ns
		)
		port map(
			din0 => PREADYs(0),
			din1 => PREADYs(1),
			din2 => PREADYs(2),
			sel => ram_NUM_SLAVE,
			dout => ram_PREADY
		);

	--main clk
	clk_process: process
    begin
        tb_clk <= not tb_clk;
        wait for clk_period;

    END PROCESS clk_process;

	simulation : PROCESS
		
		-- Procedure for giving values to signal
		procedure fetch_clocks(constant first_entry: in integer) is
			variable idx : integer := first_entry;
			--alias for check internal signals
			alias reg_file is <<signal .datapath_tb.UUT.register_file.reg_file : reg_file_t >>;
			alias pc       is <<signal .datapath_tb.UUT.PC_value : std_logic_vector(31 downto 0) >>;
		begin
			for idx in first_entry to first_entry+100 loop
				cu_fetching <= list_1(idx).fetching;
				cu_sel1PC <= list_1(idx).sel1PC;
				cu_sel2PC <= list_1(idx).sel2PC;
				cu_iPC <= list_1(idx).iPC;
				cu_JB <= list_1(idx).JB;
				cu_XZ <= list_1(idx).XZ;
				cu_XN <= list_1(idx).XN;
				cu_XF <= list_1(idx).XF;
				cu_wRD <= list_1(idx).wRD;
				cu_selRD <= list_1(idx).selRD;
				cu_sel1ALU <= list_1(idx).sel1ALU;
				cu_sel2ALU <= list_1(idx).sel2ALU;
				cu_selopALU <= list_1(idx).selopALU;
				cu_wIR <= list_1(idx).wIR;
				cu_RDMEM <= list_1(idx).RDMEM;
				cu_WRMEM <=list_1(idx).WRMEM;
				cu_IDMEM <= list_1(idx).IDMEM;
				
				for i in 0 to 100 loop
					wait until rising_edge(tb_clk);
					
					-- check the if the values are as expected ones.
					if dotest = true then
						dotest <= false;
						case op_type is 
							when t_regfile =>
								assert to_integer(signed(reg_file(test_expected_destination_reg))) = test_expected_value report test_name&" destination or value is wrong. The destination is "&integer'image(test_expected_destination_reg)&". the value is "&integer'image(to_integer(signed(reg_file(test_expected_destination_reg))));
							when t_pc =>
								assert to_integer(unsigned(pc)) = test_expected_value report test_name&" pc value is wrong, the pc value is "&integer'image(to_integer(unsigned(pc)));
							when others => NULL;
						end case;
					end if;
					
					--exit the check loop when memory is busy
					if ((list_1(idx).WaitMEM = '0') or (tb_Membusy = '0')) then
						exit;
					end if;	
				end loop;
				
				--exit fetch clock
				if (list_1(idx).EOF = '1') then
					exit;
				end if;
			end loop;
			
			REPORT "fetch finished";
		end procedure fetch_clocks;
		
		-- Procedure for excecuting
		procedure exec_clocks(constant first_entry: in integer) is
			variable idx : integer := first_entry;
		begin
			for idx in first_entry to first_entry+100 loop
				cu_sel1PC <= list_1(idx).sel1PC;
				cu_sel2PC <= list_1(idx).sel2PC;	
				cu_iPC <= list_1(idx).iPC;
				cu_JB <= list_1(idx).JB;
				cu_XZ <= list_1(idx).XZ;
				cu_XN <= list_1(idx).XN;
				cu_XF <= list_1(idx).XF;
				cu_wRD <= list_1(idx).wRD;
				cu_selRD <= list_1(idx).selRD;
				cu_sel1ALU <= list_1(idx).sel1ALU;
				cu_sel2ALU <= list_1(idx).sel2ALU;
				cu_selopALU <= list_1(idx).selopALU;
				cu_wIR <= list_1(idx).wIR;
				cu_RDMEM <= list_1(idx).RDMEM;
				cu_WRMEM <=list_1(idx).WRMEM;
				cu_IDMEM <= list_1(idx).IDMEM;

				for i in 0 to 100 loop
					wait until rising_edge(tb_clk);
					if ((list_1(idx).WaitMEM = '0') or (tb_Membusy = '0')) then
						exit;
					end if;	
				end loop;
				--exit exec clock when End of Instruction
				if (list_1(idx).EOI = '1') then
					exit;
				end if;
			end loop;
			
			REPORT "exec finished";
		end procedure exec_clocks;

		--ADDI
		procedure exec_addi(constant expected_results: in integer; constant destination : in integer ) is
			variable actual_results : std_logic_vector(31 downto 0) ;
		begin
			fetch_clocks(index_fetch);			-- index_* is the position of list which control cu signal 
			exec_clocks(index_addi);			-- *_clock is different instruction execution
			actual_results := tb_alu_res;	
			
			dotest <= true;
			op_type <= t_regfile;				-- Arithmetic = t_regfile which will store the result in register
			test_name <="addi";					-- Logic = t_pc which may change pc value
			test_expected_value <= expected_results;
			test_expected_destination_reg <= destination;
			
			assert to_integer(signed(actual_results)) = expected_results report "addi Execcution failed! expected_results is " &integer'image(expected_results) & " The actual result is"& to_binary_string(actual_results) &"" severity failure;
			--REPORT test_name&" finished expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"";
		end procedure exec_addi;

		--ADD
		procedure exec_add(expected_results: in integer; constant destination : in integer) is
			variable actual_results : std_logic_vector(31 downto 0);
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_add);
			actual_results := tb_alu_res;
			
			dotest <= true;
			op_type <= t_regfile;
			test_name <="add ";
			test_expected_value <= expected_results;
			test_expected_destination_reg <= destination;
			
			assert to_integer(signed(actual_results)) = expected_results report " add Execcution failed! expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"" severity failure;
			--REPORT "add finished expected_results is " &integer'image(expected_results) & " The actual result is  "& to_binary_string(actual_results) &"";
		end procedure exec_add;
		
		--BEQ
		procedure exec_beq(expected_flags: std_logic_vector(2 downto 0); expected_results: in integer ) is
			variable actual_flags : std_logic_vector(2 downto 0);
		begin
			
			fetch_clocks(index_fetch);
			exec_clocks(index_beq);
			actual_flags := tb_alu_flag;
			
			test_name <="beq ";
			dotest <= true;
			op_type <= t_pc;
			test_expected_value <= expected_results;
			
			assert actual_flags = expected_flags report " beq Execcution failed! expected_results is " &to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"" severity failure;
			--REPORT "beq finished expected_results is " & to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"";
		end procedure exec_beq;
		
		--BNE
		procedure exec_bne(expected_flags: std_logic_vector(2 downto 0); expected_results: in integer ) is
			variable actual_flags : std_logic_vector(2 downto 0);
		begin
			
			fetch_clocks(index_fetch);
			exec_clocks(index_bne);
			actual_flags := tb_alu_flag;
			
			test_name <="bne ";
			dotest <= true;
			op_type <= t_pc;
			test_expected_value <= expected_results;
			
			assert actual_flags = expected_flags report " bne Execcution failed! expected_results is " &to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"" ; --severity failure;
			--REPORT "bne finished expected_results is " & to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"";
		end procedure exec_bne;
		
		--BLT
		procedure exec_blt(expected_flags: std_logic_vector(2 downto 0); expected_results: in integer ) is
			variable actual_flags : std_logic_vector(2 downto 0);
		begin
			
			fetch_clocks(index_fetch);
			exec_clocks(index_blt);
			actual_flags := tb_alu_flag;
			
			test_name <="blt ";
			dotest <= true;
			op_type <= t_pc;
			test_expected_value <= expected_results;
			
			assert actual_flags = expected_flags report " blt Execcution failed! expected_results is " &to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"" severity failure;
			--REPORT "blt finished expected_results is " & to_binary_string(expected_flags) & " The actual result is  "& to_binary_string(actual_flags) &"";
		end procedure exec_blt;
		
		--JUMP
		procedure exec_j(expected_results: in integer) is
		begin
			fetch_clocks(index_fetch);
			exec_clocks(index_j);
			
			test_name <="jump";
			dotest <= true;
			op_type <= t_pc;
			test_expected_value <= expected_results;
			
			--REPORT "jump finished";
		end procedure exec_j;
		
		--mnemonic decode
		constant mnemonic_addi: integer := 0;
		constant mnemonic_add:  integer := 1;
		constant mnemonic_beq:  integer := 2;
		constant mnemonic_bne:  integer := 3;
		constant mnemonic_blt:  integer := 4;
		constant mnemonic_j:    integer := 5;
		
		--function to decode the name of test in order to reacting properly 
		function decode_mnemonic(constant mnemonic : string(1 to 7))  return integer is
		BEGIN
			case mnemonic is
				when "addi   " =>
					return 0;
				when "add    " =>
					return 1;
				when "beq    " =>
					return 2;
				when "bne    " =>
					return 3;
				when "blt    " =>
					return 4;
				when "jump   " =>
					return 5;
				when others =>
					report "decode failed";
					return 99;
			end case;
		end function decode_mnemonic;
		
		
	file file_pointer : text;
	variable line_num : line;
	variable mnemonic : string(1 to 7);
	variable space_character : character;
	variable destination_register : std_logic_vector(4 downto 0);
	variable vGoodRead      : boolean := true;
	variable expected_value : std_logic_vector(31 downto 0);
	variable text_expected_flags : std_logic_vector(2 downto 0);
	variable expected_pc : integer;

	BEGIN
		file_open(file_pointer, filename ,READ_MODE);
	
		tb_rst <= '1';
		wait for 10 ns; 
		tb_rst <= '0';
		
		wait for 10 ns;
		wait until rising_edge(tb_clk);
		
		--this loop will start read the list line by line and do the test case until finished
		while not endfile(file_pointer) loop
			vGoodRead := true;
			readline(file_pointer, line_num);
			ASSERT vGoodRead = true report "read failed0";--debug
			
			if line_num'length <25 then						--avoid empty line
				next;
			end if;
			read(line_num, mnemonic);
			ASSERT vGoodRead = true report "read failed1";--debug
			
			if mnemonic(1) = '#' then						--avoid comment line
				next;
			end if;
			read(line_num, space_character);				--recognize space as divider
			if space_character /= ' ' then
				next;
			end if;
			hread(line_num, destination_register, vGoodRead);	--read reg_file destination 
			
			ASSERT vGoodRead = true report "read failed2";--debug
			if vGoodRead = false then						-- quit if read failed
				next;
			end if;
			
			read(line_num, space_character);				--recognize space as divider
			if space_character /= ' ' then
				next;
			end if;
			hread(line_num, expected_value, vGoodRead);			--read expected value
			ASSERT vGoodRead = true report "read failed3";--debug
			if vGoodRead = false then
				next;
			end if;
			
			read(line_num, space_character);				--recognize space as divider
			if space_character /= ' ' then
				next;
			end if;
			read(line_num, text_expected_flags, vGoodRead);	--read expected flags
			ASSERT vGoodRead = true report "read failed4";--debug
			if vGoodRead = false then
				next;
			end if;
			
			read(line_num, space_character);				--recognize space as divider
			if space_character /= ' ' then
				next;
			end if;
			read(line_num, expected_pc, vGoodRead);			--read expected pc value
			ASSERT vGoodRead = true report "read failed5";--debug
			if vGoodRead = false then
				next;
			end if;
			
			mnemonic_out <= mnemonic;			--debug
			dest_out <= destination_register;	--debug
			flag_out <= text_expected_flags;	--debug
			success <= endfile(file_pointer);	--debug
			vGoodRead_out <= vGoodRead;			--debug
			
			-- according to the decode result, run different execution procedure.
			case decode_mnemonic(mnemonic) IS
				when mnemonic_addi =>
					exec_addi(to_integer(signed(expected_value)),to_integer(unsigned(destination_register)));
				when mnemonic_add =>
					exec_add(to_integer(signed(expected_value)),to_integer(unsigned(destination_register)));
				when mnemonic_beq =>
					exec_beq(text_expected_flags, expected_pc);
				when mnemonic_bne =>
					exec_bne(text_expected_flags, expected_pc);
				when mnemonic_blt =>
					exec_blt(text_expected_flags, expected_pc);
				when mnemonic_j =>
					exec_j(expected_pc);
				when others =>
					null;
			end case;
		end loop;
		
		success <= endfile(file_pointer);--debug
		vGoodRead_out <= vGoodRead;--debug
		
		fetch_clocks(index_fetch);		--to check the value whether it is correct
		ASSERT false
			REPORT "Simulation ended ( not a failure actually ) "
		SEVERITY failure;
		
	end process simulation;



end ARCHITECTURE;