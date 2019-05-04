`timescale 1 ns / 1 ps

module testbench;
	    wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
//      wire        rstn;       	
		wire  		div_wire_o;
		reg		rst;
		wire        clk_test;
		reg clock_test;
		reg div_o;
//added to instantiate PUR_INST to run clock dividers
//GSR GSR_INST (.GSR ());
//PUR PUR_INST (.PUR ());
//and
//assign rst <= ~rstn;	

	
OSCH CLOCK_TEST(
	.STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(clk_test),
    .SEDSTDBY()
);
//assign clock_test = clk_test;
//assign div_o = div_wire_o;

clock_division DUT(.rst(rst), .clk(clk_test), .clock_div_o(div_wire_o));
initial	  

	begin
               #50 rst = 1'b0;
               #1000 rst = 1'b1;
			   #1000000000; // 1s
			   #1000000000; // 1s

				
		$finish;
	end



endmodule