module write_ptr (wclk,wrst_n,write_enable,wq2_rptr,wptr,rq2_wptr,wfull,half_full);

	parameter PTR_DEPTH=9;
	
	input wclk, wrst_n, write_enable;
	input [PTR_DEPTH:0] wq2_rptr;
	output reg [PTR_DEPTH:0] wptr, rq2_wptr;
	output reg wfull;
	output reg half_full;

	reg [PTR_DEPTH:0] inc_wptr;
	reg [PTR_DEPTH:0] g_inc_wptr;

	wire full;

	assign inc_wptr = wptr+(write_enable & !wfull);
	assign g_inc_wptr = (inc_wptr >>1)^inc_wptr;
	
	assign half_full = (wptr >= (1<<(PTR_DEPTH-1)));

	always@(posedge wclk or negedge wrst_n) 
		begin
			if(!wrst_n) 
			begin
				wptr <= 0;
				rq2_wptr <= 0;
			end
			else 
			begin
				wptr <= inc_wptr; 
				rq2_wptr <= g_inc_wptr;
			end
		end

	always@(posedge wclk or negedge wrst_n) 
		begin
			if(!wrst_n) 
				wfull <= 0;
			else        
				wfull <= full;
		end

	
	assign full = (g_inc_wptr == {~wq2_rptr[PTR_DEPTH:PTR_DEPTH-1], wq2_rptr[PTR_DEPTH-2:0]});

endmodule