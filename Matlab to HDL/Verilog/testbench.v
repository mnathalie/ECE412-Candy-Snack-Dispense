`timescale 1 ms / 1 ps

module testbench;
        wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
        reg        rstn;       	// from SW1 pushbutton
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
		wire        IO_C4;			// [2]
		wire 		clock_tst_step;
		wire 		clock_DC;
		wire 		clock_DCSLOW;
project_module DUT( .rstn(rstn),.DIPSW(DIPSW),
					.IO_B7(IO_B7),.IO_D9(IO_D9),.IO_A10(IO_A10),
					.IO_B9(IO_B9),.IO_F7(IO_F7), .IO_C4(IO_C4), .clock_test_DC(clock_DC),.clock_test_DCSLOW(clock_DCSLOW)
				   );
				   
	initial
	begin
		#5 rstn = 1'b0;	
		#20 rstn = 1'b1;
		#100 // 1s
		DIPSW[2:0] = 3'b000;
		#10000 // 1s
		DIPSW[2:0] = 3'b001;
		#10000 DIPSW[2:0] = 3'b000;
		#100 // 1s
		DIPSW[2:0] = 3'b010;
		#10000 DIPSW[2:0] = 3'b000;
		#100 // 1s
		DIPSW[2:0] = 3'b011;
		#10000 DIPSW[2:0] = 3'b000;
		#100 // 1s
		DIPSW[2:0] = 3'b100;
		#10000 DIPSW[2:0] = 3'b000;
		#100// 1s
		DIPSW[2:0] = 3'b101;
		#10000 DIPSW[2:0] = 3'b000;
		#100 // 1s
		DIPSW[2:0] = 3'b110;
		#10000 DIPSW[2:0] = 3'b000;
		#100 // 1s
		DIPSW[2:0] = 3'b111;
		#900 // 100000s
		$finish;
	end
	
	
	
	
endmodule