//V6: has outputs for when candydispense is set
//V7: set countermax and testing for candydispense with it, need to remove unused/commented out code
//the purpose of the program is to take in inputs from the raspberry pi to give movement to motors.
//V8: Completely new way of coding
//V9: Try to fix an issue where handshake gets set to 1 instantly after candyflag is 1
//V10: Hardcoded version
//Team 24: Jiawen, Calob, Jennifer, Nathalie

module project_module (       // inputs
		input   wire  		IO_B4,			//[0] of[2:0] teststate for 7 states from rasp pi
		input   wire 		IO_B5,			//[1]
		input 	wire 		IO_B6,			//[2]
		
		input 	wire 		IO_A3,			//[0] of[1:0] stateamount for amount to dispense
		input   wire 		IO_A4,			//[1]
		input   wire  		IO_A5, 			//candyflag indicates when it's time to dispense
		//outputs
		output  wire 		IO_D9, 			// stepperstep
		output  wire 		IO_A10,			// stepperdir,
		output  wire  		IO_B9,			// [0] of [1:0] dcmotor, direction
		output  wire 		IO_F7,			// [1] controls direction
		output  wire        IO_C4			// [2] controls speed, pwm
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
reg [1:0] dc_dir;
reg	dc_out;

//for making clocks and pwm signals foe outputs
wire stepSlow;
wire stepMedium;
wire stepFast;
wire dc_pwm25; //clock wire for DC, output of ~27733Hz ; med/fast
wire dc_pwm50;
wire dc_pwm75;
wire fixDC;

//flags to control motors
reg	stepfast_flag;
reg stepmedium_flag;
reg stepslow_flag;
reg DC25_flag;
reg DC50_flag;
reg DC75_flag;

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

//----------25% DUTY CYCLE AT 200Hz
PWM_DC #(.rise(25)) inst_DCSLOW_CLK (
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

//DC motor actions
always @ (*)
	if(DC50_flag == 1'b1)
		dc_out = dc_pwm50;
	else if(DC25_flag == 1'b1)
		dc_out = dc_pwm25;
	else if(DC75_flag == 1'b1)
		dc_out = dc_pwm75;
	else
		dc_out = 1'b0;

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
		dc_dir[0] = 1'b0;
		dc_dir[1] = 1'b1;
		step_dir = 1'b0;
		case (dispAmount)
			2'b00:	begin
					DC50_flag = 1'b1;
					stepslow_flag = 1'b1;
				end
			2'b01:	begin
					DC50_flag = 1'b1;
					stepmedium_flag = 1'b1;
				end
			2'b10:	begin
					DC50_flag = 1'b1;
					stepfast_flag = 1'b1;
				end
			default:	begin
					DC50_flag = 1'b1;
					stepslow_flag = 1'b1;
				end
		endcase
	end
	//else if candyflag != 1, test teststates
	else	begin
		dc_dir[0] = 1'b0;
		dc_dir[1] = 1'b1;
		step_dir = 1'b0;
		case (teststate)
			//Stepper motor testing
			3'b001 : 	stepslow_flag = 1'b1;  //reduce hz to reduce speed
			3'b010 : 	begin 
						  //signal to stepper motor	//stepper motor change dir right
						  //signal to stepper motor only
						  step_dir = 1'b1;
  						  stepslow_flag = 1'b1;  //reduce hz to reduce speed
					end
			3'b011 :	stepfast_flag = 1'b1;  //reduce hz to reduce speed
			//DC motor testing
			3'b100 :	DC25_flag = 1'b1; // ? 1'b1 : 1'b0 ;		
			3'b101 : 	begin 
							   //signal to right pwm to DC motor
							   dc_dir[0] = 1'b1;
							   dc_dir[1] = 1'b0;
							   DC25_flag = 1'b1; // ? 1'b1 : 1'b0 ;
                    end				
			3'b110 :	DC75_flag = 1'b1; // ? 1'b1 : 1'b0 ;
            default : 	begin     
						//stop all motors
						DC25_flag = 1'b0;
						DC50_flag = 1'b0;
						DC75_flag = 1'b0;
						stepfast_flag = 1'b0;
						stepslow_flag = 1'b0;
						stepmedium_flag = 1'b0;
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
assign IO_B9 = dc_dir[0];
assign IO_F7 = dc_dir[1];
assign IO_C4 = dc_out; 
endmodule 