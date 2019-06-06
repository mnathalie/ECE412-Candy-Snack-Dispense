//V6: has outputs for when candydispense is set
//V7: set countermax and testing for candydispense with it, need to remove unused/commented out code
//the purpose of the program is to take in inputs from the raspberry pi to give movement to motors.
//V8: Completely new way of coding
//V9: Try to fix an issue where handshake gets set to 1 instantly after candyflag is 1
//V10: Hardcoded version
//Team 24: Jiawen, Calob, Jennifer, Nathalie

module project_module (       // inputs
		input     		IO_B4,			//[0] of[2:0] teststate for 7 states from rasp pi
		input           IO_B5,			//[1]
		input 	 		IO_B6,			//[2]
		
		input 	 		IO_A3,			//[0] of[1:0] stateamount for amount to dispense
		input    		IO_A4,			//[1]
		input     		IO_A5, 			//candyflag indicates when it's time to dispense
		//outputs
		output   		IO_D9, 			// stepperstep
		output   		IO_A10,			// stepperdir,
		output  		IO_B9,			// [0] of [1:0] dcmotor1, direction
		output  		IO_F7,			// [1] controls dcmotor1, direction
		output          IO_C4,			// [2] controls dcmotor1, speed, pwm
		output  		IO_D7,			// [0] of [1:0] dcmotor2, direction
		output  		IO_E7,			// [1] controls dcmotor2, direction
		output          IO_E8			// [2] controls dcmotor2, speed, pwm
		);
		

// wires (assigns)
wire          osc_clk;        // Internal OSCILLATOR clock

//regs used to take in input signals
reg [2:0] teststate;		//3 inputs total
reg [1:0] dispAmount;		//2 inputs total
reg candyflag;	//indicates when it's time to dispense 

//Output regs
reg step_out;	
reg step_dir;
reg [1:0] dc1_dir;
reg	dc1_out;
reg [1:0] dc2_dir;
reg	dc2_out;

//for making clocks and pwm signals foe outputs
wire stepSlow;
wire stepMedium;
wire stepFast;
wire dc_pwm5;
wire dc_pwm25; //clock wire for DC, output of ~27733Hz ; med/fast
wire dc_pwm50;
wire dc_pwm75;
wire fixDC;

//flags to control motors
reg	stepfast_flag;
reg stepmedium_flag;
reg stepslow_flag;
reg DC1_5flag = 1'b1;
reg DC1_25flag;
reg DC1_50flag;
reg DC1_75flag;
reg DC2_50flag;

//--------------------------------------------------------------------
//--  module instances
//--------------------------------------------------------------------


//default param is 2.08 (2MHz)
OSCH #(.NOM_FREQ(2.08)) OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
    );
 
//signals for stepper
//used for stepper motor slow
clock_division #(.N(32000), .width(15)) inst_stepslow (
        .clk        (osc_clk),
        .clock_div_o (stepSlow)	//65Hz
		);
//used for stepper motor medium
clock_division #(.N(16000), .width(14)) inst_stepmed(
        .clk        (osc_clk),
        .clock_div_o (stepMedium)	//130 Hz
		);
//used for stepper motor fast
clock_division #(.N(8000), .width(13)) inst_stepfast(
        .clk        (osc_clk),
        .clock_div_o (stepFast)	//260 Hz
		);
		
//Signal for DC motors			

clock_division #(.N(101), .width(7)) inst_DC (
        .clk        (osc_clk),
        .clock_div_o (fixDC)	//18,086.95 Hz
		);		
//----------5% DUTY CYCLE AT 200Hz
PWM_DC #(.rise(5)) inst_DCSLOW5_CLK (
		.clk (fixDC),			
		.clk_out (dc_pwm5)
);

//----------25% DUTY CYCLE AT 200Hz
PWM_DC #(.rise(25)) inst_DCSLOW25_CLK (
		.clk (fixDC),			
		.clk_out (dc_pwm25)
);

//----------50% DUTY CYCLE AT 200Hz
PWM_DC inst_DC_CLK (
		.clk (fixDC),
		.clk_out (dc_pwm50)
);

//----------75% DUTY CYCLE AT 200Hz
PWM_DC #(.rise(75)) inst_DCFAST_CLK (
		.clk (fixDC),
		.clk_out (dc_pwm75)
);

