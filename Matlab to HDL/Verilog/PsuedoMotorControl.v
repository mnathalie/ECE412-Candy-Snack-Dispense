//A simple module for motor controlling in Psuedocode format

module motor(	handshake,
		stepper_dir,
		stepper_step,
		DC_speed,
		DC_in1,
		DC_in2,
		disp,
		inA,
		inB
);

output handshake,stepper_dir,stepper_step,DC_speed,DC_in1,DC_in2;
reg handshake = 0; 	//first declare handshake to send out a "0" 
reg stepper_step = 0; 	//stepper motor no action
reg DC_speed = 0;  	//DC motor no action
reg stepper_dir = 0;	//stepper dir -> clockwise
reg DC_in1 = 0;		//DC dir -> clockwise
reg DC_in2 = 1;

input disp;
input [1:0] inA;	//Two bits to select dispensing amount
input [2:0] inB;	//Three bits to select for testing


always @ (disp)
	if(disp)
		case(inA)	
		2'b00:	begin
				DC_speed = moderate;	//PWM = 50% 		
				stepper_step = 100;	//Step half a circle, send pulses at 160hz for 100 times, probably uses a counter
				DC_speed = 0;		//stops DC motor
				handshake = 1;		//After dispensing, send handshake = 1 to reset
			end
		2'b01:	begin
				DC_speed = moderate;	//PWM = 50%
				stepper_step = 200;	//Step a full circle, send pulses at 160hz for 200 times, probably uses a counter
				DC_speed = 0;		//stops DC motor
				handshake = 1;		//After dispensing, send handshake = 1 to reset
			end
		2'b10:	begin
				DC_speed = moderate;	//PWM = 50% 		
				stepper_step = 300;	//Step one and a half circle, send pulses at 160hz for 300 times, probably uses a counter
				DC_speed = 0;		//stops DC motor
				handshake = 1;		//After dispensing, send handshake = 1 to reset
			end
		default:				//same as small
			begin
				DC_speed = moderate; 		
				stepper_step = 100;
				DC_speed = 0;
				handshake = 1;
			end
		endcase
	else
		handshake = 0;

always @ (inB)
	case(inB)
	3'b001:	begin
			stepper_step = slow;   	//send pulses at 160Hz to this pin 
		end
	3'b010:	begin
			stepper_dir = 1;	//dir -> counterclockwise
			stepper_step = slow;	//send pulses at 160Hz to this pin
		end
	3'b011:	begin
			stepper_step = fast;	//send pulses at 250Hz(something larger than ~200Hz) to this pin
		end
	3'b100:	begin
			DC_speed = slow;	//PWM = 25%
		end
	3'b101:	begin
			DC_in1 = 1;		//dir -> counterclockwise
			DC_in2 = 0;	
			DC_speed = slow;	//PWM = 25%
		end
	3'b110:	begin
			DC_speed = fast;	//PWM = 75%
		end
	default:
		begin
			DC_speed = 0;		//Stops DC motor
			stepper_step = 0;	//stops Stepper motor
			DC_in1 = 0;		//DC dir -> clockwise
			DC_in2 = 1;
			stepper_dir = 0;	//Stepper dir -> clockwise
		end
	
endmodule
