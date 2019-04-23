`timescale 1ns / 1ps


module top( input clk, output led );
	
	//create a simple counter
	
	reg [7:0] counter = 0;
	
always@(posedge clk) begin
	if (counter < 100) counter <= counter + 1; //count until 100
	else counter <= 0;
end

assign led = (counter < 20 ) ? 1:0; //assign led to 1 if counter value is less than 
endmodule 

