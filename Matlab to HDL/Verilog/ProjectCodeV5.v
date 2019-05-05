//added new clock for clkdiv for pwm signal to see if works
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
		
		output	wire  		IO_B7, 			// signalrecieved = signal for when new state was recieved
		output  wire 		IO_D9, 			// stepperstep
		output  wire 		IO_A10,			// stepperdir,
		output  wire  		IO_B9,			// [0] of [1:0] dcmotor,
		output  wire 		IO_F7,			// [1]
		output  wire        IO_C5,			// servopwm
		output  wire 		IO_D6,			// handshake to give to raspberry pi
		output  wire 		clock_test_step,	    //makes sure we have a beat
		output	wire		clock_test_DC,
		output	wire		clock_test_DCSLOW
		);
		

// wires (assigns)
wire          osc_clk;        // Internal OSCILLATOR clock
wire          clk12M;         // 12MHz logic clock
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
reg [1:0] dcmotor;
reg servopwm; 
reg handshake = 1'b0; //for rasp pi
//counter
reg countstep = 0;
//these are regs right now so that it compiles. Will be used for PWM
reg rightservob; // 12500000 / 12500 to get 1000Hz, equals 1ms (-90)
reg leftservob;  // 12500000 / 25000 to get 500Hz, equals 2ms (90)
//reg zeroservob;  // 12500000 / 18750 to get 666.66, equals 1.5 (0)
wire stepb;
wire stepDC; //clock wire for DC, output of ~27733Hz ; med/fast
wire stepDCslow; 
wire fixDCslow;
wire fixDC;
//and
assign rst = ~rstn;
//assign clk12M = DIPSW[3] ? osc_clk : clk_x1;    // select clock source int/ext
//
//inputs
assign IO_A5_i = IO_A5;		 //assigns input of candyflag
assign IO_B4_i = IO_B4;	 	 //input teststate[0] stated in first line
assign IO_B5_i = IO_B5;	 	 //input teststate[1] stated in first line
assign IO_B6_i = IO_B6;	 	 //input teststate[2] stated in first line
assign IO_A3_i = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
assign IO_A4_i = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense


always @ (DIPSW[2:0],stepperstep,stateamount[1:0], teststate[2:0], candyflag, stepb)
    begin
		candyflag <= IO_A5_i;			 //assigns input of candyflag
		teststate[0] <= IO_B4_i;	 	 //input teststate[0] stated in first line
		teststate[1] <= IO_B5_i;	 	 //input teststate[1] stated in first line
		teststate[2] <= IO_B6_i;	 	 //input teststate[2] stated in first line
		stateamount[0] <= IO_A3_i; 	 //[0] of[1:0] stateamount for amount to dispense
		stateamount[1] <= IO_A4_i; 	 //[1] of[1:0] stateamount for amount to dispense
		
            case (DIPSW[2:0])        //later changed to state when we can recieve Rasp Pi inputs

				3'b001 : begin 
						  //signal to stepper motor
						  countstep = 0;
						  //stepper motor change dir right
						  //signal to stepper motor only
						  stepperdir <= 1'b0;
						  if(countstep < 200)
							begin
								stepperstep <= stepb ? 1'b1 : 1'b0;	//reduce hz to reduce speed
								countstep <= countstep + 1;
							end
                       end
				3'b010 : begin 
						  //signal to stepper motor
						  countstep = 0;
						  //stepper motor change dir right
						  //signal to stepper motor only
						  stepperdir <= 1'b1;
						  if(countstep < 200)
							begin
								stepperstep <= stepb ? 1'b1 : 1'b0;	//reduce hz to reduce speed
								countstep <= countstep + 1;
							end
					   end
				3'b011 : begin 
						  //stepper motor change fast 
						  //signal to stepper motor
						  countstep = 0;
						  stepperdir <= 1'b0;
						  if(countstep < 400)
							begin
								stepperstep <= stepb ? 1'b1 : 1'b0;	//reduce hz to reduce speed							
								countstep <= countstep + 1;
							end
						end
				3'b100 : begin //signal to left pwm to DC motor
					   dcmotor[0] <= 1'b1;
					   dcmotor[1] <= stepDCslow ? 1'b1 : 1'b0 ;
                    end
				3'b101 : begin 
					   //signal to right pwm to DC motor
					   dcmotor[0] <= 1'b0;
					   dcmotor[1] <= stepDCslow ? 1'b1 : 1'b0 ;
                    end					
				3'b110 : begin
					   //signal to right pwm to DC motor
					   dcmotor[0] <= 1'b0;
					   dcmotor[1] <= stepDC ? 1'b1 : 1'b0 ;
                    end	
				3'b111 : begin
                    end
                default : begin     // error?
                      
						//stop all motors
                    end
				
           endcase
		   //Added handshake send input to raspberrypi to confirms that candyflag was set 
		   case(candyflag)
			1'b1:
				begin
				   case (stateamount[1:0])
						//State 00 is the small amount state, the GUI should send this signal 
						//whenever nothing has been changed and just starting up
						2'b00 : begin      //small amount being dispensed
								//send signals to stepper motor 
								//send open flap signal to servo
								//send signal to dcmotor pin
							end
						//State 10 is in medium amount being dispensed
						2'b01 : begin      //med amount being dispensed
							  //send signals to stepper motor 
							  //send open flap signal to servo
							  //send signal to dcmotor pin

							end
							
						2'b10 : begin   //large amount being dispensed
								//send signals to stepper motor 
								//send open flap signal to servo
								//send signal to dcmotor pin
								end
					endcase
					handshake <= 1'b1;		//send output to raspberry pi
				end
			1'b0:
				begin
					handshake <= 1'b0;		//send output to raspberry pi
				end

		    endcase
   end	
	


//--------------------------------------------------------------------
//--  module instances
//--------------------------------------------------------------------

defparam OSCH_inst.NOM_FREQ = "2.08";  
//default param is 2.08 (2MHz)
OSCH OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
    );
//clock_division 
//signal for stepper
defparam inst_step.width = "15";
defparam inst_step.N = "13000";
clock_division inst_step (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (stepb)
		);
defparam inst_DC.width = "7";
defparam inst_DC.N = "60";		
clock_division inst_DC (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixDC)
		);	
defparam inst_DCSLOW.width = "7";
defparam inst_DCSLOW.N = "90";		
clock_division inst_DCSLOW (
        .clk        (osc_clk),
        .rst        (rst),
        .clock_div_o (fixDCslow)
		);	
PWM_DC inst_DCSLOW_CLK (
		.clk (fixDCslow),
		.clk_out (stepDCslow)

);
PWM_DC inst_DC_CLK (
		.clk (fixDC),
		.clk_out (stepDC)
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

assign IO_B7 = signalrecieved; //signal for when new state was recieved
assign IO_D9 = stepperstep;
assign IO_A10 = stepperdir;
assign IO_B9 = dcmotor[0];
assign IO_F7 = dcmotor[1];
assign IO_C5 = servopwm; 
assign IO_D6 = handshake;
assign clock_test_step = stepb;
assign clock_test_DC = stepDC;
assign clock_test_DCSLOW = stepDCslow;
endmodule 