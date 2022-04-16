`include "rooms.sv"
`include "amulet_states.sv"

import rooms::*;
import amulet_states::*;

module amulet_state_machine(input logic clk,
									 input logic reset,
									 input room_state room,
									 output logic amulet);
		
	amulet_state current, next;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) current <= A0;
		else current <= next;
		
	always_comb
		case (current)
			A0: if (room == R2) next = A1;
				  else next = A0;
			A1: next = A1;
		endcase
		
	assign amulet = (next == A1);
endmodule