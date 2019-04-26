`timescale 1 ns / 1 ps

module testbench;
	    wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
//      wire        rstn;       	
		wire  		div_wire_o;
		wire		rst;
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

clock_division DUT(.rstn(rst), .clock_test(clk_test), .clock_div_o(div_wire_o));
initial	  

	begin
				#1000000000 // 1s
				$display("hello, clock testing");
				#1000000000 // 1s
				#1000000000 // 1s
				#1000000000 // 1s
				#1000000000 // 1s
				#1000000000 // 1s
				#1000000000 // 1s
				
		$finish;
	end



endmodule
