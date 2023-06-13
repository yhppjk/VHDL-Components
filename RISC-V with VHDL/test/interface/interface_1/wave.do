onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interface_1_tb/memory/clk
add wave -noupdate -radix hexadecimal /interface_1_tb/memory/PADDR
add wave -noupdate /interface_1_tb/memory/PWRITE
add wave -noupdate /interface_1_tb/memory/PSEL
add wave -noupdate /interface_1_tb/memory/PENABLE
add wave -noupdate -radix hexadecimal /interface_1_tb/memory/PRDATA
add wave -noupdate /interface_1_tb/memory/PREADY
add wave -noupdate /interface_1_tb/UUT/current_state
add wave -noupdate /interface_1_tb/UUT/next_state
add wave -noupdate -radix hexadecimal /interface_1_tb/rdata_o
add wave -noupdate -radix hexadecimal /interface_1_tb/UUT/PWDATA
add wave -noupdate /interface_1_tb/memory/PWDATA_PSTRB
add wave -noupdate /interface_1_tb/memory/PSTRB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1255952 ps} 0}
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
WaveRestoreZoom {1183345 ps} {1302469 ps}
