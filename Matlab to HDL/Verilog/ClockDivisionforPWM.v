`timescale 1 ns / 1 ps
module clock_division(
	input   wire        rstn,
	input   wire        clock_test,
	output	wire 		clock_div_o
	);

reg  clk_test_i;
reg  clk_test_i2;
reg  clk_test_i3;
wire  divide_o;
wire  divide_o2;
wire  divide_o3;
wire  dud;
wire  alignwd;
reg  total_output;
always@(posedge clock_test)
	begin
		clk_test_i = clock_test;
		clk_test_i2 = clk_test_i;
		clk_test_i3 = clk_test_i2;
		total_output = divide_o3;
	end
// Clock Divider
defparam CLOCKDIV_TEST.DIV = "4.0";	  
defparam CLOCKDIV_TEST2.DIV = "4.0";
defparam CLOCKDIV_TEST3.DIV = "4.0";

CLKDIVC CLOCKDIV_TEST (.CLKI(clk_test_i),
	.RST(rstn),
	.ALIGNWD(alignwd),
	.CDIV1(dud),
	.CDIVX(divide_o)
);	
CLKDIVC CLOCKDIV_TEST2 (.CLKI(clk_test_i2),
	.RST(rstn),
	.ALIGNWD(alignwd),
	.CDIV1(dud),
	.CDIVX(divide_o2)
);
CLKDIVC CLOCKDIV_TEST2 (.CLKI(clk_test_i3),
	.RST(rstn),
	.ALIGNWD(alignwd),
	.CDIV1(dud),
	.CDIVX(divide_o3)
);
//this should leave the Hz to 31K

assign clock_div_o = total_output;


endmodule	
