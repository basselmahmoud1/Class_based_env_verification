vlib work
vlog -f src_files.list +cover=sbfec -coveropt 3
vsim -voptargs=+acc work.top
add wave *
#do wave.do
run -all