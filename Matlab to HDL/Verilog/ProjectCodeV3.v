//need to reduce dcmotor to one output, instead of [1:0]?
module project_module (       // inputs
        input   wire        clk_x1,     	// 12M clock from FTDI/X1 crystal
        input   wire        rstn,       	// from SW1 pushbutton
        input   wire  [3:0] DIPSW,      	// from SW2 DIP switches
		input     		IO_B4,			//[0] of[2:0] teststate for 7 states from rasp pi
		input     		IO_B5,			//[1]
		input 	 		IO_B6,			//[2]
		
		input 	 		IO_A3,			//[0] of[1:0] stateamount for amount to dispense
		input    		IO_A4,			//[1]
		input     		IO_A5, 			//candyflag indicates when it's time to dispense
		
		output	wire  		IO_B7, 			// signalrecieved = signal for when new state was recieved
		output  wire 		IO_D9, 			// stepperstep
		output  wire 		IO_A10,			// stepperdir,
		output  wire  		IO_B9,			// [0] of [1:0] dcmotor,
		output  wire 		IO_F7,			// [1]
		output  wire        IO_C5			// servopwm
		
		);
		

// wires (assigns)
wire          osc_clk;        // Internal OSCILLATOR clock
wire          clk12M;         // 12MHz logic clock
wire          rst;            //	
//moved here because it wasn't working earlier, can change back later
wire IO_A5_i;			 //assigns input of candyflag
wire IO_B4_i;	 	 //input teststate[0] stated in first line
wire IO_B5_i;	 	 //input teststate[1] stated in first line
wire IO_B6_i;	 	 //input teststate[2] stated in first line
wire IO_A3_i; 	 //[0] of[1:0] stateamount for amount to dispense
wire IO_A4_i; 	 //[1] of[1:0] stateamount for amount to dispense
		

//
//reg (always), 6 in all
reg [2:0] teststate;		//3 inputs total
reg [1:0] stateamount;		//2 inputs total
reg candyflag;	//indicates when it's time to dispense 
//outputs
reg signalrecieved; //signal for when new state was recieved
reg stepperstep;	
reg stepperdir;
reg [1:0] dcmotor;
reg servopwm; 
//counter
reg countstep = 0;

//beats changed to using heartbeat.v module instance 
//reg rightservob = heartbeat / 12500; // 12500000 / 12500 to get 1000Hz, equals 1ms (-90)
//reg leftservob = heartbeat / 25000;  // 12500000 / 25000 to get 500Hz, equals 2ms (90)
//reg zeroservob = heartbeat / 18750;  // 12500000 / 18750 to get 666.66, equals 1.5 (0)
//reg stepb = heartbeat / 6250; 	     //12500000 / 6250 to get 2000Hz, equals 500microseconds


//and
assign rst = ~rstn;
assign clk12M = DIPSW[3] ? osc_clk : clk_x1;    // select clock source int/ext
//
//inputs
assign IO_A5_i = IO_A5;			 //assigns input of candyflag
assign IO_B4_i = IO_B4;	 	 //input teststate[0] stated in first line
assign IO_B5_i = IO_B5;	 	 //input teststate[1] stated in first line
assign IO_B6_i = IO_B6;	 	 //input teststate[2] stated in first line
assign IO_A3_i = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
assign IO_A4_i = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense
	
//
/*always @(negedge clk_x1)
	begin
		candyflag = IO_A5;			 //assigns input of candyflag
		teststate[0] = IO_B4;	 	 //input teststate[0] stated in first line
		teststate[1] = IO_B5;	 	 //input teststate[1] stated in first line
		teststate[2] = IO_B6;	 	 //input teststate[2] stated in first line
		stateamount[0] = IO_A3; 	 //[0] of[1:0] stateamount for amount to dispense
		stateamount[1] = IO_A4; 	 //[1] of[1:0] stateamount for amount to dispense
		
		end*/
always @ (DIPSW[2:0], rightservob,leftservob,stepperstep,stateamount[1:0], teststate[2:0], candyflag)
    begin
		candyflag <= IO_A5_i;			 //assigns input of candyflag
		teststate[0] <= IO_B4_i;	 	 //input teststate[0] stated in first line
		teststate[1] <= IO_B5_i;	 	 //input teststate[1] stated in first line
		teststate[2] <= IO_B6_i;	 	 //input teststate[2] stated in first line
		stateamount[0] <= IO_A3_i; 	 //[0] of[1:0] stateamount for amount to dispense
		stateamount[1] <= IO_A4_i; 	 //[1] of[1:0] stateamount for amount to dispense
		
            case (DIPSW[2:0])        //later changed to state when we can recieve Rasp Pi inputs
				//State 000 servo move fowd
                3'b000 : begin      
						 //need to set a pulse/or counter different than heartbeat 
						 servopwm <= rightservob ? 8'b00000001 : 8'b00000000;
                         end

				3'b001 : begin      //move back
                       //send signal to servomotor
						servopwm <= leftservob ? 8'b00000001 : 8'b00000000;
                       end
				3'b010 : begin      //stepper motor change dir left
						//signal to stepper motor only
						stepperdir <= 1'b1;
					   end
				3'b011 : begin      //stepper motor change dir right
						//signal to stepper motor only
						stepperdir <= 1'b0;
						end
				3'b100 : begin     //stepper motor change slow 
					  //signal to stepper motor
					  countstep = 0;
					  if(countstep < 200)
						begin
							stepperstep <= stepb ? 8'b00000001 : 8'b00000000;	//reduce heartbeat to reduce speed
							countstep <= countstep + 1;
						end
                    end
				3'b101 : begin     //stepper motor change fast 
					  //signal to stepper motor
					  countstep = 0;
					  if(countstep < 400)
						begin
							stepperstep <= stepb ? 8'b00000001 : 8'b00000000;	//reduce heartbeat to reduce speed
							countstep <= countstep + 1;
						end
                    end					
				3'b110 : begin     //signal to left pwm to DC motor
								   //add pulse?
					   dcmotor[0] <= 1'b1;
					   dcmotor[1] <= 1'b0;
                    end	
				3'b111 : begin     //signal to right pwm to DC motor
					   dcmotor[0] <= 1'b0;
					   dcmotor[1] <= 1'b1;
                    end
                default : begin     // error?
                      
				
                    end
				
           endcase
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
				end
				default: 
						begin
						//nothing
						end
		    endcase
   end	
	


//--------------------------------------------------------------------
//--  module instances
//--------------------------------------------------------------------

defparam OSCH_inst.NOM_FREQ = "12.09";  
OSCH OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
    );

heartbeat #(.clk_freq (12000000))
    heartbeat_inst (
        .clk        (clk12M),
        .rst        (rst),
        .heartbeat  (heartbeat)
        );
 heartbeat #(.clk_freq (2000))
    inst_right(
        .clk        (clk12M),
        .rst        (rst),
        .heartbeat  (rightservob)
        );
  heartbeat #(.clk_freq (1000))
    inst_left (
        .clk        (clk12M),
        .rst        (rst),
        .heartbeat  (leftservob)
        );
  heartbeat #(.clk_freq (25000))  //100MHz (2* desired frequency) ; desired frequency = 2000;
    inst_step(
        .clk        (clk12M),
        .rst        (rst),
        .heartbeat  (stepb)
        ); 		
//dont think zero inst is needed...
kitcar #(.clk_freq (12000000))
    kitcar_inst (
        .clk        (clk12M),
        .rst        (rst),
        .LED_array  (LED_array)
        );



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
	
endmodule 