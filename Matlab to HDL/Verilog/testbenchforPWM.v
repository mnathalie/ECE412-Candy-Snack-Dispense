`timescale 1 ms / 1 us

module testbench;
	    wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
//      wire        rstn;       	
		wire  		div_wire_o;	
		wire  		div_wire_o2;
		reg		rst;
		wire        clk_test;
		reg clock_test;
		reg div_o;
		reg [3:0] rise;
		reg [3:0] fall; 
//added to instantiate PUR_INST to run clock dividers
//GSR GSR_INST (.GSR ());
//PUR PUR_INST (.PUR ());
//and
//assign rst <= ~rstn;	

defparam CLOCK_TEST.NOM_FREQ = "2.08";	
OSCH CLOCK_TEST(
	.STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(clk_test),
    .SEDSTDBY()
);
//assign clock_test = clk_test;
//assign div_o = div_wire_o;

//clock_division DUT(.rst(rst), .clock_test(clk_test), .clock_div_o(div_wire_o));
PWM_generation DUT(.clk(clk_test), .reset(rst),.rise(rise),.fall(fall),.clk_out(div_wire_o));
initial	  

	begin				 
		//$monitor($time,"clk = %b,rst = %b,out_clk = %b",clk_test,rst,div_wire_o);
		rst = 0;
		#50 rst = 1;
		rise = 4'b0010;
		fall = 4'b0010;
		#20 ;
		#20 rise = 4'b0001;
		#10 $finish;

	end



endmodule
