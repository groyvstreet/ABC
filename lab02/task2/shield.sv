`include "rooms.sv"
`include "shield_states.sv"

import rooms::*;
import shield_states::*;

module shield_state_machine(input logic clk,
									 input logic reset,
									 input room_state room,
									 input logic gold,
									 output logic shield);
		
	shield_state current, next;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) current <= SH0;
		else current <= next;
		
	always_comb
		case (current)
			SH0: if (room == R7 && gold) next = SH1;
				  else next = SH0;
			SH1: next = SH1;
		endcase
		
	assign shield = (next == SH1);
endmodule