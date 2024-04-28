`include "synchronizer.sv"
`include "write_ptr.sv"
`include "read_ptr.sv"
`include "fifomem.sv"

module asynchronous_fifo (wclk,wrst_n,rclk,rrst_n,write_enable,read_enable,data_read,data_write,wfull,rempty,half_full,half_rempty);

	parameter DEPTH=512, DATA_WIDTH=8;
	parameter PTR_WIDTH = $clog2(DEPTH);

	input wclk, wrst_n;
	input rclk, rrst_n;
	input write_enable, read_enable;
	input [DATA_WIDTH-1:0] data_read;
	output reg [DATA_WIDTH-1:0] data_write;
	output reg wfull, rempty,half_full,half_rempty;

	reg [PTR_WIDTH:0] sync_rq2_wptr, sync_wq2_rptr;
	reg [PTR_WIDTH:0] wptr, rptr;
	reg [PTR_WIDTH:0] rq2_wptr, wq2_rptr;

	wire [PTR_WIDTH-1:0] waddr, raddr;

	synchronizer #(PTR_WIDTH) sync_wptr (rclk, rrst_n, rq2_wptr, sync_rq2_wptr); 
	synchronizer #(PTR_WIDTH) sync_rptr (wclk, wrst_n, wq2_rptr, sync_wq2_rptr);  

	write_ptr #(PTR_WIDTH) wptr_h(wclk, wrst_n, write_enable,sync_wq2_rptr,wptr,rq2_wptr,wfull,half_full);
	read_ptr #(PTR_WIDTH) rptr_h(rclk, rrst_n, read_enable,sync_rq2_wptr,rptr,wq2_rptr,rempty,half_rempty);
	fifo_mem fifom(wclk, write_enable, rclk, read_enable,wptr, rptr, data_read,wfull,rempty, data_write);

endmodule
