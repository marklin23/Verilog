onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bfm_tb/u0/clk_clk
add wave -noupdate /bfm_tb/u0/reg32_read_port_external_connection_export
add wave -noupdate /bfm_tb/u0/reg32_write_port_external_connection_export
add wave -noupdate /bfm_tb/u0/reset_reset_n
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_byteenable
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_address
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_read
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_readdata
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_readdatavalid
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_write
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_writedata
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_burstcount
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bfm_tb/u0/mm_master_bfm_0_m0_waitrequest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60161840 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 471
configure wave -valuecolwidth 96
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {60057928 ps} {60261234 ps}
