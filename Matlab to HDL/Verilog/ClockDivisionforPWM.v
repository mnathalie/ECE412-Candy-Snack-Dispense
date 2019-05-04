`timescale 1 ns / 1 ps
module clock_division(
	input   wire        rst,
	input   wire        clk,
	output	clock_div_o
	); 

parameter width = 2;
parameter N = 2;	
reg [width:0] clk_div_counter;
//wire [width:0] next;
reg clock_tracker;

always @(posedge clk)
	begin
		if(rst)
			begin
				clk_div_counter = 0;
				clock_tracker <= 1'b0;  
			end
		else if( clk_div_counter == N)
			begin
				clk_div_counter <= 0;
				clock_tracker <= ~clock_tracker;
			end	
		else
			begin
				clock_tracker <= 1'b0;
				clk_div_counter = clk_div_counter + 1;
			end
	 end			
	 
assign clock_div_o = clock_tracker;

endmodule	
