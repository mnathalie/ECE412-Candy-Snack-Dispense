`timescale 1 ns / 1 ns

module testbench;
        wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
        wire        rstn;       	// from SW1 pushbutton
        reg  [3:0] DIPSW;      	// from SW2 DIP switches
		wire     	IO_B4;			//[0] of[2:0] teststate for 7 states from rasp pi
		wire     	IO_B5;			//[1]
		wire 	 	IO_B6;			//[2]
		wire 	 	IO_A3;			//[0] of[1:0] stateamount for amount to dispense
		wire    	IO_A4;			//[1]
		wire     	IO_A5; 			//candyflag indicates when it's time to dispense
		
		wire  		IO_B7; 			// signalrecieved = signal for when new state was recieved
		wire 		IO_D9; 			// stepperstep
		wire 		IO_A10;			// stepperdir;
		wire  		IO_B9;			// [0] of [1:0] dcmotor;
		wire 		IO_F7;			// [1]
		wire        IO_C5;			// servopwm
/*				reg [2:0] teststate;		//3 inputs total
reg [1:0] stateamount;		//2 inputs total
reg candyflag;	//indicates when it's time to dispense 
//outputs
reg signalrecieved; //signal for when new state was recieved
reg stepperstep;	
reg stepperdir;
reg [1:0] dcmotor;
reg servopwm; 
//assigns
assign IO_A5_i = IO_A5;			 //assigns input of candyflag
assign IO_B4_i = IO_B4;	 	 //input teststate[0] stated in first line
assign IO_B5_i = IO_B5;	 	 //input teststate[1] stated in first line
assign IO_B6_i = IO_B6;	 	 //input teststate[2] stated in first line
assign IO_A3_i = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
assign IO_A4_i = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense
*/
project_module DUT(.clk_x1(clk_x1),.rstn(rstn),.DIPSW(DIPSW),.IO_B4(IO_B4),.IO_B5(IO_B5),.IO_B6(IO_B6),
					.IO_A3(IO_A3),.IO_A4(IO_A4),.IO_A5(IO_A5),.IO_B7(IO_B7),.IO_D9(IO_D9),.IO_A10(IO_A10),
					.IO_B9(IO_B9),.IO_F7(IO_F7),.IO_C5(IO_C5)
				   );
				   
	initial
	begin
		DIPSW[2:0] = 3'b000;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b001;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b010;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b011;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b100;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b101;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b110;
		#1000000000 // 1s
		DIPSW[2:0] = 3'b111;
		#1000000000 // 1s
		$finish;
	end
	
	
	
	
endmodule