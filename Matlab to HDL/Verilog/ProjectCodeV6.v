//V6: has outputs for when candydispense is set
//the purpose of the program is to take in inputs from the raspberry pi to give movement to motors.

module project_module (       // inputs
     //   input   wire        clk_x1,     	// 12M clock from FTDI/X1 crystal
        input   wire        rstn,       	// from SW1 pushbutton
        input   wire  [3:0] DIPSW,      	// from SW2 DIP switches
		input   wire  		IO_B4,			//[0] of[2:0] teststate for 7 states from rasp pi
		input   wire 		IO_B5,			//[1]
		input 	wire 		IO_B6,			//[2]
		
		input 	wire 		IO_A3,			//[0] of[1:0] stateamount for amount to dispense
		input   wire 		IO_A4,			//[1]
		input   wire  		IO_A5, 			//candyflag indicates when it's time to dispense
		

		output  wire 		IO_D9, 			// stepperstep
		output  wire 		IO_A10,			// stepperdir,
		output  wire  		IO_B9,			// [0] of [1:0] dcmotor, direction
		output  wire 		IO_F7,			// [1] controls direction
		output  wire        IO_C4,			// [2] controls speed, pwm
		output  wire 		IO_D6,			// handshake to give to raspberry pi, also signal for when new state was recieved
		output  wire 		clock_test_step,	    //makes sure we have a beat, good for testing on simulation
		output	wire		clock_test_DC,
		output	wire		clock_test_DCSLOW
		);
		

// wires (assigns)
wire          osc_clk;        // Internal OSCILLATOR clock

wire          rst;            //	
wire 		  clk_test;
//moved here because it wasn't working earlier, can change back later
wire IO_A5_i;		//assigns input of candyflag
wire IO_B4_i;	 	//input teststate[0] stated in first line
wire IO_B5_i;	 	//input teststate[1] stated in first line
wire IO_B6_i;	 	//input teststate[2] stated in first line
wire IO_A3_i; 	 	//[0] of[1:0] stateamount for amount to dispense
wire IO_A4_i; 	 	//[1] of[1:0] stateamount for amount to dispense


//
//reg (always)
reg [2:0] teststate;		//3 inputs total
reg [1:0] stateamount;		//2 inputs total
reg candyflag;	//indicates when it's time to dispense 
//outputs
reg signalrecieved; //signal for when new state was recieved
reg stepperstep;	
reg stepperdir;
reg [2:0] dcmotor;
reg servopwm; 
reg handshake = 1'b0; //for rasp pi
//counter
reg countstep = 0; //used for candyflag dispense
reg test;
reg prev = 0; //temp value
reg current; //temp value
reg i; 
//for clocks
wire stepb;
wire stepbslow;
wire stepDC; //clock wire for DC, output of ~27733Hz ; med/fast
wire stepDCslow;
wire stepDCfast;
wire clockhandshake;

wire fixDCslow;
wire fixDC;
wire fixstep;

//and
assign rst = ~rstn;

//inputs
assign IO_A5_i = IO_A5;		 //assigns input of candyflag
assign IO_B4_i = IO_B4;	 	 //input teststate[0] stated in first line
assign IO_B5_i = IO_B5;	 	 //input teststate[1] stated in first line
assign IO_B6_i = IO_B6;	 	 //input teststate[2] stated in first line
assign IO_A3_i = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
assign IO_A4_i = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense


