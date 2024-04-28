module synchronizer (clk,rst_n,D_in,D_out);

	parameter WIDTH=8;
	
	input clk, rst_n;
	input [WIDTH:0] D_in;
	output reg [WIDTH:0] D_out;
	
	reg [WIDTH:0] q;
	
	always@(posedge clk) 
		begin
			if(!rst_n) 
			begin
				q <= 0;
				D_out <= 0;
			end
			else 
			begin
				q <= D_in;
				D_out <= q;
			end
		end
endmodule