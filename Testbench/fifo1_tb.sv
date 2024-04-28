module top;

	parameter DATA_WIDTH = 8;

	wire [DATA_WIDTH-1:0] data_read;
	wire wfull;
	wire rempty;
	wire half_wfull,half_rempty;
	reg [DATA_WIDTH-1:0] data_write;
	reg w_en, wclk, wrst_n;
	reg r_en, rclk, rrst_n;


	reg [DATA_WIDTH-1:0] data_write_q[$], wdata;

	asynchronous_fifo as_fifo (wclk, wrst_n,rclk, rrst_n,w_en,r_en,data_write,data_read,wfull,rempty,half_wfull,half_rempty);

	always #4.12ns wclk = ~wclk;
	always #10ns rclk = ~rclk;

	initial 
	begin
		wclk = 1'b0; wrst_n = 1'b0;
		w_en = 1'b0;
		data_write = 0;

		repeat(10) @(posedge wclk);
		wrst_n = 1'b1;

		repeat(2) 
		begin
			for (int i=0; i<512; i++) 
			begin
				@(posedge wclk iff !wfull);
				w_en = (i%2 == 0)? 1'b1 : 1'b0;
				if (w_en) 
				begin
					data_write = $urandom;
					data_write_q.push_back(data_write);
				end
			end
			#50;
		end
	end

	initial 
		begin
			rclk = 1'b0; rrst_n = 1'b0;
			r_en = 1'b0;

			repeat(20) @(posedge rclk);
			rrst_n = 1'b1;

			repeat(2) 
			begin
				for (int i=0; i<512; i++) 
				begin
					@(posedge rclk iff !rempty);
					r_en = (i%2 == 0)? 1'b1 : 1'b0;
					if (r_en) begin
						wdata = data_write_q.pop_front();
						if(data_read !== wdata) 
							$error("Time = %0t: TestBench Failed: expected value: wr_data = %h, got value : rd_data = %h,half_wfull = %b,half_rempty = %b", $time, wdata, data_read,half_wfull,half_rempty);
						else 
							$display("Time = %0t: TestBench Passed: expected value :wr_data = %h and got value : rd_data = %h,half_wfull = %b,half_rempty = %b",$time, wdata, data_read,half_wfull,half_rempty);
					end
				end
				#50;
		end

	$finish;
	end
	
	
endmodule
