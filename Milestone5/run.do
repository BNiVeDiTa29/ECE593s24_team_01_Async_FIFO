vlib work
vlog async_fifo.sv
vlog async_fifo_package.sv
vlog async_fifo_top.sv
vlog async_fifo_test1.sv
vlog async_fifo_test2.sv
vlog async_fifo_test3.sv
vlog async_fifo_driver.sv
vlog async_fifo_env.sv
vlog async_fifo_interface.sv
vlog async_fifo_read_agent.sv
vlog async_fifo_scoreboard.sv
vlog async_fifo_seq_item.sv
vlog async_fifo_seq_test1.sv
vlog async_fifo_seq_test2.sv
vlog async_fifo_seq_test3.sv
vlog async_fifo_sequencer.sv
vlog async_fifo_write_agent.sv
vlog async_fifo_read_monitor.sv
vlog async_fifo_write_monitor.sv


vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll basetest.ucdb; run -all"
#vsim -coverage tb_top -voptargs="+cover=bcesf"
coverage report -code bcesf
coverage report -codeAll
#coverage report -assert -binrhs -details -cvg

#vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll fulltest.ucdb; run -all"
#vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll randomtest.ucdb; run -all"
#vcover merge output basetest.ucdb fulltest.ucdb randomtest.ucdb
#vcover report -html output

