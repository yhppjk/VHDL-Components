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
add wave -noupdate /datapath_tb/ram_PRDATA
add wave -noupdate /datapath_tb/ram_PREADY
add wave -noupdate /datapath_tb/ram_PADDR
add wave -noupdate /datapath_tb/ram_PSTRB
add wave -noupdate /datapath_tb/ram_PWDATA
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
add wave -noupdate /datapath_tb/PRDATAs
add wave -noupdate /datapath_tb/UUT/memory_interface/rdata_o
add wave -noupdate /datapath_tb/UUT/RI_value
add wave -noupdate /datapath_tb/UUT/LoadIR
add wave -noupdate /datapath_tb/cu_wIR
add wave -noupdate /datapath_tb/tb_Membusy
add wave -noupdate /datapath_tb/UUT/port_Membusy
add wave -noupdate /datapath_tb/UUT/Membusy
add wave -noupdate /datapath_tb/UUT/memory_interface/busy_o
add wave -noupdate /datapath_tb/UUT/memory_interface/trigger
add wave -noupdate /datapath_tb/UUT/memory_interface/busy_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170687 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 40
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
WaveRestoreZoom {170075 ps} {199711 ps}
