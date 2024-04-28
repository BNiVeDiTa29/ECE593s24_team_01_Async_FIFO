vlib work
vdel -all
vlib work

vlog -lint -source fifo1.sv
vlog -lint -source fifomem.sv
vlog -lint -source read_ptr.sv
vlog -lint -source write_ptr.sv
vlog -lint -source synchronizer.sv
vlog -lint -source fifo1_tb.sv

vsim work.top

run -all