always @ (DIPSW[2:0], stepb, clockhandshake) // teststate[2:0], candyflag, stateamount[1:0] )//(posedge osc_clk) //removed because no support for synthesis of mixed edge and level triggers: DIPSW[2:0], teststate[2:0], candyflag, stateamount[1:0])
						   //by using clock we're able to assign the teststate reg and such to wires
    begin
		
			//these inputs are tested because there's a continous assignment from IO_XX_i = IO_XX
			teststate[0] = IO_B6_i;	 	 //input teststate[0] stated in first line
			teststate[1] = IO_B5_i;	 	 //input teststate[1] stated in first line
			teststate[2] = IO_B4_i;	 	 //input teststate[2] stated in first line
			stateamount[0] = IO_A3_i; 	 //[0] of[1:0] stateamount for amount to dispense
			stateamount[1] = IO_A4_i; 	 //[1] of[1:0] stateamount for amount to dispense
			candyflag = IO_A5_i;			 //assigns input of candyflag

            case(DIPSW[2:0])        //later changed to state when we can recieve Rasp Pi inputs
			
				3'b001 : begin 
						  //signal to stepper motor
				  		  stepperdir = 1'b0; // dont need to step again because of default
						  stepperstep = stepbslow;  //reduce hz to reduce speed
						 end
				3'b010 : begin 
						  //signal to stepper motor						  //stepper motor change dir right
						  //signal to stepper motor only
						  stepperdir = 1'b1;
  						  stepperstep = stepbslow;  //reduce hz to reduce speed
						end
				3'b011 : begin 
						  //stepper motor change fast 
						  //signal to stepper motor
						  stepperdir = 1'b0; // dont need to step again because of default
  						  stepperstep = stepb;  //reduce hz to reduce speed
						end
				3'b100 : begin //signal to left pwm to DC motor
							   dcmotor[0] = 1'b0; //default
							   dcmotor[1] = 1'b1;
							   dcmotor[2] = stepDCslow ;//? 1'b1 : 1'b0 ;
                    end
				3'b101 : begin 
							   //signal to right pwm to DC motor
							   dcmotor[0] = 1'b1;
							   dcmotor[1] = 1'b0;
							   dcmotor[2] = stepDCslow; // ? 1'b1 : 1'b0 ;
                    end					
				3'b110 : begin
							   //signal to right pwm to DC motor
							   dcmotor[0] = 1'b0; //default
							   dcmotor[1] = 1'b1;
							   dcmotor[2] = stepDCfast ;//? 1'b1 : 1'b0 ;
						end	

                default : begin     
                        stepperstep = 1'b0;
						stepperdir = 1'b0;
						dcmotor[0] = 1'b0;
					    dcmotor[1] = 1'b1;
						dcmotor[2] = 1'b0;
						//stop all motors
                    end
				
           endcase
		   //Added handshake send input to raspberrypi to confirms that candyflag was set 
		//removed, check it on github v6
	
   if(candyflag == 1)
				begin
				   case (stateamount[1:0])
						//State 00 is the small amount state, the GUI should send this signal 
						//whenever nothing has been changed and just starting up
						2'b00 : begin      //small amount being dispensed
								//send signals to stepper motor 
								 //signal to stepper motor
								 stepperdir = 1'b0; // dont need to step again because of default
								 stepperstep = stepb;  //reduce hz to reduce speed

								//	begin 
								i = 10 ;
								while( i > 0)
								begin
											stepperdir = 1'b1;
											i = i - 1 ;
								end
								//	if(stepb == 0 ) begin
									//	while(stepb == 0)
									//		stepperstep = stepb;
									//	while(stepb == 1)
									//		stepperstep = stepb;
									//	countstep = countstep + 1;	
									
									
								stepperdir = 1'b0;
								//	else 
								//		stepperstep = 0;
									
								/*
									current = stepb; 
									if(current == prev)
										stepperstep = stepperstep;
									else if(current != prev)
										begin
											countstep = countstep + 1;
											stepperstep = current; 
											prev = current; 
										end
									 */	 
									 //signal to stepper motor
								// stepperdir = 1'b0; // dont need to step again because of default
						 		// stepperstep = stepb;  //reduce hz to reduce speed
								//	end


								//send signal to dcmotor pin
															   //signal to right pwm to DC motor
							   dcmotor[0] = 1'b1;
							   dcmotor[1] = 1'b0;
							   dcmotor[2] = stepDC; // ? 1'b1 : 1'b0 ;
						///	 cant leave handshake here because then the GUI gets that the motor is ready to stop too soon
						//	   handshake = 1'b1;		//send output to raspberry pi
							end
						//State 10 is in medium amount being dispensed
						2'b01 : begin      //med amount being dispensed
								//send signals to stepper motor 

								for( i = 10; i > 0; i = i - 1) 
									begin
									/*if(stepb == 0 ) begin
										while(stepb == 0)
											stepperstep = stepb;
										while(stepb == 1)
											stepperstep = stepb;
										countstep = countstep + 1;
									end
									else 
										stepperstep = 0
							*/
									current = stepb; 
									if(current == prev)
										stepperstep = stepperstep;
									else if(current != prev)
										begin
											countstep = countstep + 1;
											stepperstep = current; 
											prev = current; 
										end

									end

								//send signal to dcmotor pin
															   //signal to right pwm to DC motor
							   dcmotor[0] = 1'b1;
							   dcmotor[1] = 1'b0;
							   dcmotor[2] = stepDC; // ? 1'b1 : 1'b0 ;
							   handshake = 1'b1;		//send output to raspberry pi
							end

						2'b10 : begin   //large amount being dispensed
								//send signals to stepper motor 

								for( i = 10; i > 0; i = i - 1)  									
									begin
									/*if(stepb == 0 ) begin
										while(stepb == 0)
											stepperstep = stepb;
										while(stepb == 1)
											stepperstep = stepb;
										countstep = countstep + 1;
									end
									else 
										stepperstep = 0;*/
									current = stepb; 
									if(current == prev)
										stepperstep = stepperstep;
									else if(current != prev)
										begin
											countstep = countstep + 1;
											stepperstep = current; 
											prev = current; 
										end

									end
								//send signal to dcmotor pin
															   //signal to right pwm to DC motor
							   dcmotor[0] = 1'b1;
							   dcmotor[1] = 1'b0;
							   dcmotor[2] = stepDC; // ? 1'b1 : 1'b0 ;
							   handshake = 1'b1;		//send output to raspberry pi
								end

					endcase

				  //  handshake = 1'b1;

				end
			else
				begin
					handshake = 1'b0;		//send output to raspberry pi
					stepperstep = 1'b0;
					stepperdir = 1'b0;
					dcmotor[0] = 1'b0;
					dcmotor[1] = 1'b1;
					dcmotor[2] = 1'b0;
					//stop all motors
				end


