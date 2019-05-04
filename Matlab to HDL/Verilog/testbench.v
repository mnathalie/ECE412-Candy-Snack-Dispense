`timescale 1 ms / 1 us

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
		wire        IO_C5;			// servopwm
		wire 		clock_tst;
project_module DUT( .rstn(rstn),.DIPSW(DIPSW),.IO_B4(IO_B4),.IO_B5(IO_B5),.IO_B6(IO_B6),
					.IO_A3(IO_A3),.IO_A4(IO_A4),.IO_A5(IO_A5),.IO_B7(IO_B7),.IO_D9(IO_D9),.IO_A10(IO_A10),
					.IO_B9(IO_B9),.IO_F7(IO_F7),.clock_test(clock_tst)
				   );
				   
	initial
	begin
		#5 rstn = 1'b1;	
		#20 rstn = 1'b0;
		#100 // 1s
		DIPSW[2:0] = 3'b000;
		#100000 // 1s
		DIPSW[2:0] = 3'b001;
		#100000 // 1s
		DIPSW[2:0] = 3'b010;
		#100000 // 1s
		DIPSW[2:0] = 3'b011;
		#100000 // 1s
		DIPSW[2:0] = 3'b100;
		#900000// 1s
		DIPSW[2:0] = 3'b101;
		#100000 // 1s
		DIPSW[2:0] = 3'b110;
		#100000 // 1s
		DIPSW[2:0] = 3'b111;
		#900000 // 100000s
		$finish;
	end
	
	
	
	
endmodule