`timescale 1 s / 1 ps
// add testing for candy dispense flags, 
module testbench;
        //reg        clk_x1;     	// 12M clock from FTDI/X1 crystal
        reg        rstn;       	// from SW1 pushbutton
     
		reg     	teststate0;			//[0][2:0] teststate for 7 states from rasp pi
		reg			teststate1;			//[1]
		reg			teststate2;			//[2]
		reg 	 	stateamount0;			//[0][1:0] stateamount for amount to dispense
		reg	    	stateamount1;			//[1]
		reg     	candyflag; 			//candyflag indicates when it's time to dispense

		wire 		stepperstep;	// stepperstep
		wire 		stepperdir;			// stepperdir;
		wire  		dcmotor0;			// [0] of [1:0] dcmotor (IO_B9)
		wire 		dcmotor1;			// [1] (IO_F7)
		wire        dcmotor2;			// [2] (IO_C4)
		wire 		handshake;		//output
		wire 		clock_DC;
		wire 		clock_DCSLOW;
		wire 		clock_test_step; 
project_module DUT( .rstn(rstn),.IO_B4(teststate0),.IO_B5(teststate1),.IO_B6(teststate2),
					.IO_A3(stateamount0),.IO_A4(stateamount1),.IO_A5(candyflag),.IO_D9(stepperstep),.IO_A10(stepperdir),
					.IO_B9(dcmotor0),.IO_F7(dcmotor1), .IO_C4(dcmotor2), .IO_D6(handshake) ,.clock_test_DC(clock_DC),.clock_test_DCSLOW(clock_DCSLOW), .clock_test_step(clock_test_step)
				   );
				   
				   
		//initial	begin		   
		//	clk_x1 = 0;
		//	forever	#0.0000005 clk_x1 = ~clk_x1;
		//end
		
		initial
	begin
		
		teststate0 = 1'b1;
		teststate1 = 1'b1;
		teststate2 = 1'b0;	
	    rstn = 1'b0;	
		#2 rstn = 1'b1;
		
		#2
		teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b0;
		candyflag = 1'b1;
		#1
		if(handshake == 1)
			candyflag = 1'b0;
		#2
		stateamount0 = 1'b1;
		stateamount1 = 1'b0;
		candyflag = 1'b1;
		#1
		if(handshake == 1)
			candyflag = 1'b0;
		#2
		stateamount0 = 1'b0;
		stateamount1 = 1'b1;
		candyflag = 1'b1;
		#1
		if(handshake == 1)
			candyflag = 1'b0;
		//stateamount0 = 1'b0;
		#2
		teststate0 = 1'b1;
		teststate1 = 1'b0;
		teststate2 = 1'b1;
		#2
		teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b0;
		#1
		teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b1;
		#2
		teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b0;
		#1
		teststate0 = 1'b1;
		teststate1 = 1'b1;
		teststate2 = 1'b1;
		#2
			teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b0;
		#1
		teststate0 = 1'b0;
		teststate1 = 1'b1;
		teststate2 = 1'b0;
		#2
		teststate0 = 1'b0;
		teststate1 = 1'b0;
		teststate2 = 1'b0;
		#1
		teststate0 = 1'b1;
		teststate1 = 1'b1;
		teststate2 = 1'b0;
		#2
		$finish; 
	end
	
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
	