end


//--------------------------------------------------------------------
//--  module instances
//--------------------------------------------------------------------

//defparam OSCH_inst.NOM_FREQ = "2.08";  
//default param is 2.08 (2MHz)
OSCH #(.NOM_FREQ(2.08)) OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
    );
//clock_division 
//signal for stepper
//defparam inst_fixstep.width = "9";
//defparam inst_fixstep.N = "400";
clock_division #(.N(400), .width(9)) inst_fixstep (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixstep)	//5200Hz
		);
//defparam inst_stepslow.width = "6";
//defparam inst_stepslow.N = "32";
clock_division #(.N(32), .width(6)) inst_stepslow (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (stepbslow)	//162Hz
		);
//defparam inst_step.width = "4";
//defparam inst_step.N = "10";
clock_division #(.N(10), .width(4)) inst_step(
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (stepb)	//520 Hz
		);
			
//defparam inst_DC.width = 9;
//defparam inst_DC.N = 101;		//18,086.95 Hz
clock_division #(.N(101), .width(7)) inst_DC (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixDC)
		);	
//defparam inst_DCSLOW.width = "9";
//defparam inst_DCSLOW.N = "200";		//10,400hz	
clock_division #(.N(200), .width(9)) inst_DCSLOW (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixDCslow)
		);
		
clock_division #(.N(36), .width(6)) inst_handshake (
        .clk        (stepbslow),
        .rst        (rst),				//36
        .clock_div_o (clockhandshake)	//4.5Hz
		);		
//defparam inst_DCSLOW_CLK.rise = "25";
PWM_DC #(.rise(25)) inst_DCSLOW_CLK (
		.clk (fixDC),			//changed from fixDCslow
		.clk_out (stepDCslow)

);
PWM_DC inst_DC_CLK (
		.clk (fixDC),
		.clk_out (stepDC)
);
//defparam inst_DCFAST_CLK.rise = "75";
PWM_DC #(.rise(75)) inst_DCFAST_CLK (
		.clk (fixDC),
		.clk_out (stepDCfast)
);
/* PWM_generation inst_dc_pwm(
        .clk        (osc_clk),
        .reset        (rst),
        .rise  		(rise),
		.fall		(fall),
		.clk_out	(clock_dc)
        );
	
*/
//-------------------------------------//
//-------- output assignments  --------//
//-------------------------------------//
//assign GPIO outputs to outputs named

assign IO_D9 = stepperstep;
assign IO_A10 = stepperdir;
assign IO_B9 = dcmotor[0];
assign IO_F7 = dcmotor[1];
assign IO_C4 = dcmotor[2]; 
assign IO_D6 = handshake;
assign clock_test_step = clockhandshake;
assign clock_test_DC = stepDC;
assign clock_test_DCSLOW = stepDCslow;

endmodule 