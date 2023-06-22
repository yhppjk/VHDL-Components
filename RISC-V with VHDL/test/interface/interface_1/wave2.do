onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interface_2_tb/memory/clk
add wave -noupdate -radix hexadecimal /interface_2_tb/memory/PADDR
add wave -noupdate /interface_2_tb/memory/PWRITE
add wave -noupdate /interface_2_tb/memory/PSEL
add wave -noupdate /interface_2_tb/memory/PENABLE
add wave -noupdate -radix hexadecimal /interface_2_tb/memory/PRDATA
add wave -noupdate /interface_2_tb/memory/PREADY
add wave -noupdate /interface_2_tb/UUT/current_state
add wave -noupdate /interface_2_tb/UUT/next_state
add wave -noupdate -radix hexadecimal /interface_2_tb/rdata_o
add wave -noupdate -radix hexadecimal /interface_2_tb/UUT/PWDATA
add wave -noupdate /interface_2_tb/tb_PSTRB
add wave -noupdate /interface_2_tb/UUT/ALIGNMENT
add wave -noupdate /interface_2_tb/size_i
add wave -noupdate /interface_2_tb/UUT/size_operation/BYTESTRB_3_0
add wave -noupdate /interface_2_tb/UUT/size_operation/BYTESTRB_7_4
add wave -noupdate /interface_2_tb/UUT/mux_PSTRB/dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31096 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {281372 ps}
