module fifo_mem (wclk,write_enable,rclk,read_enable,wptr,rptr,data_write,wfull,rempty,data_read);

	parameter DEPTH=512, DATA_WIDTH=8, PTR_WIDTH=9;
	
	input wclk, write_enable, rclk, read_enable;
	input [PTR_WIDTH:0] wptr, rptr;
	input [DATA_WIDTH-1:0] data_write;
	input wfull, rempty;
	output reg [DATA_WIDTH-1:0] data_read;
	
	reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
	
	assign data_read = fifo[rptr[PTR_WIDTH-1:0]];
  
	always@(posedge wclk) 
		begin
			if(write_enable & !wfull) 
			begin
			  fifo[wptr[PTR_WIDTH-1:0]] <= data_write;
			end
		end
	
	
endmodule