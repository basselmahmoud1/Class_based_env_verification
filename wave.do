onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate -expand /top/mem/mem
add wave -noupdate /top/memif/data_in
add wave -noupdate /top/memif/data_out
add wave -noupdate -radix binary /top/memif/addr
add wave -noupdate /top/memif/EN
add wave -noupdate /top/memif/RW
add wave -noupdate /top/memif/valid_out
add wave -noupdate /top/memif/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {322 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {1258 ns}
