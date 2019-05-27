//V6: has outputs for when candydispense is set
//V7: set countermax and testing for candydispense with it, need to remove unused/commented out code
//the purpose of the program is to take in inputs from the raspberry pi to give movement to motors.

module project_module (       // inputs
        //input   wire        clk_x1,     	// 12M clock from FTDI/X1 crystal
		//input   wire        osc_clk,
        input   wire        rstn,       	// from SW1 pushbutton
        //input   wire  [3:0] DIPSW,      	// from SW2 DIP switches
		input   wire  		IO_B4,			//[0] of[2:0] teststate for 7 states from rasp pi
		input   wire 		IO_B5,			//[1]
		input 	wire 		IO_B6,			//[2]
		
		input 	wire 		IO_A3,			//[0] of[1:0] stateamount for amount to dispense
		input   wire 		IO_A4,			//[1]
		input   wire  		IO_A5, 			//candyflag indicates when it's time to dispense
		//input candyflag;
		//input [2:0]	teststate;
		//input [1:0]	stateamount;

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
//wire 		  clk_test;
//moved here because it wasn't working earlier, can change back later
//wire IO_A5_i;		//assigns input of candyflag
//wire IO_B4_i;	 	//input teststate[0] stated in first line
//wire IO_B5_i;	 	//input teststate[1] stated in first line
//wire IO_B6_i;	 	//input teststate[2] stated in first line
//wire IO_A3_i; 	 	//[0] of[1:0] stateamount for amount to dispense
//wire IO_A4_i; 	 	//[1] of[1:0] stateamount for amount to dispense


//reg (always)
reg [2:0] teststate;		//3 inputs total
reg [1:0] dispAmount;		//2 inputs total
reg candyflag;	//indicates when it's time to dispense 
//outputs
//reg signalrecieved; //signal for when new state was recieved
reg step_out;	
reg step_dir;
reg [1:0] dc_dir;
reg	dc_out;
//reg servopwm; 
reg handshake; //for rasp pi
//counter
//reg countstep = 0; //used for candyflag dispense
//reg test;
//reg prev = 0; //temp value
//reg current; //temp value
//reg i; 
//reg counterflag = 1;
//counters for dispensing candy
reg [9:0] stepcount;
reg [9:0] count = 10'b00_0000_0000;
//for clocks
wire stepSlow;
wire stepFast;
wire dc_pwm25; //clock wire for DC, output of ~27733Hz ; med/fast
wire dc_pwm50;
wire dc_pwm75;
//wire clockhandshake;

wire fixDCslow;
wire fixDC;
wire fixstep;

//flags for testing
reg	stepfast_flag;
reg stepslow_flag;
reg DC25_flag;
reg DC50_flag;
reg DC75_flag;

//and
assign rst = ~rstn;

//inputs
//assign IO_A5_i = IO_A5;		 //assigns input of candyflag
//assign IO_B4_i = IO_B4;	 	 //input teststate[0] stated in first line
//assign IO_B5_i = IO_B5;	 	 //input teststate[1] stated in first line
//assign IO_B6_i = IO_B6;	 	 //input teststate[2] stated in first line
//assign IO_A3_i = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
//assign IO_A4_i = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense




//--------------------------------------------------------------------
//--  module instances
//--------------------------------------------------------------------


//default param is 2.08 (2MHz)
OSCH #(.NOM_FREQ(2.08)) OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
    );
//clock_division 
//signal for stepper

clock_division #(.N(200), .width(9)) inst_fixstep1 (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixstep)	//5200Hz
		);
		
		
clock_division #(.N(13000), .width(14)) inst_stepslow (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (stepSlow)	//162Hz
		);

clock_division #(.N(4000), .width(12)) inst_step(
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (stepFast)	//520 Hz
		);
//Signal for DC motors			
//18,086.95 Hz
clock_division #(.N(101), .width(7)) inst_DC (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixDC)
		);	
//10,400hz	
//clock_division #(.N(200), .width(9)) inst_DCSLOW (
//        .clk        (osc_clk),
 //       .rst        (rst),
 //       .clock_div_o (fixDCslow)
//		);	

//----------25% DUTY CYCLE AT 200Hz
PWM_DC #(.rise(25)) inst_DCSLOW_CLK (
		.clk (fixDC),			//changed from fixDCslow
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
always @ (osc_clk)	begin
	if(candyflag == 1'b1)	begin
		if(count < stepcount && stepSlow)	begin
			step_out = stepSlow;
			count = count + 1'b1;
		end
		else if(count == stepcount)	begin
				handshake = 1'b1;
				step_out = 1'b0;
		end
		else	step_out = stepSlow;
	end
	else if(stepfast_flag == 1'b1)
		step_out = stepFast;
	else if(stepslow_flag == 1'b1)
		step_out = stepSlow;
	else	begin
		count = 0;
		step_out = 1'b0;
		handshake = 1'b0;
	end
end

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
					stepcount = 100;
				end
			2'b01:	begin
					DC50_flag = 1'b1;
					stepcount = 200;
				end
			2'b10:	begin
					DC50_flag = 1'b1;
					stepcount = 300;
				end
			default:	begin
					DC50_flag = 1'b1;
					stepcount = 100;
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
                    end
		endcase
	end
end
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

assign IO_D9 = step_out;
assign IO_A10 = step_dir;
assign IO_B9 = dc_dir[0];
assign IO_F7 = dc_dir[1];
assign IO_C4 = dc_out; 
assign IO_D6 = handshake;
assign clock_test_step = stepSlow;
assign clock_test_DC = dc_pwm50;
assign clock_test_DCSLOW = dc_pwm25;

endmodule 