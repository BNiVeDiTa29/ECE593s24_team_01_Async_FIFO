module read_ptr (rclk,rrst_n,read_enable,rq2_wptr,rptr,wq2_rptr,rempty,half_wempty);

	parameter PTR_DEPTH = 9;
	
	input rclk, rrst_n, read_enable;
	input [PTR_DEPTH:0] rq2_wptr;
	output reg [PTR_DEPTH:0] rptr, wq2_rptr;
	output reg rempty,half_wempty;

	reg [PTR_DEPTH:0] inc_rptr;
	reg [PTR_DEPTH:0] g_inc_rptr;

	assign inc_rptr = rptr+(read_enable & !rempty);
	assign g_inc_rptr = (inc_rptr >>1)^inc_rptr;
	assign empty = (rq2_wptr == g_inc_rptr);
	
	assign half_wempty = (rptr <= (1 << (PTR_DEPTH - 1)));
  
	always@(posedge rclk or negedge rrst_n) 
		begin
			if(!rrst_n) begin
				rptr <= 0;
				wq2_rptr <= 0;
			end
			else begin
				rptr <= inc_rptr;
				wq2_rptr <= g_inc_rptr;
			end
		end
  
	always@(posedge rclk or negedge rrst_n) 
		begin
			if(!rrst_n) 
				rempty <= 1;
			else        
				rempty <= empty;
		end
		
		
endmodule