vlib work
vlog -f src_files.list    +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover -sv_seed random
add wave /top/fifo_if/*
add wave -position insertpoint  \
sim:/top/F1/wr_ptr \
sim:/top/F1/rd_ptr \
sim:/top/F1/count
coverage save FIFO_top.ucdb -onexit
run -all