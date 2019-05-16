`timescale 1 s / 1 ps

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
		
		wire 		stepperstep; 			// stepperstep
		wire 		stepperdir;			// stepperdir;
		wire  		dcmotor0;			// [0] of [1:0] dcmotor;
		wire 		dcmotor1;			// [1]
		wire        dcmotor2;			// [2]
		wire 		clock_tst_step;
		wire 		clock_DC;
		wire 		clock_DCSLOW;
project_module DUT( .rstn(rstn),.DIPSW(DIPSW), .IO_B4(IO_B4), .IO_B5(IO_B5), .IO_B6(IO_B6), .IO_A3(IO_A3), .IO_A4(IO_A4), .IO_A5(IO_A5),
					.IO_D9(stepperstep),.IO_A10(stepperdir),
					.IO_B9(dcmotor0),.IO_F7(dcmotor1), .IO_C4(dcmotor2), .clock_test_DC(clock_DC),.clock_test_DCSLOW(clock_DCSLOW), .clock_test_step(clock_tst_step)
				   );
				   
	initial
	begin
		#5 rstn = 1'b1;	
		#2 rstn = 1'b0;
		#10 // 1s
		DIPSW[2:0] = 3'b000;
		#10 // 1s
		DIPSW[2:0] = 3'b001;
		#10 DIPSW[2:0] = 3'b000;
		#1 // 1s
		DIPSW[2:0] = 3'b010;
		#10 DIPSW[2:0] = 3'b000;
		#1 // 1s
		DIPSW[2:0] = 3'b011;
		#10 DIPSW[2:0] = 3'b000;
		#1 // 1s
		DIPSW[2:0] = 3'b100;
		#10 DIPSW[2:0] = 3'b000;
		#1// 1s
		DIPSW[2:0] = 3'b101;
		#10 DIPSW[2:0] = 3'b000;
		#1 // 1s
		DIPSW[2:0] = 3'b110;
		#10 DIPSW[2:0] = 3'b000;
		#1 // 1s
		DIPSW[2:0] = 3'b111;
		#9 // 100000s
		$finish;
	end
	
	
	
	
endmodule