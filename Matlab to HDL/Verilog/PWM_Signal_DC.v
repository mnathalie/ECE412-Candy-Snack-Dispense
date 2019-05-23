//DC only. The module takes in the already divided clock signal and re-adjusts it so that we can 
// control ratios for PWM if needed. The default is set to 50, or 50% duty cycle.
module PWM_DC( input wire clk , output wire clk_out);


parameter rise = 50;
//parameter fall;

reg [7:0] counter = 0;

always@(posedge clk)
	begin
		if( counter < 100 )
			begin
				counter <= counter + 1; //count until 100
			end
		else
			begin
				counter <= 0; // reset counter
			end
	end
	
	assign clk_out = (counter < rise ) ? 1:0 ;
	
endmodule
	
	