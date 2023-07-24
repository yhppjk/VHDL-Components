onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/tb_clk
add wave -noupdate /datapath_tb/tb_rst
add wave -noupdate /datapath_tb/cu_fetching
add wave -noupdate /datapath_tb/cu_sel1PC
add wave -noupdate /datapath_tb/cu_sel2PC
add wave -noupdate /datapath_tb/cu_iPC
add wave -noupdate /datapath_tb/cu_JB
add wave -noupdate /datapath_tb/cu_XZ
add wave -noupdate /datapath_tb/cu_XN
add wave -noupdate /datapath_tb/cu_XF
add wave -noupdate /datapath_tb/cu_wRD
add wave -noupdate /datapath_tb/cu_selRD
add wave -noupdate /datapath_tb/cu_sel1ALU
add wave -noupdate /datapath_tb/cu_sel2ALU
add wave -noupdate /datapath_tb/cu_selopALU
add wave -noupdate /datapath_tb/cu_wIR
add wave -noupdate /datapath_tb/cu_RDMEM
add wave -noupdate /datapath_tb/cu_WRMEM
add wave -noupdate /datapath_tb/cu_IDMEM
add wave -noupdate -radix hexadecimal /datapath_tb/ram_PRDATA
add wave -noupdate /datapath_tb/ram_PREADY
add wave -noupdate -radix hexadecimal /datapath_tb/ram_PADDR
add wave -noupdate /datapath_tb/ram_PSTRB
add wave -noupdate -radix hexadecimal /datapath_tb/ram_PWDATA
add wave -noupdate /datapath_tb/ram_PWRITE
add wave -noupdate /datapath_tb/ram_PENABLE
add wave -noupdate /datapath_tb/ram_PREQ
add wave -noupdate /datapath_tb/slave_addr_error
add wave -noupdate /datapath_tb/ram_PSEL
add wave -noupdate /datapath_tb/ram_NUM_SLAVE
add wave -noupdate /datapath_tb/tb_Membusy
add wave -noupdate /datapath_tb/PSELs
add wave -noupdate /datapath_tb/SLAVE_NUM
add wave -noupdate /datapath_tb/PREADYs
add wave -noupdate -radix hexadecimal /datapath_tb/PRDATAs
add wave -noupdate -radix hexadecimal /datapath_tb/UUT/memory_interface/rdata_o
add wave -noupdate -radix hexadecimal /datapath_tb/UUT/RI_value
add wave -noupdate /datapath_tb/UUT/LoadIR
add wave -noupdate /datapath_tb/cu_wIR
add wave -noupdate /datapath_tb/tb_Membusy
add wave -noupdate /datapath_tb/UUT/port_Membusy
add wave -noupdate /datapath_tb/UUT/Membusy
add wave -noupdate /datapath_tb/UUT/memory_interface/busy_o
add wave -noupdate /datapath_tb/UUT/memory_interface/trigger
add wave -noupdate /datapath_tb/UUT/memory_interface/busy_sel
add wave -noupdate -radix hexadecimal /datapath_tb/imem1/mem_contents
add wave -noupdate /datapath_tb/UUT/memory_interface/unsigned_i
add wave -noupdate /datapath_tb/UUT/memory_interface/size_i
add wave -noupdate -radix hexadecimal /datapath_tb/UUT/ALU_part/res
add wave -noupdate /datapath_tb/UUT/ALU_part/flags
add wave -noupdate -radix hexadecimal -childformat {{/datapath_tb/UUT/register_file/reg_file(0) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(1) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(2) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(3) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(4) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(5) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(6) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(7) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(8) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(9) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(10) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(11) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(12) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(13) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(14) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(15) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(16) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(17) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(18) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(19) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(20) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(21) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(22) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(23) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(24) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(25) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(26) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(27) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(28) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(29) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(30) -radix hexadecimal} {/datapath_tb/UUT/register_file/reg_file(31) -radix hexadecimal}} -subitemconfig {/datapath_tb/UUT/register_file/reg_file(0) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(1) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(2) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(3) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(4) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(5) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(6) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(7) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(8) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(9) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(10) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(11) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(12) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(13) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(14) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(15) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(16) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(17) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(18) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(19) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(20) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(21) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(22) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(23) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(24) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(25) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(26) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(27) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(28) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(29) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(30) {-height 15 -radix hexadecimal} /datapath_tb/UUT/register_file/reg_file(31) {-height 15 -radix hexadecimal}} /datapath_tb/UUT/register_file/reg_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {436543 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 276
configure wave -valuecolwidth 54
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {366772 ps} {664907 ps}
