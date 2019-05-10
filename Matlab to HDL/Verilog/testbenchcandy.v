`timescale 1 ms / 1 ps
// add testing for candy dispense flags, 
module testbench;
        wire        clk_x1;     	// 12M clock from FTDI/X1 crystal
        reg        rstn;       	// from SW1 pushbutton
     
		wire     	teststate0;			//[2:0] teststate for 7 states from rasp pi
		wire		teststate1;
		wire		teststate2;
		reg 	 	stateamount0;			//[1:0] stateamount for amount to dispense
		reg	    	stateamount1;
		reg     	candyflag; 			//candyflag indicates when it's time to dispense

		wire 		stepperstep;	// stepperstep
		wire 		stepperdir;			// stepperdir;
		wire  		IO_B9;			// [0] of [1:0] dcmotor;
		wire 		IO_F7;			// [1]
		wire        IO_C4;			// [2]
		wire 		handshake;		//output
		wire 		clock_DC;
		wire 		clock_DCSLOW;
		
project_module DUT( .rstn(rstn),.IO_B4(teststate0),.IO_B5(teststate1),.IO_B6(teststate2),
					.IO_A3(stateamount0),.IO_A4(stateamount1),.IO_A5(candyflag),.IO_D9(stepperstep),.IO_A10(stepperdir),
					.IO_B9(IO_B9),.IO_F7(IO_F7), .IO_C4(IO_C4), .IO_D6(handshake) ,.clock_test_DC(clock_DC),.clock_test_DCSLOW(clock_DCSLOW)
				   );
/*	//assign TESTSTATE = {teststate0,teststate1,teststate2} ;
		#5 rstn = 1'b0;	
		#20 rstn = 1'b1;
		#100 // .1s
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#10000 // .1s
		teststate0 = 1;
		teststate1 = 0;
		teststate2 = 0; 
		#10000 		
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#100 // .1s
		teststate0 = 0;
		teststate1 = 1;
		teststate2 = 0;
		#10000 
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#100 // .1s
		teststate0 = 1;
		teststate1 = 1;
		teststate2 = 0; 
		#10000 
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#100 // .1s
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 1; 
		#10000 	
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#100// .1s
		teststate0 = 1;
		teststate1 = 0;
		teststate2 = 1; 
		#10000 		
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0;
		#100 // .1s
		teststate0 = 0;
		teststate1 = 1;
		teststate2 = 1;
		#10000 		
		teststate0 = 0;
		teststate1 = 0;
		teststate2 = 0; 
		#100 // .1s
		teststate0 = 1;
		teststate1 = 1;
		teststate2 = 1;
		#900 // s
	*/
	initial
	begin
			
		#5 rstn = 1'b0;	
		#20 rstn = 1'b1;
		#100 // .1s
		stateamount0 = 1'b0;
		stateamount1 = 1'b0;
		candyflag = 1'b1;
		#5000
		candyflag = 1'b0;
		#5000 
		stateamount0 = 1'b1;
		stateamount1 = 1'b0;
		candyflag = 1'b1;
		#5000
		candyflag = 1'b0;
		#5000
		stateamount0 = 1'b0;
		stateamount1 = 1'b1;
		candyflag = 1'b1;
		#5000
		candyflag = 1'b0;
		#5000
		//#90000 // 9s
		$finish;
	end
	
	
	
	
endmodule