//assigned all inputs signals to registers
always @ (*)	begin
	teststate[0] = IO_B4;	 	 //input teststate[0] stated in first line
	teststate[1] = IO_B5;	 	 //input teststate[1] stated in first line
	teststate[2] = IO_B6;	 	 //input teststate[2] stated in first line
	dispAmount[0] = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
	dispAmount[1] = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense
	candyflag = IO_A5;			 //assigns input of candyflag
end

//DC motor1 actions
always @ (*)
	if(DC1_50flag == 1'b1)
		dc1_out = dc_pwm50;
	else if(DC1_5flag == 1'b1)
		dc1_out = dc_pwm5;
	else if(DC1_25flag == 1'b1)
		dc1_out = dc_pwm25;
	else if(DC1_75flag == 1'b1)
		dc1_out = dc_pwm75;
	else
		dc1_out = 1'b0;

//DC motor2 actions
always @ (*)
	if(DC2_50flag == 1'b1)
		dc2_out = dc_pwm50;
	else dc2_out = 1'b0;
	
//Stepper motor actions
always @ (*)
	if(stepslow_flag == 1'b1)
		step_out = stepSlow;
	else if(stepmedium_flag == 1'b1)
		step_out = stepMedium;
	else if(stepfast_flag == 1'b1)
		step_out = stepFast;
	else
		step_out = 1'b0;


//takes care different cases
always @ (candyflag,teststate)	begin
	//if candyflag == 1, do all dispensing commands
	if(candyflag == 1'b1)	begin
		dc1_dir[0] = 1'b0;
		dc1_dir[1] = 1'b1;
		dc2_dir[0] = 1'b0;
		dc2_dir[1] = 1'b1;
		step_dir = 1'b0;
		DC1_50flag = 1'b1;
		DC2_50flag = 1'b1;
		case (dispAmount)
			2'b00:	stepslow_flag = 1'b1;
			2'b01:	stepmedium_flag = 1'b1;
			2'b10:	stepfast_flag = 1'b1;
			default:	stepslow_flag = 1'b1;
		endcase
	end
	//else if candyflag != 1, test teststates
	else	begin
		dc1_dir[0] = 1'b0;
		dc1_dir[1] = 1'b1;
		dc2_dir[0] = 1'b0;
		dc2_dir[1] = 1'b1;
		step_dir = 1'b0;
		case (teststate)
			//Stepper motor testing
			3'b000 :	begin
						DC1_5flag = 1'b1;
						DC1_25flag = 1'b0;
						DC1_50flag = 1'b0;
						DC1_75flag = 1'b0;
						DC2_50flag = 1'b0;
						stepfast_flag = 1'b0;
						stepslow_flag = 1'b0;
						stepmedium_flag = 1'b0;
					end
			3'b001 : 	stepslow_flag = 1'b1;  //reduce hz to reduce speed
			3'b010 : 	begin 
						  //signal to stepper motor	//stepper motor change dir right
						  //signal to stepper motor only
						  step_dir = 1'b1;
  						  stepslow_flag = 1'b1;  //reduce hz to reduce speed
					end
			3'b011 :	stepfast_flag = 1'b1;  //reduce hz to reduce speed
			//DC motor testing
			3'b100 :	DC1_25flag = 1'b1; // ? 1'b1 : 1'b0 ;		
			3'b101 : 	begin 
							   //signal to right pwm to DC motor
							   dc1_dir[0] = 1'b1;
							   dc1_dir[1] = 1'b0;
							   DC1_25flag = 1'b1; // ? 1'b1 : 1'b0 ;
                    end				
			3'b110 :	DC1_75flag = 1'b1; // ? 1'b1 : 1'b0 ;
		   default : 	begin     
						//stop all motors
						DC1_5flag = 1'b0;
						DC1_25flag = 1'b0;
						DC1_75flag = 1'b0;
						stepfast_flag = 1'b0;
						stepslow_flag = 1'b0;
                    end
		endcase
	end
end

//-------------------------------------//
//-------- output assignments  --------//
//-------------------------------------//
//assign GPIO outputs to outputs named

assign IO_D9 = step_out;
assign IO_A10 = step_dir;
assign IO_B9 = dc1_dir[0];
assign IO_F7 = dc1_dir[1];
assign IO_C4 = dc1_out; 
assign IO_D7 = dc2_dir[0];
assign IO_E7 = dc2_dir[1];
assign IO_E8 = dc2_out;
endmodule 